indexing
	description: "Objects that represent an EV_TITLED_WINDOW.%
		%The original version of this class was generated by EiffelBuild."

deferred class
	WIZARD_FOLDER_PATH_BOX_IMP

inherit
	EV_VERTICAL_BOX
		redefine
			initialize, is_in_default_state
		end
			
	WIZARD_CONSTANTS
		undefine
			is_equal, default_create, copy
		end

-- This class is the implementation of an EV_TITLED_WINDOW generated by EiffelBuild.
-- You should not modify this code by hand, as it will be re-generated every time
-- modifications are made to the project.

feature {NONE}-- Initialization

	initialize is
			-- Initialize `Current'.
		do
			Precursor {EV_VERTICAL_BOX}
			initialize_constants
			
				-- Create all widgets.
			create path_label
			create path_text_box
			create path_combo
			create path_button
			
				-- Build_widget_structure.
			extend (path_label)
			extend (path_text_box)
			path_text_box.extend (path_combo)
			path_text_box.extend (path_button)
			
			set_padding_width (5)
			disable_item_expand (path_label)
			disable_item_expand (path_text_box)
			path_label.set_text ("Folder path:")
			path_label.align_text_left
			path_text_box.set_padding_width (7)
			path_text_box.disable_item_expand (path_button)
			path_combo.set_background_color (create {EV_COLOR}.make_with_8_bit_rgb (255, 255, 185))
			path_button.set_text ("...")
			path_button.set_minimum_width (40)
			
				--Connect events.
			path_combo.change_actions.extend (agent on_change)
			path_combo.focus_in_actions.extend (agent on_mouse_enter)
			path_combo.focus_out_actions.extend (agent on_mouse_leave)
			path_button.select_actions.extend (agent on_browse)
				-- Close the application when an interface close
				-- request is recieved on `Current'. i.e. the cross is clicked.

				-- Call `user_initialization'.
			user_initialization
		end

feature -- Access

	path_label: EV_LABEL
	path_text_box: EV_HORIZONTAL_BOX
	path_combo: EV_COMBO_BOX
	path_button: EV_BUTTON

feature {NONE} -- Implementation

	is_in_default_state: BOOLEAN is
			-- Is `Current' in its default state?
		do
			-- Re-implement if you wish to enable checking
			-- for `Current'.
			Result := True
		end
	
	user_initialization is
			-- Feature for custom initialization, called at end of `initialize'.
		deferred
		end
	
	on_change is
			-- Called by `change_actions' of `path_combo'.
		deferred
		end
	
	on_mouse_enter is
			-- Called by `focus_in_actions' of `path_combo'.
		deferred
		end
	
	on_mouse_leave is
			-- Called by `focus_out_actions' of `path_combo'.
		deferred
		end
	
	on_browse is
			-- Called by `select_actions' of `path_button'.
		deferred
		end
	

end -- class WIZARD_FOLDER_PATH_BOX_IMP
