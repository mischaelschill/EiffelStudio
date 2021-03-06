/*
	description: "Traversal of objects. Useful for storing objects and/or recursively coying them."
	date:		"$Date$"
	revision:	"$Revision$"
	copyright:	"Copyright (c) 1985-2013, Eiffel Software."
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

/*
doc:<file name="traverse.c" header="eif_traverse.h" version="$Id$" summary="Traversal of objects">
*/

#include "eif_portable.h"
#include "rt_garcol.h"
#include "rt_malloc.h"
#include "rt_macros.h"
#include "eif_except.h"

#if !defined CUSTOM || defined NEED_STORE_H
#include "rt_store.h"
#endif
#if !defined CUSTOM || defined NEED_HASH_H
#include "rt_hashin.h"
#endif

#include "rt_hector.h"
#include "rt_traverse.h"
#include "rt_types.h"
#include "eif_memory.h"
#include "rt_gen_types.h"
#include "rt_gen_conf.h"
#include "rt_struct.h"
#include "rt_interp.h"
#include <string.h>				/* For memset() */
#include "rt_assert.h"
#include "rt_globals_access.h"
#include "eif_stack.h"

#define ACCOUNT_TYPE        0x01	/* accounted for type as seen */
#define ACCOUNT_ATTRIBUTES  0x04	/* accounted for types of attributes */

/*
 * Declarations
 */
/*#define DEBUG */		/**/

/*
doc:	<attribute name="map_stack" return_type="struct mstack" export="private">
doc:		<summary>Map table. It is used to record the EIF_OBJECT protections of all the objects created during the maping traversal. It is represented as a stack and not as an array to avoid fragmentation when resizing (since we do not know how many objects we will traverse)--RAM.</summary>
doc:		<access>Read/Write</access>
doc:		<thread_safety>Safe with synchronization</thread_safety>
doc:		<synchronization>Safe if caller holds the `eif_eo_store_mutex' lock.</synchronization>
doc:	</attribute>
*/
rt_private struct mstack map_stack;

#ifdef EIF_THREADS
/*
doc:	<attribute name="eif_eo_store_mutex" return_type="EIF_CS_TYPE" export="shared">
doc:		<summary>When using EO_MARK to mark object, the full marking and unmarking process should be protected using this mutex. Not doing so, you might end up marking objects marked by a different thread or unmarking them, at the end it is a mess.</summary>
doc:		<thread_safety>Safe</thread_safety>
doc:	</attribute>
*/

rt_shared EIF_CS_TYPE *eif_eo_store_mutex = NULL;
#endif

#ifdef DEBUG
rt_shared uint32 nomark(char *);
rt_private uint32 chknomark(char *, struct htable *, long);
#endif

rt_private void internal_traversal(struct rt_traversal_context *a_context, EIF_REFERENCE object, int is_first_level); /* Traversal of objects */
rt_private EIF_REFERENCE matching (void (*action_fnptr) (EIF_REFERENCE, EIF_REFERENCE), EIF_TYPE_INDEX result_type);
rt_private void match_object (EIF_REFERENCE object, void (*action_fnptr) (EIF_REFERENCE, EIF_REFERENCE));
rt_private void match_simple_stack (struct ostack *stk, void (*action_fnptr) (EIF_REFERENCE, EIF_REFERENCE));
rt_private void match_stack (struct oastack *stk, void (*action_fnptr) (EIF_REFERENCE, EIF_REFERENCE));
#ifdef WORKBENCH
rt_private void match_op_stack(struct opstack *stk, void (*action_fnptr) (EIF_REFERENCE, EIF_REFERENCE));
#endif

rt_private void internal_find_all_instances (EIF_REFERENCE enclosing, EIF_REFERENCE compare_to);
rt_private void internal_find_instance_of (EIF_REFERENCE enclosing, EIF_REFERENCE compare_to);
rt_private void internal_find_referers (EIF_REFERENCE enclosing, EIF_REFERENCE compare_to);

/*
doc:	<routine name="eif_lock_marking" export="public">
doc:		<summary>Prevent 2 threads from using the EO_STORE marking facilities at the same time: this is the locking.</summary>
doc:		<thread_safety>Safe</thread_safety>
doc:	</routine>
*/

rt_public void eif_lock_marking (void)
{
	RT_GET_CONTEXT
	EIF_EO_STORE_LOCK;
}

/*
doc:	<routine name="eif_unlock_marking" export="public">
doc:		<summary>Prevent 2 threads from using the EO_STORE marking facilities at the same time: this is the unlocking.</summary>
doc:		<thread_safety>Safe</thread_safety>
doc:	</routine>
*/

rt_public void eif_unlock_marking (void)
{
	RT_GET_CONTEXT
	EIF_EO_STORE_UNLOCK;
}

/*
doc:	<routine name="account_type" export="private">
doc:		<summary>Account for types only, ignoring any attributes. Attributes are only processed when encountering an object of type `dftype' in `internal_traversal'.</summary>
doc:		<param name="a_context" type="struct rt_traversal_context *">Context read for configuring traversal and updated at the end?.</param>
doc:		<param name="dftype" type="EIF_TYPE_INDEX">Full dynamic type from which we want to know the types of its attributes.</param>
doc:		<thread_safety>Safe with synchronization</thread_safety>
doc:		<synchronization>Safe if caller holds the `eif_eo_store_mutex' lock.</synchronization>
doc:	</routine>
*/

rt_private void account_type (struct rt_traversal_context *a_context, EIF_TYPE_INDEX dftype)
{
	EIF_TYPE_INDEX dtype = To_dtype(dftype);

		/* Check that we are within bounds. */
	if (dftype >= a_context->account_count) {
			/* Increase by 50%. */
		size_t old_count = a_context->account_count;
		a_context->account_count = a_context->account_count + (a_context->account_count / 2);
		a_context->account = (struct rt_traversal_info *) crealloc (a_context->account, a_context->account_count * sizeof(struct rt_traversal_info));
		memset (a_context->account + old_count, 0, (a_context->account_count - old_count) * sizeof(struct rt_traversal_info));	/* Reset an empty stack */
	}

		/* Only process the type if not yet processed. */
	if (!a_context->account[dftype].processed) {
			/* We mark `dftype' as processed and `dtype' too. Note that
			 * `dtype' might have already been processed in the case `dftype'
			 * is another generic derivation of the same base class `dtype'. */
		a_context->account[dftype].processed = 1;
		a_context->account[dtype].processed = 1;
		if (dftype != dtype) {
				/* Type is generic, we need to record both the type and its actual
				 * generic parameters as well. */
			uint32 i, l_nb_gen = eif_gen_count_with_dftype(dftype);
			for (i = 0; i < l_nb_gen; i++) {
					/* + 1 here because it is 1-based. */
				account_type (a_context, eif_gen_param(dftype, i + 1).id);
			}
		}
	}
}

/*
doc:	<routine name="account_type_with_attributes" export="private">
doc:		<summary>Account for type of object found.</summary>
doc:		<param name="a_context" type="struct rt_traversal_context *">Context read for configuring traversal and updated at the end?.</param>
doc:		<param name="dftype" type="EIF_TYPE_INDEX">Full dynamic type from which we want to know the types of its attributes.</param>
doc:		<thread_safety>Safe with synchronization</thread_safety>
doc:		<synchronization>Safe if caller holds the `eif_eo_store_mutex' lock.</synchronization>
doc:	</routine>
*/

rt_private void account_type_with_attributes (struct rt_traversal_context *a_context, EIF_TYPE_INDEX dftype)
{
	EIF_TYPE_INDEX dtype = To_dtype(dftype);

	account_type (a_context, dftype);

		/* Account for declared types of the attributes of the type. This
		 * is important because the declared type of an attribute may be
		 * different from the object which is attached to it (through
		 * conformance).
		 */
	if ((a_context->accounting & TR_ACCOUNT_ATTR) && (!a_context->account[dftype].attributes_processed)) {
		long i, num_attrib = System (dtype).cn_nbattr;
		a_context->account[dftype].attributes_processed = 1;
		for (i = 0; i < num_attrib; i++) {
				/* Resolve type of attributes in context of `dftype'.
				 * Which means that if the attributes involves some formal generic parameters
				 * they are fully resolved with the actual generic parameter held via `dftype'. */
			account_type (a_context, eif_compound_id (dftype, System (dtype).cn_gtypes[i]).id);
		}
	}
}

/*
doc:	<routine name="traversal" export="shared">
doc:		<summary>First pass of the store mechanism consisting in marking objects with the EO_STORE flag.</summary>
doc:		<param name="a_context" type="struct rt_traversal_context">Context read for configuring traversal and updated at the end?.</param>
doc:		<param name="object" type="EIF_REFERENCE">Object from which we start the marking mechanism.</param>
doc:		<exception>"No more memory" when it fails</exception>
doc:		<thread_safety>Safe with synchronization</thread_safety>
doc:		<synchronization>Safe if caller holds the `eif_eo_store_mutex' lock.</synchronization>
doc:	</routine>
*/

rt_shared void traversal(struct rt_traversal_context *a_context, EIF_REFERENCE object)
{
	REQUIRE("object not null", object);

		/* Use `internal_traversal' so that if `object' is expanded, we still process it properly. */
	internal_traversal(a_context, object, 1);
}

rt_private void internal_traversal(struct rt_traversal_context *a_context, EIF_REFERENCE object, int is_first_level)
{
		/* First pass of the store mechanism consisting in marking objects. */
	EIF_GET_CONTEXT
	char *reference;
	rt_uint_ptr count, elem_size;
	union overhead *zone;		/* Object header */
	uint16 flags;				/* Object flags */
	char *new;					/* Mapped object */
	EIF_OBJECT mapped;				/* Mapped object protection */
	int mapped_object = 0;		/* True if maping occurred */
	rt_uint_ptr i;						/* To iterate over the references */

	REQUIRE("object not null", object);

	zone = HEADER(object);
	flags = zone->ov_flags;

	if (!a_context->is_unmarking) {
		if (flags & EO_STORE)			/* Object is already marked? */
			return;						/* Then we already dealt with it */
	} else {
		if (!(flags & EO_STORE))		/* Object is already unmarked? */
			return;						/* Then we already dealt with it. */
	}

		/* Mark the object if it is not expanded, or if it is, it should be the top level object. */
	if (is_first_level || !eif_is_nested_expanded(flags)) {

		/* If a maping table is to be built, create a new object and insert it
		 * in the map table. The reference is protected by requesting insertion
		 * in the hector stack. There is no need to check for a null pointer
		 * upon return from spmalloc, emalloc or hrecord since those calls will
		 * raise an exception if there is not enough memory to perform the
		 * operation.
		 */

		if (a_context->accounting & TR_MAP) {
			RT_GC_PROTECT(object);		/* Protection against GC */
			new = eclone(object);
			mapped = hrecord(new);
			if (eif_oastack_push(&map_stack.stack, mapped) != T_OK) {
				eraise("map table recording", EN_MEM);
			}
			zone = HEADER(object);			/* Object may have moved */
			flags = zone->ov_flags;			/* Flags may have changed */
			mapped_object = 1;				/* Maping occurred */
		}

		/* It is important to count the objects only once they have been
		 * recorded in the mapping stack (eventually), since the emergency
		 * release of the stack relies on an accurate object count.
		 */

		if (!a_context->is_unmarking) {
			flags |= EO_STORE;			/* Object marked as traversed */
		} else {
			flags &= ~EO_STORE;
		}
		a_context->obj_nb++; 					/* Count the number of objects traversed */
	}

#if !defined CUSTOM || defined NEED_STORE_H
	if (a_context->accounting & TR_ACCOUNT) {	/* Possible accounting */
		account_type_with_attributes (a_context, zone->ov_dftype);
# ifdef RECOVERABLE_DEBUG
		if (eif_is_nested_expanded(flags))
			printf ("      expanded %s [%p]\n", eif_typename (zone->ov_dftype), object);
		else
			printf ("%2ld: %s [%p]\n", a_context->obj_nb, eif_typename (zone->ov_dftype), object);
# endif

	}
#endif

	zone->ov_flags = flags;			/* Update mark of the object */

	/* Evaluation of the number of references of the object. It is really
	 * important that we traverse the objects in the same way a deep clone
	 * would, or the maping operation would not match the object graph
	 * topology--RAM.
	 */

	if (flags & EO_SPEC) {			/* Special object */
		if (!(flags & EO_REF)) {	/* Object does not have any reference */
			if (mapped_object)
				RT_GC_WEAN(object);
			return;
		}

			/* Evaluation of the number of items in the special object */
		count = RT_SPECIAL_COUNT(object);

		if (flags & EO_TUPLE) {
				/* Don't forget that first element of TUPLE is the BOOLEAN
				 * `object_comparison' attribute. */
			for (i = 1; i < count ; i++) {
				if (eif_item_sk_type(object, i) == SK_REF) {
					reference = eif_reference_item(object, i);
					if (reference) {
						internal_traversal(a_context, reference, 0);
					}
				}
			}
		} else if (!(flags & EO_COMP))
				/* Special object filled with references */
			for (i = 0; i < count; i++) {
				reference = *((char **) object + i);
				if (reference) {
					internal_traversal(a_context, reference, 0);
				}
			}
		else {
				/* Special object filled with expanded objects which are
				 * necessary not special objects. */
			rt_uint_ptr offset = OVERHEAD;
			elem_size = RT_SPECIAL_ELEM_SIZE(object);
			for (i = 0; i < count; i++, offset += elem_size) {
				internal_traversal(a_context, object + offset, 0);
			}
		}
	} else {
		/* Normal object */
		count = References(zone->ov_dtype);

		/* Traversal of references of `object' */
		for (i = 0; i < count; i++) {
			reference = *((char **) object + i);
				/* Only account for non-volatile attributes in `for_persistence' mode. */
			if (reference && (!a_context->is_for_persistence || (!EIF_IS_TRANSIENT_ATTRIBUTE(System(zone->ov_dtype),i)))) {
				internal_traversal(a_context, reference, 0);
			}
		}
	}

	if (mapped_object)
		RT_GC_WEAN(object);
}

/*
 * Indirection table handling.
 */

/*
doc:	<routine name="map_start" export="shared">
doc:		<summary>Restart the maping table at the beginning. Note that we are using the extra st_bot field which is added after all the fields from the stack structure.</summary>
doc:		<thread_safety>Safe with synchronization</thread_safety>
doc:		<synchronization>Safe if caller holds the `eif_eo_store_mutex' lock.</synchronization>
doc:	</routine>
*/

rt_shared void map_start(void)
{
	map_stack.bottom.sc_chunk = map_stack.stack.st_head;
	map_stack.bottom.sc_item = map_stack.stack.st_head->sk_arena - 1;
}

/*
doc:	<routine name="map_next" return_type="EIF_OBJECT" export="shared">
doc:		<summary>Return next object in the map table, via its indirection pointer. Note that the stack structure is physically destroyed in the process, being mangled from the bottom.</summary>
doc:		<thread_safety>Safe with synchronization</thread_safety>
doc:		<synchronization>Safe if caller holds the `eif_eo_store_mutex' lock.</synchronization>
doc:	</routine>
*/

rt_shared EIF_OBJECT map_next(void)
{
	eif_oastack_forth (&map_stack.bottom);
	return *map_stack.bottom.sc_item;
}

/*
doc:	<routine name="map_reset" export="shared">
doc:		<summary>At the end of a cloning operation, the stack is reset (i.e. emptied) and a consistency check is made to ensure it is really empty.</summary>
doc:		<param name="emergency" type="int">Need to reset due to emergency (exception)?</param>
doc:		<thread_safety>Safe with synchronization</thread_safety>
doc:		<synchronization>Safe if caller holds the `eif_eo_store_mutex' lock.</synchronization>
doc:	</routine>
*/

rt_shared void map_reset(int emergency)
{
	eif_oastack_reset (&map_stack.stack);
	memset(&map_stack, 0, sizeof(struct mstack));
}

/*
doc:	<attribute name="referers_target" return_type="EIF_REFERENCE" export="private">
doc:		<summary>Object for which we track all the objects that refers to it in `find_referers'.</summary>
doc:		<access>Read/Write</access>
doc:		<thread_safety>Safe with synchronization</thread_safety>
doc:		<synchronization>Safe if caller holds the `eif_gc_mutex' lock.</synchronization>
doc:	</attribute>
*/
rt_private EIF_REFERENCE referers_target = NULL;

/*
doc:	<attribute name="instance_type" return_type="EIF_TYPE" export="private">
doc:		<summary>Dynamic type used to track all objects of this particular dynamic type in `find_instance_of'.</summary>
doc:		<access>Read/Write</access>
doc:		<thread_safety>Safe with synchronization</thread_safety>
doc:		<synchronization>Safe if caller holds the `eif_gc_mutex' lock.</synchronization>
doc:	</attribute>
*/
rt_private EIF_TYPE instance_type;

/*
doc:	<routine name="find_referers" return_type="EIF_REFERENCE" export="shared">
doc:		<summary>Find all objects that refers to `target' and return a SPECIAL object.</summary>
doc:		<param name="target" type="EIF_REFERENCE">Object from which we want to find all objects that refer to it.</param>
doc:		<param name="result_type" type="EIF_ENCODED_TYPE">Full dynamic type of SPECIAL [ANY].</param>
doc:		<thread_safety>Safe</thread_safety>
doc:		<synchronization>Through `eif_gc_mutex'.</synchronization>
doc:	</routine>
*/

rt_public EIF_REFERENCE find_referers (EIF_REFERENCE target, EIF_ENCODED_TYPE result_type)
{
	RT_GET_CONTEXT
	EIF_GET_CONTEXT
	EIF_REFERENCE result = NULL;
	EIF_TYPE ftype = eif_decoded_type(result_type);
#ifdef ISE_GC
		/* Fixed eweasel test#thread008 where if a GC cycle happen, while we wait for the
		 * synchronization, then `target' might not be valid anymore. */
	RT_GC_PROTECT(target);
	GC_THREAD_PROTECT(eif_synchronize_gc (rt_globals));
	RT_GC_WEAN(target);
	referers_target = target;
	result = matching (internal_find_referers, ftype.id);
	GC_THREAD_PROTECT(eif_unsynchronize_gc (rt_globals));
#else
	EIF_EO_STORE_LOCK;
	referers_target = target;
	result = matching (internal_find_referers, ftype.id);
	EIF_EO_STORE_UNLOCK;
#endif
	return result;
}

/*
doc:	<routine name="find_instance_of" return_type="EIF_REFERENCE" export="shared">
doc:		<summary>Find all object that have `type' as dynamic type and return a SPECIAL object containing them all.</summary>
doc:		<param name="type" type="EIF_ENCODED_TYPE">Dynamic type of objects we are looking for.</param>
doc:		<param name="result_type" type="EIF_ENCODED_TYPE">Full dynamic type of SPECIAL[ANY].</param>
doc:		<thread_safety>Safe</thread_safety>
doc:		<synchronization>Through `eif_gc_mutex'.</synchronization>
doc:	</routine>
*/

rt_public EIF_REFERENCE find_instance_of (EIF_ENCODED_TYPE type, EIF_ENCODED_TYPE result_type)
{
	RT_GET_CONTEXT
	EIF_REFERENCE result = NULL;
	instance_type = eif_decoded_type(type);
#ifdef ISE_GC
	GC_THREAD_PROTECT(eif_synchronize_gc (rt_globals));
	result = matching (internal_find_instance_of, eif_decoded_type(result_type).id);
	GC_THREAD_PROTECT(eif_unsynchronize_gc (rt_globals));
#else
	EIF_EO_STORE_LOCK;
	result = matching (internal_find_instance_of, eif_decoded_type(result_type).id);
	EIF_EO_STORE_UNLOCK;
#endif
	return result;
}

/*
doc:	<routine name="find_all_instances" return_type="EIF_REFERENCE" export="shared">
doc:		<summary>Find all objects in system and return a SPECIAL object containing them all.</summary>
doc:		<param name="result_type" type="EIF_ENCODED_TYPE">Full dynamic type of SPECIAL[ANY].</param>
doc:		<thread_safety>Safe</thread_safety>
doc:		<synchronization>Through `eif_gc_mutex'.</synchronization>
doc:	</routine>
*/

rt_public EIF_REFERENCE find_all_instances (EIF_ENCODED_TYPE result_type)
{
	RT_GET_CONTEXT
	EIF_REFERENCE result = NULL;
#ifdef ISE_GC
	GC_THREAD_PROTECT(eif_synchronize_gc (rt_globals));
	result = matching (internal_find_all_instances, eif_decoded_type(result_type).id);
	GC_THREAD_PROTECT(eif_unsynchronize_gc (rt_globals));
#else
	EIF_EO_STORE_LOCK;
	result = matching (internal_find_all_instances, eif_decoded_type(result_type).id);
	EIF_EO_STORE_UNLOCK;
#endif
	return result;
}


/*
doc:	<attribute name="found_collection" return_type="struct obj_array *" export="private">
doc:		<summary>Collects all matching objects found in `find_instance_of' or `find_referers'.</summary>
doc:		<access>Read/Write</access>
doc:		<thread_safety>Safe with synchronization</thread_safety>
doc:		<synchronization>Safe if caller holds the `eif_gc_mutex' lock.</synchronization>
doc:	</attribute>
*/
rt_private struct obj_array *found_collection = NULL;

/*
doc:	<attribute name="marked_collection" return_type="struct obj_array *" export="private">
doc:		<summary>Keeps all objects marked during search in `find_instance_of' or `find_referers'.</summary>
doc:		<access>Read/Write</access>
doc:		<thread_safety>Safe with synchronization</thread_safety>
doc:		<synchronization>Safe if caller holds the `eif_gc_mutex' lock.</synchronization>
doc:	</attribute>
*/
rt_private struct obj_array *marked_collection = NULL;

/*
doc:	<routine name="obj_array_extend" export="private">
doc:		<summary>Add `obj' to `a_collection'.</summary>
doc:		<param name="obj" type="EIF_REFERENCE">Object to add in `a_collection'.</param>
doc:		<param name="a_collection" type="struct obj_array *">Collection in which `obj' is added.</param>
doc:		<thread_safety>Safe with synchronization</thread_safety>
doc:		<synchronization>Safe if caller holds the `eif_gc_mutex' lock.</synchronization>
doc:	</routine>
*/

rt_private void obj_array_extend (EIF_REFERENCE obj, struct obj_array *a_collection)
{
	if (a_collection->count >= a_collection->capacity) {
		a_collection->capacity = a_collection->capacity * 2;
		a_collection->area = realloc (a_collection->area, sizeof (EIF_REFERENCE) * (a_collection->capacity));
		if (!a_collection->area) {
				/* Cannot reallocate. */
			enomem();
		}
	}
	a_collection->area [a_collection->count] = obj;
	a_collection->count = a_collection->count + 1;
}

/*
doc:	<routine name="internal_find_instance_of" export="private">
doc:		<summary>Check if dynamic type of `compare_to' and `enclosing' matches `instance_type'. If so, add it to `found_collection'.</summary>
doc:		<param name="enclosing" type="EIF_REFERENCE">Object we possibly want to add to `found_collection'.</param>
doc:		<param name="compare_to" type="EIF_REFERENCE">Only for signature purposes. We only do something if `enclosing' references the same object as `compare_to'.</param>
doc:		<thread_safety>Safe with synchronization</thread_safety>
doc:		<synchronization>Safe if caller holds the `eif_gc_mutex' lock.</synchronization>
doc:	</routine>
*/

rt_private void internal_find_instance_of (EIF_REFERENCE enclosing, EIF_REFERENCE compare_to)
{
	if
		((enclosing == compare_to) &&
		((EIF_INTEGER) (HEADER(enclosing)->ov_dftype) == instance_type.id ? 1 : 0) &&
		(!((HEADER(enclosing)->ov_flags) & EO_STORE)))
	{
		obj_array_extend (enclosing, found_collection);
	}
}

/*
doc:	<routine name="internal_find_all_instances" export="private">
doc:		<summary>Add `enclosing' to `found_collection' if not yet processed, as we try to find all objects in universe.</summary>
doc:		<param name="enclosing" type="EIF_REFERENCE">Object we possibly want to add to `found_collection'.</param>
doc:		<param name="compare_to" type="EIF_REFERENCE">Only for signature purposes. We only do something if `enclosing' references the same object as `compare_to'.</param>
doc:		<thread_safety>Safe with synchronization</thread_safety>
doc:		<synchronization>Safe if caller holds the `eif_gc_mutex' lock.</synchronization>
doc:	</routine>
*/

rt_private void internal_find_all_instances (EIF_REFERENCE enclosing, EIF_REFERENCE compare_to)
{
	if ((enclosing == compare_to) && (!((HEADER(enclosing)->ov_flags) & EO_STORE))) {
		obj_array_extend (enclosing, found_collection);
	}
}

/*
doc:	<routine name="internal_find_referers" export="private">
doc:		<summary>Check if `compare_to' refers to `referers_target' and that `enclosing' is not equal to `compare_to'. If it matches, then we add `enclosing' to `found_collection'.</summary>
doc:		<param name="enclosing" type="EIF_REFERENCE">Object we possibly want to add to `found_collection'.</param>
doc:		<param name="compare_to" type="EIF_REFERENCE">If `compare_to' is `referers_target' then we add enclosing.</param>
doc:		<thread_safety>Safe with synchronization</thread_safety>
doc:		<synchronization>Safe if caller holds the `eif_gc_mutex' lock.</synchronization>
doc:	</routine>
*/

rt_private void internal_find_referers (EIF_REFERENCE enclosing, EIF_REFERENCE compare_to)
{
	if
		((enclosing != compare_to) &&
		(referers_target == compare_to ? 1 : 0))
	{
		obj_array_extend (enclosing, found_collection);
	}
}

/*
doc:	<routine name="matching" return_type="EIF_REFERENCE" export="private">
doc:		<summary>Using `action_fnptr' find all objects where `action_fnptr' returns a matching object. Return a SPECIAL [ANY] of type `result_type' with all found references.</summary>
doc:		<param name="action_fnptr" type="void (*) (EIF_REFERENCE, EIF_REFERENCE)">Agent to be called for each object we find.</param>
doc:		<param name="result_type" type="EIF_TYPE_INDEX">Full dynamic type of SPECIAL [ANY].</param>
doc:		<thread_safety>Safe with synchronization</thread_safety>
doc:		<synchronization>Safe if caller holds the `eif_gc_mutex' lock.</synchronization>
doc:	</routine>
*/

rt_private EIF_REFERENCE matching (void (*action_fnptr) (EIF_REFERENCE, EIF_REFERENCE), EIF_TYPE_INDEX result_type)
{
	size_t i = 0;
	char gc_stopped;
	struct obj_array l_found, l_marked;
	union overhead *zone;
	EIF_REFERENCE Result;

		/* Initialize structure that will hold found objects */
	l_found.count = 0;
	l_found.capacity = 64;
	l_found.area = malloc (sizeof (EIF_REFERENCE) * l_found.capacity);
	if (!l_found.area) {
		enomem();
	}
	found_collection = &l_found;

		/* Initialize structure that will hold marked objects */
	l_marked.count = 0;
	l_marked.capacity = 64;
	l_marked.area = malloc (sizeof (EIF_REFERENCE) * l_marked.capacity);
	if (!l_marked.area) {
		free(l_found.area);
		enomem();
	}
	marked_collection = &l_marked;

		/* Traverse all stacks and root object to find objects matching `action_fnptr'. */
	if (root_obj) {
		match_object (root_obj, action_fnptr);
	}

#ifdef ISE_GC
	match_simple_stack (&eif_hec_saved, action_fnptr);
	match_simple_stack (&eif_weak_references, action_fnptr);
#endif

#ifndef EIF_THREADS
#ifdef ISE_GC
	match_simple_stack (&hec_stack, action_fnptr);

	match_stack (&loc_set, action_fnptr);
	match_stack (&loc_stack, action_fnptr);
#endif
#ifdef WORKBENCH
	match_op_stack (&op_stack, action_fnptr);
	match_simple_stack (&once_set, action_fnptr);
#else
	match_stack (&once_set, action_fnptr);
#endif
	match_stack (&oms_set, action_fnptr);
#else
#ifdef ISE_GC
	for (i = 0; i < hec_stack_list.count; i++)
		match_simple_stack(hec_stack_list.threads.ostack[i], action_fnptr);

	for (i = 0; i < loc_set_list.count; i++)
		match_stack(loc_set_list.threads.oastack[i], action_fnptr);
	for (i = 0; i < loc_stack_list.count; i++)
		match_stack(loc_stack_list.threads.oastack[i], action_fnptr);
	match_stack(&global_once_set, action_fnptr);

	for (i = 0; i < once_set_list.count; i++)
		match_simple_stack(once_set_list.threads.ostack[i], action_fnptr);

#ifdef WORKBENCH
	for (i = 0; i < opstack_list.count; i++)
		match_op_stack(opstack_list.threads.opstack[i], action_fnptr);
#endif
#endif
#endif

		/* Now `l_found' is properly populated so let's create
		 * SPECIAL objects of type `result_type' that we will return.
		 * We turn off GC since we do not want objects to be moved. */
	gc_stopped = !eif_gc_ison();
	eif_gc_stop();
	Result = spmalloc (l_found.count, sizeof (EIF_REFERENCE), EIF_FALSE);
	zone = HEADER (Result);
	zone->ov_flags |= EO_REF;
	zone->ov_dftype = result_type;
	zone->ov_dtype = To_dtype(result_type);
	RT_SPECIAL_COUNT(Result) = l_found.count;
	RT_SPECIAL_ELEM_SIZE(Result) = sizeof(EIF_REFERENCE);
	RT_SPECIAL_CAPACITY(Result) = l_found.count;

		/* Now, populate `Result' with content of `l_found'. Since we just
		 * created a new Eiffel objects. */
	for (i = 0 ; i < l_found.count ; i++) {

			/* Store object in `Result'. */
		*((EIF_REFERENCE*) Result + i) = l_found.area [i];
		RTAR(Result, l_found.area [i]);
	}

		/* Now, we reset all EO_STORE flags. */
	for (i = 0 ; i < l_marked.count ; i++) {
			/* Reset `EO_STORE' flags */
		zone = HEADER(l_marked.area [i]);
		zone->ov_flags &= (~EO_STORE);
	}

	free (l_found.area);
	free (l_marked.area);

		/* Let's turn back the GC on */
	if (!gc_stopped) eif_gc_run();

	return Result;
}

/*
doc:	<routine name="match_simple_stack" export="private">
doc:		<summary>Using `action_fnptr' find all objects where `action_fnptr' returns a matching object for objects located in simple stacks.</summary>
doc:		<param name="stk" type="struct ostack *">Stack in which we are searching.</param>
doc:		<param name="action_fnptr" type="void (*) (EIF_REFERENCE, EIF_REFERENCE)">Agent to be called for each object we find.</param>
doc:		<thread_safety>Safe with synchronization</thread_safety>
doc:		<synchronization>Safe if caller holds the `eif_gc_mutex' lock.</synchronization>
doc:	</routine>
*/

rt_private void match_simple_stack (struct ostack *stk, void (*action_fnptr) (EIF_REFERENCE, EIF_REFERENCE))
{
	struct stochunk *s, *current_chunk;
	EIF_REFERENCE *object, o_ref;
	rt_uint_ptr n;
	int done = 0;

	for (s = stk->st_head, current_chunk = stk->st_cur; s && !done; s = s->sk_next) {
			/* Do not process any further chunks beyond the current chunk. */
		done = (s == current_chunk);
		object = s->sk_arena;
		n = s->sk_top - object;
		for ( ; n > 0 ; n--, object++) {
			o_ref = *object;
			if (o_ref) {
				match_object (o_ref, action_fnptr);
			}
		}
	}
}

/*
doc:	<routine name="match_stack" export="private">
doc:		<summary>Using `action_fnptr' find all objects where `action_fnptr' returns a matching object for objects located in stacks.</summary>
doc:		<param name="stk" type="struct oastack *">Stack in which we are searching.</param>
doc:		<param name="action_fnptr" type="void (*) (EIF_REFERENCE, EIF_REFERENCE)">Agent to be called for each object we find.</param>
doc:		<thread_safety>Safe with synchronization</thread_safety>
doc:		<synchronization>Safe if caller holds the `eif_gc_mutex' lock.</synchronization>
doc:	</routine>
*/

rt_private void match_stack (struct oastack *stk, void (*action_fnptr) (EIF_REFERENCE, EIF_REFERENCE))
{
	struct stoachunk *s, *current_chunk;
	EIF_REFERENCE **object, o_ref;
	rt_uint_ptr n;
	int done = 0;

	for (s = stk->st_head, current_chunk = stk->st_cur; s && !done; s = s->sk_next) {
			/* Do not process any further chunks beyond the current chunk. */
		done = (s == current_chunk);
		object = s->sk_arena;
		n = s->sk_top - object;
		for ( ; n > 0 ; n--, object++) {
			o_ref = **object;
			if (o_ref) {
				match_object (o_ref, action_fnptr);
			}
		}
	}
}

/*
doc:	<routine name="match_op_stack" export="private">
doc:		<summary>Using `action_fnptr' find all objects where `action_fnptr' returns a matching object for objects located in opstack.</summary>
doc:		<param name="stk" type="struct opstack *">Stack in which we are searching.</param>
doc:		<param name="action_fnptr" type="void (*) (EIF_REFERENCE, EIF_REFERENCE)">Agent to be called for each object we find.</param>
doc:		<thread_safety>Safe with synchronization</thread_safety>
doc:		<synchronization>Safe if caller holds the `eif_gc_mutex' lock.</synchronization>
doc:	</routine>
*/

#ifdef WORKBENCH
rt_private void match_op_stack(struct opstack *stk, void (*action_fnptr) (EIF_REFERENCE, EIF_REFERENCE))
{
	/* Loop over the operational stack (the one used by the interpreter) and
	 * mark all the references found.
	 */

	EIF_TYPED_VALUE *last;	/* For looping over subsidiary roots */
	rt_uint_ptr roots;			/* Number of roots in each chunk */
	struct stopchunk *s, *current_chunk;	/* To walk through each stack's chunk */
	int done = 0;

	REQUIRE ("stk not null", stk);
	REQUIRE ("action_fnptr not null", action_fnptr);

	for (s = stk->st_head, current_chunk = stk->st_cur; s && !done; s = s->sk_next) {
			/* Do not process any further chunks beyond the current chunk. */
		done = (s == current_chunk);
		last = s->sk_arena;						/* Start of stack */
		roots = s->sk_top - last;			/* The whole chunk */

		for (; roots > 0; roots--, last++)		/* Objects may be moved */
			switch (last->type & SK_HEAD) {		/* Type in stack */
			case SK_REF:						/* Reference */
			case SK_EXP:
				if (last->it_ref) {
					match_object (last->it_ref, action_fnptr);
				}
				break;
			}
	}
}
#endif

/*
doc:	<routine name="match_object" export="private">
doc:		<summary>Using `action_fnptr' find all objects where `action_fnptr' returns a matching object for objects located in stacks. Performs a recursive call for every references found in `object'.</summary>
doc:		<param name="object" type="EIF_REFERENCE">Object we use for comparison.</param>
doc:		<param name="action_fnptr" type="void (*) (EIF_REFERENCE, EIF_REFERENCE)">Agent to be called for each object we find.</param>
doc:		<thread_safety>Safe with synchronization</thread_safety>
doc:		<synchronization>Safe if caller holds the `eif_gc_mutex' lock.</synchronization>
doc:	</routine>
*/

rt_private void match_object (EIF_REFERENCE object, void (*action_fnptr) (EIF_REFERENCE, EIF_REFERENCE))
{
	EIF_REFERENCE *o_ref;
	EIF_INTEGER count;
	union overhead *zone;
	uint16 flags;

	zone = HEADER(object);
	flags = zone->ov_flags;

	if (flags & EO_STORE) {
		/* Object is already marked, so we skip it. */
		return;
	}

		/* Insert Current object in case criterion `action_fnptr' needs it. */
	action_fnptr (object, object);

		/* Insert object in `marked_collection' so that we can remove the EO_STORE flag
		 * later on. */
	obj_array_extend (object, marked_collection);
	zone->ov_flags |= EO_STORE;	/* We marked object as traversed. */

	if (flags & EO_SPEC) {	/* Special object */
		if (!(flags & EO_REF))	/* Object does not have any references. */
			return;
		CHECK ("Not a SPECIAL of expanded objects", !(flags & EO_COMP));

		if (flags & EO_TUPLE) {
			EIF_TYPED_VALUE *l_item = (EIF_TYPED_VALUE *) object;
				/* Don't forget that first element of TUPLE is the BOOLEAN
				 * `object_comparison' attribute. */
			l_item++;
			count = RT_SPECIAL_COUNT(object) - 1;
			for (; count > 0; count--, l_item++) {
				if
					(eif_is_reference_tuple_item(l_item) &&
					(eif_reference_tuple_item(l_item)))
				{
					action_fnptr (object, eif_reference_tuple_item(l_item));
					match_object (eif_reference_tuple_item(l_item), action_fnptr);
				}
			}
			return;
		} else {
			count = RT_SPECIAL_COUNT(object);
		}
	} else {
		count = References(zone->ov_dtype);
	}

		/* Perform recursion on enclosed references */
	for (o_ref = (EIF_REFERENCE *) object; count > 0; count--, o_ref++) {
		if (*o_ref != NULL) {
			action_fnptr (object, *o_ref);
			match_object (*o_ref, action_fnptr);
		}
	}
}

#ifdef DEBUG

rt_shared uint32 nomark(char *obj)
{
	/* Check if there is no object marked EO_STORE under `obj'. */
	struct htable *tbl;
	uint32 result;
	char gc_stopped;

	gc_stopped = !eif_gc_ison();
	eif_gc_stop();

	tbl = (struct htable *) cmalloc(sizeof(struct htable));
	if (tbl == (struct htable *) 0)
		enomem();
	if (ht_create(tbl, 1000, sizeof(char *)) != 0)
		enomem();
	result = chknomark(obj,tbl,0);
	ht_free(tbl);
	if (!gc_stopped) eif_gc_run();
	return result;
}

rt_private uint32 chknomark(char *object, struct htable *tbl, uint32 object_count)
{
	/* First pass of the store mechanism consisting in marking objects. */

	char *reference;
	rt_uint_ptr count, elem_size, i;
	union overhead *zone = HEADER(object);		/* Object header */
	uint16 flags;								/* Object flags */
	unsigned long key = ((unsigned long) object) - 1;

	flags = zone->ov_flags;

	/* Check if the object is already checked */
	if (ht_value(tbl,key) != (char *) 0)
		return object_count;

	/* Mark the object if not expanded */
	if (!eif_is_nested_expanded(flags)) {
		ht_force(tbl,key,object);
		object_count++;
	}

	/* Check if no mark */
	if (flags & EO_STORE)
		eif_panic("object still marked");

	/* Evaluation of the number of references of the object */
	if (flags & EO_SPEC) {
		/* Special object */
		if (!(flags & EO_REF))
			/* Special object filled with direct instances */
			return object_count;

		/* Evaluation of the number of items in the special object */
		count = RT_SPECIAL_COUNT(object);

		if (flags & EO_TUPLE) {
				/* Don't forget that first element of TUPLE is the BOOLEAN
				 * `object_comparison' attribute. */
			for (i = 1; i < count ; i++) {
				if (eif_item_sk_type(object, i) == SK_REF) {
					reference = eif_reference_item(object, i);
					if (reference) {
						object_count = chknomark(reference, tbl, object_count);
					}
				}
			}
		} else if (!(flags & EO_COMP)) {
			/* Special object filled with references */
			for (; count > 0; count--,
					object = (char *) ((char **) object + 1)) {
				reference = *(char **)object;
				if (0 != reference)
					/* Non void reference */
					object_count = chknomark(reference,tbl,object_count);
			}
		} else {
			/* Special object filled with expanded objects which are
			 * necessary not special objects.
			 */
			elem_size = RT_SPECIAL_ELEM_SIZE(object);
			for (object += OVERHEAD; count > 0;
					count --, object += elem_size)
				object_count = chknomark(object,tbl,object_count);
		}
	} else {
		/* Normal object */
		count = References(zone->ov_dtype);

		/* Traversal of references of `object' */
		for (;  count > 0;
				count--, object = (char *) (((char **) object) +1)) {
			reference = *(char **)object;
			if (((char *) 0) != reference)
				object_count = chknomark(reference,tbl,object_count);
		}
	}
	return object_count;
}
#endif

/*
doc:</file>
*/
