note
	description: "Windows Registry preferences storage implementation."
	legal: "See notice at end of class."
	status: "See notice at end of class."

class
	PREFERENCES_STORAGE_REGISTRY

inherit
	PREFERENCES_STORAGE_I
		redefine
			initialize_with_preferences
		end

	WEL_REGISTRY

create
	make_empty,
	make_with_location

feature {PREFERENCES} -- Initialization

	make_empty
			-- Create preferences storage in the registry.  Registry key created base on name of application
			-- in `HKEY_CURRENT_USER\Software\'.  So location will be `HKEY_CURRENT_USER\Software\APPLICATION_NAME_HERE'
		local
			l_loc: STRING_32
			l_exec: EXECUTION_ENVIRONMENT
			l_path: PATH
		do
			create l_exec
			create l_loc.make_from_string_general ("HKEY_CURRENT_USER\Software\")
			create l_path.make_from_string (l_exec.arguments.command_name)
			if attached l_path.entry as l_entry then
				l_loc.append_string (l_entry.name)
				l_loc.append_string_general ("\")
			else
					-- Very unlikely there will be no name, but who knows.
				l_loc.append_string_general ("EiffelDefaultApplication\")
			end
			make_with_location (l_loc)
		end

feature {PREFERENCES} -- Initialization

	initialize_with_preferences (a_preferences: PREFERENCES)
	   	local
			l_keyp: POINTER
			l_name: STRING_32
			l_value: detachable STRING_32
			l_key_values: LINKED_LIST [STRING_32]
		do
			Precursor (a_preferences)

			l_keyp := open_key_with_access (location, key_read)
			if l_keyp /= default_pointer then
				l_key_values := enumerate_values (l_keyp)
				if not l_key_values.is_empty then
					from
						l_key_values.start
					until
						l_key_values.after
					loop
						l_name := l_key_values.item.to_string_8 -- FIXME: preference does not support unicode pref name
						if attached key_value (l_keyp, l_name) as l_key_value then
							l_value := l_key_value.string_value
							if l_name.has ('_') then
								l_name := l_name.substring (l_name.index_of ('_', 1) + 1, l_name.count)
							end
							if not session_values.has (l_name) then
								session_values.put (l_value, l_name)
							end
						else
							check key_value_exists: False end
						end
						l_key_values.forth
					end
				end
				close_key (l_keyp)
			end
		end

feature {PREFERENCES} -- Resource Management

	exists: BOOLEAN
			-- Does storage exists ?
		do
			Result := True
				--| Registry exists by default on Windows
				--| If the related key did not exists,
				--|   `initialize_with_preferences' created it anyway
		end

	has_preference (a_name: READABLE_STRING_GENERAL): BOOLEAN
			-- Does the underlying store contain a preference with `a_name'?
		do
			Result := get_preference_value (a_name) /= Void
		end

	get_preference_value (a_name: READABLE_STRING_GENERAL): detachable STRING_32
			-- Retrieve the preference string value from the underlying store.
		local
			l_handle: POINTER
		do
			l_handle := open_key_with_access (location, Key_read)

			if valid_value_for_hkey (l_handle) then
				if attached key_value (l_handle, a_name) as l_key_value then
					Result := l_key_value.string_value
				end
				close_key (l_handle)
			end
		end

	save_preference (a_preference: PREFERENCE)
			-- Save `a_preference' to registry.
		local
			l_parent_key: POINTER
			l_new_value: WEL_REGISTRY_KEY_VALUE
			l_registry_preference_name: STRING
		do
			l_parent_key := open_key_with_access (location, key_write)
			if not  valid_value_for_hkey (l_parent_key) then
				create_new_key (location)
				l_parent_key := open_key_with_access (location, key_write)
			end
			if valid_value_for_hkey (l_parent_key) then
				l_registry_preference_name := a_preference.string_type + "_" + a_preference.name
				create l_new_value.make ({WEL_REGISTRY_KEY_VALUE_TYPE}.reg_sz, a_preference.text_value)
				set_key_value (l_parent_key, l_registry_preference_name, l_new_value)
				close_key (l_parent_key)
			end
		end

	remove_preference (a_preference: PREFERENCE)
			-- Remove `preference' from storage device.
		local
			l_parent_key: POINTER
			l_registry_preference_name: STRING
		do
			l_parent_key := open_key_with_access (location, key_write)
			if not  valid_value_for_hkey (l_parent_key) then
				create_new_key (location)
				l_parent_key := open_key_with_access (location, key_write)
			end
			if valid_value_for_hkey (l_parent_key) then
				l_registry_preference_name := a_preference.string_type + "_" + a_preference.name
				delete_value (l_parent_key, l_registry_preference_name)
				close_key (l_parent_key)
			end
		end

invariant
	has_session_values: session_values /= Void

note
	copyright:	"Copyright (c) 1984-2012, Eiffel Software and others"
	license:	"Eiffel Forum License v2 (see http://www.eiffel.com/licensing/forum.txt)"
	source: "[
			Eiffel Software
			5949 Hollister Ave., Goleta, CA 93117 USA
			Telephone 805-685-1006, Fax 805-685-6869
			Website http://www.eiffel.com
			Customer support http://support.eiffel.com
		]"




end
