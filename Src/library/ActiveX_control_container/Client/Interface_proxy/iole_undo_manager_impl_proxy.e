note
	description: "Implemented `IOleUndoManager' Interface."
	legal: "See notice at end of class."
	status: "See notice at end of class."
	generator: "Automatically generated by the EiffelCOM Wizard."

class
	IOLE_UNDO_MANAGER_IMPL_PROXY

inherit
	IOLE_UNDO_MANAGER_INTERFACE

	ECOM_QUERIABLE

create
	make_from_other,
	make_from_pointer

feature {NONE}  -- Initialization

	make_from_pointer (cpp_obj: POINTER)
			-- Make from pointer
		do
			initializer := ccom_create_iole_undo_manager_impl_proxy_from_pointer(cpp_obj)
			item := ccom_item (initializer)
		end

feature -- Basic Operations

	open (p_puu: IOLE_PARENT_UNDO_UNIT_INTERFACE)
			-- No description available.
			-- `p_puu' [in].  
		local
			p_puu_item: POINTER
			a_stub: ECOM_STUB
		do
			if p_puu /= Void then
				if (p_puu.item = default_pointer) then
					a_stub ?= p_puu
					if a_stub /= Void then
						a_stub.create_item
					end
				end
				p_puu_item := p_puu.item
			end
			ccom_open (initializer, p_puu_item)
		end

	close (p_puu: IOLE_PARENT_UNDO_UNIT_INTERFACE; f_commit: INTEGER)
			-- No description available.
			-- `p_puu' [in].  
			-- `f_commit' [in].  
		local
			p_puu_item: POINTER
			a_stub: ECOM_STUB
		do
			if p_puu /= Void then
				if (p_puu.item = default_pointer) then
					a_stub ?= p_puu
					if a_stub /= Void then
						a_stub.create_item
					end
				end
				p_puu_item := p_puu.item
			end
			ccom_close (initializer, p_puu_item, f_commit)
		end

	add (p_uu: IOLE_UNDO_UNIT_INTERFACE)
			-- No description available.
			-- `p_uu' [in].  
		local
			p_uu_item: POINTER
			a_stub: ECOM_STUB
		do
			if p_uu /= Void then
				if (p_uu.item = default_pointer) then
					a_stub ?= p_uu
					if a_stub /= Void then
						a_stub.create_item
					end
				end
				p_uu_item := p_uu.item
			end
			ccom_add (initializer, p_uu_item)
		end

	get_open_parent_state (pdw_state: INTEGER_REF)
			-- No description available.
			-- `pdw_state' [out].  
		do
			ccom_get_open_parent_state (initializer, pdw_state)
		end

	discard_from (p_uu: IOLE_UNDO_UNIT_INTERFACE)
			-- No description available.
			-- `p_uu' [in].  
		local
			p_uu_item: POINTER
			a_stub: ECOM_STUB
		do
			if p_uu /= Void then
				if (p_uu.item = default_pointer) then
					a_stub ?= p_uu
					if a_stub /= Void then
						a_stub.create_item
					end
				end
				p_uu_item := p_uu.item
			end
			ccom_discard_from (initializer, p_uu_item)
		end

	undo_to (p_uu: IOLE_UNDO_UNIT_INTERFACE)
			-- No description available.
			-- `p_uu' [in].  
		local
			p_uu_item: POINTER
			a_stub: ECOM_STUB
		do
			if p_uu /= Void then
				if (p_uu.item = default_pointer) then
					a_stub ?= p_uu
					if a_stub /= Void then
						a_stub.create_item
					end
				end
				p_uu_item := p_uu.item
			end
			ccom_undo_to (initializer, p_uu_item)
		end

	redo_to (p_uu: IOLE_UNDO_UNIT_INTERFACE)
			-- No description available.
			-- `p_uu' [in].  
		local
			p_uu_item: POINTER
			a_stub: ECOM_STUB
		do
			if p_uu /= Void then
				if (p_uu.item = default_pointer) then
					a_stub ?= p_uu
					if a_stub /= Void then
						a_stub.create_item
					end
				end
				p_uu_item := p_uu.item
			end
			ccom_redo_to (initializer, p_uu_item)
		end

	enum_undoable (ppenum: CELL [IENUM_OLE_UNDO_UNITS_INTERFACE])
			-- No description available.
			-- `ppenum' [out].  
		do
			ccom_enum_undoable (initializer, ppenum)
		end

	enum_redoable (ppenum: CELL [IENUM_OLE_UNDO_UNITS_INTERFACE])
			-- No description available.
			-- `ppenum' [out].  
		do
			ccom_enum_redoable (initializer, ppenum)
		end

	get_last_undo_description (p_bstr: CELL [STRING])
			-- No description available.
			-- `p_bstr' [out].  
		do
			ccom_get_last_undo_description (initializer, p_bstr)
		end

	get_last_redo_description (p_bstr: CELL [STRING])
			-- No description available.
			-- `p_bstr' [out].  
		do
			ccom_get_last_redo_description (initializer, p_bstr)
		end

	enable (f_enable: INTEGER)
			-- No description available.
			-- `f_enable' [in].  
		do
			ccom_enable (initializer, f_enable)
		end

feature {NONE}  -- Implementation

	delete_wrapper
			-- Delete wrapper
		do
			ccom_delete_iole_undo_manager_impl_proxy(initializer)
		end

feature {NONE}  -- Externals

	ccom_open (cpp_obj: POINTER; p_puu: POINTER)
			-- No description available.
		external
			"C++ [ecom_control_library::IOleUndoManager_impl_proxy %"ecom_control_library_IOleUndoManager_impl_proxy_s.h%"](::IOleParentUndoUnit *)"
		end

	ccom_close (cpp_obj: POINTER; p_puu: POINTER; f_commit: INTEGER)
			-- No description available.
		external
			"C++ [ecom_control_library::IOleUndoManager_impl_proxy %"ecom_control_library_IOleUndoManager_impl_proxy_s.h%"](::IOleParentUndoUnit *,EIF_INTEGER)"
		end

	ccom_add (cpp_obj: POINTER; p_uu: POINTER)
			-- No description available.
		external
			"C++ [ecom_control_library::IOleUndoManager_impl_proxy %"ecom_control_library_IOleUndoManager_impl_proxy_s.h%"](::IOleUndoUnit *)"
		end

	ccom_get_open_parent_state (cpp_obj: POINTER; pdw_state: INTEGER_REF)
			-- No description available.
		external
			"C++ [ecom_control_library::IOleUndoManager_impl_proxy %"ecom_control_library_IOleUndoManager_impl_proxy_s.h%"](EIF_OBJECT)"
		end

	ccom_discard_from (cpp_obj: POINTER; p_uu: POINTER)
			-- No description available.
		external
			"C++ [ecom_control_library::IOleUndoManager_impl_proxy %"ecom_control_library_IOleUndoManager_impl_proxy_s.h%"](::IOleUndoUnit *)"
		end

	ccom_undo_to (cpp_obj: POINTER; p_uu: POINTER)
			-- No description available.
		external
			"C++ [ecom_control_library::IOleUndoManager_impl_proxy %"ecom_control_library_IOleUndoManager_impl_proxy_s.h%"](::IOleUndoUnit *)"
		end

	ccom_redo_to (cpp_obj: POINTER; p_uu: POINTER)
			-- No description available.
		external
			"C++ [ecom_control_library::IOleUndoManager_impl_proxy %"ecom_control_library_IOleUndoManager_impl_proxy_s.h%"](::IOleUndoUnit *)"
		end

	ccom_enum_undoable (cpp_obj: POINTER; ppenum: CELL [IENUM_OLE_UNDO_UNITS_INTERFACE])
			-- No description available.
		external
			"C++ [ecom_control_library::IOleUndoManager_impl_proxy %"ecom_control_library_IOleUndoManager_impl_proxy_s.h%"](EIF_OBJECT)"
		end

	ccom_enum_redoable (cpp_obj: POINTER; ppenum: CELL [IENUM_OLE_UNDO_UNITS_INTERFACE])
			-- No description available.
		external
			"C++ [ecom_control_library::IOleUndoManager_impl_proxy %"ecom_control_library_IOleUndoManager_impl_proxy_s.h%"](EIF_OBJECT)"
		end

	ccom_get_last_undo_description (cpp_obj: POINTER; p_bstr: CELL [STRING])
			-- No description available.
		external
			"C++ [ecom_control_library::IOleUndoManager_impl_proxy %"ecom_control_library_IOleUndoManager_impl_proxy_s.h%"](EIF_OBJECT)"
		end

	ccom_get_last_redo_description (cpp_obj: POINTER; p_bstr: CELL [STRING])
			-- No description available.
		external
			"C++ [ecom_control_library::IOleUndoManager_impl_proxy %"ecom_control_library_IOleUndoManager_impl_proxy_s.h%"](EIF_OBJECT)"
		end

	ccom_enable (cpp_obj: POINTER; f_enable: INTEGER)
			-- No description available.
		external
			"C++ [ecom_control_library::IOleUndoManager_impl_proxy %"ecom_control_library_IOleUndoManager_impl_proxy_s.h%"](EIF_INTEGER)"
		end

	ccom_delete_iole_undo_manager_impl_proxy (a_pointer: POINTER)
			-- Release resource
		external
			"C++ [delete ecom_control_library::IOleUndoManager_impl_proxy %"ecom_control_library_IOleUndoManager_impl_proxy_s.h%"]()"
		end

	ccom_create_iole_undo_manager_impl_proxy_from_pointer (a_pointer: POINTER): POINTER
			-- Create from pointer
		external
			"C++ [new ecom_control_library::IOleUndoManager_impl_proxy %"ecom_control_library_IOleUndoManager_impl_proxy_s.h%"](IUnknown *)"
		end

	ccom_item (cpp_obj: POINTER): POINTER
			-- Item
		external
			"C++ [ecom_control_library::IOleUndoManager_impl_proxy %"ecom_control_library_IOleUndoManager_impl_proxy_s.h%"]():EIF_POINTER"
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




end -- IOLE_UNDO_MANAGER_IMPL_PROXY

