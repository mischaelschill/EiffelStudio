indexing
	description	: "COMPARABLE_CONSUMED_PROCEDURE with comparaison on feature dotnet_name"
	author		: "Generated by the New Vision2 Application Wizard."
	date		: "$Date$"
	revision	: "1.0.0"

class
	COMPARABLE_CONSUMED_PROCEDURE

inherit
	CONSUMED_FUNCTION
	
	COMPARABLE
		undefine
			default_create, is_equal, copy
		end

create
	make_with_consumed_procedure
	
feature -- Initialization
	
	make_with_consumed_procedure (a_consumed_procedure: CONSUMED_PROCEDURE) is
		require
			non_void_a_consumed_procedure: a_consumed_procedure /= Void
		do
			eiffel_name := a_consumed_procedure.eiffel_name
			dotnet_name := a_consumed_procedure.dotnet_name
			arguments := a_consumed_procedure.arguments
			declared_type := a_consumed_procedure.declared_type
			return_type := a_consumed_procedure.return_type
		ensure
			eiffel_name_set: eiffel_name = a_consumed_procedure.eiffel_name
			dotnet_name_set: dotnet_name = a_consumed_procedure.dotnet_name
			arguments_set: arguments = a_consumed_procedure.arguments
			declared_type_set: declared_type = a_consumed_procedure.declared_type
			return_type_set: return_type = a_consumed_procedure.return_type
		end

feature -- Implementation
	
	infix "<" (other: like Current): BOOLEAN is
			-- Is current object less than `other'?
		do
			Result := dotnet_name < other.dotnet_name
		end

end -- class COMPARABLE_CONSUMED_PROCEDURE
