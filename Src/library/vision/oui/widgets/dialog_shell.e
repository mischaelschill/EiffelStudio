indexing

	description: "Special shell which can be popped up or popped down at any time";
	status: "See notice at end of class";
	date: "$Date$";
	revision: "$Revision$"

class

	DIALOG_SHELL 

inherit

	POPUP_SHELL
		redefine
			implementation
		end;

	WM_SHELL
		rename
			implementation as wm_implementation
		end

create

	make
	
feature {NONE} -- Initialization

	make (a_name: STRING; a_parent: COMPOSITE) is
			-- Create a dialog shell with `a_name' as identifier,
			-- `a_parent' as parent and call `set_default'.
		require
			valid_name: a_name /= Void;
			valid_parent: a_parent /= Void
		do
			depth := a_parent.depth+1;
			widget_manager.new (Current, a_parent);
			identifier:= clone (a_name);
			create {DIALOG_SHELL_IMP} implementation.make (current, a_parent);
			set_default
		ensure
			parent_set: parent = a_parent;
			identifer_set: identifier.is_equal (a_name)
		end;
	
feature {G_ANY, G_ANY_I, WIDGET_I, TOOLKIT} -- Implementation

	implementation: DIALOG_SHELL_I
			-- Implementation of dialog shell

feature {NONE} -- Implementation

	set_default is
			-- Set default values to current dialog shell.
		do
		end;

end -- class DIALOG_SHELL

--|----------------------------------------------------------------
--| EiffelVision: library of reusable components for ISE Eiffel.
--| Copyright (C) 1985-2004 Eiffel Software. All rights reserved.
--| Duplication and distribution prohibited.  May be used only with
--| ISE Eiffel, under terms of user license.
--| Contact Eiffel Software for any other use.
--|
--| Interactive Software Engineering Inc.
--| dba Eiffel Software
--| 356 Storke Road, Goleta, CA 93117 USA
--| Telephone 805-685-1006, Fax 805-685-6869
--| Contact us at: http://www.eiffel.com/general/email.html
--| Customer support: http://support.eiffel.com
--| For latest info on our award winning products, visit:
--|	http://www.eiffel.com
--|----------------------------------------------------------------

