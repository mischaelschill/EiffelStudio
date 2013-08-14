note
	description: "Storage of EIS, access to servers"
	status: "See notice at end of class."
	legal: "See notice at end of class."
	date: "$Date$"
	revision: "$Revision$"

class
	EIS_STORAGE

inherit
	ES_EIS_STORAGE_OBSERVER_MANAGER
		rename
			make as make_observer_manager
		end

	EB_SHARED_ID_SOLUTION
		export
			{NONE} all
		end

	EIFFEL_LAYOUT
		export
			{NONE} all
		end

	PROJECT_CONTEXT
		export
			{NONE} all
		end

	ES_EIS_SHARED
		export
			{NONE} all
		end

create
	make

feature {NONE} -- Initialization

	make
			-- Initialization
		do
			create internal_tag_server
			create internal_entry_server
			create internal_date_server.make (10)
			create internal_fingerprint_server.make (10)
			create internal_acknowledge_server.make (10)
			create internal_change_server.make (10)
			make_observer_manager
		end

feature -- Retrieve and save

	retrieve_from_file
			-- Retrieve storage from file	
		local
			l_file: RAW_FILE
			l_facility: SED_STORABLE_FACILITIES
			l_reader: SED_MEDIUM_READER_WRITER
			l_retried: BOOLEAN
		do
			if not l_retried then
				create l_file.make_with_path (storage_file_name)
				if l_file.exists then
					l_file.open_read
					create l_reader.make (l_file)
					l_reader.set_for_reading
					create l_facility
					if attached {like type_to_store} l_facility.retrieved (l_reader, True) as l_tuple then
						internal_tag_server := l_tuple.tag_server
						internal_entry_server := l_tuple.entry_server
						internal_date_server := l_tuple.date_server
						internal_fingerprint_server := l_tuple.fingerprint_server
						internal_acknowledge_server := l_tuple.acknowledge_server
						internal_change_server := l_tuple.change_server
						save_needed := False
					end
				end
				if not l_file.is_closed then
					l_file.close
				end
			end
		rescue
			save_needed := True
			l_retried := True
			if l_file /= Void and not l_file.is_closed then
				l_file.close
			end
		end

	save_to_file
			-- Save storage to file when needed.
		local
			l_tuple: like type_to_store
			l_file: RAW_FILE
			l_facility: SED_STORABLE_FACILITIES
			l_writer: SED_MEDIUM_READER_WRITER
			l_retried: BOOLEAN
		do
			if not l_retried and then save_needed then
				clean_up
				l_tuple := [tag_server, entry_server, date_server, fingerprint_server, acknowledge_server, change_server]
				create l_file.make_with_path (storage_file_name)
				l_file.create_read_write
				create l_writer.make (l_file)
				create l_facility
				l_facility.store (l_tuple, l_writer)
				l_file.close
				save_needed := False
			end
		rescue
			save_needed := True
			l_retried := True
			if l_file /= Void and not l_file.is_closed then
				l_file.close
			end
		end

feature -- Element change

	register_entry (a_entry: EIS_ENTRY; a_component_id: STRING; a_date: INTEGER)
			-- Register an entry from the storage
			-- Syncronize servers
			-- `a_component_id' is the class EIS id when `a_entry' is written in a feature
		require
			a_entry_attached: a_entry /= Void
			a_component_id_attached: a_component_id /= Void
			has_date: a_date /= 0
		do
			register_entry_with_fingerprint (a_entry, a_component_id, a_date, True)
		end

	deregister_entry (a_entry: EIS_ENTRY; a_component_id: STRING)
			-- Deregister an entry from the storage
			-- Syncronize servers
			-- `a_component_id' is the class EIS id when `a_entry' is written in a feature
		require
			a_entry_attached: a_entry /= Void
			a_component_id_attached: a_component_id /= Void
		local
			l_tags: ARRAYED_LIST [STRING_32]
			l_entries: SEARCH_TABLE [EIS_ENTRY]
		do
			if entry_server.deregister_entry (a_entry, a_component_id) then
					-- Syncronize tag server
				if (attached a_entry.tags as lt_tags) and then not lt_tags.is_empty then
					l_tags := lt_tags.twin
					from
						l_tags.start
					until
						l_tags.after
					loop
						if (attached l_tags.item as lt_tag) and then not lt_tag.is_empty then
							if tag_server.deregister_entry (a_entry, lt_tag) then
								l_entries := tag_server.entries_of_id (lt_tag)
								if l_entries = Void or else l_entries.is_empty then
									on_tag_removed (lt_tag)
								end
							end
						end
						l_tags.forth
					end
				else
						-- Deregister entry without tag with empty string.
					if tag_server.deregister_entry (a_entry, create {STRING_32}.make_empty) then
						-- Do nothing
					end
				end

					-- No need to syncronize the date server.

					-- Inform observers.
				on_entry_deregistered (a_entry, a_component_id)

				save_needed := True
			end
		end

	register_entries_of_component_id (a_entries: SEARCH_TABLE [EIS_ENTRY]; a_component_id: STRING; a_date: INTEGER)
			-- Deregister entries of `a_component_id'.
			-- Syncronize servers
		require
			a_entries_attached: a_entries /= Void
			a_component_id_attached: a_component_id /= Void
			has_date: a_date /= 0
		local
			l_entry: detachable EIS_ENTRY
		do
				-- We need to correctly remove old entries first, and sync tag server.
			deregister_entries_of_component_id (a_component_id)
				-- Start registration.

			from
				a_entries.start
			until
				a_entries.after
			loop
				l_entry := a_entries.item_for_iteration
				check l_entry_not_void: l_entry /= Void end
					-- We do not update the target fingerprint at the moment,
					-- in order to track all changes of the entries of the given target.
				register_entry_with_fingerprint (l_entry, a_component_id, a_date, False)
				a_entries.forth
			end

				-- Process the last entry to update entry fingerprint now.
			if l_entry /= Void then
				process_fingerprints_for_entry (l_entry, True)
			end

				-- We still keep the information that the target does not contain any entry.
			if a_entries.is_empty then
				entry_server.register_component (a_component_id)
			end
				-- We still keep date of the target.
			if a_entries.is_empty then
				date_server.search (a_component_id)
				if date_server.found then
					date_server.replace (a_date, a_component_id)
				else
					date_server.put (a_date, a_component_id)
				end
			end
		end

	deregister_entries_of_component_id (a_component_id: STRING)
			-- Deregister entries of `a_component_id'.
			-- Syncronize servers
		require
			a_component_id_attached: a_component_id /= Void
		local
			l_entries: SEARCH_TABLE [EIS_ENTRY]
			l_entry: detachable EIS_ENTRY
		do
			if (attached entry_server.entries_of_id (a_component_id) as lt_entries) then
					-- Twinning to ensure that the circulation structure is not broken by `deregister_entry'
				l_entries := lt_entries.twin
				from
					lt_entries.start
				until
					lt_entries.after
				loop
					l_entry := lt_entries.item_for_iteration
					check l_entry_not_void: l_entry /= Void end
					deregister_entry (l_entry, a_component_id)
					lt_entries.forth
				end
			end
		end

	acknowledge_entry (a_entry: EIS_ENTRY)
			-- Acknowledge an entry, so that current different change of fingerprint is not reported,
			-- until next fingerprint change is detected.
		local
			l_target_fingerprint, l_resource_fingerprint: EIS_FINGERPRINT
		do
			l_target_fingerprint := target_fingerprint_from_entry (a_entry)
			l_resource_fingerprint := resource_fingerprint_from_entry (a_entry)
			acknowledge_server.force (create {EIS_ACKNOWLEDGEMENT}.make (a_entry, l_target_fingerprint, l_resource_fingerprint), a_entry.entry_id)
		end

	clean_up
			-- Clean up the storage, remove garbage information
		local
			l_entries: like entry_server.entries
		do
			l_entries := entry_server.entries.twin
			from
				l_entries.start
			until
				l_entries.after
			loop
				if not id_valid (l_entries.key_for_iteration) then
					deregister_entries_of_component_id (l_entries.key_for_iteration)
						-- Now remove from the date server, as it is an invalid target id.
					date_server.remove (l_entries.key_for_iteration)
				end
				l_entries.forth
			end

			clean_up_garbage_fingerprints
			clean_up_acknowledgements (l_entries)

			clean_up_changes (l_entries)
		end

feature {NONE} -- Clean up

	clean_up_garbage_fingerprints
			-- Clean up garbage fingerprints recorded
		local
			l_fingerprint_server: like fingerprint_server
			l_new_server: like fingerprint_server
		do
			l_fingerprint_server := fingerprint_server
			create l_new_server.make (l_fingerprint_server.count)
			across
				entry_server.entries as l_c
			loop
				across
					l_c.item as l_item_c
				loop
					if attached l_fingerprint_server.item (l_item_c.item.target_id) as l_f then
						l_new_server.force (l_f, l_item_c.item.target_id)
					end
					if attached l_item_c.item.source as l_source and then attached l_fingerprint_server.item (l_source) as l_f then
						l_new_server.force (l_f, l_source)
					end
				end
			end
			internal_fingerprint_server := l_new_server
		end

	clean_up_acknowledgements (a_entries: like entry_server.entries)
			-- Remove garbage acknowledgements.
		require
			a_entries_not_void: a_entries /= Void
			a_entries_not_from_server: a_entries /= entry_server.entries
		local
			l_id: like {EIS_ENTRY}.target_id
		do
			across
				acknowledge_server.twin as l_c
			loop
				l_id := l_c.item.entry.target_id
				if attached a_entries.item (l_id) as l_item then
					if not attached l_item.item (l_c.item.entry) then
						acknowledge_server.remove (l_c.key)
					end
				else
					acknowledge_server.remove (l_c.key)
				end
			end
		end

	clean_up_changes (a_entries: like entry_server.entries)
			-- Remove garbage changes
		require
			a_entries_not_void: a_entries /= Void
			a_entries_not_from_server: a_entries /= entry_server.entries
		do
			across
				change_server.twin as l_c
			loop
				if attached a_entries.item (l_c.item.target_id) as l_item then
					if not attached l_item.item (l_c.item) then
						change_server.remove (l_c.key)
					end
				else
					change_server.remove (l_c.key)
				end
			end
		end

feature -- Access

	tag_server: EIS_ENTRY_SERVER [STRING_32]
			-- Tag server
		do
			Result := internal_tag_server
		ensure
			tag_server_attached: Result /= Void
		end

	entry_server: EIS_ENTRY_SERVER [STRING]
			-- Entry server
		do
			Result := internal_entry_server
		ensure
			entry_server_attached: Result /= Void
		end

	date_server: STRING_TABLE [INTEGER]
			-- Date server
			-- Save time stamp for each target.
			-- Used as caches to skip unnessary scan.
			-- Indexed by target id.
		do
			Result := internal_date_server
		ensure
			date_server_attached: Result /= Void
		end

	fingerprint_server: STRING_TABLE [EIS_FINGERPRINT]
			-- Saved fingerprints of target and resources
			-- Indexed by target id or source uri.
		do
			Result := internal_fingerprint_server
		ensure
			fingerprint_server_attached: Result /= Void
		end

	acknowledge_server: STRING_TABLE [EIS_ACKNOWLEDGEMENT]
			-- Server recording acknowledgement of entry changes.
			-- Indexed by md5 of fingerprint of an EIS_ENTRY.
		do
			Result := internal_acknowledge_server
		ensure
			date_server_attached: Result /= Void
		end

	change_server: STRING_TABLE [EIS_ENTRY]
			-- Change server
			-- Indexed by md5 of an EIS_ENTRY.
		do
			Result := internal_change_server
		ensure
			entry_server_attached: Result /= Void
		end

feature {ES_EIS_EXTRACTOR} -- Fingerprints

	target_fingerprint_from_entry (a_entry: EIS_ENTRY): EIS_FINGERPRINT
			-- Target fingerprint from entry
		require
			a_entry_not_void: a_entry /= Void
		local
			l_type: NATURAL_32
			l_result: detachable EIS_FINGERPRINT
		do
			l_type := id_solution.most_possible_type_of_id (a_entry.target_id)
			if l_type = id_solution.target_type and then attached id_solution.target_of_id (a_entry.target_id) as l_target then
				create {EIS_TIMESTAMP_FINGERPRINT} l_result.make_with_timestamp (file_modified_date_path (l_target.system.file_path))
			elseif l_type = id_solution.group_type and then attached id_solution.group_of_id (a_entry.target_id) as l_group then
				create {EIS_TIMESTAMP_FINGERPRINT} l_result.make_with_timestamp (file_modified_date_path (l_group.target.system.file_path))
			elseif l_type = id_solution.folder_type and then attached id_solution.folder_of_id (a_entry.target_id) as l_folder then
					-- Should never get a folder type here.
				create {EIS_TIMESTAMP_FINGERPRINT} l_result.make_with_timestamp (file_modified_date_path (l_folder.cluster.target.system.file_path))
			elseif l_type = id_solution.class_type and then attached id_solution.class_of_id (a_entry.target_id) as l_class then
				create {EIS_TIMESTAMP_FINGERPRINT} l_result.make_with_timestamp (file_modified_date_path (l_class.full_file_name))
			elseif l_type = id_solution.feature_type and then attached id_solution.class_of_id (a_entry.target_id) as l_class then
					-- Use the class section instead of the feature. As when the class is not compiled, the feature does not exist.
				create {EIS_TIMESTAMP_FINGERPRINT} l_result.make_with_timestamp (file_modified_date_path (l_class.full_file_name))
			end
			if l_result = Void then
				create {EIS_MD5_FINGERPRINT} Result.make_empty
			else
				Result := l_result
			end
		ensure
			Result_set: Result /= Void
		end

	resource_fingerprint_from_entry (a_entry: EIS_ENTRY): EIS_FINGERPRINT
			-- Target fingerprint from entry
		require
			a_entry_not_void: a_entry /= Void
		local
			l_f: detachable RAW_FILE
			l_fname: STRING_32
		do
			l_fname := uri_expender.expanded_uri_from_entry (a_entry)
			if not l_fname.is_empty then
				create l_f.make_with_name (l_fname)
			end
			if l_f /= Void and then l_f.exists then
				create {EIS_TIMESTAMP_FINGERPRINT} Result.make_with_timestamp (l_f.date)
			else
					-- We need to access remote resource if possible.
				create {EIS_TIMESTAMP_FINGERPRINT} Result.make_with_timestamp (-1)
			end
		end

	update_fingerprint_for_entries (a_entries: SEARCH_TABLE [EIS_ENTRY])
			-- Update fingerprints of `a_entries'.
		do
			across
				a_entries as l_c
			loop
				process_fingerprints_for_entry (l_c.item, True)
			end
		end

feature {NONE} -- Fingerprints

	register_entry_with_fingerprint (a_entry: EIS_ENTRY; a_component_id: STRING; a_date: INTEGER; a_update_target_fingerprint: BOOLEAN)
			-- Register an entry from the storage
			-- Syncronize servers
			-- `a_component_id' is the class EIS id when `a_entry' is written in a feature
		require
			a_entry_attached: a_entry /= Void
			a_component_id_attached: a_component_id /= Void
			has_date: a_date /= 0
		local
			l_tags: ARRAYED_LIST [STRING_32]
		do
			if entry_server.register_entry (a_entry, a_component_id) then
					-- Syncronize tag server
				if (attached a_entry.tags as lt_tags) and then not lt_tags.is_empty then
					l_tags := lt_tags.twin
					from
						l_tags.start
					until
						l_tags.after
					loop
						if (attached l_tags.item as lt_tag) and then not lt_tag.is_empty then
							if tag_server.register_entry (a_entry, lt_tag) then
								on_tag_extended (lt_tag)
							end
						end
						l_tags.forth
					end
				else
						-- Register empty string to reference entry without tag.
					if tag_server.register_entry (a_entry, create {STRING_32}.make_empty) then
						-- Do nothing.
					end
				end

					-- Syncronize date sever
				date_server.search (a_component_id)
				if date_server.found then
					date_server.replace (a_date, a_component_id)
				else
					date_server.put (a_date, a_component_id)
				end

					-- Inform observers.
				on_entry_registered (a_entry, a_component_id)

				save_needed := True
			end

				-- Update the change server according the comparison result to existing fingerprint server.
				-- Update fingerprints of the `a_entry' in fingerprint server.
			process_fingerprints_for_entry (a_entry, a_update_target_fingerprint)
		end

	file_modified_date_path (a_path: PATH): INTEGER
			-- Get last modified timestamp of `a_path'.
		require
			a_path_set: a_path /= Void and then not a_path.is_empty
		local
			f: RAW_FILE
		do
			create f.make_with_path (a_path)
			if f.exists then
				Result := f.date
			else
				Result := -1
			end
		ensure
			file_modified_date_valid: Result >= -1
		end

	process_fingerprints_for_entry (a_entry: EIS_ENTRY; a_update_target: BOOLEAN)
			-- Update the change server according the comparison result to existing fingerprint server.
			-- Update fingerprints of the `a_entry' in fingerprint server.
			-- If `a_update_target', update the fingerprint of the target when possible.
		local
			l_target_fingerprint, l_resource_fingerprint: EIS_FINGERPRINT
			l_change_detected, l_new_target, l_new_source: BOOLEAN
		do
				-- Current target fingerprint
			l_target_fingerprint := target_fingerprint_from_entry (a_entry)
				-- Current resource fingerprint
			l_resource_fingerprint := resource_fingerprint_from_entry (a_entry)

				-- Compare target fingerprint
			if attached fingerprint_server.item (a_entry.target_id) as l_saved_target_fingerprint then
				if not l_saved_target_fingerprint.same_fingerprint (l_target_fingerprint) then
						-- Change detected.
					l_change_detected := True
					if a_update_target then
						fingerprint_server.replace (l_target_fingerprint, a_entry.target_id)
					end
				end
			else
					-- There was no recorded fingerprint for the target.
					-- For the first time we find non recorded fingerprint, we don't take it as a change.
				l_new_target := True
				fingerprint_server.force (l_target_fingerprint, a_entry.target_id)
			end

				-- Compare resource_fingerprint
			if attached a_entry.source as l_source then
				l_new_source := not fingerprint_server.has (l_source)
				if l_change_detected then
						-- There was a change already, we don't bother to compare the resource fingerprint.
					fingerprint_server.force (l_resource_fingerprint, l_source)
				else
					if attached fingerprint_server.item (l_source) as l_saved_resource_fingerprint then
						if not l_saved_resource_fingerprint.same_fingerprint (l_resource_fingerprint) then
								-- Change detected.
							l_change_detected := True
							fingerprint_server.replace (l_resource_fingerprint, l_source)
						end
					else
							-- There was no recorded fingerprint
							-- For the first time we find record fingerprint, we don't take it as a change.
						fingerprint_server.force (l_resource_fingerprint, l_source)
					end
				end
			else
				l_new_source := True
			end

			if l_new_target or l_new_source then
					-- We make a default acknowledgement for new entry.
				acknowledge_server.force (create {EIS_ACKNOWLEDGEMENT}.make (a_entry, l_target_fingerprint, l_resource_fingerprint), a_entry.entry_id)
			end

			if l_change_detected then
				change_server.force (a_entry, a_entry.entry_id)
			end
		end

	uri_expender: EIS_DEFAULT_HELP_PROVIDER
			-- Only used as uri expander
		once
			create Result.make (agent (preferences.misc_data.internet_browser_preference).value)
		end

feature {NONE} -- Access

	storage_file_name: PATH
			-- Path to save the storage
		do
			Result := project_location.target_path.extended (eiffel_layout.eis_storage_file)
		ensure
			storage_file_name_attached: Result /= Void
		end

	type_to_store: detachable TUPLE [
								tag_server: like tag_server;
								entry_server: like entry_server;
								date_server: like date_server;
								fingerprint_server: like fingerprint_server
								acknowledge_server: like acknowledge_server
								change_server: like change_server]
			-- Type of the object to be stored
		do
		end

	hold_target_fingerprint: BOOLEAN
			-- Hold updating target fingerprint?

	save_needed: BOOLEAN
			-- Save needed?

	internal_tag_server: like tag_server
			-- Internal tag server

	internal_entry_server: like entry_server;
			-- Internal entry server

	internal_date_server: like date_server
			-- Internal date server

	internal_acknowledge_server: like acknowledge_server
			-- Internal resouce acknowledge server

	internal_fingerprint_server: like fingerprint_server
			-- Internal ingerprint server

	internal_change_server: like change_server;
			-- Internal change server

invariant
	internal_tag_server_attached: internal_tag_server /= Void
	internal_entry_server_attached: internal_entry_server /= Void
	internal_date_server_attached: internal_date_server /= Void
	internal_acknowledge_server_attached: internal_acknowledge_server /= Void
	internal_fingerprint_server_attached: internal_fingerprint_server /= Void
	internal_date_server_attached: internal_change_server /= Void

note
	copyright: "Copyright (c) 1984-2013, Eiffel Software"
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
