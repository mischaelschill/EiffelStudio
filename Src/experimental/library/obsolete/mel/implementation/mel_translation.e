note

	description: 
		"Mel representation of an translation string. %
		%This class is needed for the passing of translation string %
		%to C which is then retrieved in the callback to execute the %
		%corresponding Eiffel Callback. However, since we adopted the %
		%string object, the translation string had to encapsulated so it %
		%can be weaned automatically by the GC."
	legal: "See notice at end of class.";
	status: "See notice at end of class.";
	date: "$Date$";
	revision: "$Revision$"

class MEL_TRANSLATION

inherit
	MEL_CALLBACK_KEY
		redefine
			out, is_equal
		end

	DISPOSABLE
		redefine
			out, is_equal
		end

create
	make,
	make_no_adopted

feature {NONE} -- Initialization

	make (a_translation: STRING)
			-- Create a mel_translation from `a_translation'.
		require
			non_void_a_translation: a_translation /= Void
		do
			type := translation_type;
			translation_string := a_translation;
			hash_code := a_translation.hash_code;
			adopted_trans := eif_adopt (translation_string);
		ensure
			set: a_translation = translation_string
		end;

	make_no_adopted (a_translation: STRING)
			-- Create a mel_translation from `a_translation'
			-- but do not adopt the string
		do
			type := translation_type;
			translation_string := a_translation;
			hash_code := a_translation.hash_code
		ensure
			set: a_translation = translation_string
		end;

feature -- Access

	translation_string: STRING;
			-- Translation string
	
feature -- Comparison

	is_equal (other: like Current): BOOLEAN
			-- Is `other' translation_string equal to Current?
		local
			a: like Current
		do
			a ?= other
			if a /= Void then
				Result := type = a.type and then 
					translation_string.is_equal (a.translation_string)
			end
		end;

feature -- Output

	out: STRING
		do
			Result := translation_string.out
		end;

feature {MEL_WIDGET} -- Access

	xt_translation_string: STRING
			-- Translation string to be passed out
			-- to XtOverrideTranslations that will execute
			-- the callback with arguments
		do
			create Result.make (0)
			Result.append (translation_string);
			Result.append (": ");
			Result.append (external_routine_name);
			Result.extend ('(');
			Result.append (adopted_trans.out)
			Result.append (")%N");
		end;

	xt_translation_null_string: STRING
			-- An Translation string to be passed out
			-- to XtOverrideTranslations that will execute
			-- the callback with no arguments
		do
			create Result.make (0);
			Result.append (translation_string)
			Result.append (": ");
			Result.append (external_routine_name);
			Result.extend ('(');
			Result.append (")%N");
		end;

feature {MEL_DISPATCHER} -- Removal

	dispose
			-- Dispose the adopted translation.
		do
			if adopted_trans /= default_pointer then
				eif_wean (adopted_trans);
				adopted_trans := default_pointer
			end
		end;

feature {NONE} -- Implementation

	adopted_trans: POINTER;
			-- Translation adopted object

	external_routine_name: STRING
			-- External routine name for handling
			-- translations
		do
			create Result.make (0);
			Result.from_c (c_trans_name)
		end;

feature {NONE} -- External features

	eif_wean (obj: POINTER)
			-- eif_wean object `obj'.
		external
			"C [macro %"eif_macros.h%"]"
		alias
			"eif_wean"
		end

	eif_adopt (obj: ANY): POINTER
			-- Adopt object `obj'
		external
			"C [macro %"eif_macros.h%"]"
		alias
			"eif_adopt"
		end;

	c_trans_name: POINTER
			-- Adopt object `obj'
		external
			"C [macro %"mel.h%"]"
		alias
			"c_trans_routine"
		end;

invariant

	non_void_translation: translation_string /= Void

note
	copyright:	"Copyright (c) 1984-2006, Eiffel Software and others"
	license:	"Eiffel Forum License v2 (see http://www.eiffel.com/licensing/forum.txt)"
	source: "[
			 Eiffel Software
			 356 Storke Road, Goleta, CA 93117 USA
			 Telephone 805-685-1006, Fax 805-685-6869
			 Website http://www.eiffel.com
			 Customer support http://support.eiffel.com
		]"




end -- class MEL_TRANSLATION


