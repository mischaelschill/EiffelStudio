indexing 
	description: "Generic wizard dialog"

class 
	WIZARD_DIALOG

inherit
	WEL_MODAL_DIALOG
		redefine
			on_cancel,
			on_control_command,
			setup_dialog
		end

	APPLICATION_IDS
		export
			{NONE} all
		end

	WIZARD_SHARED_DATA
		export
			{NONE} all
		end

	EXECUTION_ENVIRONMENT
		export
			{NONE} all
		end

	WEL_HELP_CONSTANTS
		export
			{NONE} all
		end

feature -- Access

	id_cancel: WEL_PUSH_BUTTON
			-- Back button

	id_ok: WEL_PUSH_BUTTON
			-- Next/Finish button

	id_back: WEL_PUSH_BUTTON
			-- Back button

	help_button: WEL_PUSH_BUTTON
			-- Help button

	help_topic_id: INTEGER
			-- Topic ID for Help

feature -- Behavior

	on_cancel is
			-- Cancel button was pushed
		do
			Shared_wizard_environment.set_abort (0)
			Precursor {WEL_MODAL_DIALOG}
		end

	on_control_command (control: WEL_CONTROL) is
			-- A command has been received from `control'.
		do
			if control = help_button then
				on_help
			elseif control = id_back then
				terminate (Idcancel)
			end
		end

	setup_dialog is
			-- Give focus to Next button.
		do
			id_ok.set_focus
		end

	on_help is
			-- Invoce Help.
		local
			tmp_help_path: STRING			
		do
			tmp_help_path := clone (get ("EIFFEL4"))
			tmp_help_path.append ("\wizards\com\eiffelcom.hlp")
			win_help (tmp_help_path, Help_context, help_topic_id)
		end

end -- class WIZARD_DIALOG

--|-------------------------------------------------------------------
--| This class was automatically generated by Resource Bench
--| Copyright (C) 1996-1997, Interactive Software Engineering, Inc.
--|
--| 270 Storke Road, Suite 7, Goleta, CA 93117 USA
--| Telephone 805-685-1006
--| Fax 805-685-6869
--| Information e-mail <info@eiffel.com>
--| Customer support e-mail <support@eiffel.com>
--|-------------------------------------------------------------------
