indexing
	description: "Text applicable to a PNG image."
	author: "pascalf"
	date: "$Date$"
	revision: "$Revision$"

class
	GD_TEXT

inherit
	GD_FIGURE
		rename
			draw_border as draw_text
		end

	GD_FONTS

	GD_COLORABLE

Creation
	make

feature -- Initialization

	make(im: GD_IMAGE;new_x,new_y,a_font:INTEGER;txt:STRING) is
		-- Create text
		require
			coordinates_within_the_image:im.coordinates_within_the_image(new_x,new_y)
			string_exists: txt /= Void
			gif_font_possible: font_possible ( a_font )
		do
			initialize_figure(im)
			set_x_y(new_x,new_y)
			text := txt
			gd_font := a_font
		ensure
			set: text = txt and gd_font=a_font and new_x = x and new_y = y and image = im
		end
		
feature -- Drawing

	draw_text is
			-- Draw text.
		local
			a: any
			p: POINTER
		do
			a := text.to_c
			p := font(gd_font)
			c_image_string(image.image, p,x,y, $a , color_index)	
		end

feature -- Implementation

	text: STRING
		-- text which is going to be displayed.
		
	gd_font: INTEGER
		-- Indice which corresponds to the selected font.
		-- Please refer to class "GD_FONTS".

feature {NONE} -- Externals

	c_image_string (p,f: POINTER; i1,i2: INTEGER; s: POINTER; a_color_index: INTEGER) is
		external
			"c"
		alias
			"gdImageString"
		end

end -- class GD_TEXT
