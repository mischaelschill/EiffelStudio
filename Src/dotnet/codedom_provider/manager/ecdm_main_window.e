indexing
	description: "Objects that represent an EV_TITLED_WINDOW.%
		%The original version of this class was generated by EiffelBuild."
	date: "$Date$"
	revision: "$Revision$"

class
	ECDM_MAIN_WINDOW

inherit
	ECDM_MAIN_WINDOW_IMP

	ECDM_SAVED_SETTINGS
		rename
			make as saved_settings_make
		export
			{NONE} all
		undefine
			default_create,
			copy
		end

	CODE_EVENT_LOG_LEVEL
		export
			{NONE} all
		undefine
			default_create,
			copy
		end

create
	make

feature {NONE} -- Initialization

	make (a_manager: ECDM_MANAGER) is
			-- Set `manager' with `a_manager'.
		require
			non_void_manager: a_manager /= Void
		do
			saved_settings_make
			manager := a_manager
			default_create
		ensure
			manager_set: manager = a_manager
		end
		
	user_initialization is
			-- called by `initialize'. 
			-- Any custom user initialization that
			-- could not be performed in `initialize',
			-- (due to regeneration of implementation class)
			-- can be added here.
		local
			l_item: EV_LIST_ITEM
			l_constants: ECDM_CONSTANTS
			l_dialog: EV_MESSAGE_DIALOG
			l_configs: LIST [ECDM_CONFIGURATION]
			l_config: ECDM_CONFIGURATION
		do
			if manager.Default_configuration = Void then
				create l_dialog.make_with_text ("Could not load default configuration file, please check Eiffel Codedom Provider installation.")
				l_dialog.set_title ("Error")
				l_dialog.set_buttons (<<"OK">>)
				l_dialog.set_default_push_button (l_dialog.button ("OK"))
				l_dialog.set_pixmap ((create {EV_STOCK_PIXMAPS}).error_pixmap)
				l_dialog.show_modal_to_window (Current)
				(create {EXCEPTIONS}).die (1)
			end
			set_height (saved_height)
			set_width (saved_width)
			set_x_position (saved_x_pos)
			set_y_position (saved_y_pos)
			if saved_show_text then
				show_text_menu_item.enable_select
			else
				show_text_menu_item.disable_select
			end
			on_show_text
			if saved_show_tooltip then
				show_tooltips_menu_item.enable_select
			else
				show_tooltips_menu_item.disable_select
			end
			on_show_tooltips
			applications_list.disable_multiple_selection
			configurations_list.disable_multiple_selection
			close_request_actions.extend (agent on_close)
			create l_constants
			create l_item.make_with_text (l_constants.No_logging)
			l_item.set_data (No_log)
			log_level_combo.extend (l_item)
			create l_item.make_with_text (l_constants.Error_logging)
			l_item.set_data (Default_log)
			log_level_combo.extend (l_item)
			create l_item.make_with_text (l_constants.Warning_logging)
			l_item.set_data (Warning_log)
			log_level_combo.extend (l_item)
			create l_item.make_with_text (l_constants.All_logging)
			l_item.set_data (Full_log)
			log_level_combo.extend (l_item)
			configurations_list.set_focus
			l_configs := manager.all_configurations
			from
				l_configs.start
			until
				l_configs.after
			loop
				l_config := l_configs.item
				if (create {RAW_FILE}.make (l_config.path)).exists then
					create l_item.make_with_text (l_config.name)
					l_item.set_data (l_config)
					configurations_list.extend (l_item)
				end
				if l_config.precompile /= Void then
					precompile_combo.extend (create {EV_LIST_ITEM}.make_with_text (l_config.precompile))
				end
				l_configs.forth
			end
			configurations_list.first.enable_select
			prefixes_list.set_column_titles (<<"Prefix", "Assembly File Name">>)
			initialize_from_configuration
			set_help_context (agent hlp_ctxt)
			create help_parent_control.make_from_text ("")
			create help_control
			help_control.extend (help_parent_control)
			show_actions.extend (agent on_column_resize (1))
		end

feature -- Access

	help_control: EV_WINFORM_CONTAINER
			-- Help parent control container

	help_parent_control: WINFORMS_CONTROL
			-- Help dialog parent

	manager: ECDM_MANAGER
			-- Associated manager
	
	initialized: BOOLEAN
			-- Was interface initialized?

	hlp_ctxt: ECDM_HELP_CONTEXT is
			-- Help context
		do
			create Result.make_from_string ("")
		end
		
feature {NONE} -- Events

	on_config_new is
			-- Called by `select_actions' of `new_button'.
			-- Show new configuration dialog.
		local
			l_last_config: ECDM_CONFIGURATION
			l_list_item: EV_LIST_ITEM
			l_new_dialog: ECDM_NEW_CONFIGURATION_DIALOG
		do
			create l_new_dialog.make (manager)
			l_new_dialog.show_modal_to_window (Current)
			l_last_config := l_new_dialog.configuration
			if l_last_config /= Void then
				create l_list_item.make_with_text (l_last_config.name)
				l_list_item.set_data (l_last_config)
				configurations_list.extend (l_list_item)
			end
		end

	on_config_save is
			-- Called by `select_actions' of `save_button'.
			-- Save selected configuration.
		local
			l_config: ECDM_CONFIGURATION
		do
			l_config := active_configuration
			if l_config /= Void then
				l_config.save
				manager.commit
				set_clean
			end
		ensure then
			clean: not is_dirty
			save_button_disabled: not save_button.is_sensitive
			revert_button_disabled: not revert_button.is_sensitive
		end

	on_revert is
			-- Called by `select_actions' of `revert_menu_item'.
			-- Revert to last saved information
		local
			l_config: ECDM_CONFIGURATION
		do
			l_config := active_configuration
			if l_config /= Void then
				if feature {SYSTEM_FILE}.exists (l_config.path) then
					active_configuration.load (l_config.path)
					initialize_from_configuration
				end
				manager.roll_back
			end
		ensure then
			clean: not is_dirty
			save_button_disabled: not save_button.is_sensitive
			revert_button_disabled: not revert_button.is_sensitive
		end
		
	on_config_info is
			-- Called by `select_actions' of `info_button'.
			-- Show selected configuration properties dialog.
		local
			l_prop_dialog: ECDM_CONFIGURATION_PROPERTIES_DIALOG
			l_config: ECDM_CONFIGURATION
		do
			l_config := active_configuration
			if l_config /= Void then
				create l_prop_dialog.make (l_config, manager)
				l_prop_dialog.show_modal_to_window (Current)
			end
		end

	on_config_delete is
			-- Called by `select_actions' of `delete_button'.
			-- Delete selected configuration.
		local
			l_apps: LIST [STRING]
			l_message: STRING
			l_dialog: EV_QUESTION_DIALOG
			l_config: ECDM_CONFIGURATION
		do
			l_config := active_configuration
			if l_config /= Void then
				l_apps := manager.applications (l_config)
				create l_message.make (128)
				from
					l_apps.start
					if not l_apps.after then
						l_message.append (" - ")
						l_message.append (l_apps.item)
						l_apps.forth
					end
				until
					l_apps.after
				loop
					l_message.append ("%N - ")
					l_message.append (l_apps.item)
					l_apps.forth
				end
				create l_dialog.make_with_text_and_actions ("Are you sure you want to delete this configuration?%NThe following application(s) rely on it:%N" + l_message, <<agent delete_active_configuration, agent do_nothing, agent do_nothing>>)
				l_dialog.show_modal_to_window (Current)
			end
		end

	on_help_select is
			-- Called by `select_actions' of `help_button'.
		do
			(create {EV_ENVIRONMENT}).application.display_help_for_widget (Current)
		end

	on_configuration_select is
			-- Called by `pointer_button_press_actions' of `configurations_list'.
			-- Check if selected is default configuration and hide applications frame and disable delete button
			-- Otherwise show applications frame and enable delete button.
		local
			l_item: EV_LIST_ITEM
			l_config: ECDM_CONFIGURATION
		do
			l_item := configurations_list.selected_item
			if l_item /= Void then
				l_config ?= l_item.data
				check
					is_configuration: l_config /= Void
				end
				if active_configuration = Void or else not l_config.is_equal (active_configuration) then
					check_should_save
					if not selection_cancelled then
						l_item := configurations_list.selected_item
						if l_item /= Void then
							active_configuration ?= l_item.data
						end
						initialize_from_configuration
					elseif active_configuration /= Void then
						configurations_list.retrieve_item_by_data (active_configuration, True).enable_select
						selection_cancelled := False
					end
				end
			end
		end

	on_configuration_double_click (a_x, a_y, a_button: INTEGER; a_x_tilt, a_y_tilt, a_pressure: DOUBLE; a_screen_x, a_screen_y: INTEGER) is
			-- Called by `pointer_double_press_actions' of `configurations_list'.
		do
			on_config_info
		end

	on_key_press (a_key: EV_KEY) is
			-- Called by `key_press_actions' of `applications_list'.
		local
			l_done: BOOLEAN
		do
			if a_key.is_alpha then
				from
					applications_list.start
				until
					applications_list.after	or l_done			
				loop
					l_done := applications_list.item.text.item (1).is_equal (a_key.out.item (1))
					if l_done then
						applications_list.ensure_item_visible (applications_list.item)
					end
					applications_list.forth
				end
			end
		end

	on_fail_on_error_select is
			-- Called by `select_actions' of `fail_on_error_check_button'.
			-- Update selected configuration object.
			-- Set dirty flag.
		local
			l_set: BOOLEAN
		do
			if active_configuration /= Void then
				l_set := fail_on_error_check_button.is_selected
				if active_configuration.fail_on_error /= l_set then
					active_configuration.set_fail_on_error (l_set)
					set_dirty
				end
			end
		end

	on_log_level_select is
			-- Called by `select_actions' of `log_level_combo'.
			-- Update selected configuration object.
			-- Set dirty flag.
		local
			l_level: INTEGER_REF
		do
			if active_configuration /= Void then
				l_level ?= log_level_combo.selected_item.data
				if active_configuration.log_level /= l_level then
					active_configuration.set_log_level (l_level.item)
					set_dirty
				end
			end
		end

	on_log_server_select is
			-- Called by `return_actions' of `log_server_text_field'.
			-- Update selected configuration object.
			-- Set dirty flag.
		local
			l_server: STRING
		do
			if active_configuration /= Void then
				l_server := log_server_text_field.text
				if l_server.is_empty then
					log_server_text_field.set_text (active_configuration.log_server_name) -- Log server name cannot be empty
				elseif not l_server.is_equal (active_configuration.log_server_name) then
					active_configuration.set_log_server_name (l_server)
					set_dirty					
				end
			end
		end

	on_root_class_select is
			-- Called by `return_actions' of `root_class_text_field'.
			-- Update selected configuration object.
			-- Set dirty flag.
		local
			l_name: STRING
		do
			if active_configuration /= Void then
				l_name := root_class_text_field.text
				if l_name.is_empty then
					root_class_text_field.set_text (active_configuration.default_root_class) -- Default root class cannot be empty
				elseif not l_name.is_equal (active_configuration.default_root_class) then
					active_configuration.set_default_root_class (l_name)
					set_dirty
				end
			end
		end

	on_precompiled_select is
			-- Called by `return_actions' of `precompile_combo'.
			-- Update selected configuration object.
			-- Set dirty flag.
		local
			l_precomp: STRING
		do
			if active_configuration /= Void then
				l_precomp := precompile_combo.text
				if not l_precomp.is_empty then
					if active_configuration.precompile = Void or else not l_precomp.is_equal (active_configuration.precompile) then
						active_configuration.set_precompile (l_precomp)
						set_dirty
					end
				elseif active_configuration.precompile /= Void then
					active_configuration.set_precompile (Void)
					set_dirty
				end
			end
		end

	on_precompiled_browse is
			-- Called by `select_actions' of `browse_button'.
			-- Browse for precompiled library.
		local
			l_dialog: EV_FILE_OPEN_DIALOG
			l_path: STRING
		do
			if active_configuration /= Void then
				create l_dialog.make_with_title ("Find Precompiled Library")
				l_dialog.filters.extend (["*.epr", "Eiffel Projects (*.epr)"])
				l_dialog.show_modal_to_window (Current)
				l_path := l_dialog.file_name
				if not l_path.is_empty then
					precompile_combo.set_text (l_path)
				end
			end
		end

	on_add_application is
			-- Called by `select_actions' of `add_button'.
			-- Browse for application.
		local
			l_dialog: EV_FILE_OPEN_DIALOG
			l_path: STRING
			l_strings: LIST [STRING]
			l_error_dialog: EV_MESSAGE_DIALOG
		do
			if active_configuration /= Void then
				create l_dialog.make_with_title ("Find Application")
				l_dialog.filters.extend (["*.exe", "Applications (*.exe)"])
				l_dialog.show_modal_to_window (Current)
				l_path := l_dialog.file_name
				if not l_path.is_empty then
					l_strings := applications_list.strings
					l_strings.compare_objects
					if not l_strings.has (l_path) then
						applications_list.extend (create {EV_LIST_ITEM}.make_with_text (l_path))
						manager.add_application_to_register (l_path, active_configuration)
						remove_button.enable_sensitive
						set_dirty
					else
						create l_error_dialog.make_with_text ("Application is already in list, please choose a different application.")
						l_error_dialog.set_title (product_title)
						l_error_dialog.set_pixmap ((create {EV_STOCK_PIXMAPS}).Warning_pixmap)
						l_error_dialog.set_buttons_and_actions (<<"OK">>, <<agent on_add_application>>)
						l_error_dialog.set_default_push_button (l_error_dialog.button ("OK"))
						l_error_dialog.show_modal_to_window (Current)
					end
				end
			end
		end

	on_remove_application is
			-- Called by `select_actions' of `remove_button'.
			-- Browse for application.
		local
			l_item: EV_LIST_ITEM
		do
			l_item := applications_list.selected_item
			if active_configuration /= Void and l_item /= Void then
				manager.add_application_to_delete (l_item.text, active_configuration)	
				applications_list.prune_all (l_item)
				if applications_list.count = 1 then
					remove_button.disable_sensitive
				end
				set_dirty
			end
		end

	on_application_select is
			-- Called by `select_actions' of `applications_list'.
			-- Enable `remove' button.
		do
			if applications_list.count > 1 then
				remove_button.enable_sensitive			
			end
		end

	on_application_deselect is
			-- Called by `select_actions' of `applications_list'.
			-- Disable `remove' button if no more selected items.
		do
			remove_button.disable_sensitive
		end

	on_about is
			-- Called by `select_actions' of `about_menu_item'.
			-- Display about dialog box.
		do
			(create {ECDM_ABOUT_DIALOG}).show_modal_to_window (Current)
		end
	
	on_close is
			-- Save graphical settings for next start.
		do
			check_should_save
			if selection_cancelled then
				selection_cancelled := False	
			else
				save_height (height)
				save_width (width)
				save_x_pos (x_position)
				save_y_pos (y_position)
				save_show_text (show_text_menu_item.is_selected)
				save_show_tooltip (show_tooltips_menu_item.is_selected)
				(create {EV_APPLICATION}).destroy
			end
		end

	on_show_text is
			-- Called by `select_actions' of `show_text_menu_item'.
			-- Show or hide menu text
		do
			if show_text_menu_item.is_selected then
				tool_bars_box.set_minimum_height (36)
			else
				tool_bars_box.set_minimum_height (22)
			end
		end
		
	on_show_tooltips is
			-- Called by `select_actions' of `show_tooltips_item'.
			-- Show or hide menu tooltips
		do
			if show_tooltips_menu_item.is_selected then
				new_button.set_tooltip (new_button_tooltip)
				save_button.set_tooltip (save_button_tooltip)
				revert_button.set_tooltip (revert_button_tooltip)
				properties_button.set_tooltip (properties_button_tooltip)
				delete_button.set_tooltip (delete_button_tooltip)
				help_button.set_tooltip (help_button_tooltip)
			else
				new_button.remove_tooltip
				save_button.remove_tooltip
				revert_button.remove_tooltip
				properties_button.remove_tooltip
				delete_button.remove_tooltip
				help_button.remove_tooltip
			end
		end
		
	on_assembly_file_name_select (an_item: EV_MULTI_COLUMN_LIST_ROW) is
			-- Called by `select_actions' of `prefixes_list'.
		do
			check_can_remove_prefix
			prefix_text_field.set_text (an_item.i_th (1))
			assembly_file_name_text_field.set_text (an_item.i_th (2))
		end
	
	on_assembly_file_name_deselect (an_item: EV_MULTI_COLUMN_LIST_ROW) is
			-- Called by `deselect_actions' of `prefixes_list'.
		do
			assembly_file_name_add_button.disable_sensitive
			assembly_file_name_remove_button.disable_sensitive
		end

	on_prefix_change is
			-- Called by `change_actions' of `prefix_text_field'.
		do
			check_can_add_prefix
		end

	on_assembly_file_name_change is
			-- Called by `change_actions' of `assembly_file_name_text_field'.
		do
			check_can_add_prefix
		end
	
	on_assembly_file_name_browse is
			-- Called by `select_actions' of `assembly_file_name_browse_button'.
		local
			l_dialog: EV_FILE_OPEN_DIALOG
			l_file_name: STRING
			l_runtime_dir: STRING
		do
			create l_dialog.make_with_title ("Browse for assembly...")
			l_dialog.filters.extend (["*.dll", "Assembly File (*.dll)"])
			l_dialog.filters.extend (["*.*", "All Files (*.*)"])
			l_dialog.show_modal_to_window (Current)
			l_file_name := l_dialog.file_name
			if not l_file_name.is_empty then
				l_runtime_dir := feature {RUNTIME_ENVIRONMENT}.get_runtime_directory
				if l_file_name.substring_index (l_runtime_dir, 1) = 1 then
					l_file_name.keep_tail (l_file_name.count - l_runtime_dir.count)
				end
				assembly_file_name_text_field.set_text (l_file_name)
			end
		end
	
	on_add_assembly_file_name is
			-- Called by `select_actions' of `assembly_file_name_add_button'.
		local
			l_runtime_dir, l_file_name: STRING
			l_row: EV_MULTI_COLUMN_LIST_ROW
		do
			if active_configuration /= Void then
				l_file_name := assembly_file_name_text_field.text
				l_runtime_dir := feature {RUNTIME_ENVIRONMENT}.get_runtime_directory
				if l_file_name.substring_index (l_runtime_dir, 1) = 1 then
					l_file_name.keep_tail (l_file_name.count - l_runtime_dir.count)
				end
				active_configuration.add_prefix (l_file_name, prefix_text_field.text)
				create l_row
				l_row.extend (prefix_text_field.text)
				l_row.extend (assembly_file_name_text_field.text)
				prefixes_list.extend (l_row)
				assembly_file_name_add_button.disable_sensitive
				set_dirty
			end
		end
	
	on_remove_assembly_file_name is
			-- Called by `select_actions' of `assembly_file_name_remove_button'.
		do
			if active_configuration /= Void then
				active_configuration.remove_prefix (prefixes_list.selected_item.i_th (2))
				prefixes_list.prune_all (prefixes_list.selected_item)
				assembly_file_name_add_button.enable_sensitive
				set_dirty
			end
		end

	on_column_resize (a_column: INTEGER) is
			-- Called by `column_resize_actions' of `prefixes_list'.
			-- Make sure last column fills all available space.
		do
			if a_column = 1 then
				prefixes_list.set_column_width (prefixes_list.width - prefixes_list.column_width (1), 2)
			end
		end

feature {NONE} -- Implementation

	initialize_from_configuration is
			-- Initialize widget from `active_configuration'.
		local
			l_config: ECDM_CONFIGURATION
			l_apps: LIST [STRING]
			l_assemblies: LIST [STRING]
			l_row: EV_MULTI_COLUMN_LIST_ROW
		do
			l_config := active_configuration
			if l_config /= Void then
				initialized := True
				if l_config.fail_on_error then
					fail_on_error_check_button.enable_select
				else
					fail_on_error_check_button.disable_select
				end
				log_server_text_field.set_text (l_config.log_server_name)
				log_level_combo.retrieve_item_by_data (l_config.log_level, True).enable_select
				if l_config.default_root_class /= Void then
					root_class_text_field.set_text (l_config.default_root_class)
				else
					root_class_text_field.remove_text
				end
				if l_config.precompile /= Void then
					precompile_combo.set_text (l_config.precompile)
				else
					precompile_combo.remove_text
				end
				if not compiler_frame.is_show_requested then
					compiler_frame.show
				end
				if not general_frame.is_show_requested then
					general_frame.show
				end
				if l_config.is_equal (manager.Default_configuration) then
					if applications_frame.is_show_requested then
						applications_frame.hide
					end
					if delete_button.is_sensitive then
						delete_button.disable_sensitive
					end
				else
					if not applications_frame.is_show_requested then
						applications_frame.show
					end
					if not delete_button.is_sensitive then
						delete_button.enable_sensitive
					end
					l_apps := manager.applications (l_config)
					if l_apps /= Void then
						from
							l_apps.start
							applications_list.wipe_out
						until
							l_apps.after
						loop
							applications_list.extend (create {EV_LIST_ITEM}.make_with_text (l_apps.item))
							l_apps.forth
						end
						if l_apps.count = 1 and remove_button.is_sensitive then
							remove_button.disable_sensitive -- There has to be at least one application for the configuration
						end
					else
						remove_button.disable_sensitive
					end
				end
				if not properties_button.is_sensitive then
					properties_button.enable_sensitive				
				end
				l_assemblies := l_config.prefixed_assemblies
				from
					l_assemblies.start
					prefixes_list.wipe_out
				until
					l_assemblies.after
				loop
					create l_row
					l_row.extend (l_config.assembly_prefix (l_assemblies.item))
					l_row.extend (l_assemblies.item)
					prefixes_list.extend (l_row)
					l_assemblies.forth
				end
				set_clean -- we have to manually clean as setting the values
							-- dirtied the configuration
			end
		ensure
			applications_frame_hidden_if_default_config: active_configuration.is_equal (manager.Default_configuration) implies not applications_frame.is_show_requested
			applications_frame_shown_if_not_default_config: not active_configuration.is_equal (manager.Default_configuration) implies applications_frame.is_show_requested
			delete_button_disabled_if_default_config: active_configuration.is_equal (manager.Default_configuration) implies not delete_button.is_sensitive
			delete_button_enabled_if_not_default_config: not active_configuration.is_equal (manager.Default_configuration) implies delete_button.is_sensitive
		end

	delete_active_configuration is
			-- Delete active configuration.
		do
			if active_configuration /= Void then
				manager.delete_configuration (active_configuration)
				configurations_list.prune_all (configurations_list.retrieve_item_by_data (active_configuration, True))
				if configurations_list.count > 0 then
					configurations_list.first.enable_select
				end
			end
		end
		
	active_configuration: ECDM_CONFIGURATION
			-- Currently selected configuration if any.
	
	log_level (a_level: INTEGER): STRING is
			-- Text corresponding to log level `a_level'
		require
			valid_level: a_level >= 0 and a_level <= 3
		local
			l_constants: ECDM_CONSTANTS
		do
			create l_constants
			inspect
				a_level
			when No_log then
				Result := l_constants.No_logging
			when Default_log then
				Result := l_constants.Error_logging
			when Warning_log then
				Result := l_constants.Warning_logging
			when Full_log then
				Result := l_constants.All_logging
			end
		ensure
			has_text: Result /= Void
		end
	
	check_should_save is
			-- Check whether there has been unsaved changes and prompt for saving if needed.
		local
			l_dialog: EV_MESSAGE_DIALOG
		do
			if is_dirty then
				create l_dialog.make_with_text ("Configuration has been modified, do you want to save your changes?")
				l_dialog.set_title (product_title)
				l_dialog.set_buttons_and_actions (<<"Yes", "No", "Cancel">>, <<agent on_config_save, agent on_revert, agent cancel_selection>>)
				l_dialog.set_default_push_button (l_dialog.button ("Yes"))
				l_dialog.set_pixmap ((create {EV_STOCK_PIXMAPS}).question_pixmap)
				l_dialog.show_modal_to_window (Current)
			end
		ensure
			save_button_disabled: not save_button.is_sensitive
			revert_button_disabled: not revert_button.is_sensitive
		end
	
	check_can_remove_prefix is
			-- Check whether `Remove' button from prefix list should be enabled.
		local
			l_item: EV_MULTI_COLUMN_LIST_ROW
		do
			l_item := prefixes_list.selected_item
			if l_item /= Void and active_configuration /= Void then
				if active_configuration.Default_prefixes.has (l_item.i_th (2)) then
					assembly_file_name_remove_button.disable_sensitive
				else
					assembly_file_name_remove_button.enable_sensitive
				end
			else
				assembly_file_name_remove_button.disable_sensitive
			end
		end
		
	check_can_add_prefix is
			-- Check whether `Add' button from prefix list should be enabled.
		do
			if active_configuration /= Void and not prefix_text_field.text.is_empty and not assembly_file_name_text_field.text.is_empty then
				if not active_configuration.prefixed_assemblies.has (assembly_file_name_text_field.text) then
					assembly_file_name_add_button.enable_sensitive
				else
					assembly_file_name_add_button.disable_sensitive
				end
			else
				assembly_file_name_add_button.disable_sensitive
			end
		end

	cancel_selection is
			-- Set `selection_cancelled' to `True'.
		do
			selection_cancelled := True
		end
	
	selection_cancelled: BOOLEAN
			-- Was last selection cancelled by user?

	set_clean is
			-- Set `is_dirty' to fase and disable save and revert buttons.
		do
			if is_dirty then
				is_dirty := False
				if save_button.is_sensitive then
					save_button.disable_sensitive					
				end
				if revert_button.is_sensitive then
					revert_button.disable_sensitive					
				end
			end
		ensure
			is_clean: not is_dirty
			save_button_disabled: not save_button.is_sensitive
			revert_button_disabled: not revert_button.is_sensitive
		end
		
	set_dirty is
			-- Set `is_dirty' to true and enable save and revert button.
		do
			if not is_dirty then
				is_dirty := True
				if not save_button.is_sensitive then
					save_button.enable_sensitive
				end
				if not revert_button.is_sensitive then
					revert_button.enable_sensitive
				end
			end
		ensure
			is_dirty: is_dirty
			save_button_enabled: save_button.is_sensitive
			revert_button_enabled: revert_button.is_sensitive
		end
		
	is_dirty: BOOLEAN
			-- Was configuration object changed since it was last loaded/saved?

invariant
	non_void_manager: manager /= Void

end -- class ECDM_ECDM_MAIN_WINDOW

--+--------------------------------------------------------------------
--| Eiffel CodeDOM Provider Manager
--| Copyright (C) 2001-2004 Eiffel Software
--| Eiffel Software Confidential
--| All rights reserved. Duplication and distribution prohibited.
--|
--| Eiffel Software
--| 356 Storke Road, Goleta, CA 93117 USA
--| http://www.eiffel.com
--+--------------------------------------------------------------------