indexing
	description:
		"Abstract class for drawing of figures."
	status: "See notice at end of class"
	keywords: "figure, primitives, drawing" 
	date: "$Date$"
	revision: "$Revision$"

deferred class
	EV_FIGURE_DRAWING_ROUTINES

inherit
	EV_FIGURE_MATH
		export
			{NONE} all
		end

feature -- Figure drawing

	draw_figure_arc (arc: EV_FIGURE_ARC) is
			-- Draw standard representation of `arc' to canvas.
		require
			arc_not_void: arc /= Void
		deferred
		end

	draw_figure_dot (dot: EV_FIGURE_DOT) is
			-- Draw standard representation of `dot' to canvas.
		require
			dot_not_void: dot /= Void
		deferred
		end

	draw_figure_ellipse (ellipse: EV_FIGURE_ELLIPSE) is
			-- Draw standard representation of `ellipse' to canvas.
		require
			ellipse_not_void: ellipse /= Void
		deferred
		end

	draw_figure_equilateral (eql: EV_FIGURE_EQUILATERAL) is
			-- Draw standard representation of `eql' to canvas.
		require
			eql_not_void: eql /= Void
		deferred
		end

	draw_figure_line (line: EV_FIGURE_LINE) is
			-- Draw a standard representation of `line' to the canvas.
		require
			line_not_void: line /= Void
		deferred
		end

	draw_figure_picture (picture: EV_FIGURE_PICTURE) is
			-- Draw standard representation of `picture' to canvas.
		require
			picture_not_void: picture /= Void
		deferred
		end

	draw_figure_pie_slice (slice: EV_FIGURE_PIE_SLICE) is
			-- Draw standard representation of `slice' to canvas.
		require
			slice_not_void: slice /= Void
		deferred
		end

	draw_figure_polygon (polygon: EV_FIGURE_POLYGON) is
			-- Draw standard representation of `polygon' to canvas.
		require
			polygon_not_void: polygon /= Void
		deferred
		end

	draw_figure_polyline (line: EV_FIGURE_POLYLINE) is
			-- Draw standard representation of `polyline' to canvas.
		require
			line_not_void: line /= Void
		deferred
		end

	draw_figure_rectangle (rectangle: EV_FIGURE_RECTANGLE) is
			-- Draw standard representation of `rectangle' to canvas.
		require
			rectangle_not_void: rectangle /= Void
		deferred
		end

	draw_figure_rounded_rectangle (f: EV_FIGURE_ROUNDED_RECTANGLE) is
			-- Draw standard representation of `f' to canvas.
		require
			f_not_void: f /= Void
		deferred
		end

	draw_figure_star (star: EV_FIGURE_STAR) is
			-- Draw standard representation of `star' to canvas.
		require
			star_not_void: star /= Void
		deferred
		end

	draw_figure_text (text_figure: EV_FIGURE_TEXT) is
			-- Draw standard representation of `text_figure' to canvas.
		require
			text_figure_not_void: text_figure /= Void
		deferred
		end

end -- class EV_FIGURE_DRAWING_ROUTINES

--|----------------------------------------------------------------
--| EiffelVision2: library of reusable components for ISE Eiffel.
--| Copyright (C) 1986-2001 Interactive Software Engineering Inc.
--| All rights reserved. Duplication and distribution prohibited.
--| May be used only with ISE Eiffel, under terms of user license. 
--| Contact ISE for any other use.
--|
--| Interactive Software Engineering Inc.
--| ISE Building
--| 360 Storke Road, Goleta, CA 93117 USA
--| Telephone 805-685-1006, Fax 805-685-6869
--| Electronic mail <info@eiffel.com>
--| Customer support: http://support.eiffel.com>
--| For latest info see award-winning pages: http://www.eiffel.com
--|----------------------------------------------------------------

