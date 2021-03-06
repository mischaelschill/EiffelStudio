note
	legal: "See notice at end of class."
	status: "See notice at end of class."
	keywords: "Eiffel test";
	date: "August 20, 2003"

class EW_SETENV_INST

inherit
	EW_TEST_INSTRUCTION;
	EW_STRING_UTILITIES
		export
			{NONE} all
		end
	EW_SUBSTITUTION_CONST
		export
			{NONE} all
		end
	EXECUTION_ENVIRONMENT
		export
			{NONE} all
		end

feature

	inst_initialize (line: STRING)
			-- Initialize instruction from `line'.  Set
			-- `init_ok' to indicate whether
			-- initialization was successful.
		local
			args: LIST [STRING];
			count, pos: INTEGER;
		do
			args := broken_into_words (line);
			count := args.count;
			if count < 2 then
				failure_explanation := "argument count must be at least 2";
				init_ok := False;
			elseif args.first.has ('%/0/') then
				create failure_explanation.make (0);
				failure_explanation.append ("environment variable name contains null character");
				init_ok := False;
			elseif args.i_th (2).has ('%/0/') then
				create failure_explanation.make (0);
				failure_explanation.append ("environment variable value contains null character");
				init_ok := False;
			elseif count = 2 then
				variable := args.i_th (1);
				value := args.i_th (2);
				init_ok := True;
			else
				pos :=  first_white_position (line);
				variable := line.substring (1, pos - 1);
				value := line.substring (pos, line.count);
				value.left_adjust;
				value.right_adjust;
				init_ok := True;
			end;
			if init_ok then
				if value.item (1) = Quote_char and 
				   value.item (value.count) = Quote_char then
					value.remove (value.count);
					value.remove (1);
				elseif value.item (1) = Quote_char or 
				   value.item (value.count) = Quote_char then
					failure_explanation := "value must be quoted on both ends or on neither end";
					init_ok := False;
				end;
			end;
		end;

	execute (test: EW_EIFFEL_EWEASEL_TEST)
			-- Execute `Current' as one of the
			-- instructions of `test'
		do
			test.environment.add_environment_variable (variable, value);
			execute_ok := True
		end;

	init_ok: BOOLEAN;
			-- Was last call to `initialize' successful?
	
	execute_ok: BOOLEAN
			-- Was last call to `execute' successful?

feature {NONE}
	
	variable: STRING;
			-- Name of environment variable
	
	value: STRING;
			-- Value to be given to environment variable
	
note
	copyright: "[
			Copyright (c) 1984-2007, University of Southern California and contributors.
			All rights reserved.
			]"
	license:   "Your use of this work is governed under the terms of the GNU General Public License version 2"
	copying: "[
			This file is part of the EiffelWeasel Eiffel Regression Tester.

			The EiffelWeasel Eiffel Regression Tester is free
			software; you can redistribute it and/or modify it under
			the terms of the GNU General Public License version 2 as published
			by the Free Software Foundation.

			The EiffelWeasel Eiffel Regression Tester is
			distributed in the hope that it will be useful, but
			WITHOUT ANY WARRANTY; without even the implied warranty
			of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
			See the GNU General Public License version 2 for more details.

			You should have received a copy of the GNU General Public
			License version 2 along with the EiffelWeasel Eiffel Regression Tester
			if not, write to the Free Software Foundation,
			Inc., 51 Franklin St, Fifth Floor, Boston, MA
		]"

end
