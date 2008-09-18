indexing
	description: "Implemented `Picture' Interface."
	legal: "See notice at end of class."
	status: "See notice at end of class."
	generator: "Automatically generated by the EiffelCOM Wizard."

class
	PICTURE_IMPL_PROXY

inherit
	PICTURE_INTERFACE

	ECOM_QUERIABLE

create
	make_from_other,
	make_from_pointer

feature {NONE}  -- Initialization

	make_from_pointer (cpp_obj: POINTER) is
			-- Make from pointer
		do
			initializer := ccom_create_picture23_impl_proxy_from_pointer(cpp_obj)
			item := ccom_item (initializer)
		end

feature -- Access

	handle: INTEGER is
			-- No description available.
		do
			Result := ccom_handle (initializer)
		end

	h_pal: INTEGER is
			-- No description available.
		do
			Result := ccom_h_pal (initializer)
		end

	type: INTEGER is
			-- No description available.
		do
			Result := ccom_type (initializer)
		end

	width: INTEGER is
			-- No description available.
		do
			Result := ccom_width (initializer)
		end

	height: INTEGER is
			-- No description available.
		do
			Result := ccom_height (initializer)
		end

feature -- Status Report

	last_error_code: INTEGER is
			-- Last error code.
		do
			Result := ccom_last_error_code (initializer)
		end

	last_error_description: STRING is
			-- Last error description.
		do
			Result := ccom_last_error_description (initializer)
		end

	last_error_help_file: STRING is
			-- Last error help file.
		do
			Result := ccom_last_error_help_file (initializer)
		end

	last_source_of_exception: STRING is
			-- Last source of exception.
		do
			Result := ccom_last_source_of_exception (initializer)
		end

feature -- Element Change

	set_h_pal (a_value: INTEGER) is
			-- Set `h_pal' with `a_value'.
		do
			ccom_set_h_pal (initializer, a_value)
		end

feature -- Basic Operations

	render (hdc: INTEGER; x: INTEGER; y: INTEGER; cx: INTEGER; cy: INTEGER; x_src: INTEGER; y_src: INTEGER; cx_src: INTEGER; cy_src: INTEGER; prc_wbounds: POINTER) is
			-- No description available.
			-- `hdc' [out].
			-- `x' [out].
			-- `y' [out].
			-- `cx' [out].
			-- `cy' [out].
			-- `x_src' [out].
			-- `y_src' [out].
			-- `cx_src' [out].
			-- `cy_src' [out].
			-- `prc_wbounds' [out].
		do
			ccom_render (initializer, hdc, x, y, cx, cy, x_src, y_src, cx_src, cy_src, prc_wbounds)
		end

feature {NONE}  -- Implementation

	delete_wrapper is
			-- Delete wrapper
		do
			ccom_delete_picture23_impl_proxy(initializer)
		end

feature {NONE}  -- Externals

	ccom_handle (cpp_obj: POINTER): INTEGER is
			-- No description available.
		external
			"C++ [Picture23_impl_proxy %"ecom_Picture23_impl_proxy.h%"]():EIF_INTEGER"
		end

	ccom_h_pal (cpp_obj: POINTER): INTEGER is
			-- No description available.
		external
			"C++ [Picture23_impl_proxy %"ecom_Picture23_impl_proxy.h%"]():EIF_INTEGER"
		end

	ccom_set_h_pal (cpp_obj: POINTER; a_value: INTEGER) is
			-- Set `h_pal' with `a_value'.
		external
			"C++ [Picture23_impl_proxy %"ecom_Picture23_impl_proxy.h%"](EIF_INTEGER)"
		end

	ccom_type (cpp_obj: POINTER): INTEGER is
			-- No description available.
		external
			"C++ [Picture23_impl_proxy %"ecom_Picture23_impl_proxy.h%"]():EIF_INTEGER"
		end

	ccom_width (cpp_obj: POINTER): INTEGER is
			-- No description available.
		external
			"C++ [Picture23_impl_proxy %"ecom_Picture23_impl_proxy.h%"]():EIF_INTEGER"
		end

	ccom_height (cpp_obj: POINTER): INTEGER is
			-- No description available.
		external
			"C++ [Picture23_impl_proxy %"ecom_Picture23_impl_proxy.h%"]():EIF_INTEGER"
		end

	ccom_render (cpp_obj: POINTER; hdc: INTEGER; x: INTEGER; y: INTEGER; cx: INTEGER; cy: INTEGER; x_src: INTEGER; y_src: INTEGER; cx_src: INTEGER; cy_src: INTEGER; prc_wbounds: POINTER) is
			-- No description available.
		external
			"C++ [Picture23_impl_proxy %"ecom_Picture23_impl_proxy.h%"](EIF_INTEGER,EIF_INTEGER,EIF_INTEGER,EIF_INTEGER,EIF_INTEGER,EIF_INTEGER,EIF_INTEGER,EIF_INTEGER,EIF_INTEGER,EIF_POINTER)"
		end

	ccom_delete_picture23_impl_proxy (a_pointer: POINTER) is
			-- Release resource
		external
			"C++ [delete Picture23_impl_proxy %"ecom_Picture23_impl_proxy.h%"]()"
		end

	ccom_create_picture23_impl_proxy_from_pointer (a_pointer: POINTER): POINTER is
			-- Create from pointer
		external
			"C++ [new Picture23_impl_proxy %"ecom_Picture23_impl_proxy.h%"](IUnknown *)"
		end

	ccom_item (cpp_obj: POINTER): POINTER is
			-- Item
		external
			"C++ [Picture23_impl_proxy %"ecom_Picture23_impl_proxy.h%"]():EIF_POINTER"
		end

	ccom_last_error_code (cpp_obj: POINTER): INTEGER is
			-- Last error code
		external
			"C++ [Picture23_impl_proxy %"ecom_Picture23_impl_proxy.h%"]():EIF_INTEGER"
		end

	ccom_last_error_description (cpp_obj: POINTER): STRING is
			-- Last error description
		external
			"C++ [Picture23_impl_proxy %"ecom_Picture23_impl_proxy.h%"]():EIF_REFERENCE"
		end

	ccom_last_error_help_file (cpp_obj: POINTER): STRING is
			-- Last error help file
		external
			"C++ [Picture23_impl_proxy %"ecom_Picture23_impl_proxy.h%"]():EIF_REFERENCE"
		end

	ccom_last_source_of_exception (cpp_obj: POINTER): STRING is
			-- Last source of exception
		external
			"C++ [Picture23_impl_proxy %"ecom_Picture23_impl_proxy.h%"]():EIF_REFERENCE"
		end

indexing
	copyright:	"Copyright (c) 1984-2006, Eiffel Software and others"
	license:	"Eiffel Forum License v2 (see http://www.eiffel.com/licensing/forum.txt)"
	source: "[
			 Eiffel Software
			 356 Storke Road, Goleta, CA 93117 USA
			 Telephone 805-685-1006, Fax 805-685-6869
			 Website http://www.eiffel.com
			 Customer support http://support.eiffel.com
		]"




end -- PICTURE_IMPL_PROXY

