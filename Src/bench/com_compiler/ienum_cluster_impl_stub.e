indexing
	description: "Implemented `IEnumCluster' Interface."
	Note: "Automatically generated by the EiffelCOM Wizard."

class
	IENUM_CLUSTER_IMPL_STUB

inherit
	IENUM_CLUSTER_INTERFACE

	ECOM_STUB

feature -- Access

	count: INTEGER is
			-- Retrieve enumerator item count.
		do
			-- Put Implementation here.
		end

feature -- Basic Operations

	next (pp_ieiffel_cluster_descriptor: CELL [IEIFFEL_CLUSTER_DESCRIPTOR_INTERFACE]; pul_count: INTEGER_REF) is
			-- Go to next item in enumerator
			-- `pp_ieiffel_cluster_descriptor' [out].  
			-- `pul_count' [out].  
		do
			-- Put Implementation here.
		end

	skip (ul_count: INTEGER) is
			-- Skip `ulCount' items.
			-- `ul_count' [in].  
		do
			-- Put Implementation here.
		end

	reset is
			-- Reset enumerator.
		do
			-- Put Implementation here.
		end

	clone1 (pp_ienum_cluster: CELL [IENUM_CLUSTER_INTERFACE]) is
			-- Clone enumerator.
			-- `pp_ienum_cluster' [out].  
		do
			-- Put Implementation here.
		end

	ith_item (ul_index: INTEGER; pp_ieiffel_cluster_descriptor: CELL [IEIFFEL_CLUSTER_DESCRIPTOR_INTERFACE]) is
			-- Retrieve enumerators ith item at `ulIndex'.
			-- `ul_index' [in].  
			-- `pp_ieiffel_cluster_descriptor' [out].  
		do
			-- Put Implementation here.
		end

	create_item is
			-- Initialize `item'
		do
			item := ccom_create_item (Current)
		end

feature {NONE}  -- Externals

	ccom_create_item (eif_object: IENUM_CLUSTER_IMPL_STUB): POINTER is
			-- Initialize `item'
		external
			"C++ [new ecom_EiffelComCompiler::IEnumCluster_impl_stub %"ecom_EiffelComCompiler_IEnumCluster_impl_stub_s.h%"](EIF_OBJECT)"
		end

end -- IENUM_CLUSTER_IMPL_STUB

