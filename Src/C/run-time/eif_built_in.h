/*
	description: "Declarations for `built_in' externals."
	date:		"$Date$"
	revision:	"$Revision$"
	copyright:	"Copyright (c) 1985-2008, Eiffel Software."
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

#ifndef _eif_built_in_h
#define _eif_built_in_h
#if defined(_MSC_VER) && (_MSC_VER >= 1020)
#pragma once
#endif

#include "eif_eiffel.h"
#include "eif_misc.h"
#include "eif_helpers.h"
#include "eif_argv.h"
#include "eif_internal.h"
#include "eif_gen_conf.h"
#include "eif_object_id.h"
#include "eif_traverse.h"
#include "eif_macros.h"

#ifdef __cplusplus
extern "C" {
#endif

/* ANY class */
#define eif_builtin_ANY_generator(object) 				c_generator ((object))
#define eif_builtin_ANY_generating_type(object)			eif_gen_typename ((object))
#define eif_builtin_ANY_conforms_to(source, target)		econfg ((target), (source)) 
#define eif_builtin_ANY_same_type(obj1, obj2)			estypeg ((obj1), (obj2))
#define eif_builtin_ANY_tagged_out(object)				c_tagged_out ((object))
#define eif_builtin_ANY_copy(target, source)			ecopy ((source), (target))
#define eif_builtin_ANY_standard_copy(target, source)	ecopy ((source), (target))
#define eif_builtin_ANY_twin(object)			eif_twin (object)
#define eif_builtin_ANY_standard_twin(object)			eif_standard_twin (object)
#define eif_builtin_ANY_is_deep_equal(some, other)		ediso ((some), (other))
#define eif_builtin_ANY_is_equal(some, other)			eequal ((some), (other))
#define eif_builtin_ANY_standard_is_equal(some, other)	eequal ((some), (other))
#define eif_builtin_ANY_deep_twin(object)				edclone ((object))

/* ARGUMENTS class */
#define eif_builtin_ARGUMENTS_argument(some,i)			arg_option(i)
#define eif_builtin_ARGUMENTS_argument_count(some)		(arg_number() - 1)

/* EV_ANY_IMP class */
#define eif_builtin_EV_ANY_IMP_eif_current_object_id(object)	eif_reference_id(object)
#define eif_builtin_EV_ANY_IMP_eif_is_object_id_of_current(object,id) EIF_TEST(eif_id_object(id) == object)

/* EXCEPTION_MANAGER class */
#define eif_builtin_ISE_EXCEPTION_MANAGER_developer_raise(object, code, meaning, message)			draise(code, meaning, message)

/* IDENTIFIED_CONTROLLER class */
#define eif_builtin_IDENTIFIED_CONTROLLER_object_id_stack_size(obj)			eif_object_id_stack_size();
#define eif_builtin_IDENTIFIED_CONTROLLER_extend_object_id_stack(obj,nb)	eif_extend_object_id_stack(nb);

/* IDENTIFIED_ROUTINES class */
#define eif_builtin_IDENTIFIED_ROUTINES_eif_current_object_id(object)	eif_reference_id(object)
#define eif_builtin_IDENTIFIED_ROUTINES_eif_is_object_id_of_current(object,id) EIF_TEST(eif_id_object(id) == object)

/* INTERNAL class */
#define eif_builtin_INTERNAL_c_is_instance_of(dftype,obj)	RTRA(dftype,obj)
#define eif_builtin_INTERNAL_c_field(i,obj)					ei_field(i,obj)
#define eif_builtin_INTERNAL_c_expanded_type(i,obj)			ei_exp_type(i,obj)
#define eif_builtin_INTERNAL_c_character_8_field(i,obj)		ei_char_field(i,obj)
#define eif_builtin_INTERNAL_c_character_32_field(i,obj)	ei_char_32_field(i,obj)
#define eif_builtin_INTERNAL_c_boolean_field(i,obj)			ei_bool_field(i,obj)
#define eif_builtin_INTERNAL_c_natural_8_field(i,obj)		ei_uint_8_field(i,obj)
#define eif_builtin_INTERNAL_c_natural_16_field(i,obj)		ei_uint_16_field(i,obj)
#define eif_builtin_INTERNAL_c_natural_32_field(i,obj)		ei_uint_32_field(i,obj)
#define eif_builtin_INTERNAL_c_natural_64_field(i,obj)		ei_uint_64_field(i,obj)
#define eif_builtin_INTERNAL_c_integer_8_field(i,obj)		ei_int_8_field(i,obj)
#define eif_builtin_INTERNAL_c_integer_16_field(i,obj)		ei_int_16_field(i,obj)
#define eif_builtin_INTERNAL_c_integer_32_field(i,obj)		ei_int_32_field(i,obj)
#define eif_builtin_INTERNAL_c_integer_64_field(i,obj)		ei_int_64_field(i,obj)
#define eif_builtin_INTERNAL_c_real_32_field(i,obj)			ei_float_field(i,obj)
#define eif_builtin_INTERNAL_c_real_64_field(i,obj)			ei_double_field(i,obj)
#define eif_builtin_INTERNAL_c_pointer_field(i,obj)			ei_ptr_field(i,obj)
#define eif_builtin_INTERNAL_c_is_special(obj)				ei_special(obj)
#define eif_builtin_INTERNAL_c_is_tuple(obj)				ei_tuple(obj)
#define eif_builtin_INTERNAL_c_field_offset(i,obj)			ei_offset(i,obj)
#define eif_builtin_INTERNAL_c_bit_size(i,obj)				ei_bit_size(i,obj)
#define eif_builtin_INTERNAL_c_size(obj)					ei_size(obj)
#define eif_builtin_INTERNAL_c_set_reference_field(i,obj,val)		ei_set_reference_field(i,obj,val)
#define eif_builtin_INTERNAL_c_set_character_8_field(i,obj,val)		ei_set_char_field(i,obj,val)
#define eif_builtin_INTERNAL_c_set_character_32_field(i,obj,val)	ei_set_char_32_field(i,obj,val)
#define eif_builtin_INTERNAL_c_set_boolean_field(i,obj,val)			ei_set_boolean_field(i,obj,val)
#define eif_builtin_INTERNAL_c_set_natural_8_field(i,obj,val)		ei_set_natural_8_field(i,obj,val)
#define eif_builtin_INTERNAL_c_set_natural_16_field(i,obj,val)		ei_set_natural_16_field(i,obj,val)
#define eif_builtin_INTERNAL_c_set_natural_32_field(i,obj,val)		ei_set_natural_32_field(i,obj,val)
#define eif_builtin_INTERNAL_c_set_natural_64_field(i,obj,val)		ei_set_natural_64_field(i,obj,val)
#define eif_builtin_INTERNAL_c_set_integer_8_field(i,obj,val)		ei_set_integer_8_field(i,obj,val)
#define eif_builtin_INTERNAL_c_set_integer_16_field(i,obj,val)		ei_set_integer_16_field(i,obj,val)
#define eif_builtin_INTERNAL_c_set_integer_32_field(i,obj,val)		ei_set_integer_32_field(i,obj,val)
#define eif_builtin_INTERNAL_c_set_integer_64_field(i,obj,val)		ei_set_integer_64_field(i,obj,val)
#define eif_builtin_INTERNAL_c_set_real_32_field(i,obj,val)			ei_set_float_field(i,obj,val)
#define eif_builtin_INTERNAL_c_set_real_64_field(i,obj,val)			ei_set_double_field(i,obj,val)
#define eif_builtin_INTERNAL_c_set_pointer_field(i,obj,val)			ei_set_pointer_field(i,obj,val)
#define eif_builtin_INTERNAL_c_set_dynamic_type(obj,dftype)	eif_set_dynamic_type(obj,dftype)
#define eif_builtin_INTERNAL_c_mark(obj)					ei_mark(obj)
#define eif_builtin_INTERNAL_c_unmark(obj)					ei_unmark(obj)
#define eif_builtin_INTERNAL_c_is_marked(obj)				ei_is_marked(obj)

/* ISE_RUNTIME class */
#define eif_builtin_ISE_RUNTIME_dynamic_type(obj)			Dftype(obj)

/* MEMORY class */
#define eif_builtin_MEMORY_free(obj)					eif_mem_free(obj)
#define eif_builtin_MEMORY_find_referers(obj,dftype)	find_referers(obj,dftype)

/* PLATFORM class */
#define eif_builtin_PLATFORM_is_vms						EIF_IS_VMS
#ifdef EIF_IL_DLL
#define eif_builtin_PLATFORM_is_thread_capable 			EIF_TRUE
#else
#define eif_builtin_PLATFORM_is_thread_capable 			EIF_THREADS_SUPPORTED
#endif
#define eif_builtin_PLATFORM_is_scoop_capable 			EIF_TEST(egc_is_scoop_capable==1)
#define eif_builtin_PLATFORM_is_windows 				EIF_IS_WINDOWS
#define eif_builtin_PLATFORM_is_unix 					EIF_TEST(!(EIF_IS_VMS || EIF_IS_WINDOWS))
#define eif_builtin_PLATFORM_is_mac						EIF_TEST(EIF_OS==EIF_OS_DARWIN)
#define eif_builtin_PLATFORM_is_vxworks					EIF_TEST(EIF_OS==EIF_OS_VXWORKS)
#ifdef EIF_IL_DLL
#define eif_builtin_PLATFORM_is_dotnet					EIF_TRUE
#else
#define eif_builtin_PLATFORM_is_dotnet					EIF_FALSE
#endif
#define eif_builtin_PLATFORM_boolean_bytes 				sizeof(EIF_BOOLEAN)
#define eif_builtin_PLATFORM_character_bytes 			sizeof(EIF_CHARACTER_8)
#define eif_builtin_PLATFORM_wide_character_bytes 		sizeof(EIF_CHARACTER_32)
#define eif_builtin_PLATFORM_integer_bytes 				sizeof(EIF_INTEGER_32)
#define eif_builtin_PLATFORM_real_bytes 				sizeof(EIF_REAL_32)
#define eif_builtin_PLATFORM_double_bytes 				sizeof(EIF_REAL_64)
#define eif_builtin_PLATFORM_pointer_bytes 				sizeof(EIF_POINTER)

#define eif_builtin_REAL_32_REF_nan						eif_real_32_nan
#define eif_builtin_REAL_32_REF_negative_infinity		eif_real_32_negative_infinity
#define eif_builtin_REAL_32_REF_positive_infinity		eif_real_32_positive_infinity

#define eif_builtin_REAL_64_REF_nan						eif_real_64_nan
#define eif_builtin_REAL_64_REF_negative_infinity		eif_real_64_negative_infinity
#define eif_builtin_REAL_64_REF_positive_infinity		eif_real_64_positive_infinity

/* SPECIAL class */
#define eif_builtin_SPECIAL_aliased_resized_area(area, n)	arycpy (area, n, RT_SPECIAL_COUNT (area))
#define eif_builtin_SPECIAL_base_address(area)				(EIF_POINTER) (area)
#define eif_builtin_SPECIAL_capacity(area)					RT_SPECIAL_CAPACITY(area)
#define eif_builtin_SPECIAL_count(area)						RT_SPECIAL_COUNT(area)
#define eif_builtin_SPECIAL_element_size(area)				RT_SPECIAL_ELEM_SIZE(area)
#define eif_builtin_SPECIAL_set_count(area,n)				RT_SPECIAL_COUNT(area) = n

/* TYPE class */
#define eif_builtin_TYPE_has_default(obj)					eif_gen_has_default(eif_gen_param_id(Dftype(obj), 1))
#define eif_builtin_TYPE_is_expanded(obj)					eif_gen_is_expanded(eif_gen_param_id(Dftype(obj), 1))
#define eif_builtin_TYPE_type_id(obj)						eif_gen_param_id(Dftype(obj), 1)
#define eif_builtin_TYPE_runtime_name(obj)					eif_gen_typename_of_type(eif_gen_param_id(Dftype(obj), 1))
#define eif_builtin_TYPE_generic_parameter_type(obj,i)		RTLNTY(eif_gen_param_id(eif_gen_param_id(Dftype(obj), 1), i))
#define eif_builtin_TYPE_generic_parameter_count(obj)		eif_gen_count_with_dftype(eif_gen_param_id(Dftype(obj), 1))

/* TUPLE class */
#define eif_builtin_TUPLE_count(area)						(RT_SPECIAL_COUNT(area) - 1) /* - 1 because first argument is for object_comparison */

/* WEL_IDENTIFIED class */
#define eif_builtin_WEL_IDENTIFIED_eif_current_object_id(object)	eif_reference_id(object)
#define eif_builtin_WEL_IDENTIFIED_eif_is_object_id_of_current(object,id) EIF_TEST(eif_id_object(id) == object)

/* EQA_EXTERNALS class */
#ifdef WORKBENCH
#define eif_builtin_EQA_EXTERNALS_invoke_routine(obj, body_id)		eif_invoke_test_routine(obj,body_id)
#define eif_builtin_EQA_EXTERNALS_override_byte_code_of_body(body_id, pattern_id, byte_code, length)	eif_override_byte_code_of_body((int) body_id, (int) pattern_id, (unsigned char *) byte_code, (int)length)
#else
#define eif_builtin_EQA_EXTERNALS_invoke_routine(obj, body_id)
#define eif_builtin_EQA_EXTERNALS_override_byte_code_of_body(body_id, pattern_id, byte_code, length)
#endif


#ifdef __cplusplus
}
#endif

#endif
