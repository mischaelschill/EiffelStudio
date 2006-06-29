indexing
	description: "An Eiffel pixmap matrix accessor, generated by Eiffel Matrix Generator."
	legal      : "See notice at end of class."
	status     : "See notice at end of class."
	date       : "$Date$"
	revision   : "$Revision$"

class
	ES_PIXMAPS_12X12
	
create
	make

feature {NONE} -- Initialization

	make (a_name: STRING) is
			-- Initialize matrix
		require
			a_name_attached: a_name /= Void
			not_a_name_is_empty: not a_name.is_empty
		local
			l_file: FILE_NAME
			l_warn: EV_WARNING_DIALOG
			retried: BOOLEAN
		do
			if not retried then
				create l_file.make_from_string ((create {EIFFEL_ENV}).bitmaps_path)
				l_file.set_subdirectory ("png")
				l_file.set_file_name (a_name)
			end

			if not retried and then (create {RAW_FILE}.make (l_file)).exists then
				create raw_buffer
				raw_buffer.set_with_named_file (l_file)
			else
				create l_warn.make_with_text ("Cannot read pixmap file:%N" + l_file + ".%NPlease make sure the installation is not corrupted.")
				l_warn.show

					-- Fail safe, use blank pixmap
				create raw_buffer.make_with_size ((12 * 12) + 1,(1 * 12) + 1)
			end
		rescue
			retried := True
			retry
		end
		
feature -- Access

	pixel_width: INTEGER is 12
			-- Element width

	pixel_height: INTEGER is 12
			-- Element width

	width: INTEGER is 12
			-- Matrix width

	height: INTEGER is 1
			-- Matrix height

	frozen bp_current_line_icon: EV_PIXMAP is
			-- Access to 'current line' pixmap.
		once
			Result := raw_buffer.sub_pixmap (pixel_rectangle (1, 1))
		end

	frozen bp_current_line_icon_buffer: EV_PIXEL_BUFFER is
			-- Access to 'current line' pixmap pixel buffer.
		once
			Result := raw_buffer.sub_pixel_buffer (pixel_rectangle (1, 1))
		end

	frozen bp_slot_icon: EV_PIXMAP is
			-- Access to 'slot' pixmap.
		once
			Result := raw_buffer.sub_pixmap (pixel_rectangle (2, 1))
		end

	frozen bp_slot_icon_buffer: EV_PIXEL_BUFFER is
			-- Access to 'slot' pixmap pixel buffer.
		once
			Result := raw_buffer.sub_pixel_buffer (pixel_rectangle (2, 1))
		end

	frozen bp_enabled_icon: EV_PIXMAP is
			-- Access to 'enabled' pixmap.
		once
			Result := raw_buffer.sub_pixmap (pixel_rectangle (3, 1))
		end

	frozen bp_enabled_icon_buffer: EV_PIXEL_BUFFER is
			-- Access to 'enabled' pixmap pixel buffer.
		once
			Result := raw_buffer.sub_pixel_buffer (pixel_rectangle (3, 1))
		end

	frozen bp_disabled_icon: EV_PIXMAP is
			-- Access to 'disabled' pixmap.
		once
			Result := raw_buffer.sub_pixmap (pixel_rectangle (4, 1))
		end

	frozen bp_disabled_icon_buffer: EV_PIXEL_BUFFER is
			-- Access to 'disabled' pixmap pixel buffer.
		once
			Result := raw_buffer.sub_pixel_buffer (pixel_rectangle (4, 1))
		end

	frozen bp_slot_current_line_icon: EV_PIXMAP is
			-- Access to 'slot current line' pixmap.
		once
			Result := raw_buffer.sub_pixmap (pixel_rectangle (5, 1))
		end

	frozen bp_slot_current_line_icon_buffer: EV_PIXEL_BUFFER is
			-- Access to 'slot current line' pixmap pixel buffer.
		once
			Result := raw_buffer.sub_pixel_buffer (pixel_rectangle (5, 1))
		end

	frozen bp_enabled_current_line_icon: EV_PIXMAP is
			-- Access to 'enabled current line' pixmap.
		once
			Result := raw_buffer.sub_pixmap (pixel_rectangle (6, 1))
		end

	frozen bp_enabled_current_line_icon_buffer: EV_PIXEL_BUFFER is
			-- Access to 'enabled current line' pixmap pixel buffer.
		once
			Result := raw_buffer.sub_pixel_buffer (pixel_rectangle (6, 1))
		end

	frozen bp_disabled_current_line_icon: EV_PIXMAP is
			-- Access to 'disabled current line' pixmap.
		once
			Result := raw_buffer.sub_pixmap (pixel_rectangle (7, 1))
		end

	frozen bp_disabled_current_line_icon_buffer: EV_PIXEL_BUFFER is
			-- Access to 'disabled current line' pixmap pixel buffer.
		once
			Result := raw_buffer.sub_pixel_buffer (pixel_rectangle (7, 1))
		end

	frozen bp_slot_other_frame_icon: EV_PIXMAP is
			-- Access to 'slot other frame' pixmap.
		once
			Result := raw_buffer.sub_pixmap (pixel_rectangle (8, 1))
		end

	frozen bp_slot_other_frame_icon_buffer: EV_PIXEL_BUFFER is
			-- Access to 'slot other frame' pixmap pixel buffer.
		once
			Result := raw_buffer.sub_pixel_buffer (pixel_rectangle (8, 1))
		end

	frozen bp_enabled_other_frame_icon: EV_PIXMAP is
			-- Access to 'enabled other frame' pixmap.
		once
			Result := raw_buffer.sub_pixmap (pixel_rectangle (9, 1))
		end

	frozen bp_enabled_other_frame_icon_buffer: EV_PIXEL_BUFFER is
			-- Access to 'enabled other frame' pixmap pixel buffer.
		once
			Result := raw_buffer.sub_pixel_buffer (pixel_rectangle (9, 1))
		end

	frozen bp_disabled_other_frame_icon: EV_PIXMAP is
			-- Access to 'disabled other frame' pixmap.
		once
			Result := raw_buffer.sub_pixmap (pixel_rectangle (10, 1))
		end

	frozen bp_disabled_other_frame_icon_buffer: EV_PIXEL_BUFFER is
			-- Access to 'disabled other frame' pixmap pixel buffer.
		once
			Result := raw_buffer.sub_pixel_buffer (pixel_rectangle (10, 1))
		end

	frozen bp_enabled_conditional_icon: EV_PIXMAP is
			-- Access to 'enabled conditional' pixmap.
		once
			Result := raw_buffer.sub_pixmap (pixel_rectangle (11, 1))
		end

	frozen bp_enabled_conditional_icon_buffer: EV_PIXEL_BUFFER is
			-- Access to 'enabled conditional' pixmap pixel buffer.
		once
			Result := raw_buffer.sub_pixel_buffer (pixel_rectangle (11, 1))
		end

	frozen bp_disabled_conditional_icon: EV_PIXMAP is
			-- Access to 'disabled conditional' pixmap.
		once
			Result := raw_buffer.sub_pixmap (pixel_rectangle (12, 1))
		end

	frozen bp_disabled_conditional_icon_buffer: EV_PIXEL_BUFFER is
			-- Access to 'disabled conditional' pixmap pixel buffer.
		once
			Result := raw_buffer.sub_pixel_buffer (pixel_rectangle (12, 1))
		end
		
feature {NONE} -- Query

	frozen pixel_rectangle (a_x: INTEGER; a_y: INTEGER): EV_RECTANGLE is
			-- Retrieves a pixmap from matrix coordinates `a_x', `a_y'	
		require
			a_x_positive: a_x > 0
			a_x_small_enough: a_x <= 12
			a_y_positive: a_y > 0
			a_y_small_enough: a_y <= 1
		local
			l_x_offset: INTEGER
			l_y_offset: INTEGER
		do
			l_x_offset := ((a_x - 1) * (12 + 1)) + 1
			l_y_offset := ((a_y - 1) * (12 + 1)) + 1

			Result := rectangle
			Result.set_x (l_x_offset)
			Result.set_y (l_y_offset)
			Result.set_width (12)
			Result.set_height (12)
		ensure
			result_attached: Result /= Void
		end

feature {NONE} -- Implementation

	raw_buffer: EV_PIXEL_BUFFER
			-- raw matrix pixel buffer

	frozen rectangle: EV_RECTANGLE is
			-- Reusable rectangle for `pixmap_from_constant'.
		once
			create Result
		end

invariant
	raw_buffer_attached: raw_buffer /= Void

indexing
	copyright: "Copyright (c) 1984-2006, Eiffel Software and others"
	license: "Eiffel Forum License v2 (see http://www.eiffel.com/licensing/forum.txt)"
	source: "[
		Eiffel Software
		356 Storke Road, Goleta, CA 93117 USA
		Telephone 805-685-1006, Fax 805-685-6869
		Website http://www.eiffel.com
		Customer support http://support.eiffel.com
	]"

end -- class {ES_PIXMAPS_12X12}