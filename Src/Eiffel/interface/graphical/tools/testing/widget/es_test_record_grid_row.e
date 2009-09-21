note
	description: "[
		Grid row visualizing the content and state of a {TEST_SESSION_RECORD}.
	]"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	ES_TEST_RECORD_GRID_ROW [G -> TEST_SESSION_I, H -> TEST_SESSION_RECORD]

inherit
	EB_RECYCLABLE

	EB_SHARED_PIXMAPS

feature {NONE} -- Initialization

	make (a_record: like record; a_row: like row; a_icons_provider: like icons_provider)
			-- Initialize `Current'.
			--
			-- `a_record': Test session record to be displayed in row
			-- `a_row': Grid row in which `a_record' is displayed
			-- `a_icons_provider': Icons provider for testing tool icons.
		require
			a_record_attached: a_record /= Void
			a_row_attached: a_row /= Void
			a_icons_provider_attached: a_icons_provider /= Void
		do
			record := a_record
			row := a_row
			icons_provider := a_icons_provider
			row.expand_actions.extend (agent on_row_expand)
			row.collapse_actions.extend (agent on_row_collapse)
			refresh
			if is_expandable then
				row.ensure_expandable
			end
		ensure
			record_set: record = a_record
			row_set: row = a_row
			icons_provider_set: icons_provider = a_icons_provider
		end

	make_running (a_session: like session; a_row: like row; a_icons_provider: like icons_provider)
			-- Initialize `Current'.
			--
			-- `a_session': Running session.
			-- `a_row': Grid row in which record of `a_session' is displayed.
			-- `a_icons_provider': Icons provider for testing tool icons.
		require
			a_session_attached: a_session /= Void
			a_row_attached: a_row /= Void
			a_icons_provider_attached: a_icons_provider /= Void
			a_session_usable: a_session.is_interface_usable
			a_session_running: a_session.has_next_step
		local
			l_record: detachable like record
		do
				-- It is required that a session of type G provides a record of type H
			if attached {H} a_session.record as l_typed_record then
				l_record := l_typed_record
			else
				check dead_end: l_record /= Void end
			end
			internal_session := a_session
			make (l_record, a_row, a_icons_provider)
		ensure
			running: is_running
			session_set: session = a_session
			row_set: row = a_row
			icons_provider_set: icons_provider = a_icons_provider
		end

feature -- Access

	record: H
			-- Test session record

	row: EV_GRID_ROW
			-- Row diaplying `record'

	session: G
			-- Session contributing to `record'
		require
			running: is_running
		local
			l_session: like internal_session
		do
			l_session := internal_session
			check l_session /= Void end
			Result := l_session
		ensure
			result_valid: Result = internal_session
		end

feature {NONE} -- Access

	internal_session: detachable G
			-- Internal storage of `session'

	icons_provider: ES_TOOL_ICONS_PROVIDER_I [ES_TESTING_TOOL_ICONS]
			-- Icons provider for testing tool icons.

	pixmap: EV_PIXMAP
			-- Pixmap used at beginning of row
		deferred
		ensure
			result_attached: Result /= Void
		end

	label: STRING
			-- Label shown in first item of `row'
		deferred
		ensure
			result_attached: Result /= Void
			result_not_empty: not Result.is_empty
		end

feature -- Status report

	frozen is_running: BOOLEAN
			-- Does `Current' point to the running session which is contributing to `record'?
		do
			Result := internal_session /= Void
		ensure
			result_valid: Result = (internal_session /= Void)
		end

	is_expanded: BOOLEAN
			-- Are subrows currently computed and displayed?

feature {NONE} -- Status report

	is_expandable: BOOLEAN
			-- Should `row' be displayed expandable?
		deferred
		end

feature {ES_TEST_RECORDS_TAB} -- Status setting

	detach_session
			-- Detach `session' from `Current'.
		require
			running: is_running
		do
			internal_session := session.default
		ensure
			not_running: not is_running
		end

feature {ES_TEST_RECORDS_TAB} -- Basic operations

	refresh
			-- Rebuild content and all subrows of `row'.
		local
			l_pixmap: EV_PIXMAP
			l_label: EV_GRID_LABEL_ITEM
			l_text: STRING_32
		do
			create l_text.make (80)
			l_text.append_string_general (label)
			l_text.append_string_general (" (")
			l_text.append_string_general (record.creation_date.formatted_out ("[0]mm/[0]dd/yyyy [0]hh:[0]mi"))
			l_text.append_string_general (")")
			create l_label.make_with_text (l_text)
			l_label.set_pixmap (pixmap)
			row.set_item (1, l_label)

			create l_label.make_with_text ("")
			l_pixmap := icon_pixmaps.general_save_icon.twin
			l_pixmap.disable_sensitive
			l_label.set_pixmap (l_pixmap)
			l_label.disable_full_select
			row.set_item (3, l_label)

			create l_label.make_with_text ("")
			l_label.set_pixmap (icon_pixmaps.general_delete_icon)
			l_label.disable_full_select
			row.set_item (4, l_label)
		end

	show_content
			-- Fill subrows with content of `record'.
		require
			not_expanded: not is_expanded
		do
			is_expanded := True
		ensure
			is_expanded: is_expanded
		end

	clear_content
			-- Rebuild subwrows of `row'.
		require
			is_expanded: is_expanded
		local
			l_row: like row
			l_start, l_count: INTEGER
		do
			is_expanded := False
			l_row := row
			l_start := l_row.index + 1
			l_count := l_row.subrow_count_recursive
			if l_count > 0 then
				l_row.parent.remove_rows (l_start, l_start + l_count - 1)
			end
			if is_expandable then
				l_row.ensure_expandable
			end
		ensure
			not_expanded: not is_expanded
		end

feature {NONE} -- Events: row

	on_row_expand
			-- Called when `row' is expanded for the first time.
		do
			if not is_expanded then
				show_content
			end
		end

	on_row_collapse
			-- Calledn when `row' is collapsed.
		do
			if is_expanded then
				clear_content
			end
		end

feature {NONE} -- Clean up

	internal_recycle
			-- <Precursor>
		do
			if is_running then
				detach_session
			end
		end

invariant
	row_not_destroyed: not row.is_destroyed
	running_implies_valid_record: is_running implies record = session.record

note
	copyright: "Copyright (c) 1984-2009, Eiffel Software"
	license: "GPL version 2 (see http://www.eiffel.com/licensing/gpl.txt)"
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
