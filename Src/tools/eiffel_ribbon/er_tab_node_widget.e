note
	description: "Objects that represent an EV_TITLED_WINDOW.%
		%The original version of this class was generated by EiffelBuild."
	generator: "EiffelBuild"
	date: "$Date$"
	revision: "$Revision$"

class
	ER_TAB_NODE_WIDGET

inherit
	ER_TAB_NODE_WIDGET_IMP


feature {NONE} -- Initialization

	user_initialization
			-- Called by `initialize'.
			-- Any custom user initialization that
			-- could not be performed in `initialize',
			-- (due to regeneration of implementation class)
			-- can be added here.
		do
		end

	user_create_interface_objects
			-- <Precursor>
		do
				-- Initialize before calling Precursor all the attached attributes
				-- from the current class.

				-- Proceed with vision2 objects creation.
		end

feature -- Command

	set_tree_node_data (a_data: detachable ER_TREE_NODE_TAB_DATA)
			-- Update GUI with tree node data
		do
			tree_node_data := a_data
			if attached a_data as l_data then
				if attached a_data.command_name as l_command_name then
					command_name.set_text (l_command_name)
				else
					command_name.remove_text
				end

				if attached a_data.label_title as l_label_title then
					label.set_text (l_label_title)
				else
					label.remove_text
				end
			end
		end

feature {NONE} -- Implementation

	tree_node_data: detachable ER_TREE_NODE_TAB_DATA
			-- Tab tree node data

	on_command_name_text_change
			-- <Precursor>
		local
			l_checker: ER_IDENTIFIER_UNIQUENESS_CHECKER
		do
			create l_checker
			l_checker.on_identifier_name_change (command_name, tree_node_data)
		end

	on_label_changes
			-- Called by `change_actions' of `label'.
		do
			if attached tree_node_data as l_data then
				l_data.set_label_title (label.text)
			end
		end
end
