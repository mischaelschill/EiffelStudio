indexing
	description: "Eiffel Class Descriptor.  Help file: "
	Note: "Automatically generated by the EiffelCOM Wizard."

deferred class
	IEIFFEL_CLASS_DESCRIPTOR_INTERFACE

inherit
	ECOM_INTERFACE

feature -- Status Report

	name_user_precondition: BOOLEAN is
			-- User-defined preconditions for `name'.
			-- Redefine in descendants if needed.
		do
			Result := True
		end

	description_user_precondition: BOOLEAN is
			-- User-defined preconditions for `description'.
			-- Redefine in descendants if needed.
		do
			Result := True
		end

	external_name_user_precondition: BOOLEAN is
			-- User-defined preconditions for `external_name'.
			-- Redefine in descendants if needed.
		do
			Result := True
		end

	feature_names_user_precondition: BOOLEAN is
			-- User-defined preconditions for `feature_names'.
			-- Redefine in descendants if needed.
		do
			Result := True
		end

	features_user_precondition: BOOLEAN is
			-- User-defined preconditions for `features'.
			-- Redefine in descendants if needed.
		do
			Result := True
		end

	feature_count_user_precondition: BOOLEAN is
			-- User-defined preconditions for `feature_count'.
			-- Redefine in descendants if needed.
		do
			Result := True
		end

	flat_features_user_precondition: BOOLEAN is
			-- User-defined preconditions for `flat_features'.
			-- Redefine in descendants if needed.
		do
			Result := True
		end

	flat_feature_count_user_precondition: BOOLEAN is
			-- User-defined preconditions for `flat_feature_count'.
			-- Redefine in descendants if needed.
		do
			Result := True
		end

	clients_user_precondition: BOOLEAN is
			-- User-defined preconditions for `clients'.
			-- Redefine in descendants if needed.
		do
			Result := True
		end

	client_count_user_precondition: BOOLEAN is
			-- User-defined preconditions for `client_count'.
			-- Redefine in descendants if needed.
		do
			Result := True
		end

	suppliers_user_precondition: BOOLEAN is
			-- User-defined preconditions for `suppliers'.
			-- Redefine in descendants if needed.
		do
			Result := True
		end

	supplier_count_user_precondition: BOOLEAN is
			-- User-defined preconditions for `supplier_count'.
			-- Redefine in descendants if needed.
		do
			Result := True
		end

	ancestors_user_precondition: BOOLEAN is
			-- User-defined preconditions for `ancestors'.
			-- Redefine in descendants if needed.
		do
			Result := True
		end

	ancestor_count_user_precondition: BOOLEAN is
			-- User-defined preconditions for `ancestor_count'.
			-- Redefine in descendants if needed.
		do
			Result := True
		end

	descendants_user_precondition: BOOLEAN is
			-- User-defined preconditions for `descendants'.
			-- Redefine in descendants if needed.
		do
			Result := True
		end

	descendant_count_user_precondition: BOOLEAN is
			-- User-defined preconditions for `descendant_count'.
			-- Redefine in descendants if needed.
		do
			Result := True
		end

	class_path_user_precondition: BOOLEAN is
			-- User-defined preconditions for `class_path'.
			-- Redefine in descendants if needed.
		do
			Result := True
		end

	is_deferred_user_precondition: BOOLEAN is
			-- User-defined preconditions for `is_deferred'.
			-- Redefine in descendants if needed.
		do
			Result := True
		end

	is_external_user_precondition: BOOLEAN is
			-- User-defined preconditions for `is_external'.
			-- Redefine in descendants if needed.
		do
			Result := True
		end

	is_generic_user_precondition: BOOLEAN is
			-- User-defined preconditions for `is_generic'.
			-- Redefine in descendants if needed.
		do
			Result := True
		end

feature -- Basic Operations

	name: STRING is
			-- Class name.
		require
			name_user_precondition: name_user_precondition
		deferred

		end

	description: STRING is
			-- Class description.
		require
			description_user_precondition: description_user_precondition
		deferred

		end

	external_name: STRING is
			-- Class external name.
		require
			external_name_user_precondition: external_name_user_precondition
		deferred

		end

	feature_names: ECOM_ARRAY [STRING] is
			-- List of names of class features.
		require
			feature_names_user_precondition: feature_names_user_precondition
		deferred

		end

	features: ECOM_VARIANT is
			-- List of class features.
		require
			features_user_precondition: features_user_precondition
		deferred

		ensure
			valid_features: Result.item /= default_pointer
		end

	feature_count: INTEGER is
			-- Number of class features.
		require
			feature_count_user_precondition: feature_count_user_precondition
		deferred

		end

	flat_features: ECOM_VARIANT is
			-- List of class features including ancestor features.
		require
			flat_features_user_precondition: flat_features_user_precondition
		deferred

		ensure
			valid_flat_features: Result.item /= default_pointer
		end

	flat_feature_count: INTEGER is
			-- Number of flat class features.
		require
			flat_feature_count_user_precondition: flat_feature_count_user_precondition
		deferred

		end

	clients: ECOM_VARIANT is
			-- List of class clients.
		require
			clients_user_precondition: clients_user_precondition
		deferred

		ensure
			valid_clients: Result.item /= default_pointer
		end

	client_count: INTEGER is
			-- Number of class clients.
		require
			client_count_user_precondition: client_count_user_precondition
		deferred

		end

	suppliers: ECOM_VARIANT is
			-- List of class suppliers.
		require
			suppliers_user_precondition: suppliers_user_precondition
		deferred

		ensure
			valid_suppliers: Result.item /= default_pointer
		end

	supplier_count: INTEGER is
			-- Number of class suppliers.
		require
			supplier_count_user_precondition: supplier_count_user_precondition
		deferred

		end

	ancestors: ECOM_VARIANT is
			-- List of direct ancestors of class.
		require
			ancestors_user_precondition: ancestors_user_precondition
		deferred

		ensure
			valid_ancestors: Result.item /= default_pointer
		end

	ancestor_count: INTEGER is
			-- Number of direct ancestors.
		require
			ancestor_count_user_precondition: ancestor_count_user_precondition
		deferred

		end

	descendants: ECOM_VARIANT is
			-- List of direct descendants of class.
		require
			descendants_user_precondition: descendants_user_precondition
		deferred

		ensure
			valid_descendants: Result.item /= default_pointer
		end

	descendant_count: INTEGER is
			-- Number of direct descendants.
		require
			descendant_count_user_precondition: descendant_count_user_precondition
		deferred

		end

	class_path: STRING is
			-- Full path to file.
		require
			class_path_user_precondition: class_path_user_precondition
		deferred

		end

	is_deferred: BOOLEAN is
			-- Is class deferred?
		require
			is_deferred_user_precondition: is_deferred_user_precondition
		deferred

		end

	is_external: BOOLEAN is
			-- Is class external?
		require
			is_external_user_precondition: is_external_user_precondition
		deferred

		end

	is_generic: BOOLEAN is
			-- Is class generic?
		require
			is_generic_user_precondition: is_generic_user_precondition
		deferred

		end

end -- IEIFFEL_CLASS_DESCRIPTOR_INTERFACE

