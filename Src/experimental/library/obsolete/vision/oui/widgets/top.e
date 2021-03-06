note

	description: "Top is the abstract class for TOP_SHELL and BASE"
	legal: "See notice at end of class.";
	status: "See notice at end of class.";
	date: "$Date$";
	revision: "$Revision$"

deferred class

	TOP 

inherit

	SHELL
		redefine
			implementation, screen, top
		end;

	WM_SHELL
		rename
			implementation as wm_implementation
		end
	
feature  -- Access

	screen: SCREEN;
			-- Screen of current top-level

	icon_name: STRING
			-- Short form of application name to be displayed
			-- by the window manager when application is iconified
		require
			exists: not destroyed
		do
			Result := implementation.icon_name
		end; 

	top: TOP
			-- Top shell or base of widget (itself here)
		do
			Result := Current
		ensure then
			Top_is_current: Result = Current
		end ;

feature -- Status report

	is_iconic_state: BOOLEAN
			-- Does application start in iconic state?
		require
			exists: not destroyed
		do
			Result := implementation.is_iconic_state
		end;

	is_maximized_state: BOOLEAN
			-- Does application start in maximized state?
		require
			exists: not destroyed
		do
			Result := implementation.is_maximized_state
		end;

feature -- Status setting

	set_iconic_state
			-- Set start state of the application to be iconic.
		require
			exists: not destroyed
		do
			implementation.set_iconic_state
		end;

	set_normal_state
			-- Set start state of the application to be normal.
		require
			exists: not destroyed
		do
			implementation.set_normal_state
		end;

	set_maximized_state
			-- Set start state of the application to be maximized.
		require
			exists: not destroyed
		do
			implementation.set_maximized_state
		end

feature -- Element change

	set_icon_name (a_name: STRING)
			-- Set `icon_name' to `a_name'.
		require
			exists: not destroyed;
			Valid_name: a_name /= Void
		do
			implementation.set_icon_name (a_name)
		end;

	delete_window_action
			-- Called when 'top' is destroyed.
			-- (Will exit application if
			-- `delete_command' is not set).
		do
			if delete_command = Void then
				toolkit.exit
			else
				delete_command.execute (Void);
			end;
		end;

feature -- Removal

	set_delete_command (c: COMMAND)
		do
			delete_command := c;
		end;

feature {NONE} -- Implementation

	delete_command: COMMAND;

feature {G_ANY, G_ANY_I, WIDGET_I, APPLICATION} -- Implementation

	implementation: TOP_I;
			-- Implementation of top

invariant

	Depth_is_zero: depth = 0;
	Has_no_parent: parent = Void

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




end -- class TOP

