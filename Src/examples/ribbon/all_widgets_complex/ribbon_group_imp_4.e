note
	description: "[
					Generated by EiffelRibbon tool
					Don't edit this file, since it will be replaced by EiffelRibbon tool
					generated files everytime
																							]"
	date: "$Date$"
	revision: "$Revision$"

deferred class
	RIBBON_GROUP_IMP_4

inherit
	EV_RIBBON_GROUP

feature {NONE} -- Initialization

	create_interface_objects
			-- Create objects
		do
			create checkbox_1.make_with_command_list (<<{COMMAND_NAME_CONSTANTS}.checkbox_1>>)

			create buttons.make (1)
			buttons.extend (checkbox_1)

		end

feature -- Query

	checkbox_1: CHECKBOX_1


end

