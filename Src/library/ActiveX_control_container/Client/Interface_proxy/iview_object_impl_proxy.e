indexing
	description: "Implemented `IViewObject' Interface."
	Note: "Automatically generated by the EiffelCOM Wizard."

class
	IVIEW_OBJECT_IMPL_PROXY

inherit
	IVIEW_OBJECT_INTERFACE

	ECOM_QUERIABLE

creation
	make_from_other,
	make_from_pointer

feature {NONE}  -- Initialization

	make_from_pointer (cpp_obj: POINTER) is
			-- Make from pointer
		do
			initializer := ccom_create_iview_object_impl_proxy_from_pointer(cpp_obj)
			item := ccom_item (initializer)
		end

feature -- Basic Operations

	draw (dw_draw_aspect: INTEGER; lindex: INTEGER; pv_aspect: INTEGER; ptd: TAG_DVTARGETDEVICE_RECORD; hdc_target_dev: INTEGER; hdc_draw: INTEGER; lprc_bounds: X_RECTL_RECORD; lprc_wbounds: X_RECTL_RECORD; p_continue: ICONTINUE_INTERFACE) is
			-- No description available.
			-- `dw_draw_aspect' [in].  
			-- `lindex' [in].  
			-- `pv_aspect' [in].  
			-- `ptd' [in].  
			-- `hdc_target_dev' [in].  
			-- `hdc_draw' [in].  
			-- `lprc_bounds' [in].  
			-- `lprc_wbounds' [in].  
			-- `p_continue' [in].  
		local
			p_continue_item: POINTER
			a_stub: ECOM_STUB
		do
			if p_continue /= Void then
				if (p_continue.item = default_pointer) then
					a_stub ?= p_continue
					if a_stub /= Void then
						a_stub.create_item
					end
				end
				p_continue_item := p_continue.item
			end
			ccom_draw (initializer, dw_draw_aspect, lindex, pv_aspect, ptd.item, hdc_target_dev, hdc_draw, lprc_bounds.item, lprc_wbounds.item, p_continue_item)
		end

	get_color_set (dw_draw_aspect: INTEGER; lindex: INTEGER; pv_aspect: INTEGER; ptd: TAG_DVTARGETDEVICE_RECORD; hic_target_dev: INTEGER; pp_color_set: CELL [TAG_LOGPALETTE_RECORD]) is
			-- No description available.
			-- `dw_draw_aspect' [in].  
			-- `lindex' [in].  
			-- `pv_aspect' [in].  
			-- `ptd' [in].  
			-- `hic_target_dev' [in].  
			-- `pp_color_set' [out].  
		do
			ccom_get_color_set (initializer, dw_draw_aspect, lindex, pv_aspect, ptd.item, hic_target_dev, pp_color_set)
		end

	freeze (dw_draw_aspect: INTEGER; lindex: INTEGER; pv_aspect: INTEGER; pdw_freeze: INTEGER_REF) is
			-- No description available.
			-- `dw_draw_aspect' [in].  
			-- `lindex' [in].  
			-- `pv_aspect' [in].  
			-- `pdw_freeze' [out].  
		do
			ccom_freeze (initializer, dw_draw_aspect, lindex, pv_aspect, pdw_freeze)
		end

	unfreeze (dw_freeze: INTEGER) is
			-- No description available.
			-- `dw_freeze' [in].  
		do
			ccom_unfreeze (initializer, dw_freeze)
		end

	set_advise (aspects: INTEGER; advf: INTEGER; p_adv_sink: IADVISE_SINK_INTERFACE) is
			-- No description available.
			-- `aspects' [in].  
			-- `advf' [in].  
			-- `p_adv_sink' [in].  
		local
			p_adv_sink_item: POINTER
			a_stub: ECOM_STUB
		do
			if p_adv_sink /= Void then
				if (p_adv_sink.item = default_pointer) then
					a_stub ?= p_adv_sink
					if a_stub /= Void then
						a_stub.create_item
					end
				end
				p_adv_sink_item := p_adv_sink.item
			end
			ccom_set_advise (initializer, aspects, advf, p_adv_sink_item)
		end

	get_advise (p_aspects: INTEGER_REF; p_advf: INTEGER_REF; pp_adv_sink: CELL [IADVISE_SINK_INTERFACE]) is
			-- No description available.
			-- `p_aspects' [out].  
			-- `p_advf' [out].  
			-- `pp_adv_sink' [out].  
		do
			ccom_get_advise (initializer, p_aspects, p_advf, pp_adv_sink)
		end

feature {NONE}  -- Implementation

	delete_wrapper is
			-- Delete wrapper
		do
			ccom_delete_iview_object_impl_proxy(initializer)
		end

feature {NONE}  -- Externals

	ccom_draw (cpp_obj: POINTER; dw_draw_aspect: INTEGER; lindex: INTEGER; pv_aspect: INTEGER; ptd: POINTER; hdc_target_dev: INTEGER; hdc_draw: INTEGER; lprc_bounds: POINTER; lprc_wbounds: POINTER; p_continue: POINTER) is
			-- No description available.
		external
			"C++ [ecom_control_library::IViewObject_impl_proxy %"ecom_control_library_IViewObject_impl_proxy_s.h%"](EIF_INTEGER,EIF_INTEGER,EIF_INTEGER,ecom_control_library::tagDVTARGETDEVICE *,EIF_INTEGER,EIF_INTEGER,ecom_control_library::_RECTL *,ecom_control_library::_RECTL *,ecom_control_library::IContinue *)"
		end

	ccom_get_color_set (cpp_obj: POINTER; dw_draw_aspect: INTEGER; lindex: INTEGER; pv_aspect: INTEGER; ptd: POINTER; hic_target_dev: INTEGER; pp_color_set: CELL [TAG_LOGPALETTE_RECORD]) is
			-- No description available.
		external
			"C++ [ecom_control_library::IViewObject_impl_proxy %"ecom_control_library_IViewObject_impl_proxy_s.h%"](EIF_INTEGER,EIF_INTEGER,EIF_INTEGER,ecom_control_library::tagDVTARGETDEVICE *,EIF_INTEGER,EIF_OBJECT)"
		end

	ccom_freeze (cpp_obj: POINTER; dw_draw_aspect: INTEGER; lindex: INTEGER; pv_aspect: INTEGER; pdw_freeze: INTEGER_REF) is
			-- No description available.
		external
			"C++ [ecom_control_library::IViewObject_impl_proxy %"ecom_control_library_IViewObject_impl_proxy_s.h%"](EIF_INTEGER,EIF_INTEGER,EIF_INTEGER,EIF_OBJECT)"
		end

	ccom_unfreeze (cpp_obj: POINTER; dw_freeze: INTEGER) is
			-- No description available.
		external
			"C++ [ecom_control_library::IViewObject_impl_proxy %"ecom_control_library_IViewObject_impl_proxy_s.h%"](EIF_INTEGER)"
		end

	ccom_set_advise (cpp_obj: POINTER; aspects: INTEGER; advf: INTEGER; p_adv_sink: POINTER) is
			-- No description available.
		external
			"C++ [ecom_control_library::IViewObject_impl_proxy %"ecom_control_library_IViewObject_impl_proxy_s.h%"](EIF_INTEGER,EIF_INTEGER,ecom_control_library::IAdviseSink *)"
		end

	ccom_get_advise (cpp_obj: POINTER; p_aspects: INTEGER_REF; p_advf: INTEGER_REF; pp_adv_sink: CELL [IADVISE_SINK_INTERFACE]) is
			-- No description available.
		external
			"C++ [ecom_control_library::IViewObject_impl_proxy %"ecom_control_library_IViewObject_impl_proxy_s.h%"](EIF_OBJECT,EIF_OBJECT,EIF_OBJECT)"
		end

	ccom_delete_iview_object_impl_proxy (a_pointer: POINTER) is
			-- Release resource
		external
			"C++ [delete ecom_control_library::IViewObject_impl_proxy %"ecom_control_library_IViewObject_impl_proxy_s.h%"]()"
		end

	ccom_create_iview_object_impl_proxy_from_pointer (a_pointer: POINTER): POINTER is
			-- Create from pointer
		external
			"C++ [new ecom_control_library::IViewObject_impl_proxy %"ecom_control_library_IViewObject_impl_proxy_s.h%"](IUnknown *)"
		end

	ccom_item (cpp_obj: POINTER): POINTER is
			-- Item
		external
			"C++ [ecom_control_library::IViewObject_impl_proxy %"ecom_control_library_IViewObject_impl_proxy_s.h%"]():EIF_POINTER"
		end

end -- IVIEW_OBJECT_IMPL_PROXY

