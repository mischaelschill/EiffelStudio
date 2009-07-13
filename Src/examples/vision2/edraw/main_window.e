note
	description	: "Main window for this application"
	legal: "See notice at end of class."
	status: "See notice at end of class."
	author		: "Generated by the New Vision2 Application Wizard."
	date		: "$Date$"
	revision	: "1.0.0"

deferred class
	MAIN_WINDOW

inherit
	EV_TITLED_WINDOW
		redefine
			initialize,
			is_in_default_state,
			create_interface_objects
		end

	INTERFACE_NAMES
		export
			{NONE} all
		undefine
			default_create, copy
		end

feature {NONE} -- Initialization

	create_interface_objects
		do
			create standard_menu_bar
			create file_menu
			create standard_toolbar
			create help_menu

			build_standard_status_bar
			Precursor {EV_TITLED_WINDOW}
		end

	initialize
			-- Build the interface for this window.
		do
			Precursor {EV_TITLED_WINDOW}

			build_main_container
			extend (main_container)


				-- Create and add the menu bar.
			build_standard_menu_bar
			set_menu_bar (standard_menu_bar)

				-- Create and add the toolbar.
			build_standard_toolbar
			upper_bar.extend (create {EV_HORIZONTAL_SEPARATOR})
			upper_bar.extend (standard_toolbar)

				-- Create and add the status bar.
			lower_bar.extend (standard_status_bar)

				-- Execute `request_close_window' when the user clicks
				-- on the cross in the title bar.
			close_request_actions.extend (agent request_close_window)

				-- Set the title of the window
			set_title (Window_title)

				-- Set the initial size of the window
			set_size (Window_width, Window_height)
		end

	is_in_default_state: BOOLEAN
			-- Is the window in its default state
			-- (as stated in `initialize')
		do
			Result := (width = Window_width) and then
				(height = Window_height) and then
				(title.is_equal (Window_title))
		end


feature {NONE} -- Menu Implementation

	standard_menu_bar: EV_MENU_BAR
			-- Standard menu bar for this window.

	file_menu: EV_MENU
			-- "File" menu for this window (contains New, Open, Close, Exit...)

	help_menu: EV_MENU
			-- "Help" menu for this window (contains About...)

	build_standard_menu_bar
			-- Create and populate `standard_menu_bar'.
		require
			menu_bar_not_yet_created: standard_menu_bar = Void
		do
				-- Add the "File" menu
			build_file_menu
			standard_menu_bar.extend (file_menu)

			build_extended_menu_bar

				-- Add the "Help" menu
			build_help_menu
			standard_menu_bar.extend (help_menu)
		ensure
			menu_bar_created:
				standard_menu_bar /= Void and then
				not standard_menu_bar.is_empty
		end

	build_extended_menu_bar
			-- Build extended menu bar.
		deferred
		end

	build_file_menu
			-- Create and populate `file_menu'.
		require
			file_menu_not_yet_created: file_menu = Void
		local
			menu_item: EV_MENU_ITEM
		do
			file_menu.set_text (Menu_file_item)

			create menu_item.make_with_text (Menu_file_new_item)
			menu_item.select_actions.extend (agent on_new)
			file_menu.extend (menu_item)

			create menu_item.make_with_text (Menu_file_save_item)
			menu_item.select_actions.extend (agent on_save)
			file_menu.extend (menu_item)

			create menu_item.make_with_text (Menu_file_saveas_item)
			menu_item.select_actions.extend (agent on_save_as)
			file_menu.extend (menu_item)

			file_menu.extend (create {EV_MENU_SEPARATOR})

			create menu_item.make_with_text (Menu_print_item)
			menu_item.select_actions.extend (agent on_print)
			file_menu.extend (menu_item)


			file_menu.extend (create {EV_MENU_SEPARATOR})

				-- Create the File/Exit menu item and make it call
				-- `request_close_window' when it is selected.
			create menu_item.make_with_text (Menu_file_exit_item)
			menu_item.select_actions.extend (agent request_close_window)
			file_menu.extend (menu_item)
		ensure
			file_menu_created: file_menu /= Void and then not file_menu.is_empty
		end

	build_help_menu
			-- Create and populate `help_menu'.
		require
			help_menu_not_yet_created: help_menu = Void
		local
			menu_item: EV_MENU_ITEM
		do
			help_menu.set_text (Menu_help_item)

			create menu_item.make_with_text (Menu_help_about_item)
			menu_item.select_actions.extend (agent on_about)
			help_menu.extend (menu_item)
		ensure
			help_menu_created: help_menu /= Void and then not help_menu.is_empty
		end

feature {NONE} -- ToolBar Implementation

	standard_toolbar: EV_TOOL_BAR
			-- Standard toolbar for this window

	build_standard_toolbar
			-- Create and populate the standard toolbar.
		require
			toolbar_not_yet_created: standard_toolbar = Void
		local
			toolbar_item: EV_TOOL_BAR_BUTTON
			toolbar_pixmap: EV_PIXMAP
		do
			create toolbar_item
			create toolbar_pixmap
			toolbar_pixmap.set_with_named_file ("./toolbar/new.png")
			toolbar_item.set_pixmap (toolbar_pixmap)
			toolbar_item.select_actions.extend (agent on_new)
			standard_toolbar.extend (toolbar_item)

			create toolbar_item
			create toolbar_pixmap
			toolbar_pixmap.set_with_named_file ("./toolbar/save.png")
			toolbar_item.set_pixmap (toolbar_pixmap)
			toolbar_item.select_actions.extend (agent on_save)
			standard_toolbar.extend (toolbar_item)

		ensure
			toolbar_created: standard_toolbar /= Void and then  not standard_toolbar.is_empty
		end

feature {NONE} -- StatusBar Implementation

	standard_status_bar: EV_STATUS_BAR
			-- Standard status bar for this window

	standard_status_label: EV_LABEL
			-- Label situated in the standard status bar.
			--
			-- Note: Call `standard_status_label.set_text (...)' to change the text
			--       displayed in the status bar.

	build_standard_status_bar
			-- Create and populate the standard toolbar.
		do
				-- Create the status bar.
			create standard_status_bar
			standard_status_bar.set_border_width (2)

				-- Populate the status bar.
			create standard_status_label.make_with_text ("")
			standard_status_label.align_text_left
			standard_status_bar.extend (standard_status_label)
		end

feature {NONE} -- About Dialog Implementation

	on_about
			-- Display the About dialog.
		local
			about_dialog: ABOUT_DIALOG
		do
			create about_dialog
			about_dialog.show_modal_to_window (Current)
		end

feature {NONE} -- Implementation, Close event

	request_close_window
			-- The user wants to close the window
		local
			question_dialog: EV_CONFIRMATION_DIALOG
			l_app: detachable EV_APPLICATION
		do
			create question_dialog.make_with_text (Label_confirm_close_window)
			question_dialog.show_modal_to_window (Current)

			if equal ((create {EV_DIALOG_CONSTANTS}).ev_ok.to_string_32, question_dialog.selected_button) then
					-- Destroy the window
				destroy;

					-- End the application
					--| TODO: Remove this line if you don't want the application
					--|       to end when the first window is closed..
				l_app ?= (create {EV_ENVIRONMENT}).application
				check l_app /= Void end
				l_app.destroy
			end
		end

feature {NONE} -- Implementation

	main_container: EV_VERTICAL_BOX
			-- Main container (contains all widgets displayed in this window)

	build_main_container
			-- Create and populate `main_container'.
		require
			main_container_not_yet_created: main_container = Void
		do
			create main_container

			main_container.extend (create {EV_TEXT})

		ensure
			main_container_created: main_container /= Void
		end

feature {NONE} -- Implementation / Constants

	Window_title: STRING = "edraw"
			-- Title of the window.

	Window_width: INTEGER = 800
			-- Initial width for this window.

	Window_height: INTEGER = 600
			-- Initial height for this window.

feature {NONE} -- Events

	on_save_as
			-- Save as was selected.
		deferred
		end

	on_save
			-- Save was selected.
		deferred
		end

	on_new
			-- New was selected.
		deferred
		end

	on_print
			-- Print was selected.
		deferred
		end

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


end -- class MAIN_WINDOW
