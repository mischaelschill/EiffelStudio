note
	description: "[
					Generated by EiffelRibbon tool
					Don't edit this file, since it will be replaced by EiffelRibbon tool
					generated files everytime
																							]"
	date: "$Date$"
	revision: "$Revision$"

deferred class
	RIBBON_GROUP_IMP_7

inherit
	EV_RIBBON_GROUP

feature {NONE} -- Initialization

	create_interface_objects
			-- Create objects
		do
			create split_button_1.make_with_command_list (<<{COMMAND_NAME_CONSTANTS}.split_button_1>>)

			create buttons.make (1)
			buttons.extend (split_button_1)

		end

feature -- Query

	split_button_1: SPLIT_BUTTON_1


end

