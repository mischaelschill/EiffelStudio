﻿note
	description: "Enlarged byte code for Eiffel string (allocated each time)."
	legal: "See notice at end of class."
	status: "See notice at end of class."

class STRING_BL

inherit
	STRING_B
		redefine
			register, set_register,
			analyze, generate,
			propagate, print_register,
			unanalyze, has_side_effect
		end

create {INTERNAL_COMPILER_STRING_EXPORTER}
	make

feature -- Status report

	has_side_effect: BOOLEAN
			-- <Precursor>
		do
			Result := register = No_register
		end

feature

	register: REGISTRABLE
			-- Where string is kept to ensure it is GC safe

	set_register (r: REGISTRABLE)
			-- Set `register' to `r'
		do
			register := r
		end

	propagate (r: REGISTRABLE)
			-- Propagate `r'
		do
			if not context.propagated then
				if r = No_register or r.c_type.same_class_type (c_type) then
					register := r
					context.set_propagated
				end
			end
		end

	unanalyze
			-- Undo analysis work.
		do
			register := Void
		end

	analyze
			-- Analyze the string
		do
				-- We get a register to store the string because of the garbage
				-- collector: assume we write f("one", "two"), then the GC
				-- could be invoked while allocating "two" and move "one" right
				-- under the back of the C (without notifying it, how could I?).
			get_register
		end

	generate
			-- Generate the string
		local
			buf: GENERATION_BUFFER
		do
			if register /= No_register then
				buf := buffer
				buf.put_new_line
				register.print_register
				buf.put_string (" = ")
				generate_string
				buf.put_character (';')
			end
		end

	print_register
			-- Print the string (or the register in which it is held)
		do
			if register = No_register then
				generate_string
			else
				register.print_register
			end
		end

	generate_string
			-- Generate the string (created Eiffel object)
		local
			buf: GENERATION_BUFFER
			l_value: STRING_8
			l_value_32: STRING_32
		do
				-- RTMS_EX is the macro used to create Eiffel strings from C ones
				-- RTMS32_EX_H is the macro used to create STRING_32 from C ones
			buf := buffer
			if is_string_32 then
				buf.put_string ("RTMS32_EX_H(")
				l_value_32 := value_32

				buf.put_string_literal (encoding_converter.string_32_to_stream (l_value_32))
				buf.put_character(',')

				buf.put_integer(l_value_32.count)
				buf.put_character(',')
				buf.put_integer (l_value_32.hash_code)
				buf.put_character(')')
			else
				buf.put_string ("RTMS_EX_H(")
				l_value := value_8

				buf.put_string_literal (l_value)
				buf.put_character(',')

				buf.put_integer(l_value.count)
				buf.put_character(',')
				buf.put_integer (l_value.hash_code)
				buf.put_character(')')
			end
		end

note
	copyright:	"Copyright (c) 1984-2016, Eiffel Software"
	license:	"GPL version 2 (see http://www.eiffel.com/licensing/gpl.txt)"
	licensing_options:	"http://www.eiffel.com/licensing"
	copying: "[
			This file is part of Eiffel Software's Eiffel Development Environment.
			
			Eiffel Software's Eiffel Development Environment is free
			software; you can redistribute it and/or modify it under
			the terms of the GNU General Public License as published
			by the Free Software Foundation, version 2 of the License
			(available at the URL listed under "license" above).
			
			Eiffel Software's Eiffel Development Environment is
			distributed in the hope that it will be useful, but
			WITHOUT ANY WARRANTY; without even the implied warranty
			of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
			See the GNU General Public License for more details.
			
			You should have received a copy of the GNU General Public
			License along with Eiffel Software's Eiffel Development
			Environment; if not, write to the Free Software Foundation,
			Inc., 51 Franklin St, Fifth Floor, Boston, MA 02110-1301 USA
		]"
	source: "[
			Eiffel Software
			5949 Hollister Ave., Goleta, CA 93117 USA
			Telephone 805-685-1006, Fax 805-685-6869
			Website http://www.eiffel.com
			Customer support http://support.eiffel.com
		]"

end
