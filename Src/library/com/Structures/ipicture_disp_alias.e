indexing
	description: "No description available."
	Note: "Automatically generated by the EiffelCOM Wizard."

class
	IPICTURE_DISP_ALIAS

inherit
	PICTURE_IMPL_PROXY

creation
	make_from_pointer,
	make_from_other,
	make_from_alias

feature {None}  -- Initialization

	make_from_alias (an_alias: PICTURE_IMPL_PROXY) is
			-- Create from alias
		require
			non_void_alias: an_alias /= Void
		do
			make_from_pointer (an_alias.item)
		end

end -- IPICTURE_DISP_ALIAS

