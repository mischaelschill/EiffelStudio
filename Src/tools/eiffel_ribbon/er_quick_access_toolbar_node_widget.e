note
	description: "EiffelVision Widget ER_QUICK_ACCESS_TOOLBAR_NODE_WIDGET.%
		%The original version of this class was generated by EiffelBuild."
	generator: "EiffelBuild"
	date: "$Date$"
	revision: "$Revision$"

class
	ER_QUICK_ACCESS_TOOLBAR_NODE_WIDGET

inherit
	ER_QUICK_ACCESS_TOOLBAR_NODE_WIDGET_IMP


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
			create checker
		end

feature -- Command

	set_tree_node_data (a_data: detachable ER_TREE_NODE_QUICK_ACCESS_TOOLBAR_DATA)
			-- Update GUI with tree node data
		do
			tree_node_data := a_data
			if attached a_data as l_data then
				if attached a_data.command_name as l_command_name then
					command_name.set_text (l_command_name)
				else
					command_name.remove_text
				end
			end
		end

feature {NONE} -- Implementation

	checker: ER_IDENTIFIER_UNIQUENESS_CHECKER
			-- Identifier uniqueness checker

	tree_node_data: detachable ER_TREE_NODE_QUICK_ACCESS_TOOLBAR_DATA
			-- Quick access toolbar tree node data

	on_command_name_focus_out
			-- <Precursor>
		do
			checker.on_focus_out (command_name, tree_node_data)
		end

	on_command_name_change
			-- <Precursor>
		do
			checker.on_identifier_name_change (command_name, tree_node_data)
		end

end
