indexing
	description: 
		"EiffelVision multi-column-list, implementation interface."
	status: "See notice at end of class"
	id: "$$"
	date: "$Date$"
	revision: "$Revision$"

class
	EV_MULTI_COLUMN_LIST_IMP

inherit
	EV_MULTI_COLUMN_LIST_I

	EV_PRIMITIVE_IMP
		export
			{EV_MULTI_COLUMN_LIST_ROW_IMP} widget
		redefine
			destroy,
			set_foreground_color,
			set_background_color,
			foreground_color,
			background_color
		end

	EV_ITEM_HOLDER_IMP

create
	make_with_size,
	make_with_text

feature {NONE} -- Initialization

	make_with_size (col_nb: INTEGER) is         
			-- Create a list widget with `par' as
			-- parent and `col_nb' columns.
			-- By default, a list allow only one selection.
		local
			i: INTEGER
		do
			widget := gtk_clist_new (col_nb)
			gtk_object_ref (widget)

			-- We need to specify a width for the columns
			-- otherwise the value given by gtk would be wrong.
			from
				i := 0
			until
				i = col_nb
			loop
				gtk_clist_set_column_width (widget, i, 80)
				i := i +1
			end

			show_title_row
			create ev_children.make (0)
		end

feature -- Access

	columns: INTEGER is
			-- Number of columns in the list.
		do
			Result := c_gtk_clist_columns (widget)
		end

	rows: INTEGER is
			-- Number of rows in the list.
		do
			Result := c_gtk_clist_rows (widget)
		end

	selected_item: EV_MULTI_COLUMN_LIST_ROW is
			-- Item which is currently selected, for a multiple
			-- selection.
		local
			index: INTEGER
		do
			if (c_gtk_clist_selection_length (widget) = 0 ) then
				-- there is no selected item
				Result := Void
			else
				-- there is one selected item
				index := c_gtk_clist_ith_selected_item (widget, 0)
				Result ?= (ev_children @ (index + 1)).interface
			end
		end

	selected_items: LINKED_LIST [EV_MULTI_COLUMN_LIST_ROW] is
			-- List of all the selected items. For a single
			-- selection list, it gives a list with only one
			-- element which is `selected_item'. Therefore, one
			-- should use `selected_item' rather than 
			-- `selected_items' for a single selection list
		local
			i: INTEGER
			index: INTEGER
			upper: INTEGER
			row: EV_MULTI_COLUMN_LIST_ROW
		do
			upper := c_gtk_clist_selection_length (widget)
			create Result.make
			from
				i := 0
			until
				i = upper
			loop
				index := c_gtk_clist_ith_selected_item (widget, i)
				row ?= (ev_children @ (index + 1)).interface
				Result.extend (row)
				i := i + 1
			end
		end

	background_color: EV_COLOR is
			-- Color used for the background of the widget.
			-- This feature might change if we give the
			-- possibility to set colors on the rows.
		local
			one_row: EV_MULTI_COLUMN_LIST_ROW_IMP
		do
			if (rows > 0) then
				one_row := (ev_children @ (1))
				Result := one_row.background_color
			else	
				Result := {EV_PRIMITIVE_IMP} Precursor
			end
		end

	foreground_color: EV_COLOR is
			-- Color used for the foreground of the widget,
			-- usually the text.
			-- This feature might change if we give the
			-- possibility to set colors on the rows.
		local
			one_row: EV_MULTI_COLUMN_LIST_ROW_IMP
		do
			if (rows > 0) then
				one_row := (ev_children @ (1))
				Result := one_row.foreground_color
			else	
				Result := {EV_PRIMITIVE_IMP} Precursor
			end
		end

feature -- Status report

	selected: BOOLEAN is
			-- Is at least one item selected ?
		do
			Result := c_gtk_clist_selected (widget)
		end

	is_multiple_selection: BOOLEAN is
			-- True if the user can choose several items
			-- False otherwise
		do
			Result := (c_gtk_clist_selection_mode (widget) = GTK_SELECTION_MULTIPLE)
		end

	title_shown: BOOLEAN is
			-- True if the title row is shown.
			-- False if the title row is not shown.
		do
			Result := c_gtk_clist_title_shown (widget)
		end

	get_column_width (column: INTEGER): INTEGER is
			-- Width of column `column' in pixel.
		do
			Result := c_gtk_clist_column_width (widget, column - 1)
		end

feature -- Status setting

	destroy is
		-- Destroy screen widget implementation and EV_LIST_ITEM objects
		do
			clear_items
			{EV_PRIMITIVE_IMP} Precursor 
		end

	show_title_row is
			-- Show the row of the titles.
		do
			gtk_clist_column_titles_show (widget)
		end

	hide_title_row is
			-- Hide the row of the titles.
		do
			gtk_clist_column_titles_hide (widget)
		end

	set_multiple_selection is
			-- Allow the user to do a multiple selection simply
			-- by clicking on several choices.
			-- For constants, see EV_GTK_CONSTANTS
		do
			gtk_clist_set_selection_mode (widget, GTK_SELECTION_MULTIPLE)
		end

	set_single_selection is
			-- Allow the user to do only one selection. It is the
			-- default status of the list.
			-- For constants, see EV_GTK_CONSTANTS
		do
			gtk_clist_set_selection_mode (widget, GTK_SELECTION_SINGLE)
		end

	set_column_alignment (type: INTEGER; column: INTEGER) is
			-- Align the text of the column at left.

		do
			gtk_clist_set_column_justification (widget, column - 1, type)
		end

	select_item (index: INTEGER) is
			-- Select an item at the one-based `index' of the list.
		do
			(ev_children @ index).set_selected (True)
		end

	deselect_item (index: INTEGER) is
			-- Unselect the item at the one-based `index'.
		do
			(ev_children @ index).set_selected (False)
		end

	clear_selection is
			-- Clear the selection of the list.
		do
			gtk_clist_unselect_all (widget)
		end

feature -- Element change

	set_column_title (txt: STRING; column: INTEGER) is
			-- Make `txt' the title of the column number
			-- `number'.
		local
			a: ANY
		do
			a := txt.to_c
			gtk_clist_set_column_title (widget, column - 1, $a)
		end

	set_column_width (value: INTEGER; column: INTEGER) is
			-- Make `value' the new width of the column number
			-- `column'.
		do
			gtk_clist_set_column_width (widget, column - 1, value)
		end

	set_rows_height (value: INTEGER) is
			-- Make`value' the new height of all the rows.
		do
			gtk_clist_set_row_height (widget, value)
		end

	clear_items is
			-- Clear all the items of the list.
		local
			c: ARRAYED_LIST [EV_MULTI_COLUMN_LIST_ROW_IMP]
				-- to work with local variable which
				-- increases speed if there are many elements
				-- in `ev_children'
		do
			clear_ev_children	
			gtk_clist_clear (widget)
		end

	set_background_color (color: EV_COLOR) is
			-- Make `color' the new `background_color' of every rows.
		local
			children_array: ARRAYED_LIST [EV_MULTI_COLUMN_LIST_ROW_IMP]
			row: EV_MULTI_COLUMN_LIST_ROW_IMP
		do
			if (rows > 0) then
				from
					children_array := ev_children
					children_array.start
				until
					children_array.after
				loop
					row := children_array.item
					row.set_background_color (color)
					children_array.forth
				end
			else
				 {EV_PRIMITIVE_IMP} Precursor (color)
			end
		end

	set_foreground_color (color: EV_COLOR) is
			-- Make `color' the new `foreground_color' of every rows.
		local
			children_array: ARRAYED_LIST [EV_MULTI_COLUMN_LIST_ROW_IMP]
			row: EV_MULTI_COLUMN_LIST_ROW_IMP
		do
			if (rows > 0) then
				from
					children_array := ev_children
					children_array.start
				until
					children_array.after
				loop
					row := children_array.item
					row.set_foreground_color (color)
					children_array.forth
				end
			else
				{EV_PRIMITIVE_IMP} Precursor (color)
			end
		end

feature -- Event : command association

	add_select_command (cmd: EV_COMMAND; arg: EV_ARGUMENT) is	
			-- Add `cmd' to the list of commands to be executed
			-- when a row has been selected.
		local
			i: INTEGER
		do
			-- We pass 0 as the extra_data to have a different handling in 'c_gtk_signal_connect_general'.
			i := 0
			add_command (widget, "select_row", cmd, arg, c_gtk_integer_to_pointer (i))
		end

	add_unselect_command (cmd: EV_COMMAND; arg: EV_ARGUMENT) is	
			-- Add `cmd' to the list of commands to be executed
			-- when a row has been unselected.
		local
			i: INTEGER
		do
			-- We pass 0 as the extra_data to have a different handling in 'c_gtk_signal_connect_general'.
			i := 0
			add_command (widget, "unselect_row", cmd, arg, c_gtk_integer_to_pointer (i))
		end

	add_column_click_command (cmd: EV_COMMAND; arg: EV_ARGUMENT) is
			-- Add `cmd' to the list of commands to be executed
			-- when a column is clicked.
		do
			add_command (widget, "click_column", cmd, arg, default_pointer)
		end

feature -- Event -- removing command association

	remove_select_commands is	
			-- Empty the list of commands to be executed
			-- when an item has been selected.
		local
			list: LINKED_LIST [EV_COMMAND]
		do
			-- list of the commands to be executed for "select_row" signal.
			list := (event_command_array @ select_row_id).command_list

			from
				list.start
			until
				list.after
			loop
				remove_single_command (widget, select_row_id, list.item)
				-- we do not need to do "list.forth" as an item has been removed
				-- that list.
			end
		end

	remove_unselect_commands is	
			-- Empty the list of commands to be executed
			-- when an item has been unselected.
		local
			list: LINKED_LIST [EV_COMMAND]
		do
			-- list of the commands to be executed for "unselect_row" signal.
			list := (event_command_array @ unselect_row_id).command_list

			from
				list.start
			until
				list.after
			loop
				remove_single_command (widget, unselect_row_id, list.item)
				-- we do not need to do "list.forth" as an item has been removed
				-- that list.
			end
		end

	remove_column_click_commands is
			-- Empty the list of commands to be executed
			-- when a column is clicked.
		do
			remove_commands (widget, click_column_id)
		end

feature {EV_MULTI_COLUMN_LIST_ROW_IMP} -- Implementation

	add_item (item_imp: EV_MULTI_COLUMN_LIST_ROW_IMP) is
			-- Add `item' to the list
		local
			local_index: INTEGER
			column_i: INTEGER
		do
			-- update the list of rows of the column list:
			ev_children.force (item_imp)

			-- add an empty row to the gtk column list:
			local_index := c_gtk_clist_append_row (widget)

			-- add text in the gtk column list row:
			from
				item_imp.internal_text.start
				column_i := 1
			until
				column_i > columns
			loop
				item_imp.set_cell_text ( column_i, item_imp.internal_text.item)
				item_imp.internal_text.forth
				column_i := column_i + 1
			end
		end

	remove_item (item_imp: EV_MULTI_COLUMN_LIST_ROW_IMP) is
		do
			-- Remove the gtk clist row from the gtk clist
			gtk_clist_remove (widget, item_imp.index - 1)

			-- remove the row from the `ev_children'
			ev_children.search (item_imp)
			ev_children.remove
		end

feature {NONE} -- Inapplicable

	make is
			-- Do nothing, need to be implemented
		do
			check
				Inapplicable: False
			end
		end

end -- class EV_MULTI_COLUMN_LIST_IMP

--!----------------------------------------------------------------
--! EiffelVision2: library of reusable components for ISE Eiffel.
--! Copyright (C) 1986-1999 Interactive Software Engineering Inc.
--! All rights reserved. Duplication and distribution prohibited.
--! May be used only with ISE Eiffel, under terms of user license. 
--! Contact ISE for any other use.
--!
--! Interactive Software Engineering Inc.
--! ISE Building, 2nd floor
--! 270 Storke Road, Goleta, CA 93117 USA
--! Telephone 805-685-1006, Fax 805-685-6869
--! Electronic mail <info@eiffel.com>
--! Customer support e-mail <support@eiffel.com>
--! For latest info see award-winning pages: http://www.eiffel.com
--!---------------------------------------------------------------
