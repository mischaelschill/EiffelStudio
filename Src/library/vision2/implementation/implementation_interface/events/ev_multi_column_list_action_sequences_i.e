indexing
	description:
		"Action sequences for EV_MULTI_COLUMN_LIST_I."
	status: "Generated!"
	keywords: "event, action, sequence"
	date: "Generated!"
	revision: "Generated!"

deferred class
	 EV_MULTI_COLUMN_LIST_ACTION_SEQUENCES_I


feature -- Event handling

	select_actions: EV_MULTI_COLUMN_LIST_ROW_SELECT_ACTION_SEQUENCE is
			-- Actions to be performed 
		do
			if select_actions_internal = Void then
				select_actions_internal :=
					 create_select_actions
			end
			Result := select_actions_internal
		ensure
			not_void: Result /= Void
		end

feature {EV_ANY_I} -- Implementation

	create_select_actions: EV_MULTI_COLUMN_LIST_ROW_SELECT_ACTION_SEQUENCE is
			-- Create a select action sequence.
		deferred
		end

	select_actions_internal: EV_MULTI_COLUMN_LIST_ROW_SELECT_ACTION_SEQUENCE
			-- Implementation of once per object `select_actions'.


feature -- Event handling

	deselect_actions: EV_MULTI_COLUMN_LIST_ROW_SELECT_ACTION_SEQUENCE is
			-- Actions to be performed 
		do
			if deselect_actions_internal = Void then
				deselect_actions_internal :=
					 create_deselect_actions
			end
			Result := deselect_actions_internal
		ensure
			not_void: Result /= Void
		end

feature {EV_ANY_I} -- Implementation

	create_deselect_actions: EV_MULTI_COLUMN_LIST_ROW_SELECT_ACTION_SEQUENCE is
			-- Create a deselect action sequence.
		deferred
		end

	deselect_actions_internal: EV_MULTI_COLUMN_LIST_ROW_SELECT_ACTION_SEQUENCE
			-- Implementation of once per object `deselect_actions'.


feature -- Event handling

	column_title_click_actions: EV_COLUMN_ACTION_SEQUENCE is
			-- Actions to be performed 
		do
			if column_title_click_actions_internal = Void then
				column_title_click_actions_internal :=
					 create_column_title_click_actions
			end
			Result := column_title_click_actions_internal
		ensure
			not_void: Result /= Void
		end

feature {EV_ANY_I} -- Implementation

	create_column_title_click_actions: EV_COLUMN_ACTION_SEQUENCE is
			-- Create a column_title_click action sequence.
		deferred
		end

	column_title_click_actions_internal: EV_COLUMN_ACTION_SEQUENCE
			-- Implementation of once per object `column_title_click_actions'.


feature -- Event handling

	column_resize_actions: EV_COLUMN_ACTION_SEQUENCE is
			-- Actions to be performed 
		do
			if column_resize_actions_internal = Void then
				column_resize_actions_internal :=
					 create_column_resize_actions
			end
			Result := column_resize_actions_internal
		ensure
			not_void: Result /= Void
		end

feature {EV_ANY_I} -- Implementation

	create_column_resize_actions: EV_COLUMN_ACTION_SEQUENCE is
			-- Create a column_resize action sequence.
		deferred
		end

	column_resize_actions_internal: EV_COLUMN_ACTION_SEQUENCE
			-- Implementation of once per object `column_resize_actions'.

end

--|----------------------------------------------------------------
--| EiffelVision2: library of reusable components for ISE Eiffel.
--| Copyright (C) 1986-2001 Interactive Software Engineering Inc.
--| All rights reserved. Duplication and distribution prohibited.
--| May be used only with ISE Eiffel, under terms of user license. 
--| Contact ISE for any other use.
--|
--| Interactive Software Engineering Inc.
--| ISE Building
--| 360 Storke Road, Goleta, CA 93117 USA
--| Telephone 805-685-1006, Fax 805-685-6869
--| Electronic mail <info@eiffel.com>
--| Customer support: http://support.eiffel.com>
--| For latest info see award-winning pages: http://www.eiffel.com
--|----------------------------------------------------------------

