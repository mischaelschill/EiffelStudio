indexing
	description: "Tool to view features for current edited class."
	legal: "See notice at end of class."
	status: "See notice at end of class."
	date: "$Date$"
	revision: "$Revision$"

class
	EB_FEATURES_TOOL

inherit
	EB_STONABLE_TOOL
		rename
			stone as current_stone
		redefine
			menu_name,
			pixmap,
			pixel_buffer,
			on_shown,
			widget,
			make,
			attach_to_docking_manager,
			mini_toolbar,
			build_mini_toolbar,
			internal_recycle,
			show
		end

	EB_SHARED_PREFERENCES
		export
			{NONE} all
		end

	SHARED_EIFFEL_PROJECT

create
	make

feature {NONE} -- Initialization

	make (a_manager: EB_DEVELOPMENT_WINDOW) is
			-- Make a new features tool.
		do
			develop_window ?= a_manager
			is_signature_enabled := Preferences.feature_tool_data.is_signature_enabled
			is_alias_enabled := Preferences.feature_tool_data.is_alias_enabled
			is_assigner_enabled := Preferences.feature_tool_data.is_assigner_enabled
			Precursor (a_manager)
		end

	build_interface is
			-- Build all the tool's widgets.
		do
			create tree.make (Current, True)
			create widget
			widget.set_background_color ((create {EV_STOCK_COLORS}).White)
			widget.extend (tree)
		end

	build_mini_toolbar is
			-- Build the associated toolbar
		do
			create mini_toolbar
			mini_toolbar.extend (develop_window.commands.new_feature_cmd.new_mini_toolbar_item)
			mini_toolbar.extend (develop_window.commands.toggle_feature_alias_cmd.new_mini_toolbar_item)
			mini_toolbar.extend (develop_window.commands.toggle_feature_signature_cmd.new_mini_toolbar_item)
			mini_toolbar.extend (develop_window.commands.toggle_feature_assigner_cmd.new_mini_toolbar_item)

			develop_window.commands.toggle_feature_signature_cmd.set_select (is_signature_enabled)
			develop_window.commands.toggle_feature_alias_cmd.set_select (is_alias_enabled)
			develop_window.commands.toggle_feature_assigner_cmd.set_select (is_assigner_enabled)
		ensure then
			mini_toolbar_exists: mini_toolbar /= Void
		end

feature

	attach_to_docking_manager (a_docking_manager: SD_DOCKING_MANAGER) is
			-- Attach to docking manager
		do
			build_docking_content (a_docking_manager)

			check not_already_has: not a_docking_manager.has_content (content) end
			a_docking_manager.contents.extend (content)
		end

feature -- Access

	mini_toolbar: EV_TOOL_BAR
			-- Bar containing a button for a new feature.

	widget: EV_CELL
			-- Container.

	tree: EB_FEATURES_TREE
			-- Widget corresponding to the tree of features.

	title: STRING_GENERAL is
			-- Title of the tool
		do
			Result := Interface_names.t_features_tool
		end

	title_for_pre: STRING is
			-- Title for prefence, STRING_8
		do
			Result := Interface_names.to_features_tool
		end

	menu_name: STRING_GENERAL is
			-- Name as it may appear in a menu.
		do
			Result := Interface_names.m_features_tool
		end

	pixmap: EV_PIXMAP is
			-- Pixmap as it may appear in toolbars and menus.
		do
			Result := pixmaps.icon_pixmaps.tool_features_icon
		end

	pixel_buffer: EV_PIXEL_BUFFER is
			-- Pixel buffer representing the command.
		do
			Result := pixmaps.icon_pixmaps.tool_features_icon_buffer
		end

feature -- Command

	show is
			-- Show tool.
		do
			Precursor {EB_STONABLE_TOOL}
			if tree.is_displayed then
				tree.set_focus
			end
		end

feature -- Behavior

	is_assigner_enabled: BOOLEAN
			-- Is assigner command shown?

	is_alias_enabled: BOOLEAN
			-- Is alias name shown?

	is_signature_enabled: BOOLEAN
			-- Do we display signature of feature ?

	update_tree is
			-- Update tree.
		do
			if tree /= Void then
				tree.update_all
			end
		end

	toggle_signatures is
			-- Toggle signature on/off
		do
			is_signature_enabled := not is_signature_enabled
			if tree /= Void then
				tree.update_all
			end
		end

	toggle_alias is
			-- Toggle alias name on/off
		do
			is_alias_enabled := not is_alias_enabled
			if tree /= Void then
				tree.update_all
			end
		end

	toggle_assigner is
			-- Toggle assigner command on/off
		do
			is_assigner_enabled := not is_assigner_enabled
			if tree /= Void then
				tree.update_all
			end
		end

feature {NONE} -- Memory management

	internal_recycle is
			-- Recycle `Current', but leave `Current' in an unstable state,
			-- so that we know whether we're still referenced or not.
		do
			widget.destroy
			widget := Void
			tree := Void
			Precursor {EB_STONABLE_TOOL}
		end

feature -- Element change

	seek_item_in_feature_tool (a_feature: E_FEATURE) is
			-- Seek and select item contains data of `a_feature' in features tool.
			-- If `a_feature' is void, deselect item in features tool.
		local
			l_node: EV_TREE_NODE
			l_selected_node: EV_TREE_NODE
		do
			if tree /= Void then
				l_selected_node := tree.selected_item
				if a_feature /= Void then
					l_node := tree.retrieve_item_recursively_by_data (a_feature, true)
					if l_node /= Void then
						l_node.enable_select
						if tree.is_displayed then
							tree.ensure_item_visible (l_node)
						end
					else
						if l_selected_node /= Void then
							l_selected_node.disable_select
						end
					end
				else
					if l_selected_node /= Void then
						l_selected_node.disable_select
					end
				end
			end
		end

	seek_ast_item_in_feature_tool (a_feature: STRING) is
			-- Seek item with `a_feature' in feature tree.
		local
			l_node: EV_TREE_NODE
			l_selected_node: EV_TREE_NODE
		do
			if tree /= Void then
				l_selected_node := tree.selected_item
				l_node := tree.retrieve_item_recursively_by_data (a_feature, True)
				if l_node /= Void then
					l_node.enable_select
					if tree.is_displayed then
						tree.ensure_item_visible (l_node)
					end
				else
					if l_selected_node /= Void then
						l_selected_node.disable_select
					end
				end
			end
		end

	synchronize is
			-- Should be called after recompilations.
		local
			st: CLASSI_STONE
		do
			if current_stone /= Void then
				st := current_stone.synchronized_stone
				current_stone := Void
				current_compiled_class := Void
				set_stone (st)
			end
		end

	set_stone (c: STONE) is
			-- Set `current_class' if c is instance of CLASSC_STONE, `Void' otherwise.
		local
			classc_stone: CLASSC_STONE
			external_classc: EXTERNAL_CLASS_C
			feature_clauses: EIFFEL_LIST [FEATURE_CLAUSE_AS]
			conv_cst: CLASSI_STONE
		do
			debug ("docking_integration")
				print ("%N EB_FEATURES_TOOL set_stone")
			end
			conv_cst ?= c
			if conv_cst /= Void then
				current_stone := conv_cst
			end
			classc_stone ?= c
			if shown then
					-- We put the tree off-screen to optimize performance only when something
					-- will happen to the tree (check calls to `widget.wipe_out' and
					-- `widget.extend (tree)'.
				if classc_stone /= Void then
					if
						not classc_stone.e_class.is_external and then
						classc_stone.e_class.has_ast
					then
						if classc_stone.e_class /= current_compiled_class then
							widget.wipe_out
							Eiffel_system.System.set_current_class (classc_stone.e_class)
							if classc_stone.e_class.is_precompiled then
								current_class := classc_stone.e_class.ast
							elseif classc_stone.e_class.eiffel_class_c.file_is_readable then
								current_class := classc_stone.e_class.eiffel_class_c.parsed_ast (False)
							end
							if current_class /= Void then
								feature_clauses := current_class.features
									-- Build the tree
								if tree.selected_item /= Void then
									tree.selected_item.disable_select
								end
								tree.wipe_out
								current_compiled_class := classc_stone.e_class
								if feature_clauses /= Void then
									tree.build_tree (feature_clauses)
								else
									tree.extend (create {EV_TREE_ITEM}.make_with_text
										(Warning_messages.W_no_feature_to_display))
								end
								Eiffel_system.System.set_current_class (Void)
								widget.extend (tree)
								if not tree.is_empty and then tree.is_displayed then
									tree.ensure_item_visible (tree.first)
								end
							end
						end
					elseif classc_stone.class_i.is_external_class then
							-- Special processing for a .NET type since has no 'ast' in the normal
							-- sense.
						external_classc ?= classc_stone.e_class
						if
							external_classc /= current_compiled_class and external_classc /= Void
						then
							Eiffel_system.System.set_current_class (classc_stone.e_class)
									-- Build the tree
							if tree.selected_item /= Void then
								tree.selected_item.disable_select
							end
							tree.wipe_out
							current_compiled_class := classc_stone.e_class
							tree.build_tree_for_external (current_compiled_class)
						end
					else
						tree.wipe_out
						current_compiled_class := Void
					end
				else
						-- Invalid stone, wipe out window content.
					tree.wipe_out
					current_compiled_class := Void
				end
			end
		end

feature {EB_FEATURES_TREE} -- Status setting

	go_to (a_feature: E_FEATURE) is
			-- `a_feature' has been selected, the associated class
			-- window should load corresponding feature.
		require
			a_feature_not_void: a_feature /= Void
		local
			feature_stone: FEATURE_STONE
		do
			create feature_stone.make (a_feature)
			develop_window.set_feature_locating (true)
			develop_window.set_stone (feature_stone)
			develop_window.set_feature_locating (false)
		end

	go_to_clause (a_clause: FEATURE_CLAUSE_AS; a_focus: BOOLEAN) is
			-- `a_clause' has been selected, the associated class
			-- window should display the corresponding feature clause.
			-- the premise is that basic view is being used.
			-- `a_focus' means if set focus to current editor.
		local
			s: STRING
			l_formatter: EB_BASIC_TEXT_FORMATTER
			l_current_editor:  EB_SMART_EDITOR
			l_line, l_pos: INTEGER
		do
			if a_clause.start_position > 0 and then develop_window.editors_manager.current_editor /= Void then
				s := current_compiled_class.text
				l_current_editor := develop_window.editors_manager.current_editor
				if s = Void then
					s := l_current_editor.text
				end
				check
					s_not_void: s /= Void
				end
				l_formatter ?= develop_window.pos_container
				if l_formatter /= Void then
					l_pos := a_clause.start_position
					l_line := character_line (l_pos, s)
					if not a_focus then
						l_current_editor.display_line_at_top_when_ready  (l_line)
					else
						l_current_editor.docking_content.set_focus
						l_current_editor.set_focus
						l_current_editor.scroll_to_start_of_line_when_ready_if_top (l_line, False, True)
					end
				end
			end
		end

	go_to_line (a_line: INTEGER) is
			-- Text at `a_line' has been selected, the associated class
			-- window should display the corresponding line.
		local
			l_formatter: EB_BASIC_TEXT_FORMATTER
		do
			if a_line > 0 and then develop_window.editors_manager.current_editor /= Void then
				l_formatter ?= develop_window.pos_container
				if l_formatter = Void then
					develop_window.managed_main_formatters.first.execute
				end
				develop_window.editors_manager.current_editor.display_line_at_top_when_ready (
					a_line)
			end
		end

	go_to_feature_with_name (a_name: STRING) is
			-- Go to feature with `a_name'
			-- We use this to loacte a feature which is only parsed.
		require
			a_name_not_void: a_name /= Void
		local
			l_formatter: EB_BASIC_TEXT_FORMATTER
		do
			if develop_window.editors_manager.current_editor /= Void then
				l_formatter ?= develop_window.pos_container
				if l_formatter = Void then
					develop_window.managed_main_formatters.first.execute
				end
				develop_window.editors_manager.current_editor.find_feature_named (a_name)
			end
		end

feature {EB_FEATURES_TREE} -- Implementation

	current_class: CLASS_AS
			-- Class currently opened.	

	current_compiled_class: CLASS_C
			-- Class currently opened.

feature {NONE} -- Implementation	

	current_stone: CLASSI_STONE
			-- Classc stone that was last dropped into `Current'.

	character_line (pos: INTEGER; s: STRING): INTEGER is
			-- Line number of character number `pos' in `s'.
		require
			valid_pos: pos > 0
			valid_string: s /= Void
		local
			s2: STRING
		do
			if pos <= s.count then
				s2 := s.substring (1, pos)
			else
				s2 := s
			end
			Result := s2.occurrences ('%N')
		end

	on_shown is
			-- Update the display just before the tool is shown.
		do
			set_stone (current_stone)
		end

indexing
	copyright:	"Copyright (c) 1984-2006, Eiffel Software"
	license:	"GPL version 2 (see http://www.eiffel.com/licensing/gpl.txt)"
	licensing_options:	"http://www.eiffel.com/licensing"
	copying: "[
			This file is part of Eiffel Software's Eiffel Development Environment.
			
			Eiffel Software's Eiffel Development Environment is free
			software; you can redistribute it and/or modify it under
			the terms of the GNU General Public License as published
			by the Free Software Foundation, version 2 of the License
			(available at the URL listed under "license" above).
			
			Eiffel Software's Eiffel Development Environment is
			distributed in the hope that it will be useful,	but
			WITHOUT ANY WARRANTY; without even the implied warranty
			of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
			See the	GNU General Public License for more details.
			
			You should have received a copy of the GNU General Public
			License along with Eiffel Software's Eiffel Development
			Environment; if not, write to the Free Software Foundation,
			Inc., 51 Franklin St, Fifth Floor, Boston, MA 02110-1301  USA
		]"
	source: "[
			 Eiffel Software
			 356 Storke Road, Goleta, CA 93117 USA
			 Telephone 805-685-1006, Fax 805-685-6869
			 Website http://www.eiffel.com
			 Customer support http://support.eiffel.com
		]"

end -- class EB_FEATURES_TOOL
