note
	description: "Implemented `IQuickActivate' Interface."
	legal: "See notice at end of class."
	status: "See notice at end of class."
	generator: "Automatically generated by the EiffelCOM Wizard."

class
	IQUICK_ACTIVATE_IMPL_PROXY

inherit
	IQUICK_ACTIVATE_INTERFACE

	ECOM_QUERIABLE

create
	make_from_other,
	make_from_pointer

feature {NONE}  -- Initialization

	make_from_pointer (cpp_obj: POINTER)
			-- Make from pointer
		do
			initializer := ccom_create_iquick_activate_impl_proxy_from_pointer(cpp_obj)
			item := ccom_item (initializer)
		end

feature -- Basic Operations

	quick_activate (p_qa_container: TAG_QACONTAINER_RECORD; p_qa_control: TAG_QACONTROL_RECORD)
			-- No description available.
			-- `p_qa_container' [in].  
			-- `p_qa_control' [out].  
		do
			ccom_quick_activate (initializer, p_qa_container.item, p_qa_control.item)
		end

	set_content_extent (psizel: TAG_SIZEL_RECORD)
			-- No description available.
			-- `psizel' [in].  
		do
			ccom_set_content_extent (initializer, psizel.item)
		end

	get_content_extent (psizel: TAG_SIZEL_RECORD)
			-- No description available.
			-- `psizel' [out].  
		do
			ccom_get_content_extent (initializer, psizel.item)
		end

feature {NONE}  -- Implementation

	delete_wrapper
			-- Delete wrapper
		do
			ccom_delete_iquick_activate_impl_proxy(initializer)
		end

feature {NONE}  -- Externals

	ccom_quick_activate (cpp_obj: POINTER; p_qa_container: POINTER; p_qa_control: POINTER)
			-- No description available.
		external
			"C++ [ecom_control_library::IQuickActivate_impl_proxy %"ecom_control_library_IQuickActivate_impl_proxy_s.h%"](ecom_control_library::tagQACONTAINER *,ecom_control_library::tagQACONTROL *)"
		end

	ccom_set_content_extent (cpp_obj: POINTER; psizel: POINTER)
			-- No description available.
		external
			"C++ [ecom_control_library::IQuickActivate_impl_proxy %"ecom_control_library_IQuickActivate_impl_proxy_s.h%"](ecom_control_library::tagSIZEL *)"
		end

	ccom_get_content_extent (cpp_obj: POINTER; psizel: POINTER)
			-- No description available.
		external
			"C++ [ecom_control_library::IQuickActivate_impl_proxy %"ecom_control_library_IQuickActivate_impl_proxy_s.h%"](ecom_control_library::tagSIZEL *)"
		end

	ccom_delete_iquick_activate_impl_proxy (a_pointer: POINTER)
			-- Release resource
		external
			"C++ [delete ecom_control_library::IQuickActivate_impl_proxy %"ecom_control_library_IQuickActivate_impl_proxy_s.h%"]()"
		end

	ccom_create_iquick_activate_impl_proxy_from_pointer (a_pointer: POINTER): POINTER
			-- Create from pointer
		external
			"C++ [new ecom_control_library::IQuickActivate_impl_proxy %"ecom_control_library_IQuickActivate_impl_proxy_s.h%"](IUnknown *)"
		end

	ccom_item (cpp_obj: POINTER): POINTER
			-- Item
		external
			"C++ [ecom_control_library::IQuickActivate_impl_proxy %"ecom_control_library_IQuickActivate_impl_proxy_s.h%"]():EIF_POINTER"
		end

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




end -- IQUICK_ACTIVATE_IMPL_PROXY

