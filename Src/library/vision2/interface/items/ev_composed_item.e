--| FIXME Not for release
--| FIXME Needs major revision !!!! - sam
--| Should it inherit somthing LINEAR ???
--| What does the class name mean anyway?
--| See below.
indexing	
	description:
		" EiffelVision composed item is composed of cell.%
		% each cell displays one text and one pixmap."
	note: "On windows, only the first pixmap is displayed."
	status: "See notice at end of class"
	id: "$$"
	date: "$Date$"
	revision: "$Revision$"

deferred class 
	EV_COMPOSED_ITEM

inherit
	EV_ITEM
		redefine
			implementation,
			create_action_sequences
		end

	EV_PICK_AND_DROPABLE
		redefine
			implementation,
			create_action_sequences
		end

feature {NONE} -- Initialization

--|FIXME a_text is an array.
--|FIXME comment says nothing about a_text.
	make_with_text (a_text: ARRAY [STRING]) is
			-- Create a row with text in it.
		require
			valid_text: a_text /= Void
		do
			default_create
			set_count (a_text.count)
			set_text (a_text)
		ensure
			--text_set: a_text = text
			--| FIXME needs implementing
		end

feature -- Access

--|FIXME English and period.
--|FIXME Empty precondition.
	count: INTEGER is
			-- Number of element in the item
		require
		do
			Result := implementation.count
		ensure
			positive_result: result >= 0
		end

--|FIXME Never say Return, just say what it is.
--|FIXME Try `an_index' not `value'.
	cell_text (value: INTEGER): STRING is
			-- Return the text of the cell number `value' 
		require
			valid_index: value >= 1 and value <= count
		do
			Result := implementation.cell_text (value)
		ensure
			valid_result: Result /= Void
		end

--|FIXME How can `text' or `Current lable' be a LINKED_LIST?
--|FIXME Empty precondition.
	text: LINKED_LIST [STRING] is
			-- Current label of the item
		require
		do
			Result := implementation.text
		ensure
			valid_result: Result /= Void
			valid_texts: not Result.has (Void)
		end

--|FIXME Never say Return, just say what it is.
--|FIXME Empty precondition.
--|FIXME None of this platform dependant behaviour is allowed!
	cell_pixmap (value: INTEGER): EV_PIXMAP is
			-- Return the pixmap of the cell number
			-- `value'. On windows platform, 
			-- if value > 1, the result is void.
		require
		do
			Result := implementation.cell_pixmap (value)
		end

--|FIXME Never say Return, just say what it is.
--|FIXME Empty precondition.
--|FIXME None of this platform dependant behaviour is allowed!
	pixmap: LINKED_LIST [EV_PIXMAP] is
			-- Return all the pixmaps of the item.
			-- Only 1 on windows platform.
		require
		do
			Result := implementation.pixmap
		end

feature -- Element change

--|FIXME Huh?
	set_count (value: INTEGER) is
			-- Make `value' the new count.
			-- When there is a parent, the item has the
			-- count done by the parent.
		require
			has_no_parent: parent = Void
			valid_value: value > 0
		do
			implementation.set_count (value)
		ensure
			count_set: count = value
		end

--|FIXME Wh is txt abvted.
	set_cell_text (value: INTEGER; txt: STRING) is
			-- Make `txt' the new label of the `value'-th
			-- cell of the item.
		require
			valid_index: value >= 1 and value <= count
			valid_text: txt /= Void
		do
			implementation.set_cell_text (value, txt)
		ensure
			text_set: (cell_text (value)).is_equal (txt)
		end

--|FIXME Wh is txt abvted.
--|FIXME why is txt an array when just before it was a STRING?
	set_text (txt: ARRAY [STRING]) is
			-- Make `txt' the new label of the item.
		require
			valid_text: txt /= Void
			valid_text_length: txt.count = count
		do
			implementation.set_text (txt)
		ensure
			text_set: implementation.text_set (txt)
		end

--|FIXME pix should be a_pixmap.
--|FIXME value should be `an_index'.
--|FIXME _cell_ is redundant.
	set_cell_pixmap (value: INTEGER; pix: EV_PIXMAP) is
			-- Make `pix' the new pixmap of the 
			-- `value'-th cell of the item.
		require
			valid_index: value >= 1 and value <= count
			valid_size: (pix /= Void) implies pixmap_size_ok (pix)
		do
			implementation.set_cell_pixmap (value, pix)
		ensure
			pixmap_set: (cell_pixmap (value)).is_equal (pix)
		end

--|FIXME Why is this commented out??
--	unset_cell_pixmap (value: INTEGER) is
--			-- Remove the pixmap of the 
--			-- `value'-th cell of the item.
--		require
--			valid_index: value >= 1 and value <= count
--			has_pixmap: (pixmap @ value) /= Void
--		do
--			implementation.unset_cell_pixmap (value)
--		ensure
--			pixmap_unset: (cell_pixmap (value) = Void)
--		end

--|FIXME Why is set_pixmap (singular) setting a whole array of pixmaps?
--|FIXME Why is pix, A, abbreviated, B, singular.
	set_pixmap (pix: ARRAY [EV_PIXMAP]) is
			-- Make `pix' the new pixmaps of the item.
		require
			valid_pixmaps: pix /= Void
			valid_size: pixmaps_size_ok (pix)
		do
			implementation.set_pixmap (pix)
		ensure
			text_set: implementation.pixmap_set (pix)
		end

feature {EV_ANY_I} -- Implementation

	implementation: EV_COMPOSED_ITEM_I
		-- Responsible for interaction with the native graphics toolkit.

feature {NONE} -- Implementation

	create_action_sequences is
			-- See `{EV_ANY}.create_action_sequences'.
		do
			{EV_ITEM} Precursor
			{EV_PICK_AND_DROPABLE} Precursor
		end

feature -- Contract support

	pixmap_size_ok (pix: EV_PIXMAP): BOOLEAN is
			--| FIXME word as question!
			-- Check if the size of the pixmap is ok for
			-- the container.
		do
			Result := implementation.pixmap_size_ok (pix)
		end

	pixmaps_size_ok (pix_array: ARRAY[EV_PIXMAP]): BOOLEAN is
			--| FIXME word as question!
			-- Check if the size of the pixmaps is ok for
			-- the container.
		do
			Result := implementation.pixmaps_size_ok (pix_array)
		end

end -- class EV_COMPOSED_ITEM

--!-----------------------------------------------------------------------------
--! EiffelVision : library of reusable components for ISE Eiffel.
--! Copyright (C) 1986-2000 Interactive Software Engineering Inc.
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
--!-----------------------------------------------------------------------------

--|-----------------------------------------------------------------------------
--| CVS log
--|-----------------------------------------------------------------------------
--|
--| $Log$
--| Revision 1.15  2000/04/10 19:45:49  brendel
--| Unreleased.
--|
--| Revision 1.14  2000/03/22 23:50:50  oconnor
--| added comments!!
--|
--| Revision 1.13  2000/03/10 01:27:27  king
--| Now inherits from PND
--|
--| Revision 1.12  2000/03/03 00:36:21  rogers
--| Make_with_text now sets the count of the item before setting the texts.
--|
--| Revision 1.11  2000/02/22 18:39:47  oconnor
--| updated copyright date and formatting
--|
--| Revision 1.10  2000/02/19 00:01:24  oconnor
--| released
--|
--| Revision 1.9  2000/02/17 21:49:33  king
--| Put has_no_parent precond back
--|
--| Revision 1.8  2000/02/16 20:30:46  king
--| Remove no_parent precondition from set_count
--|
--| Revision 1.7  2000/02/14 11:40:47  oconnor
--| merged changes from prerelease_20000214
--|
--| Revision 1.6.6.3  2000/01/27 19:30:36  oconnor
--| added --| FIXME Not for release
--|
--| Revision 1.6.6.2  1999/12/17 21:19:37  rogers
--| make no longer takes a parent. make_with_all has been removed.
--|
--| Revision 1.6.6.1  1999/11/24 17:30:41  oconnor
--| merged with DEVEL branch
--|
--| Revision 1.6.2.3  1999/11/04 23:10:46  oconnor
--| updates for new color model, removed exists: not destroyed
--|
--| Revision 1.6.2.2  1999/11/02 17:20:11  oconnor
--| Added CVS log, redoing creation sequence
--|
--|
--|-----------------------------------------------------------------------------
--| End of CVS log
--|-----------------------------------------------------------------------------
