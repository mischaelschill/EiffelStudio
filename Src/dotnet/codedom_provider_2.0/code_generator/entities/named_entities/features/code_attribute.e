note 
	description: "Eiffel attribute"
	legal: "See notice at end of class."
	status: "See notice at end of class."
	date: "$$"
	revision: "$$"	

class
	CODE_ATTRIBUTE

inherit
	CODE_FEATURE

create
	make

feature -- Access

	code: STRING
			-- | call 'generated_attribute' then 'generated_comments'
			-- | Result := "feature [{exports,...}] -- feature_type
			-- |				[frozen] `attribute_name': `type'
			-- |					[-- comments ..."]
			
			-- Eiffel code of attribute
		do
			create Result.make (100)
			increase_tabulation
			Result.append (indent_string)
			if line_pragma /= Void then
				Result.append (line_pragma.code)
				Result.append (Line_return)
			end
			if is_frozen then
				Result.append ("frozen ")
			end
			Result.append (eiffel_name)
			Result.append (": ")
			if result_type /= Void then
				Result.append (result_type.eiffel_name)
			else
				Event_manager.raise_event ({CODE_EVENTS_IDS}.Missing_return_type, ["Attribute " + name + " (" + eiffel_name + ")"])
				Result.append ("ANY")
			end
			Result.append (Line_return)
			Result.append (comments_code)
			Result.append (indexing_clause)
			decrease_tabulation
			Result.append (Line_return)
		end

note
	copyright:	"Copyright (c) 1984-2006, Eiffel Software"
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
			distributed in the hope that it will be useful,	but
			WITHOUT ANY WARRANTY; without even the implied warranty
			of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
			See the	GNU General Public License for more details.
			
			You should have received a copy of the GNU General Public
			License along with Eiffel Software's Eiffel Development
			Environment; if not, write to the Free Software Foundation,
			Inc., 51 Franklin St, Fifth Floor, Boston, MA 02110-1301  USA
		]"
	source: "[
			 Eiffel Software
			 356 Storke Road, Goleta, CA 93117 USA
			 Telephone 805-685-1006, Fax 805-685-6869
			 Website http://www.eiffel.com
			 Customer support http://support.eiffel.com
		]"
end -- class CODE_ATTRIBUTE

