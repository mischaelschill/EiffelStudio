class
	DOUBLE_I

inherit
	BASIC_I
		redefine
			dump,
			is_double,
			is_numeric,
			same_as, element_type, il_convert_from,
			description, sk_value, generate_cecil_value, hash_code,
			generate_byte_code_cast, generated_id, typecode
		end

	BYTE_CONST
		export
			{NONE} all
		end
		
	SHARED_IL_CODE_GENERATOR
		export
			{NONE} all
		end

feature -- Status report

	element_type: INTEGER_8 is
			-- Pointer element type
		do
			Result := feature {MD_SIGNATURE_CONSTANTS}.Element_type_r8
		end

feature

	level: INTEGER is
			-- Internal code for generation
		do
			Result := C_double
		end

	typecode: INTEGER is
			-- Typecode for TUPLE element.
		do
			Result := feature {SHARED_TYPECODE}.double_code
		end

	generate_byte_code_cast (ba: BYTE_ARRAY) is
			-- Code for interpreter cast
		do
			ba.append (Bc_cast_double)
		end

	is_double: BOOLEAN is True
			-- Is the type a double type ?

	is_numeric: BOOLEAN is True
			-- Is the type a numeric one ?

	same_as (other: TYPE_I): BOOLEAN is
			-- Is `other' equal to Current ?
		do
			Result := other.is_double
		end

	dump (buffer: GENERATION_BUFFER) is
			-- Debug purpose
		do
			buffer.putstring ("EIF_DOUBLE")
		end

	description: DOUBLE_DESC is
			-- Type description for skeleton
		do
			!!Result
		end

	generate_cecil_value (buffer: GENERATION_BUFFER) is
			-- Generate Cecil type value.
		do
			buffer.putstring ("SK_DOUBLE")
		end

	c_string: STRING is "EIF_DOUBLE"
			-- String generated for the type.
			
	c_string_id: INTEGER is
			-- String ID generated for Current
		once
			Result := Names_heap.eif_double_name_id
		end
		
	union_tag: STRING is "darg"

	separate_get_macro: STRING is "CURGD"
			-- String generated to access the argument to a separate call

	separate_send_macro: STRING is "CURSQRD"
			-- String generated to return the result of a separate call

	hash_code: INTEGER is
			-- Hash code for current type
		once
			Result := Double_code
		end

	associated_reference: CLASS_TYPE is
			-- Reference class associated with simple type
		do
			Result := system.double_ref_class.compiled_class.types.first
		end

	sk_value: INTEGER is
			-- Generate SK value associated to the current type.
		do
			Result := Sk_double
		end

	generate_union (buffer: GENERATION_BUFFER) is
			-- Generate discriminant of C structure "item" associated
			-- to the current C type in `buffer'.
		do
			buffer.putstring ("it_double")
		end

	generate_sk_value (buffer: GENERATION_BUFFER) is
			-- Generate SK value associated to current C type in `buffer'.
		do
			buffer.putstring ("SK_DOUBLE")
		end

	type_a: DOUBLE_A is
		do
			!! Result
		end

feature -- Generic conformance

	generated_id (final_mode : BOOLEAN) : INTEGER is

		do
			Result := Double_type
		end

feature -- IL code generation

	il_convert_from (source: TYPE_I) is
			-- Generate convertion from Current to `source' if needed.
		do
			if not source.is_double then
				il_generator.convert_to (Current)
			end
		end

feature

	make_basic_creation_byte_code (ba : BYTE_ARRAY) is

		do
			ba.append (Bc_double)
			ba.append_real (0.0)
		end 

end
