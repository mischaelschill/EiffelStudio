indexing
	description:
		"Eiffel Vision fixed. Mswindows implementation."
	status: "See notice at end of class"
	date: "$Date$"
	revision: "$Revision$"

class
	EV_FIXED_IMP

inherit
	EV_FIXED_I
		redefine
			interface
		end

	EV_WIDGET_LIST_IMP
		redefine
			interface,
			insert_i_th,
			remove_i_th
		end

	EV_WEL_CONTROL_CONTAINER_IMP
		rename
			make as ev_wel_control_container_make
		redefine
			top_level_window_imp,
			default_style
		end
		
create
	make

feature {NONE} -- Initialization

	make (an_interface: like interface) is
			-- Create the fixed container.
		do
			base_make (an_interface)
			ev_wel_control_container_make
			create ev_children.make (2)
			invalidate_agent := ~invalidate
		end

feature -- Status setting

	set_item_position (a_widget: EV_WIDGET; an_x, a_y: INTEGER) is
			-- Set `a_widget.x_position' to `an_x'.
			-- Set `a_widget.y_position' to `a_y'.
		local
			wel_win: WEL_WINDOW
		do
			wel_win ?= a_widget.implementation
			check
				wel_win_not_void: wel_win /= Void
			end
			wel_win.move (an_x, a_y)
			widget_changed (a_widget)
		end

	set_item_size (a_widget: EV_WIDGET; a_width, a_height: INTEGER) is
			-- Set `a_widget.width' to `a_width'.
			-- Set `a_widget.height' to `a_height'.
		local
			wel_win: WEL_WINDOW
		do
			wel_win ?= a_widget.implementation
			check
				wel_win_not_void: wel_win /= Void
			end
			wel_win.resize (a_width, a_height)
			widget_changed (a_widget)
		end

feature {EV_ANY_I} -- Implementation

	widget_changed (a_widget: EV_WIDGET) is
			-- Geometry of `a_widget' has just been modified.
			-- Repaint container and resize if necessary.
		do
			if a_widget.x_position + a_widget.width > minimum_width then
				internal_set_minimum_width (
					a_widget.x_position + a_widget.width)
			end
			if a_widget.y_position + a_widget.height > minimum_height then
				internal_set_minimum_height (
					a_widget.y_position + a_widget.height)
			end
			(create {EV_ENVIRONMENT}).application.implementation.
				do_once_on_idle (invalidate_agent)
		end

	invalidate_agent: PROCEDURE [ANY, TUPLE []]
			-- Called after a change has occurred.
	
	ev_children: ARRAYED_LIST [EV_WIDGET_IMP]
			-- Child widgets in z-order starting with farthest away.

	top_level_window_imp: EV_WINDOW_IMP
			-- Top level window that contains the current widget.

	set_top_level_window_imp (a_window: EV_WINDOW_IMP) is
			-- Assign `a_window' to `top_level_window_imp'.
		do
			top_level_window_imp := a_window
			from
				ev_children.start
			until
				ev_children.after
			loop
				ev_children.item.set_top_level_window_imp (a_window)
				ev_children.forth
			end
		end

	default_style: INTEGER is
		do
			Result := Ws_child + Ws_visible
				-- + Ws_clipchildren + Ws_clipsiblings
		end

	interface: EV_FIXED
			-- Provides a common user interface to platform dependent
			-- functionality implemented by `Current'

feature {NONE} -- Implementation

	insert_i_th (v: like item; i: INTEGER) is
			-- Insert `v' at position `i'.
		do
			Precursor (v, i)
			set_item_size (v, v.minimum_width, v.minimum_height)
		end

	remove_i_th (i: INTEGER) is
			-- Remove item at `i'-th position.
		do
			Precursor (i)
			(create {EV_ENVIRONMENT}).application.implementation.
				do_once_on_idle (invalidate_agent)
		end

feature -- Obsolete

	add_child (child_imp: EV_WIDGET_IMP) is
		obsolete
			"Call notify_change."
		do
			notify_change (2 + 1)
		end

	remove_child (child_imp: EV_WIDGET_IMP) is
		obsolete
			"Call notify_change."
		do
			notify_change (2 + 1)
		end

	add_child_ok: BOOLEAN is
		obsolete
			"Do: item = Void"
		do
			Result := item = Void
		end

	is_child (a_child: EV_WIDGET_IMP): BOOLEAN is
		obsolete
			"Do: ?? = item.implementation"
		do
			Result := a_child = item.implementation
		end

end -- class EV_FIXED_IMP

--!-----------------------------------------------------------------------------
--! EiffelVision2: library of reusable components for ISE Eiffel.
--! Copyright (C) 1986-2000 Interactive Software Engineering Inc.
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
--!-----------------------------------------------------------------------------

--|-----------------------------------------------------------------------------
--| CVS log
--|-----------------------------------------------------------------------------
--|
--| $Log$
--| Revision 1.17  2000/05/02 18:33:19  brendel
--| Completed implementation.
--|
--| Revision 1.16  2000/05/02 16:12:56  brendel
--| Implemented.
--|
--| Revision 1.15  2000/05/02 15:12:50  brendel
--| Added creation of ev_children.
--|
--| Revision 1.14  2000/05/02 00:40:27  brendel
--| Reintroduced EV_FIXED.
--| Complete revision.
--|
--| Revision 1.13  2000/02/14 11:40:43  oconnor
--| merged changes from prerelease_20000214
--|
--| Revision 1.12.10.2  2000/01/27 19:30:20  oconnor
--| added --| FIXME Not for release
--|
--| Revision 1.12.10.1  1999/11/24 17:30:26  oconnor
--| merged with DEVEL branch
--|
--| Revision 1.12.6.2  1999/11/02 17:20:09  oconnor
--| Added CVS log, redoing creation sequence
--|
--|
--|-----------------------------------------------------------------------------
--| End of CVS log
--|-----------------------------------------------------------------------------
