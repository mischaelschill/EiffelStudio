note
	description: "Abstract representation of a file system location."
	legal: "See notice at end of class."
	status: "See notice at end of class."
	date: "$Date$"
	revision: "$Revision$"

deferred class
	CONF_LOCATION

inherit

	CONF_VALIDITY
		redefine
			is_equal
		end

	KL_SHARED_OPERATING_SYSTEM
		export
			{NONE} all
		redefine
			is_equal
		end

	KL_SHARED_FILE_SYSTEM
		export
			{NONE} all
		redefine
			is_equal
		end

	SHARED_EXECUTION_ENVIRONMENT
		redefine
			is_equal
		end

feature -- Access, stored in configuration file

	original_path: STRING_32
			-- Path without resolved variables and parent cluster path.

feature -- Access queries

	original_directory: like original_path
			-- The directory part of `original_path' (without trailing '\').
		do
			Result := directory (original_path)
		ensure
			Result_not_void: Result /= Void
		end

	original_file: like original_path
			-- The file part of `original_path'.
		do
			Result := file (original_path)
		ensure
			Result_not_void: Result /= Void
		end

	evaluated_path: like original_path
			-- The fully resolved path with file name.
		local
			l_file_system: like file_system
			u: UTF_CONVERTER
		do
			l_file_system := file_system
				-- {KI_FILE_SYSTEM}.canonical_pathname works on {STRING_8}
				-- therefore the original path is converted from {STRING_32} to {STRING_8}
				-- and after the normalization back to {STRING_32}. This works because
				-- all non-ASCII codes of UTF-8 stay untouched during normalization.
			Result := u.utf_8_string_8_to_string_32
				(l_file_system.canonical_pathname (l_file_system.pathname_from_file_system
					(u.string_32_to_utf_8_string_8 (internal_evaluated_path), windows_file_system)))
		ensure
			Result_not_void: Result /= Void
		end

	evaluated_directory: like original_path
			-- The directory part of `evaluated_path' (without trailing '\' or '/').
		local
			l_file_system: like file_system
			u: UTF_CONVERTER
		do
			l_file_system := file_system
				-- If call to 'pathname_from_file_system' is empty that means we only got a '\' or '/' which got removed because we remove
				-- trailing separators
			Result := u.utf_8_string_8_to_string_32
				(l_file_system.canonical_pathname (l_file_system.pathname_from_file_system
					(u.string_32_to_utf_8_string_8 (directory (internal_evaluated_path)), windows_file_system)))
			if Result.count = 0 then
				Result := operating_environment.directory_separator.out
			end
		ensure
			Result_not_void: Result /= Void
		end

	evaluated_file: like original_path
			-- The file part of `evaluated_path'.
		do
			Result := file (internal_evaluated_path)
		ensure
			Result_not_void: Result /= Void
		end

	directory_separator: CHARACTER
			-- The directory separator for the curren platform.
		do
			if operating_system.is_windows then
				Result := windows_file_system.directory_separator
			else
				Result := unix_file_system.directory_separator
			end
		end

	build_path (a_directory, a_file: like original_path): like original_path
			-- Add directories and filename to current directory.
			-- `a_directory' can be in any format.
		require
			a_directory_not_void: a_directory /= Void
			a_file_not_void: a_file /= Void
		local
			l_dir: like original_path
			l_cluster_separator: CHARACTER_8
			u: GOBO_FILE_UTILITIES
		do
			l_cluster_separator := '\'
			Result := evaluated_directory
			if Result.is_empty then
				Result.append_character (operating_environment.directory_separator)
			end
			if not a_directory.is_empty then
				l_dir := u.adapt_unix_to_windows (a_directory)
				if l_dir.item (1) /= l_cluster_separator then
					l_dir.prepend_character (l_cluster_separator)
				end
			else
				create l_dir.make_empty
			end
			if a_file.is_empty and then not l_dir.is_empty and then l_dir.item (l_dir.count) = l_cluster_separator then
				l_dir.remove_tail (1)
			end
			if not a_file.is_empty then
				l_dir.append_character (l_cluster_separator)
				l_dir.append_string (a_file)
			end
			l_dir := u.adapt_windows_to_current (l_dir)
			Result.append (l_dir)
		ensure
			Result_not_void: Result /= Void
		end

feature {CONF_ACCESS} -- Update, stored in configuration file

	set_parent (a_parent: like parent)
			-- Set `parent' to `a_parent'.
		do
			parent := a_parent
		ensure
			parent_set: parent = a_parent
		end

	set_target (a_target: like target)
			-- Set `target' to `a_target'
		require
			a_target_not_void: a_target /= Void
		do
			target := a_target
		ensure
			target_set: target = a_target
		end

feature -- Comparison

	is_equal (other: like Current): BOOLEAN
			-- Is it the same location as `other'?
		do
			Result := equal (original_path, other.original_path)
		end

feature {NONE} -- Implementation, attributes stored in configuration file

	parent: CONF_LOCATION
			-- The path of the parent directory (if any).

	target: CONF_TARGET
			-- The target where we can get our variable settings.

feature {NONE} -- Implementation

	--| The internal format uses the windows format (because we would otherwise lose the drive letter)
	--| directories are always terminated by a \

	to_internal (a_path: like original_path): like original_path
			-- Convert `a_path' into the internal representation.
		require
			a_path_not_void: a_path /= Void
		local
			l_net_share: BOOLEAN
			u: UTF_CONVERTER
		do
			a_path.left_adjust
			a_path.right_adjust
			l_net_share := a_path.count >= 2 and then (a_path.item (1) = '/' and a_path.item (2) = '/')
				-- always works, even if a_path is already in windows file format
			Result := u.utf_8_string_8_to_string_32 (windows_file_system.pathname_from_file_system
				(u.string_32_to_utf_8_string_8 (a_path), unix_file_system))
			if l_net_share then
				Result.precede ('\')
			end

				-- convert $\ ($/ was converted into $\) at the beginning into $| because
				-- internally we only accept this as indicator for the parent path.
			if Result.count >= 2 and then Result.item (1) = '$' then
				if Result.item (2) = '\' or Result.item (2) = '/' then
					Result.put ('|', 2)
				end
			end
		end

	internal_evaluated_path: like original_path
			-- The fully resolved path with file name in internal format.
		local
			i, j, k: INTEGER
			l_old_i: INTEGER
			l_key: like original_path
			l_value: like original_path
			l_relative_base: like original_path
			l_offset: INTEGER
			l_stop: BOOLEAN
		do
			create Result.make_from_string (original_path)

				-- replace $| with parent path
			if parent /= Void then
				if Result.count >= 2 and then Result.item (1) = '$' and then Result.item (2) = '|' then
					Result.replace_substring (parent.evaluated_directory+"\", 1, 2)
				end
			end

				-- replace $ABC and ${ABC} with user defined or environment variables
			from
				l_offset := 1
				i := Result.index_of ('$', l_offset)
			until
				i = 0 or l_stop
			loop
				l_key := Void
				l_old_i := i

					-- in each loop we decrease the number of $ by 1, except if it is a $(ABC), then we increase the offset
				if i /= 0 and then Result.item (i+1) = '{' then
					j := Result.index_of ('}', i)
					if j /= 0 and j > i+2 then
						l_key := Result.substring (i+2, j-1)
					end
				elseif i /= 0 and then Result.item (i+1) = '(' then
					l_offset := Result.index_of (')', i) + 2
				elseif i /= 0 then
					j := Result.index_of (' ', i) - 1
					k := Result.index_of ('\', i) - 1
					if j < i then
						j := Result.count
					end
					if k > i then
						j := j.min (k)
					end
					l_key := Result.substring (i+1, j)
				end

				if l_key /= Void then
					l_value := target.variables.item (l_key.as_lower)
					if l_value = Void then
						l_value := execution_environment.item (l_key)
						if l_value = Void then
							l_value := once {STRING_32} ""
						end
							-- we don't want to update stored values, this is done when the project is loaded
						target.environ_variables.put (l_value, l_key)
					end
					Result.replace_substring (to_internal (l_value), i, j)
				end

				i := Result.index_of ('$', l_offset)
				if i > 0 then
						-- Check if last variable was extracted correctly
					l_stop := l_old_i = i
				end
			end

				-- handle relative path
			if (Result.count >= 2 and then
					Result [1].is_character_8 and then
					Result [1].to_character_8.is_alpha_numeric and then
					Result [2] /= ':') or else
				Result [1] = '.'
			then
				l_relative_base := target.library_root
				if l_relative_base /= Void then
					Result.prepend (l_relative_base)
				else
					Result.prepend ("\")
				end
			end

				-- handle file incasesensitivity under windows
			if operating_system.is_windows then
				Result.to_lower
			end
		ensure
			Result_not_void: Result /= Void
		end

	directory (a_path: like original_path): like original_path
			-- Get the directory of `a_path' that is in the internal format.
			-- a_path = directory + '\' + path
		require
			a_path_not_void: a_path /= Void
		local
			cnt, i: INTEGER
		do
			cnt := a_path.count
			if cnt > 0 then
				i := a_path.last_index_of ('\', cnt)
				if i /= 0 then
					Result := a_path.substring (1, i-1)
				end
			end
			if Result = Void then
				create Result.make_empty
			end
		ensure
			Result_not_void: Result /= Void
		end

	file (a_path: like original_path): like original_path
			-- Get the file of `a_path' that is in the internal format.
			-- a_path = directory + '\' + path
		require
			a_path_not_void: a_path /= Void
		local
			cnt, i: INTEGER
		do
			cnt := a_path.count
			if cnt > 0 then
				i := a_path.last_index_of ('\', cnt)
				if i /= cnt then
					Result := a_path.substring (i+1, cnt)
				end
			end
			if Result = Void then
				create Result.make_empty
			end
		ensure
			Result_not_void: Result /= Void
		end

invariant
	original_path_not_void: original_path /= Void
	target_not_void: target /= Void

note
	copyright:	"Copyright (c) 1984-2012, Eiffel Software"
	license:	"GPL version 2 (see http://www.eiffel.com/licensing/gpl.txt)"
	licensing_options:	"http://www.eiffel.com/licensing"
	copying: "[
			This file is part of Eiffel Software's Eiffel Development Environment.
			
			Eiffel Software's Eiffel Development Environment is free
			software; you can redistribute it and/or modify it under
			the terms of the GNU General Public License as published
			by the Free Software Foundation, version 2 of the License
			(available at the URL listed under "license" above).
			
			Eiffel Software's Eiffel Development Environment is
			distributed in the hope that it will be useful, but
			WITHOUT ANY WARRANTY; without even the implied warranty
			of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
			See the GNU General Public License for more details.
			
			You should have received a copy of the GNU General Public
			License along with Eiffel Software's Eiffel Development
			Environment; if not, write to the Free Software Foundation,
			Inc., 51 Franklin St, Fifth Floor, Boston, MA 02110-1301 USA
		]"
	source: "[
			Eiffel Software
			5949 Hollister Ave., Goleta, CA 93117 USA
			Telephone 805-685-1006, Fax 805-685-6869
			Website http://www.eiffel.com
			Customer support http://support.eiffel.com
		]"
end
