--|---------------------------------------------------------------
--|   Copyright (C) Interactive Software Engineering, Inc.      --
--|    270 Storke Road, Suite 7 Goleta, California 93117        --
--|                   (805) 685-1006                            --
--| All rights reserved. Duplication or distribution prohibited --
--|---------------------------------------------------------------

-- Information given by ArchiVision when a window is moved because of
-- a change in the size of its parent.
-- X event associated: `GravityNotify'.

indexing

	date: "$Date$";
	revision: "$Revision$"

class GRAVNOT_DATA 

inherit

	CONTEXT_DATA
		undefine
			make
		end

creation

	make

feature 

	make (a_widget: WIDGET) is
			-- Create a context_data for `GravityNotify' event.
		do
			widget := a_widget
		end

end
