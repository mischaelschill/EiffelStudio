indexing

	description:
		"Encapsulation of a C extension.";
	date: "$Date$";
	revision: "$Revision$"

class C_EXTENSION_I

inherit
	EXTERNAL_EXT_I
		rename
			is_equal as ext_is_equal
		end
	EXTERNAL_EXT_I
		redefine
			is_equal
		select
			is_equal
		end

feature -- Properties

	special_file_name: STRING
			-- Special file name (dll or macro)

feature -- Initialization

	set_special_file_name (f: STRING) is
			-- Assign `f' to `special_file_name'.
		do
			special_file_name := f
		end

feature -- Comparison

	is_equal (other: like Current): BOOLEAN is
		do	
			Result := ext_is_equal (other) and then
				equal (special_file_name, other.special_file_name)
		end

end -- class C_EXTENSION_I
