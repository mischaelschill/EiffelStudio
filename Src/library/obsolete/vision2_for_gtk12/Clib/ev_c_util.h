//------------------------------------------------------------------------------
// ev_c_util.h
//------------------------------------------------------------------------------
// description: "C features of EV_C_UTILS" 
// status: "See notice at end of file"
// date: "$Date$"
// revision: "$Revision$"
//------------------------------------------------------------------------------

#ifndef _EV_C_UTIL_H_INCLUDED_
#define _EV_C_UTIL_H_INCLUDED_
#include <gtk/gtk.h>

extern void (*eif_on_event) (EIF_REFERENCE, EIF_INTEGER);
extern void add_watch_callback (EIF_OBJECT io_watcher, gint handle, GIOCondition condition, gint* connection_id);
extern gboolean c_io_watcher_marshal (GIOChannel* source, GIOCondition condition, gpointer io_watcher);

EIF_REAL double_array_i_th (double* double_array, int index);
GtkArg* gtk_args_array_i_th (GtkArg** args_array, int index);

void enable_ev_gtk_log (int a_mode);

/* XPM */
char **information_pixmap_xpm (void);
char **error_pixmap_xpm (void);
char **question_pixmap_xpm (void);
char **warning_pixmap_xpm (void);
char **no_collate_pixmap_xpm (void);
char **collate_pixmap_xpm (void);
char **landscape_pixmap_xpm (void);
char **portrait_pixmap_xpm (void);
char **busy_cursor_xpm (void);
char **crosshair_cursor_xpm (void);
char **help_cursor_xpm (void);
char **ibeam_cursor_xpm (void);
char **no_cursor_xpm (void);
char **sizeall_cursor_xpm (void);
char **sizenesw_cursor_xpm (void);
char **sizens_cursor_xpm (void);
char **sizenwse_cursor_xpm (void);
char **sizewe_cursor_xpm (void);
char **standard_cursor_xpm (void);
char **uparrow_cursor_xpm (void);
char **wait_cursor_xpm (void);

#endif

//------------------------------------------------------------------------------
// EiffelVision2: library of reusable components for ISE Eiffel.
// Copyright (C) 1986-1999 Interactive Software Engineering Inc.
// All rights reserved. Duplication and distribution prohibited.
// May be used only with ISE Eiffel, under terms of user license.
// Contact ISE for any other use.
//
// Interactive Software Engineering Inc.
// ISE Building, 2nd floor
// 270 Storke Road, Goleta, CA 93117 USA
// Telephone 805-685-1006, Fax 805-685-6869
// Electronic mail <info@eiffel.com>
// Customer support e-mail <support@eiffel.com>
// For latest info see award-winning pages: http://www.eiffel.com
//------------------------------------------------------------------------------

//------------------------------------------------------------------------------
// CVS log
//------------------------------------------------------------------------------
//
// $Log$
// Revision 1.1  2005/07/07 17:02:11  king
// Initial revision
//
// Revision 1.13  2001/11/06 02:12:28  king
// Corrected pixmap externals
//
// Revision 1.12  2001/11/06 00:17:13  king
// Added public functions to private xpm data
//
// Revision 1.11  2001/10/15 23:35:21  king
// Removed static declaration on xpms
//
// Revision 1.10  2001/10/15 22:30:27  manus
// Moved pixmap definitions from header to c file
//
// Revision 1.9  2001/10/10 18:00:23  king
// Reinstated None for transparent colors
//
// Revision 1.8  2001/08/24 20:50:08  king
// Removed unused external
//
// Revision 1.7  2001/08/03 18:41:26  king
// Removed no longer needed externals
//
// Revision 1.6  2001/06/07 23:07:59  rogers
// Merged DEVEL branch into Main trunc.
//
// Revision 1.4.2.12  2001/06/04 20:08:51  king
// Updated enable_ev_gtk_log signature for debug mode
//
// Revision 1.4.2.11  2000/11/29 20:11:46  king
// Now include gtk.h
//
// Revision 1.4.2.10  2000/11/29 00:40:42  king
// Implemented gtk_args_array_i_th
//
// Revision 1.4.2.9  2000/11/27 19:16:23  andrew
// Added stock cursors and set background of icons to grey - until alpha channel is implemented
//
// Revision 1.4.2.8  2000/10/12 16:21:07  king
// Removed set_pixmap_and_mask
//
// Revision 1.4.2.7  2000/10/06 17:58:21  andrew
// Added print dialog images
//
// Revision 1.4.2.6  2000/10/02 23:14:46  king
// Added prototype for set_pixmap_and_mask
//
// Revision 1.4.2.5  2000/09/23 00:04:51  andrew
// Made transparent characters blank
//
// Revision 1.4.2.4  2000/09/21 21:44:00  andrew
// Added default pixmaps
//
// Revision 1.4.2.3  2000/07/20 18:38:50  king
// Added double_array_i_thimplementation/gtk/Clib/ev_c_util.h
//
// Revision 1.4.2.2  2000/05/03 22:00:48  king
// merged from HEAD
//
// Revision 1.5  2000/05/03 21:34:23  king
// Added temp default_pixmap
//
// Revision 1.4  2000/04/18 21:43:23  king
// Moved string_pointer_deref definition from header to source
//
// Revision 1.3  2000/04/18 17:57:53  oconnor
// Renamed get_pointer_from_array_by_index -> pointer_array_i_th
// Added string_pointer_deref (pointer: POINTER): POINTER
//
// Revision 1.2  2000/02/14 12:05:08  oconnor
// added from prerelease_20000214
//
// Revision 1.1.2.2  2000/02/11 04:48:50  oconnor
// attached GTK+ exception system to Eiffel
//
// Revision 1.1.2.1  2000/01/14 22:17:14  brendel
// Initial.
//
//
//------------------------------------------------------------------------------
// End of CVS log
//------------------------------------------------------------------------------
