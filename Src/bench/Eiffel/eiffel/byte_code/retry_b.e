-- Byte code for retry instruction

class RETRY_B

inherit

	INSTR_B
		rename
			set_line_number as make
		redefine
			generate
		end

create
	make

feature -- Visitor

	process (v: BYTE_NODE_VISITOR) is
			-- Process current element.
		do
			v.process_retry_b (Current)
		end

feature -- C code generation

	generate is
			-- Generate the retry instruction
		local
			class_c: CLASS_C
			workbench_mode: BOOLEAN
			buf: GENERATION_BUFFER
		do
			buf := buffer
			generate_line_info
			generate_frozen_debugger_hook

				-- Clean up the trace and profiling stacks
			workbench_mode := Context.workbench_mode
			class_c := Context.associated_class
			if workbench_mode or else class_c.trace_level.is_yes then
					-- Trace clean-up
				buf.put_string ("RTTS;")
				buf.put_new_line
			end
			if workbench_mode or else class_c.profile_level.is_yes then
					-- Profiling clean-up
				buf.put_string ("RTPS;")
				buf.put_new_line
			end

			buf.put_string ("RTER;")
			buf.put_new_line
		end

end
