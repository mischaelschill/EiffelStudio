-- Eiffel class generated by the 2.3 to 3 translator.

class DEBUG_RUN 

inherit

	IPC_SHARED;
	SHARED_WORKBENCH
		export
			{NONE} all
		end;
	PROJECT_CONTEXT
		export
			{NONE} all
		end;
	EIFFEL_ENV
		export
			{NONE} all
		end;
	ICONED_COMMAND;
	SHARED_DEBUG


creation

	make

	
feature 

	make (c: COMPOSITE; a_text_window: TEXT_WINDOW) is
		do
			init (c, a_text_window);
			!!run_request.make (Rqst_application);
			!!cont_request.make (Rqst_cont)
		end;

	
feature {NONE}

	work (argument: ANY) is
			-- Re-run the application
		local
			application_path: STRING;
			status: BOOLEAN
		do
			if Run_info.is_running then
					-- Application is running. Continue execution.
				status := cont_request.send_byte_code;
				if status then
					cont_request.send_breakpoints
				end;
				debug_info.tenure;
				cont_request.send_rqst_1 (Rqst_resume, Resume_cont);
			else
					-- Application is not running. Start it.
				if project_tool.initialized then
					!!application_path.make (50);
					application_path.append (Generation_path);
					application_path.append ("/");
					application_path.append (System.system_name);
--io.putstring ("Pop up prompt window to ask for arguments%N");
					run_request.set_application_name (application_path);
					run_request.send
				end
			end;
			Run_info.set_is_stopped (False);
		end;

feature 

	symbol: PIXMAP is 
		once 
			!!Result.make; 
			Result.read_from_file (bm_Debug_run) 
		end;
 
	
feature {NONE}

	command_name: STRING is do Result := l_Debug_run end;

	run_request: RUN_REQUEST;

	cont_request: EWB_REQUEST

end
