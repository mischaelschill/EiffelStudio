indexing
	description: "OLE Automation."
	Note: "Automatically generated by the EiffelCOM Wizard."

class
	FONTSIZE_ALIAS

inherit
	ECOM_CURRENCY

create
	make,
	make_by_pointer,
	make_from_alias

feature {None}  -- Initialization

	make_from_alias (an_alias: ECOM_CURRENCY) is
			-- Create from alias
		require
			non_void_alias: an_alias /= Void
		do
			make_by_pointer (an_alias.item)
			an_alias.set_shared
		end

end -- FONTSIZE_ALIAS

--|----------------------------------------------------------------
--| EiffelCOM: library of reusable components for ISE Eiffel.
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

