indexing
	description: "Objects that represent an EV_TITLED_WINDOW.%
		%The original version of this class was generated by EiffelBuild."
	legal: "See notice at end of class."
	status: "See notice at end of class."
	date: "$Date$"
	revision: "$Revision$"

class
	EB_BASIC_METRIC_DEFINITION_AREA

inherit
	EB_BASIC_METRIC_DEFINITION_AREA_IMP

	EB_METRIC_EDITOR
		undefine
			is_equal,
			copy,
			default_create
		redefine
			metric,
			is_basic_metric_editor
		end

	EB_CONSTANTS
		undefine
			is_equal,
			copy,
			default_create
		end

	EVS_GRID_TWO_WAY_SORTING_ORDER
		undefine
			is_equal,
			copy,
			default_create
		end

	QL_SHARED_NAMES
		undefine
			is_equal,
			copy,
			default_create
		end

	EB_SHARED_ID_SOLUTION
		undefine
			is_equal,
			copy,
			default_create
		end

	EB_METRIC_INTERFACE_PROVIDER
		undefine
			is_equal,
			copy,
			default_create
		end

create
	make

feature {NONE} -- Initialization

	make (a_tool: like metric_tool; a_panel: like metric_panel; a_mode: INTEGER; a_unit: QL_METRIC_UNIT) is
			-- Initialize `metric' with `a_metric' mode with `a_mode' and `unit' with `a_unit'.
		require
			a_tool_attached: a_tool /= Void
			a_mode_valid: is_mode_valid (a_mode)
			a_unit_attached: a_unit /= Void
		do
			create change_actions_internal
			create change_actions
			set_metric_tool (a_tool)
			set_metric_panel (a_panel)
			default_create
			setup_editor
			set_mode (a_mode)
			set_unit (a_unit)
		ensure
			change_actions_attached: change_actions_internal /= Void
			metric_tool_set: metric_tool = a_tool
			metric_panel_set: metric_panel = a_panel
		end

	user_initialization is
			-- Called by `initialize'.
			-- Any custom user initialization that
			-- could not be performed in `initialize',
			-- (due to regeneration of implementation class)
			-- can be added here.
		local
			l_text: EV_TEXT
		do
				-- Setup criterion combination grid.
			create combination_grid.make
			combination_grid_container.extend (combination_grid)
			combination_grid.change_actions.extend (agent on_change)

				-- Setup combination toolbar
			remove_criterion_btn.remove_text
			remove_criterion_btn.set_pixmap (pixmaps.icon_pixmaps.general_remove_icon)
			remove_all_criterion_btn.remove_text
			remove_all_criterion_btn.set_pixmap (pixmaps.icon_pixmaps.general_reset_icon)
			up_btn.remove_text
			up_btn.set_pixmap (pixmaps.icon_pixmaps.general_move_up_icon)
			down_btn.remove_text
			down_btn.set_pixmap (pixmaps.icon_pixmaps.general_move_down_icon)
			indent_and_btn.set_text ("")
			indent_and_btn.set_pixmap (pixmaps.icon_pixmaps.new_and_icon)
			indent_or_btn.set_text ("")
			indent_or_btn.set_pixmap (pixmaps.icon_pixmaps.new_or_icon)

				-- Setup actions
			remove_criterion_btn.select_actions.extend (agent on_remove_criterion)
			remove_all_criterion_btn.select_actions.extend (agent on_remove_all_criteria)
			up_btn.select_actions.extend (agent on_move (True))
			down_btn.select_actions.extend (agent on_move (False))
			indent_and_btn.select_actions.extend (agent on_indent (True))
			indent_or_btn.select_actions.extend (agent on_indent (False))
			expression_lbl.set_text (metric_names.t_expression)
			create l_text
			expression_text.set_background_color (l_text.background_color)

				-- Register key shortcuts.
			create del_key_shortcut.make_with_key_combination (create {EV_KEY}.make_with_code ({EV_KEY_CONSTANTS}.key_delete), False, False, False)
			create move_row_up_shortcut.make_with_key_combination (create {EV_KEY}.make_with_code ({EV_KEY_CONSTANTS}.key_numpad_subtract), True, False, False)
			create move_row_down_shortcut.make_with_key_combination (create {EV_KEY}.make_with_code ({EV_KEY_CONSTANTS}.key_numpad_add), True, False, False)
			create and_indent_shortcut.make_with_key_combination (create {EV_KEY}.make_with_code ({EV_KEY_CONSTANTS}.key_numpad_6), True, False, False)
			create or_indent_shortcut.make_with_key_combination (create {EV_KEY}.make_with_code ({EV_KEY_CONSTANTS}.key_numpad_3), True, False, False)
			combination_grid.register_shortcut (move_row_up_shortcut, agent on_move (True))
			combination_grid.register_shortcut (move_row_down_shortcut, agent on_move (False))
			combination_grid.register_shortcut (del_key_shortcut, agent on_remove_criterion)
			combination_grid.register_shortcut (and_indent_shortcut, agent on_indent (True))
			combination_grid.register_shortcut (or_indent_shortcut, agent on_indent (False))

			up_btn.set_tooltip (metric_names.f_move_row_up.as_string_32 + " (" + move_row_up_shortcut.out + ")")
			down_btn.set_tooltip (metric_names.f_move_row_down.as_string_32 + " (" + move_row_down_shortcut.out + ")")
			remove_criterion_btn.set_tooltip (metric_names.f_del_row.as_string_32 + " (" + del_key_shortcut.out + ")")
			indent_and_btn.set_tooltip (metric_names.f_indent_with_and_criterion.as_string_32 + " (" + and_indent_shortcut.out + ")")
			indent_or_btn.set_tooltip (metric_names.f_indent_with_or_criterion.as_string_32 + " (" + or_indent_shortcut.out + ")")

			criterion_lbl.set_text (metric_names.t_metric_criterion_definition)
			attach_non_editable_warning_to_text (metric_names.t_text_not_editable, expression_text, metric_tool_window)

				-- Delete following in docking EiffelStudio.
			criterion_definition_empty_area.drop_actions.extend (agent metric_panel.drop_cluster)
			criterion_definition_empty_area.drop_actions.extend (agent metric_panel.drop_class)
			criterion_definition_empty_area.drop_actions.extend (agent metric_panel.drop_feature)
			lbl_empty_area.drop_actions.extend (agent metric_panel.drop_cluster)
			lbl_empty_area.drop_actions.extend (agent metric_panel.drop_class)
			lbl_empty_area.drop_actions.extend (agent metric_panel.drop_feature)
			expression_lbl_empty_area.drop_actions.extend (agent metric_panel.drop_cluster)
			expression_lbl_empty_area.drop_actions.extend (agent metric_panel.drop_class)
			expression_lbl_empty_area.drop_actions.extend (agent metric_panel.drop_feature)

			add_current_target_item_btn.set_pixmap (pixmaps.icon_pixmaps.metric_domain_application_icon)
			add_current_target_item_btn.set_tooltip (metric_names.f_application_scope)
			add_current_target_item_btn.select_actions.extend (agent on_add_domain_item (agent new_current_application_target_domain_item))

			add_input_domain_item_btn.set_pixmap (pixmaps.icon_pixmaps.metric_domain_delayed_icon)
			add_input_domain_item_btn.set_tooltip (metric_names.f_delayed_scope)
			add_input_domain_item_btn.select_actions.extend (agent on_add_domain_item (agent new_input_domain_item))

			add_delayed_domain_item_btn.set_pixmap (pixmaps.icon_pixmaps.metric_domain_delayed_icon)
			add_delayed_domain_item_btn.set_tooltip (metric_names.f_use_delayed_scope)
			add_delayed_domain_item_btn.select_actions.extend (agent on_add_domain_item (agent new_delayed_domain_item))

			clear_domain_btn.set_pixmap (pixmaps.icon_pixmaps.general_remove_icon)
			clear_domain_btn.set_tooltip (metric_names.f_clear_defined_domain)
			clear_domain_btn.select_actions.extend (agent on_clear_defined_domain)

			combination_grid.item_select_actions.extend (agent on_grid_item_selected)
			quick_domain_item_tool_bar.disable_sensitive
		ensure then
			del_key_shortcut_attached: del_key_shortcut /= Void
			ctrl_up_shortcut_attached: move_row_up_shortcut /= Void
			ctrl_down_shortcut_attached: move_row_down_shortcut /= Void
			ctrl_right_shortcut_attached: and_indent_shortcut /= Void
			alt_right_shortcut_attached: or_indent_shortcut /= Void
		end

feature -- Status report

	is_basic_metric_editor: BOOLEAN is True
			-- Is current a basic metric editor?

feature -- Setting

	set_mode (a_mode: INTEGER) is
			-- Set `mode' with `a_mode'.
		do
			mode := a_mode
			if mode = readonly_mode then
				remove_criterion_btn.disable_sensitive
				remove_all_criterion_btn.disable_sensitive
			else
				remove_criterion_btn.enable_sensitive
				remove_all_criterion_btn.enable_sensitive
			end
		end

	load_metric_definition (a_metric: like metric) is
			-- Load `a_metric' in current editor.
		do
			if combination_grid.row_count > 0 then
				combination_grid.remove_rows (1, combination_grid.row_count)
			end
			load_metric_name_and_description (a_metric, mode = readonly_mode)
			if a_metric = Void then
					-- For new metric
				load_criterion (Void)
			else
				load_criterion (a_metric.criteria)
			end
		end

	load_criterion (a_criterion: EB_METRIC_CRITERION) is
			-- Load criterion of `a_metric' into `combination_grid'.
		do
			combination_grid.clear_criterion
			if is_criterion_definable then
				combination_grid.load_criterion (a_criterion, unit.scope, mode = readonly_mode)
			else
				combination_grid.load_undefinable_criteria
			end
			on_change
		end

	resize_criterion_grid_column (a_index: INTEGER; a_width: INTEGER) is
			-- Resize `a_index'-th column to `a_width' in pixels.
			-- If `a_width' is 0, resize specified column to its content.
		require
			a_index_valid: a_index > 0 and then a_index <= 2
		do
			combination_grid.resize_column (a_index, a_width)
		end

	enable_edit is
			-- Enable edit in current editor.
		do
			combination_grid.enable_sensitive
			combination_toolbar_area.enable_sensitive
		end

	disable_edit is
			-- Disable edit in current editor.
		do
			resize_criterion_grid_column (1, 0)
			resize_criterion_grid_column (2, 0)
			combination_grid.disable_sensitive
			combination_toolbar_area.disable_sensitive
		end

feature -- Access

	metric: EB_METRIC_BASIC is
			-- Metric in current editor
		do
			create Result.make (name_area.name, unit, uuid)
			Result.set_description (name_area.description)
			Result.set_criteria (combination_grid.criterion)
		end

	metric_type: INTEGER is
			-- Type of metric in current editor
		do
			Result := basic_metric_type
		end

	definition_area_widget: EV_WIDGET is
			-- Definition area
		do
			Result := Current
		end

	change_actions_internal: ACTION_SEQUENCE [TUPLE [EB_METRIC_CRITERION]]
			-- Actions to be performed when metric definition in current changes

	criterion: EB_METRIC_CRITERION is
			-- Criterion defined in current panel
		do
			Result := combination_grid.criterion
		end

feature{NONE} -- Actions

	on_remove_criterion is
			-- Action to be performed when remove a criterion
		local
			l_rows: LIST [EV_GRID_ROW]
			l_items: LIST [EV_GRID_ITEM]
		do
			l_rows := combination_grid.selected_rows
			if not l_rows.is_empty then
				combination_grid.remove_criterion_row (l_rows.first, False, True)
			else
				l_items := combination_grid.selected_items
				if not l_items.is_empty then
					combination_grid.remove_criterion_row (l_items.first.row, False, True)
				end
			end
			is_definition_changed := True
		ensure
			definition_changed: is_definition_changed
		end

	on_remove_all_criteria is
			-- Action to be performed when remove all criteria
		do
			if combination_grid.row_count > 0 then
				combination_grid.remove_criterion_row (combination_grid.row (1), True, False)
			end
			is_definition_changed := True
		ensure
			definition_changed: is_definition_changed
		end

	on_move (a_up: BOOLEAN) is
			-- Action to be performed when move selected row up if `a_up' is True, otherwise down
		local
			l_rows: LIST [EV_GRID_ROW]
			l_items: LIST [EV_GRID_ITEM]
		do
			l_rows := combination_grid.selected_rows
			l_items := combination_grid.selected_items
			if not l_rows.is_empty then
				combination_grid.move_criterion_row (l_rows.first, a_up)
			elseif not l_items.is_empty then
				combination_grid.move_criterion_row (l_items.first.row, a_up)
			end
			is_definition_changed := True
		end

	on_indent (is_and: BOOLEAN) is
			-- Action to be performed when user wants to indent a criterion
			-- If `is_and' is Ture, indent using "AND" operator, otherwise using "OR" operator.
		local
			l_rows: LIST [EV_GRID_ROW]
			l_items: LIST [EV_GRID_ITEM]
		do
			l_rows := combination_grid.selected_rows
			l_items := combination_grid.selected_items
			if not l_rows.is_empty then
				combination_grid.indent_criterion_row (l_rows.first, is_and)
			elseif not l_items.is_empty then
				combination_grid.indent_criterion_row (l_items.first.row, is_and)
			end
			is_definition_changed := True
			combination_grid.resize_column (1, 0)
			combination_grid.resize_column (2, 0)
		end

	on_change is
			-- Action to be performed when criterion definition in `combination_grid' changes
		local
			l_criterion: EB_METRIC_CRITERION
		do
			l_criterion := combination_grid.criterion
			rich_text_output.wipe_out
			if l_criterion /= Void then
				expression_generator.generate_output (l_criterion)
			end
			rich_text_output.load_expression (expression_text)
			change_actions_internal.call ([l_criterion])
			on_definition_change
		end

	on_grid_item_selected (a_item: EV_GRID_ITEM) is
			-- Agent to be performed when `a_item' in `combination_grid' is selected
		do
			current_selected_grid_domain_item ?= a_item
			if current_selected_grid_domain_item /= Void then
				quick_domain_item_tool_bar.enable_sensitive
			else
				quick_domain_item_tool_bar.disable_sensitive
			end
		end

	on_add_domain_item (a_domain_item_retrieval_agent: FUNCTION [ANY, TUPLE, EB_METRIC_DOMAIN_ITEM]) is
			-- Action to be performed to add domain item retrieved from `a_domain_item_retrieval_agent'
			-- into current selected domain grid item
		require
			a_domain_item_retrieval_agent_attached: a_domain_item_retrieval_agent /= Void
		local
			l_domain: EB_METRIC_DOMAIN
		do
			if current_selected_grid_domain_item /= Void and then current_selected_grid_domain_item.is_parented then
				create l_domain.make
				l_domain.extend (a_domain_item_retrieval_agent.item ([]))
				current_selected_grid_domain_item.set_domain (l_domain)
				on_change
			end
		end

	on_clear_defined_domain is
			-- Action to be performed to clear currently defined domain in `current_selected_grid_domain_item'.
		local
			l_domain: EB_METRIC_DOMAIN
		do
			if current_selected_grid_domain_item /= Void and then current_selected_grid_domain_item.is_parented then
				create l_domain.make
				current_selected_grid_domain_item.set_domain (l_domain)
				on_change
			end
		end

feature{NONE} -- Implementation/Access

	combination_grid: EB_METRIC_CRITERION_GRID
			-- Criterion combination grid

	current_selected_grid_domain_item: EB_METRIC_GRID_DOMAIN_ITEM [ANY]
			-- Current selected grid domain item

feature -- Key shortcuts

	del_key_shortcut: ES_KEY_SHORTCUT
			-- Del key

	move_row_up_shortcut: ES_KEY_SHORTCUT
			-- Key combination to move a row up

	move_row_down_shortcut: ES_KEY_SHORTCUT
			-- Key combination to move a row down

	and_indent_shortcut: ES_KEY_SHORTCUT
			-- Key combination to "AND" indent a row

	or_indent_shortcut: ES_KEY_SHORTCUT
			-- Key combination to "OR" indent a row

invariant
	criterion_factory_attached: criterion_factory /= Void
	metric_tool_attached: metric_tool /= Void
	change_actions_attached: change_actions_internal /= Void
	del_key_shortcut_attached: del_key_shortcut /= Void
	ctrl_up_shortcut_attached: move_row_up_shortcut /= Void
	ctrl_down_shortcut_attached: move_row_down_shortcut /= Void
	ctrl_right_shortcut_attached: and_indent_shortcut /= Void
	alt_right_shortcut_attached: or_indent_shortcut /= Void

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


end -- class EB_BASIC_METRIC_DEFINITION_AREA

