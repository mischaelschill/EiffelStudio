indexing
	description:
		"Executable components"

	status:	"See note at end of class"
	date: "$Date$"
	revision: "$Revision$"

deferred class 
	RUNNABLE

feature -- Status report

	is_enabled: BOOLEAN is
			-- Is component enabled?
	 	deferred
		end
		
	is_ready: BOOLEAN is
	 		-- Is component ready to be executed?
		deferred
		end
	
feature -- Basic operations

	execute is
			-- Execute component.
		require
			enabled: is_enabled
			ready: is_ready
		deferred
		end

end -- class RUNNABLE

--|----------------------------------------------------------------
--| EiffelTest: Reusable components for developing unit tests.
--| Copyright (C) 2000 Interactive Software Engineering Inc (ISE).
--| EiffelTest may be used by anyone as FREE SOFTWARE to
--| develop any product, public-domain or commercial, without
--| payment to ISE, under the terms of the ISE Free Eiffel Library
--| License (IFELL) at http://eiffel.com/products/base/license.html.
--|
--| Interactive Software Engineering Inc.
--| ISE Building, 2nd floor
--| 270 Storke Road, Goleta, CA 93117 USA
--| Telephone 805-685-1006, Fax 805-685-6869
--| Electronic mail <info@eiffel.com>
--| Customer support e-mail <support@eiffel.com>
--| For latest info see award-winning pages: http://www.eiffel.com
--|----------------------------------------------------------------
