note

	description: "General toggle button implementation"
	legal: "See notice at end of class.";
	status: "See notice at end of class.";
	date: "$Date$";
	revision: "$Revision$"

deferred class

	TOGGLE_B_I 

inherit

	BUTTON_I
	
feature -- Status setting

	arm
			-- Assign True to `state'.
		deferred
		ensure
			state_is_true: state
		end;

	disarm
			-- Assign False to `state'
		deferred
		ensure
			state_is_false: not state
		end;

	state: BOOLEAN
			-- State of current toggle button.
		deferred
		end

	set_toggle_on
			-- Set Current toggle on and set
			-- state to True.
		deferred
		ensure
			state_is_true: state
		end;

	set_toggle_off
			-- Set Current toggle off and set
			-- state to False.
		deferred
		ensure
			state_is_false: not state
		end;

feature -- Element change

	add_value_changed_action (a_command: COMMAND; argument: ANY)
			-- Add `a_command' to the list of action to execute when value
			-- is changed.
		require
			not_a_command_void: a_command /= Void
		deferred
		end;

	add_activate_action (a_command: COMMAND; argument: ANY)
		deferred
		end;

	set_accelerator_action (a_translation: STRING)
			-- Set the accerlator action (modifiers and key to use as a shortcut
			-- in selecting a button) to `a_translation'.
			-- `a_translation' must be specified with the X toolkit conventions.
		require
			translation_not_void: a_translation /= Void
		deferred
		end;

feature -- Removal

	remove_activate_action (a_command: COMMAND; argument: ANY)
		deferred
		end;

	remove_accelerator_action
			-- Remove the accelerator action.
		deferred
		end;

	remove_value_changed_action (a_command: COMMAND; argument: ANY)
			-- Remove `a_command' from the list of action to execute when
			-- value is changed.
		require
			not_a_command_void: a_command /= Void
		deferred
		end;

note
	copyright:	"Copyright (c) 1984-2006, Eiffel Software and others"
	license:	"Eiffel Forum License v2 (see http://www.eiffel.com/licensing/forum.txt)"
	source: "[
			 Eiffel Software
			 356 Storke Road, Goleta, CA 93117 USA
			 Telephone 805-685-1006, Fax 805-685-6869
			 Website http://www.eiffel.com
			 Customer support http://support.eiffel.com
		]"




end --class TOGGLE_B_I

