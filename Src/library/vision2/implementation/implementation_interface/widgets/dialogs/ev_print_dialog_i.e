--| FIXME Not for release
--| FIXME NOT_REVIEWED this file has not been reviewed
indexing 
	description: "EiffelVision print dialog, implementation interface."
	status: "See notice at end of class"
	date: "$Date$"
	revision: "$Revision$"

deferred class
	EV_PRINT_DIALOG_I

inherit
	EV_STANDARD_DIALOG_I

feature -- Access

	from_page: INTEGER is
			-- Value for the starting page edit control
		require
		deferred
		ensure
			positive_result: Result >= 0
		end

	to_page: INTEGER is
			-- Value for the ending page edit control
		require
		deferred
		ensure
			positive_result: Result >= 0
		end

	copies: INTEGER is
			-- Number of copies for the Copies edit control
		require
		deferred
		ensure
			positive_result: Result >= 0
		end

	maximum_range: INTEGER is
			-- Maximum value for the range of pages specified
			-- in the From and To page edit controls.
			-- 1 by default.
		require
		deferred
		ensure
			positive_result: Result >= 0
		end

feature -- Status report

	all_pages_selected: BOOLEAN is
			-- Is the "All pages" radio button selected?
		require
		deferred
		end

	page_numbers_selected: BOOLEAN is
			-- Is the "Page" radio button selected?
		require
		deferred
		end

	selection_selected: BOOLEAN is
			-- Is the "Selection" radio button selected?
		require
		deferred
		end

	print_to_file_checked: BOOLEAN is
			-- Is the "Print to file" check box checked?
		require
		deferred
		end

	collate_checked: BOOLEAN is
			-- Is the "Collate" check box checked?
		require
		deferred
		end

feature -- Status setting

	select_page_numbers is
			-- Select the "Page numbers" radio button.
			-- By default, the "All pages" button is selected.
		require
		deferred
		end

	select_selection is
			-- Select the "Selection" radio button.
			-- By default, the "All pages" button is selected.
		require
		deferred
		end

	check_print_to_file is
			-- Check the "Print to file" check box.
		require
		deferred
		ensure
			print_to_file_checked: print_to_file_checked
		end

	check_collate is
			-- Check the "Collate" check box.
		require
		deferred
		ensure
			collate_checked: collate_checked
		end

	disable_page_numbers is
			-- Disable the "Page numbers" radio button.
		require
		deferred
		end

	disable_selection is
			-- Disable the "Selection" radio button.
		require
		deferred
		end

	disable_print_to_file is
			-- Disable the "Print to file" check box.
		require
		deferred
		end

	hide_print_to_file is
			-- Hide the "Print to file" check box.
		require
		deferred
		end

feature -- Element change

	set_from_page (value: INTEGER) is
			-- Make `value' the new `from_page' number.
		require
			positive_value: value >= 0
		deferred
		ensure
			from_page_set: from_page = value
		end

	set_to_page (value: INTEGER) is
			-- Make `value' the new `to_page' number.
		require
			positive_value: value >= 0
		deferred
		ensure
			to_page_set: to_page = value
		end

	set_copies (value: INTEGER) is
			-- Make `value' the new `copies' number.
		require
			positive_value: value >= 0
		deferred
		ensure
			copies_set: copies = value
		end

	set_maximum_range (value: INTEGER) is
			-- Make `value' the new maximum_range.
		require
			positive_value: value >= 0
		deferred
		ensure
			maximum_range_set: maximum_range = value
		end

end -- class EV_PRINT_DIALOG_I

--!----------------------------------------------------------------
--! EiffelVision2: library of reusable components for ISE Eiffel.
--! Copyright (C) 1986-1999 Interactive Software Engineering Inc.
--! All rights reserved. Duplication and distribution prohibited.
--! May be used only with ISE Eiffel, under terms of user license. 
--! Contact ISE for any other use.
--!
--! Interactive Software Engineering Inc.
--! ISE Building, 2nd floor
--! 270 Storke Road, Goleta, CA 93117 USA
--! Telephone 805-685-1006, Fax 805-685-6869
--! Electronic mail <info@eiffel.com>
--! Customer support e-mail <support@eiffel.com>
--! For latest info see award-winning pages: http://www.eiffel.com
--!----------------------------------------------------------------

--|-----------------------------------------------------------------------------
--| CVS log
--|-----------------------------------------------------------------------------
--|
--| $Log$
--| Revision 1.3  2000/02/14 11:40:37  oconnor
--| merged changes from prerelease_20000214
--|
--| Revision 1.2.6.2  2000/01/27 19:29:59  oconnor
--| added --| FIXME Not for release
--|
--| Revision 1.2.6.1  1999/11/24 17:30:09  oconnor
--| merged with DEVEL branch
--|
--| Revision 1.2.2.3  1999/11/04 23:10:40  oconnor
--| updates for new color model, removed exists: not destroyed
--|
--| Revision 1.2.2.2  1999/11/02 17:20:06  oconnor
--| Added CVS log, redoing creation sequence
--|
--|
--|-----------------------------------------------------------------------------
--| End of CVS log
--|-----------------------------------------------------------------------------
