note
	description: "Pixel buffer that replaces orignal image file.%
		%The orignal version of this class has been generated by Image Eiffel Code."
	legal: "See notice at end of class."
	status: "See notice at end of class."

class
	BUTTON_CLICKER_SMALL

inherit
	EV_PIXEL_BUFFER

create
	make

feature {NONE} -- Initialization

	make
			-- Initialization
		do
			make_with_size (16, 16)
			fill_memory
		end

feature {NONE} -- Image data

	c_colors_0 (a_ptr: POINTER; a_offset: INTEGER)
			-- Fill `a_ptr' with colors data from `a_offset'.
		external
			"C inline"
		alias
			"[
			{
				#define B(q) \
					#q
				#ifdef EIF_WINDOWS
				#define A(a,r,g,b) \
					B(\x##b\x##g\x##r\x##a)
				#else
				#define A(a,r,g,b) \
					B(\x##r\x##g\x##b\x##a)
				#endif
				char l_data[] = 
				A(00,39,79,BC)A(00,16,5E,AD)A(00,0D,5A,AC)A(00,18,5A,A1)A(00,1F,5D,A0)A(4D,2E,70,AF)A(99,3F,7F,C0)A(C6,46,7C,B5)A(C6,42,78,AE)A(A0,39,71,B2)A(55,29,50,85)A(06,2E,4F,7E)A(00,3A,5C,95)A(00,47,66,A6)A(00,50,6E,B7)A(00,4D,6A,B7)A(01,3B,7A,BC)A(00,1A,61,AE)A(00,0B,58,AB)A(39,1E,65,AE)A(C0,3D,78,B9)A(FF,67,A3,E0)A(FF,77,B1,EF)A(FF,70,B0,F5)A(FF,5B,A6,F6)A(FF,45,95,EC)A(FF,32,79,D5)A(D0,31,5D,A1)A(4A,42,5E,96)A(00,4F,6B,B0)A(00,50,6F,B9)A(00,4D,69,B7)A(01,5A,96,D4)A(00,3D,7C,C0)A(64,1D,63,AF)A(FA,6C,A2,DE)A(FF,A4,CC,F8)A(FF,B5,D7,FC)A(FF,B8,DB,FF)A(FF,AF,D8,FF)A(FF,96,C9,FF)A(FF,74,B5,FE)A(FF,4A,9C,F6)A(FF,2A,75,DF)A(FF,23,4B,B1)A(83,3F,58,98)A(00,50,69,B7)A(00,48,5C,B5)A(00,6E,A8,E4)A(47,53,90,D0)A(FF,63,9D,D9)A(FF,B3,D7,FB)A(FF,CF,E7,FF)A(FF,CD,DC,EB)A(FF,8D,98,A5)A(FF,51,5D,6A)A(FF,44,55,68)A(FF,59,7A,9F)A(FF,5E,9E,E6)A(FF,3C,91,F1)A(FF,1E,58,D2)A(FF,1A,33,9E)A(59,3F,51,9B)A(00,43,58,B7)A(0A,65,A1,DF)A(D8,5F,9A,D8)A(FF,A6,CE,F9)A(FF,DC,EF,FF)A(FF,C9,CF,D1)A(FF,61,5F,5E)A(FF,45,44,43)A(FF,02,01,00)A(FF,00,00,00)A(FF,00,00,00)A(FF,0D,12,19)A(FF,37,76,B9)A(FF,2F,7A,E9)A(FF,0F,2B,B7)A(E3,1A,2A,94)A(15,34,51,B1)
				A(59,5D,9F,E2)A(FF,6E,A7,E3)A(FF,B9,DA,FE)A(FF,D0,DA,E5)A(FF,5C,5B,5A)A(FF,D7,D7,D7)A(FF,F0,F1,F0)A(FF,5F,5F,5F)A(FF,00,00,00)A(FF,01,01,01)A(FF,00,00,00)A(FF,0A,12,1B)A(FF,2A,6A,C4)A(FF,16,3A,C0)A(FF,10,20,A1)A(75,33,59,A8)A(B0,55,98,DB)A(FF,7F,B5,EF)A(FF,C5,E4,FF)A(FF,5B,62,69)A(FF,2B,2A,29)A(FF,F5,F5,F5)A(FF,FF,FF,FF)A(FF,6D,6D,6D)A(FF,00,00,00)A(FF,00,01,00)A(FF,01,01,02)A(FF,00,00,00)A(FF,20,36,5A)A(FF,18,41,C4)A(FF,09,18,A9)A(C5,2A,58,AB)A(CE,50,93,DC)A(FF,7B,B5,F3)A(FF,AF,D4,FC)A(FF,2B,31,37)A(FF,03,03,02)A(FF,61,61,61)A(FF,6D,6D,6D)A(FF,18,18,18)A(FF,00,00,00)A(FF,01,01,01)A(FF,01,01,01)A(FF,01,00,00)A(FF,35,3F,52)A(FF,18,39,BC)A(FF,0A,1A,AC)A(D3,29,5C,B9)A(D0,49,90,DA)A(FF,6A,AB,F3)A(FF,94,C5,F8)A(FF,25,2A,32)A(FF,00,00,00)A(FF,00,00,00)A(FF,00,00,00)A(FF,00,00,00)A(FF,01,01,01)A(FF,01,01,01)A(FF,00,00,00)A(FF,0E,0C,0A)A(FF,60,66,77)A(FF,15,29,B1)A(FF,0C,24,B0)A(D6,2C,6B,C3)A(A6,3B,80,CC)A(FF,50,9B,EE)A(FF,7E,BC,FE)A(FF,2F,41,55)A(FF,00,00,00)A(FF,01,01,01)A(FF,01,01,01)A(FF,01,01,01)A(FF,01,01,01)A(FF,00,00,00)A(FF,00,00,00)A(FF,43,42,3A)A(FF,83,8A,AA)A(FF,07,10,A5)A(FF,17,3E,C0)A(CC,2D,73,C4)
				A(52,30,70,B6)A(FF,35,84,DE)A(FF,53,A7,FA)A(FF,57,8A,BF)A(FF,06,04,05)A(FF,00,00,00)A(FF,01,01,01)A(FF,01,00,00)A(FF,00,00,00)A(FF,00,00,00)A(FF,24,23,22)A(FF,A7,A4,9D)A(FF,4B,59,BA)A(FF,01,0D,A3)A(FF,28,69,D9)A(98,1C,62,A8)A(0A,26,62,B2)A(C9,28,66,C6)A(FF,32,81,E7)A(FF,4B,A0,FC)A(FF,30,5D,91)A(FF,04,05,04)A(FF,00,00,00)A(FF,01,00,00)A(FF,0C,0C,0A)A(FF,3F,3D,37)A(FF,9B,9C,93)A(FF,70,78,BC)A(FF,01,0B,A2)A(FF,1A,47,C5)A(F6,29,76,CE)A(31,0F,52,97)A(00,1C,52,BB)A(44,1B,4B,B5)A(FF,1E,4C,C0)A(FF,27,68,D8)A(FF,31,81,E9)A(FF,2A,65,B3)A(FF,31,43,5D)A(FF,4F,55,5B)A(FF,7C,80,86)A(FF,92,97,B5)A(FF,49,57,BA)A(FF,00,04,9C)A(FF,14,36,B9)A(FF,31,80,E4)A(88,19,65,B9)A(00,0B,54,A3)A(00,17,4A,B8)A(00,12,3E,B0)A(68,11,2F,A2)A(F8,14,31,B1)A(FF,19,3B,BD)A(FF,1C,4B,CD)A(FF,1F,4D,CC)A(FF,24,47,BF)A(FF,1F,38,B7)A(FF,07,18,AC)A(FF,00,0B,A2)A(FF,1A,43,C2)A(FF,2C,78,DE)A(BB,1E,70,C6)A(15,0F,58,AC)A(00,0B,58,AB)A(00,17,4A,B8)A(00,0A,28,A2)A(00,02,16,95)A(47,04,0F,8D)A(D5,07,11,95)A(FF,08,0F,A0)A(FF,06,0D,A4)A(FF,05,0E,A4)A(FF,06,16,A8)A(FF,13,34,B8)A(FF,26,65,D4)A(FF,2B,80,DC)A(9E,1E,71,C7)A(02,11,66,C4)A(00,0E,63,C0)A(00,0D,5D,B4)
				A(00,06,1A,96)A(00,00,0D,8C)A(00,00,0B,8B)A(00,01,09,89)A(12,0A,1F,8F)A(77,19,37,9F)A(AF,1C,41,AE)A(BD,1E,4C,BB)A(C0,27,62,C6)A(BB,2D,75,CE)A(9C,27,76,C9)A(3F,1C,6C,C0)A(00,16,6A,C3)A(00,16,6A,C8)A(00,10,66,C6)A(00,0F,63,C2);
				memcpy ((EIF_NATURAL_32 *)$a_ptr + $a_offset, &l_data, sizeof l_data - 1);
			}
			]"
		end

	build_colors (a_ptr: POINTER)
			-- Build `colors'.
		do
			c_colors_0 (a_ptr, 0)
		end

feature {NONE} -- Image data filling.

	fill_memory
			-- Fill image data into memory.
		local
			l_imp: EV_PIXEL_BUFFER_IMP
			l_pointer: POINTER
		do
			l_imp ?= implementation
			check not_void: l_imp /= Void end

			l_pointer := l_imp.data_ptr
			if l_pointer /= default_pointer then
				build_colors (l_pointer)
				l_imp.unlock
			end
		end
		
note
	copyright:	"Copyright (c) 1984-2008, Eiffel Software"
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
			distributed in the hope that it will be useful,	but
			WITHOUT ANY WARRANTY; without even the implied warranty
			of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
			See the	GNU General Public License for more details.
			
			You should have received a copy of the GNU General Public
			License along with Eiffel Software's Eiffel Development
			Environment; if not, write to the Free Software Foundation,
			Inc., 51 Franklin St, Fifth Floor, Boston, MA 02110-1301  USA
		]"
	source: "[
			 Eiffel Software
			 356 Storke Road, Goleta, CA 93117 USA
			 Telephone 805-685-1006, Fax 805-685-6869
			 Website http://www.eiffel.com
			 Customer support http://support.eiffel.com
		]"

end -- BUTTON_CLICKER_SMALL
