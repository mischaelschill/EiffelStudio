note
	description: "[
		An initialization provider to initialize all services used by the Eiffel Compiler.
	]"
	legal: "See notice at end of class."
	status: "See notice at end of class.";
	date: "$Date$";
	revision: "$Revision$"

class
	SERVICE_INITIALIZER

feature -- Services

	add_core_services (a_container: !SERVICE_CONTAINER_S)
			-- Adds all the core services.
			--
			-- `a_container': The service container to add services to.
		do
			a_container.register_with_activator ({EVENT_LIST_S}, agent create_event_list_service, False)
			a_container.register_with_activator ({LOGGER_S}, agent create_logger_service, False)
			a_container.register_with_activator ({SESSION_MANAGER_S}, agent create_session_manager_service, False)
			a_container.register_with_activator ({TEST_SUITE_S}, agent create_testing_service, False)
		end

feature {NONE} -- Factory

	create_event_list_service: ?EVENT_LIST_S
			-- Creates the event list service.
		do
			create {EVENT_LIST} Result.make
		ensure
			result_is_interface_usable: Result /= Void implies Result.is_interface_usable
		end

	create_logger_service: ?LOGGER_S
			-- Creates the logger service.
		do
			create {LOGGER} Result.make
		ensure
			result_is_interface_usable: Result /= Void implies Result.is_interface_usable
		end

	create_session_manager_service: ?SESSION_MANAGER_S
			-- Creates the session manager service.
		do
			create {SESSION_MANAGER} Result
		ensure
			result_is_interface_usable: Result /= Void implies Result.is_interface_usable
		end

	create_testing_service: ?TEST_SUITE_S
			-- Create test suite service
		do
			create {TEST_SUITE} Result.make (create {TEST_PROJECT_HELPER})
			register_test_suite_processors (Result)
		ensure
			result_not_void_implies_usable: Result /= Void implies Result.is_interface_usable
		end

feature {NONE} -- Test suite extension

	register_test_suite_processors (a_service: !TEST_SUITE_S)
			-- Register standard test processors for test suite service.
			--
			-- `a_service': Service in which test processors are registered.
		require
			a_service_usable: a_service.is_interface_usable
		local
			a_registrar: TEST_PROCESSOR_REGISTRAR_I
		do
			a_registrar := a_service.processor_registrar
			a_registrar.register (create {TEST_BACKGROUND_EXECUTOR}.make (a_service))
			a_registrar.register (create {TEST_DEBUG_EXECUTOR}.make (a_service))
			a_registrar.register (create {TEST_MANUAL_CREATOR}.make (a_service))
			a_registrar.register (create {TEST_EXTRACTOR}.make (a_service))
			a_registrar.register (create {TEST_GENERATOR}.make (a_service))
		end

;note
	copyright: "Copyright (c) 1984-2008, Eiffel Software"
	license:   "GPL version 2 (see http://www.eiffel.com/licensing/gpl.txt)"
	licensing_options: "http://www.eiffel.com/licensing"
	copying: "[
			This file is part of Eiffel Software's Eiffel Development Environment.
			
			Eiffel Software's Eiffel Development Environment is free
			software; you can redistribute it and/or modify it under
			the terms of the GNU General Public License as published
			by the Free Software Foundation, version 2 of the License
			(available at the URL listed under "license" above).
			
			Eiffel Software's Eiffel Development Environment is
			distributed in the hope that it will be useful, but
			WITHOUT ANY WARRANTY; without even the implied warranty
			of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
			See the GNU General Public License for more details.
			
			You should have received a copy of the GNU General Public
			License along with Eiffel Software's Eiffel Development
			Environment; if not, write to the Free Software Foundation,
			Inc., 51 Franklin St, Fifth Floor, Boston, MA 02110-1301 USA
		]"
	source: "[
			 Eiffel Software
			 5949 Hollister Ave., Goleta, CA 93117 USA
			 Telephone 805-685-1006, Fax 805-685-6869
			 Website http://www.eiffel.com
			 Customer support http://support.eiffel.com
		]"

end
