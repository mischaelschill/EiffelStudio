indexing
	description: "Source interface Eiffel client generator."
	status: "See notice at end of class";
	date: "$Date$"
	revision: "$Revision$"

class
	WIZARD_SOURCE_INTERFACE_EIFFEL_CLIENT_GENERATOR

inherit
	WIZARD_SOURCE_INTERFACE_CLIENT_GENERATOR

	WIZARD_WRITER_FEATURE_CLAUSES
		export
			{NONE} all
		end

create
	generate

feature -- Initialization

	generate (a_interface: WIZARD_INTERFACE_DESCRIPTOR; a_coclass: WIZARD_COCLASS_DESCRIPTOR; a_eiffel_writer: WIZARD_WRITER_EIFFEL_CLASS) is
			-- Initialize
		do
			a_eiffel_writer.add_feature (enable_feature (a_interface), Basic_operations)
			a_eiffel_writer.add_feature (disable_feature (a_interface), Basic_operations)
			a_eiffel_writer.add_feature (boolean_feature (a_interface), Access)
			a_eiffel_writer.add_feature (external_enable_feature (a_interface, a_coclass), Externals)
			a_eiffel_writer.add_feature (external_disable_feature (a_interface, a_coclass), Externals)
		end

feature -- Basic operations

	enable_feature (a_interface: WIZARD_INTERFACE_DESCRIPTOR): WIZARD_WRITER_FEATURE is
			-- `enable_call_back_on_...' feature.
		require
			non_void_interface: a_interface /= Void
			non_void_interface_name: a_interface.name /= Void
			valid_interface_name: not a_interface.name.is_empty
		local
			l_precondition_body, l_body: STRING
			l_argument: STRING
			l_precondition, l_postcondition: WIZARD_WRITER_ASSERTION
		do
			create Result.make
			Result.set_effective
			Result.set_name (enable_feature_name (a_interface))
			Result.set_comment ("Enable call back.")

			create l_argument.make (100)
			l_argument.append ("some_events: ")
			l_argument.append (a_interface.implemented_interface.impl_eiffel_class_name (False))
			Result.add_argument (l_argument)

			create l_precondition_body.make (100)
			l_precondition_body.append ("not ")
			l_precondition_body.append (boolean_name (a_interface))
			create l_precondition.make ("disabled", l_precondition_body)
			Result.add_precondition (l_precondition)
			create l_precondition.make ("non_void_events", "some_events /= Void")
			Result.add_precondition (l_precondition)

			create l_postcondition.make ("enabled", boolean_name (a_interface))
			Result.add_postcondition (l_postcondition)

			create l_body.make (1000)
			l_body.append ("%T%T%T")
			l_body.append ("if (some_events.item = default_pointer) then")
			l_body.append ("%R%N%T%T%T%T")
			l_body.append ("some_events.create_item")
			l_body.append ("%R%N%T%T%Tend%R%N%T%T%T")
			l_body.append (external_feature_name (enable_feature_name (a_interface)))
			l_body.append (" (initializer, ")
			l_body.append ("some_events.item)")
			l_body.append ("%R%N%T%T%T")
			l_body.append (boolean_name (a_interface))
			l_body.append (" := True")
			Result.set_body (l_body)
		ensure
			non_void_feature: Result /= Void
			valid_feature: Result.can_generate
		end

	disable_feature (a_interface: WIZARD_INTERFACE_DESCRIPTOR): WIZARD_WRITER_FEATURE is
			-- `disable_call_back_on_...' feature.
		require
			non_void_interface: a_interface /= Void
			non_void_interface_name: a_interface.name /= Void
			valid_interface_name: not a_interface.name.is_empty
		local
			l_postcondition_body, l_body: STRING
			l_precondition, l_postcondition: WIZARD_WRITER_ASSERTION
		do
			create Result.make
			Result.set_effective

			Result.set_name (disable_feature_name (a_interface))

			Result.set_comment ("Disable call back.")

			create l_precondition.make ("enabled", boolean_name (a_interface))
			Result.add_precondition (l_precondition)

			create l_postcondition_body.make (100)
			l_postcondition_body.append ("not ")
			l_postcondition_body.append (boolean_name (a_interface))
			create l_postcondition.make ("disabled", l_postcondition_body)
			Result.add_postcondition (l_postcondition)

			create l_body.make (1000)
			l_body.append ("%T%T%T")
			l_body.append (external_feature_name (disable_feature_name (a_interface)))
			l_body.append (" (initializer)%R%N%T%T%T")
			l_body.append (boolean_name (a_interface))
			l_body.append (" := False")
			Result.set_body (l_body)
		ensure
			non_void_feature: Result /= Void
			valid_feature: Result.can_generate
		end

	boolean_feature (a_interface: WIZARD_INTERFACE_DESCRIPTOR): WIZARD_WRITER_FEATURE is
			-- Boolean feature.
		require
			non_void_interface: a_interface /= Void
			non_void_interface_name: a_interface.name /= Void
			valid_interface_name: not a_interface.name.is_empty
		do
			create Result.make
			Result.set_attribute
			
			Result.set_name (boolean_name (a_interface))
			Result.set_comment ("Is call back enabled?")

			Result.set_result_type (Boolean_type)
		ensure
			non_void_feature: Result /= Void
			valid_feature: Result.can_generate
		end

	boolean_name (a_interface: WIZARD_INTERFACE_DESCRIPTOR): STRING is
			-- Name of call back boolean.
		require
			non_void_interface: a_interface /= Void
			non_void_interface_name: a_interface.name /= Void
			valid_interface_name: not a_interface.name.is_empty
		do
			create Result.make (100)
			Result.append ("call_back_on_")
			Result.append (name_for_feature (a_interface.name))
			Result.append ("_enabled")
		ensure
			non_void_name: Result /= Void
			valid_name: not Result.is_empty
		end

	external_enable_feature (a_interface: WIZARD_INTERFACE_DESCRIPTOR; a_coclass: WIZARD_COCLASS_DESCRIPTOR): WIZARD_WRITER_FEATURE is
			-- External enable call back eature.
		require
			non_void_interface: a_interface /= Void
			non_void_interface_name: a_interface.name /= Void
			valid_interface_name: not a_interface.name.is_empty
			non_void_coclass: a_coclass /= Void
			non_void_coclass_c_type_name: a_coclass.c_type_name /= Void
			valid_coclass_c_type_name: not a_coclass.c_type_name.is_empty
			non_void_coclass_header_file_name: a_coclass.c_definition_header_file_name /= Void
			valid_coclass_header_file_name: not a_coclass.c_definition_header_file_name.is_empty
		local
			l_body: STRING
		do
			create Result.make
			Result.set_external
			
			Result.set_name (external_feature_name (enable_feature_name (a_interface)))
			Result.set_comment ("Enable call back.")

			Result.add_argument (default_pointer_argument)
			Result.add_argument ("an_interface_pointer: POINTER")
			
			create l_body.make (100)
			l_body.append ("%T%T%T%"C++ [")
			if a_coclass.namespace /= Void and then not a_coclass.namespace.is_empty then
				l_body.append (a_coclass.namespace)
				l_body.append ("::")
			end
			l_body.append (a_coclass.c_type_name)
			l_body.append (" %%%"")
			l_body.append (a_coclass.c_definition_header_file_name)
			l_body.append ("%%%"](EIF_POINTER)%"")			
			Result.set_body (l_body)
		ensure
			non_void_feature: Result /= Void
			valid_feature: Result.can_generate
		end
	
	external_disable_feature (a_interface: WIZARD_INTERFACE_DESCRIPTOR; a_coclass: WIZARD_COCLASS_DESCRIPTOR): WIZARD_WRITER_FEATURE is
			-- External disable call back feature.
		require
			non_void_interface: a_interface /= Void
			non_void_interface_name: a_interface.name /= Void
			valid_interface_name: not a_interface.name.is_empty
			non_void_coclass: a_coclass /= Void
			non_void_coclass_c_type_name: a_coclass.c_type_name /= Void
			valid_coclass_c_type_name: not a_coclass.c_type_name.is_empty
			non_void_coclass_header_file_name: a_coclass.c_definition_header_file_name /= Void
			valid_coclass_header_file_name: not a_coclass.c_definition_header_file_name.is_empty
		local
			l_body: STRING
		do
			create Result.make
			Result.set_external
			
			Result.set_name (external_feature_name (disable_feature_name (a_interface)))
			Result.set_comment ("Disable call back.")
			
			Result.add_argument (default_pointer_argument)
			
			create l_body.make (100)
			l_body.append ("%T%T%T%"C++ [")
			if a_coclass.namespace /= Void and then not a_coclass.namespace.is_empty then
				l_body.append (a_coclass.namespace)
				l_body.append ("::")
			end
			l_body.append (a_coclass.c_type_name)
			l_body.append (" %%%"")
			l_body.append (a_coclass.c_definition_header_file_name)
			l_body.append ("%%%"]()%"")			
			Result.set_body (l_body)
		ensure
			non_void_feature: Result /= Void
			valid_feature: Result.can_generate
		end

end -- class WIZARD_SOURCE_INTERFACE_EIFFEL_CLIENT_GENERATOR

--+----------------------------------------------------------------
--| EiffelCOM Wizard
--| Copyright (C) 1999-2005 Eiffel Software. All rights reserved.
--| Eiffel Software Confidential
--| Duplication and distribution prohibited.
--|
--| Eiffel Software
--| 356 Storke Road, Goleta, CA 93117 USA
--| http://www.eiffel.com
--+----------------------------------------------------------------

