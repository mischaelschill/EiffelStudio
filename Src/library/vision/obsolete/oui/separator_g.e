indexing

	description: "Separator Gadget";
	status: "See notice at end of class";
	date: "$Date$";
	revision: "$Revision$"

class SEPARATOR_G 

obsolete
		"Use SEPARATOR instead."

inherit

	SEPARATOR
		redefine
			make, make_unmanaged, create_ev_widget,
			set_action, remove_action,
			background_color, set_background_color,
			background_pixmap, set_background_pixmap,
			foreground_color, set_foreground_color,
			implementation
		end

creation

	make, make_unmanaged
	
feature {NONE} -- Creation

	make (a_name: STRING; a_parent: COMPOSITE) is
			-- Create a separator gadget with `a_name' as identifier,
			-- `a_parent' as parent and call `set_default'.
		do
			create_ev_widget (a_name, a_parent, True)
		end;

	make_unmanaged (a_name: STRING; a_parent: COMPOSITE) is
			-- Create an unmanaged separator gadget with `a_name' as identifier,
			-- `a_parent' as parent and call `set_default'.
		do
			create_ev_widget (a_name, a_parent, False)
		end;

	create_ev_widget (a_name: STRING; a_parent: COMPOSITE; man: BOOLEAN) is
			-- Create a separator gadget with `a_name' as identifier,
			-- `a_parent' as parent and call `set_default'.
		do
			depth := a_parent.depth+1;
			widget_manager.new (Current, a_parent);
			identifier := clone (a_name);
			implementation := toolkit.separator_g (Current, man, a_parent);
			set_default
		end;

feature -- Callback (adding and removing)

	remove_action (a_translation: STRING) is
			-- Remove the command executed when `a_translation' occurs.
			-- Do nothing if no command has been specified.
		do
		end;

	set_action (a_translation: STRING; a_command: COMMAND; argument: ANY) is
			-- Set `a_command' to be executed when `a_translation' occurs.
			-- `a_translation' is specified with Xtoolkit convention.
		do
		end;

feature -- Color

	background_color: COLOR is
			-- Background color of widget
		do
		end;

	foreground_color: COLOR is
			-- Foreground color of primitive widget
		do
		end; 

	set_background_color (new_color: COLOR) is
			-- Set background color to `new_color'.
		do
		end;

	set_foreground_color (new_color: COLOR) is
			-- Set foreground color to `new_color'.
		do
		end 

feature 

	background_pixmap: PIXMAP is
			-- Background pixmap of widget
		do
		end; 

	set_background_pixmap (new_pixmap: PIXMAP) is
			-- Set background pixmap to `new_pixmap'.
		do
		end;

feature {G_ANY, G_ANY_I, WIDGET_I, TOOLKIT}

	implementation: SEPARATO_G_I;
			-- Implementation of current separator gadget

end


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
