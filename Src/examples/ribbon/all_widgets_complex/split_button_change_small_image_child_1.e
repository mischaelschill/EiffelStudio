note
	description: "[
					Generated by EiffelRibbon tool
																							]"
	date: "$Date$"
	revision: "$Revision$"

class
	SPLIT_BUTTON_CHANGE_SMALL_IMAGE_CHILD_1

inherit
	SPLIT_BUTTON_CHANGE_SMALL_IMAGE_CHILD_1_IMP
		redefine
			create_interface_objects
		end

create
	{EV_RIBBON_GROUP, EV_RIBBON_SPLIT_BUTTON, EV_RIBBON_APPLICATION_MENU_GROUP, EV_RIBBON_DROP_DOWN_BUTTON, EV_RIBBON_QUICK_ACCESS_TOOLBAR} make_with_command_list

feature -- Query

	text: STRING_32 = "Button 1"
			-- This is generated by EiffelRibbon tool

feature {NONE} -- Initialization

	create_interface_objects
			-- <Precursor>
		do
			Precursor
			select_actions.extend (agent
										local
											l_pixel_buffer: EV_PIXEL_BUFFER
										do
											create l_pixel_buffer
											if counter.item \\ 2 = 0 then
												l_pixel_buffer.set_with_named_file ("./res/Copy.bmp")
											else
												l_pixel_buffer.set_with_named_file ("./res/Cut.bmp")
											end

											set_small_image (l_pixel_buffer)
											counter.put (counter.item + 1)
										end)
		end

	counter: CELL [INTEGER]
			--
		once
			create Result.put (0)
		end

end
