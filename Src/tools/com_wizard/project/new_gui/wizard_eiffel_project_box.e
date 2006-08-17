indexing
	description: "Objects that represent an EV_TITLED_WINDOW.%
		%The original version of this class was generated by EiffelBuild."
	legal: "See notice at end of class."
	status: "See notice at end of class."
	date: "$Date$"
	revision: "$Revision$"

class
	WIZARD_EIFFEL_PROJECT_BOX

inherit
	WIZARD_EIFFEL_PROJECT_BOX_IMP
		redefine
			show
		end

	WIZARD_VALIDITY_CHECKER
		undefine
			default_create,
			is_equal,
			copy
		end

feature {NONE} -- Initialization

	user_initialization is
			-- called by `initialize'.
		do
			initialize_checker
			epr_box.setup ("Path to Eiffel project location", "epr_key", agent eiffel_project_validity (?), Void, Void)
			ecf_file_box.setup ("Path to system's configuration file (*.ecf):", "ecf_key", agent ecf_file_validity (?), create {ARRAYED_LIST [TUPLE [STRING, STRING]]}.make_from_array (<<["*.ecf", "ECF File (*.ecf)"], ["*.*", "All Files (*.*)"]>>), "Browse for system's configuration file")
			target_box.setup ("Target to use", "target_key", agent eiffel_target_validity (?), Void, Void)
			facade_box.setup ("Name of Eiffel facade class:", "facade_key", agent eiffel_class_validity (?), Void, Void)
			facade_cluster_box.setup ("Name of Eiffel facade class cluster:", "cluster_key", agent cluster_validity (?), Void, Void)
		end

feature -- Basic Operations

	save_values is
			-- Persist combo box entries for next session.
		do
			facade_box.save_combo_text
			facade_cluster_box.save_combo_text
		end

	update_environment is
			-- Update `environment' according to text fields contents.
		local
			l_text: STRING
		do
			l_text := epr_box.value
			if is_valid_file (l_text) then
				environment.set_eiffel_project (l_text)
				environment.set_project_name (l_text.substring (l_text.last_index_of ('\', l_text.count) + 1, l_text.count))
			end
			l_text := ecf_file_box.value
			if is_valid_file (l_text) then
				environment.set_source_ecf_file_name (l_text)
			end
			l_text := target_box.value
			if not l_text.is_empty then
				environment.set_eiffel_target (l_text)
			end
			l_text := facade_box.value
			if is_valid_eiffel_identifier (l_text) then
				environment.set_eiffel_class_name (l_text)
			end
			l_text := facade_cluster_box.value
			if is_valid_eiffel_identifier (l_text) then
				environment.set_class_cluster_name (l_text)
			end
		end

	show is
			-- Update environment and show.
		do
			Precursor {WIZARD_EIFFEL_PROJECT_BOX_IMP}
			update_environment
		end

feature {NONE} -- Implementation

	eiffel_target_validity (a_target: STRING): WIZARD_VALIDITY_STATUS is
			-- Is `a_target' valid?
			-- Setup environment accordingly.
		do
			if not a_target.is_empty then
				create Result.make_success (feature {WIZARD_VALIDITY_STATUS_IDS}.Eiffel_target)
				environment.set_eiffel_target (a_target)
			else
				create Result.make_error (feature {WIZARD_VALIDITY_STATUS_IDS}.Eiffel_target)
			end
			set_status (Result)
		end

	eiffel_project_validity (a_project_file: STRING): WIZARD_VALIDITY_STATUS is
			-- Is `a_project_file' a valid eiffel project file?
			-- Setup environment accordingly.
		do
			if is_valid_folder (a_project_file) then
				create Result.make_success (feature {WIZARD_VALIDITY_STATUS_IDS}.Eiffel_project)
				environment.set_eiffel_project (a_project_file)
				environment.set_project_name (a_project_file.substring (a_project_file.last_index_of ('\', a_project_file.count) + 1, a_project_file.count))
			else
				create Result.make_error (feature {WIZARD_VALIDITY_STATUS_IDS}.Eiffel_project)
			end
			set_status (Result)
		end

	ecf_file_validity (a_file: STRING): WIZARD_VALIDITY_STATUS is
			-- Is `a_file' a valid eiffel ecf file?
			-- Setup environment accordingly.
		do
			if is_valid_file (a_file) then
				create Result.make_success (feature {WIZARD_VALIDITY_STATUS_IDS}.ecf_file)
				environment.set_source_ecf_file_name (a_file)
			else
				create Result.make_error (feature {WIZARD_VALIDITY_STATUS_IDS}.ecf_file)
			end
			set_status (Result)
		end

	eiffel_class_validity (a_eiffel_class: STRING): WIZARD_VALIDITY_STATUS is
			-- Is `a_eiffel_class' a valid eiffel class?
			-- Setup environment accordingly.
		do
			if is_valid_eiffel_identifier (a_eiffel_class) then
				create Result.make_success (feature {WIZARD_VALIDITY_STATUS_IDS}.Eiffel_class)
				environment.set_eiffel_class_name (a_eiffel_class)
			else
				create Result.make_error (feature {WIZARD_VALIDITY_STATUS_IDS}.Eiffel_class)
			end
			set_status (Result)
		end

	cluster_validity (a_cluster: STRING): WIZARD_VALIDITY_STATUS is
			-- Is `a_cluster' a valid eiffel cluster?
			-- Setup environment accordingly.
		do
			if is_valid_eiffel_identifier (a_cluster) then
				create Result.make_success (feature {WIZARD_VALIDITY_STATUS_IDS}.Eiffel_cluster)
				environment.set_class_cluster_name (a_cluster)
			else
				create Result.make_error (feature {WIZARD_VALIDITY_STATUS_IDS}.Eiffel_cluster)
			end
			set_status (Result)
		end

	is_valid_eiffel_identifier (a_string: STRING): BOOLEAN is
			-- Is `a_string' a valid eiffel identifier?
		local
			i, l_count: INTEGER;
			l_char: CHARACTER
		do
			l_count := a_string.count
			if l_count /= 0 and then a_string.item(1).is_alpha then
				from
					Result := True
					i := 2
				until
					i > l_count or else not Result
				loop
					l_char := a_string.item (i)
					Result := l_char.is_alpha or else l_char = '_' or else l_char.is_digit
					i := i + 1
				end
			end
		end

indexing
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
end -- class WIZARD_EIFFEL_PROJECT_BOX


