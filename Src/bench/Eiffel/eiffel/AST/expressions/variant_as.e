indexing
	description	: "Description of variant loop. Version for Bench."
	date		: "$Date$"
	revision	: "$Revision$"

class VARIANT_AS

inherit
	TAGGED_AS
		redefine
			byte_node, type_check
		end

feature -- Type check and byte node

	type_check is
			-- Type check on the expression
		local
			current_context: TYPE_A
			vave: VAVE
		do
			expr.type_check
				-- Check if the type of the expression is boolean
			current_context := context.item
			if not current_context.is_integer then
				create vave
				context.init_error (vave)
				vave.set_type (current_context)
				Error_handler.insert_error (vave)
			end
   
				-- Update the type stack
			context.pop (1)
		end

	byte_node: VARIANT_B is
			-- Associated byte code
		do
			create Result
			Result.set_tag (tag)
			Result.set_expr (expr.byte_node)
				-- FIXME: Manu 01/21/2003: we remove 1 since `line_number' refers to the next
				-- construct coming after a VARIANT_AS, and most usually it is on the next line,
				-- but not always.
			Result.set_line_number (line_number - 1)
		end

end -- class VARIANT_AS
