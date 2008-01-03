/*
	description: "[
			This file was originally generated by running metaconfig, but this is
			not the case anymore. It contains special definition that can be used
			to configure the Runtime in a special manner.
			
			A typical example is to enable assertions.
			]"
	date:		"$Date$"
	revision:	"$Revision$"
	copyright:	"Copyright (c) 1985-2006, Eiffel Software."
	license:	"GPL version 2 see http://www.eiffel.com/licensing/gpl.txt)"
	licensing_options:	"Commercial license is available at http://www.eiffel.com/licensing"
	copying: "[
			This file is part of Eiffel Software's Runtime.
			
			Eiffel Software's Runtime is free software; you can
			redistribute it and/or modify it under the terms of the
			GNU General Public License as published by the Free
			Software Foundation, version 2 of the License
			(available at the URL listed under "license" above).
			
			Eiffel Software's Runtime is distributed in the hope
			that it will be useful,	but WITHOUT ANY WARRANTY;
			without even the implied warranty of MERCHANTABILITY
			or FITNESS FOR A PARTICULAR PURPOSE.
			See the	GNU General Public License for more details.
			
			You should have received a copy of the GNU General Public
			License along with Eiffel Software's Runtime; if not,
			write to the Free Software Foundation, Inc.,
			51 Franklin St, Fifth Floor, Boston, MA 02110-1301  USA
		]"
	source: "[
			 Eiffel Software
			 356 Storke Road, Goleta, CA 93117 USA
			 Telephone 805-685-1006, Fax 805-685-6869
			 Website http://www.eiffel.com
			 Customer support http://support.eiffel.com
		]"
*/

#ifndef _confmagic_h_
#define _confmagic_h_

/* Specific setup for VXWORKS port */
#ifdef VXWORKS
#include <vxWorks.h>
/*
#define CUSTOM
#define NEED_HASH_H
#define NEED_TIMER_H
*/
#endif

/* Are we using ISE GC? By default, yes. */
/* DEFINE_BOEHM_GC */
/* DEFINE_NO_GC */

#ifdef BOEHM_GC 
#define NO_ISE_GC
#if defined(EIF_THREADS) && defined(EIF_WINDOWS)
#define GC_DLL
#endif
#endif

#ifdef NO_GC
#define NO_ISE_GC
#endif

#ifndef NO_ISE_GC
#define ISE_GC
#endif

/* Do not compile with assertions, by default. */
#ifdef ISE_USE_ASSERT
#define EIF_EXPENSIVE_ASSERTIONS
#define EIF_ASSERTIONS
#endif

#ifndef EIF_ASSERTIONS
#define NDEBUG
#endif	/* EIF_ASSERTIONS */

#endif	/* _confmagic_h_ */
