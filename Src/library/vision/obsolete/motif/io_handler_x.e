indexing

	description:
		"A I/O handler manager. %
		%This class should be used to monitor I/O mechanism without interfering";
	status: "See notice at end of class";
	date: "$Date$";
	revision: "$Revision$"

class 
	IO_HANDLER_X 

inherit

	IO_HANDLER_I;

	INPUT_EVENT_X

feature -- Status setting

	set_error_call_back (a_file: IO_MEDIUM; a_command: COMMAND; an_argument: ANY) is
			-- Set `a_command' with `argument' to execute when an operation
			-- on `a_file' had raised an I/O error.
			--| the behaviour of this routine should be examined when other
			--| error handlers are used (such as Eiffel exception mechanism).
		local
			ac: like application_context;
		do
			ac := application_context;
			ac.add_input_except_callback (a_file, Current, an_argument);
			identifier := ac.last_id;
			command := a_command;
		end; 

	set_read_call_back (a_file: IO_MEDIUM; a_command: COMMAND; an_argument: ANY) is
			-- Set `a_command' with `argument' to execute when `a_file' has
			-- data available.
		local
			ac: like application_context;
		do
			ac := application_context;
			ac.add_input_read_callback (a_file, Current, an_argument);
			identifier := ac.last_id;
			command := a_command;
		end;

	set_write_call_back (a_file: IO_MEDIUM; a_command: COMMAND; 
		an_argument: ANY) is
			-- Set `a_command' with `argument' to execute when `a_file' is
			-- available for writing.
		local
			ac: like application_context;
		do
			ac := application_context;
			ac.add_input_write_callback (a_file, Current, an_argument);
			identifier := ac.last_id;
			command := a_command;
		end

feature {NONE} -- Implementation

	command: COMMAND;
			-- Command to call

	execute (argument: ANY) is
			-- Call the command.
		local
			command_clone: COMMAND
		do
			if command.is_template then
				command_clone := clone (command)
			else
				command_clone := command
			end;
			command_clone.set_context_data (Void);
			command_clone.execute (argument)
		end; 

end -- class IO_HANDLER_X

--|----------------------------------------------------------------
--| EiffelVision: library of reusable components for ISE Eiffel 3.
--| Copyright (C) 1989, 1991, 1993, 1994, Interactive Software
--|   Engineering Inc.
--| All rights reserved. Duplication and distribution prohibited.
--|
--| 270 Storke Road, Suite 7, Goleta, CA 93117 USA
--| Telephone 805-685-1006
--| Fax 805-685-6869
--| Electronic mail <info@eiffel.com>
--| Customer support e-mail <support@eiffel.com>
--|----------------------------------------------------------------
