indexing

	description: "General menu implementation";
	status: "See notice at end of class";
	date: "$Date$";
	revision: "$Revision$"

deferred class MENU_I 

inherit

	MANAGER_I
	
feature 

	set_title (a_title: STRING) is
			-- Set menu title to `a_title'.
		require
			not_title_void: not (a_title = Void)
		deferred
		end;

	title: STRING is
			-- Title of menu
		deferred
		end;

	remove_title is
			-- Remove current menu title if any.
		deferred
		end;

end -- class MENU_I


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
