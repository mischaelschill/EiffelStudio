indexing
	description: "Objects that handle clipboard manipulation in EiffelBuild"
	date: "$Date$"
	revision: "$Revision$"

class
	GB_CLIPBOARD
	
inherit
	GB_SHARED_PIXMAPS
		export
			{NONE} all
		end
		
	GB_COMMAND_ADD_OBJECT
		export
			{NONE} all
		end
		
	GB_SHARED_TOOLS
		export
			{NONE} all
		end
		
	GB_XML_OBJECT_BUILDER
		export
			{NONE} all
		end
		
	GB_SHARED_ID
		export
			{NONE} all
		end

feature -- Access
		
	object: GB_OBJECT is
			-- `Result' is a new object representing clipboard contents.
		local
			a_list: ARRAYED_LIST [GB_OBJECT]
		do
			if contents_cell.item /= Void then
				Result := new_object (contents_cell.item, True)
					-- Modify id of `Result' so that it is not the same as that of `Current'.
				create a_list.make (20)
				Result.all_children_recursive (a_list)
				a_list.extend (Result)
				from
					a_list.start
				until
					a_list.off
				loop
					a_list.item.set_id (new_id)
					object_handler.add_object_to_objects (a_list.item)
					if a_list.item.associated_top_level_object_on_loading > 0 then
						a_list.item.update_object_as_instance_representation
					end
					a_list.forth
				end
			end
		end
		
	object_type: STRING
			-- Type of `object' or Void if `is_empty'.
		
	is_empty: BOOLEAN is
			-- Is clipboard empty?
		do
			Result := contents_cell.item = Void
		end

feature {GB_CUT_OBJECT_COMMAND, GB_COPY_OBJECT_COMMAND, GB_CLIPBOARD_COMMAND} -- Implementation

	set_object (an_object: GB_OBJECT) is
			-- Assign a copy of `an_object' to `Current'.
		require
			an_object_not_void: an_object /= Void
		local
			xml_store: GB_XML_STORE
		do
			object_type := an_object.type
			create xml_store
			xml_store.store_individual_object (an_object)
			contents_cell.put (xml_store.last_stored_individual_object)
		ensure
			contents_cell_not_empty: contents_cell.item /= Void
		end

	contents_cell: CELL [XM_ELEMENT] is
			-- A cell to hold the contents of `Current'.
			-- Whenver the contents are requested, this must be copied.
		once
			create Result	
		end

end -- class GB_CLIPBOARD
