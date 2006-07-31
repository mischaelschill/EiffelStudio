indexing
	description: "[
		Objects that represent an EV_TITLED_WINDOW.
		The original version of this class was generated by EiffelBuild.
		This class is the implementation of an EV_TITLED_WINDOW generated by EiffelBuild.
		You should not modify this code by hand, as it will be re-generated every time
		 modifications are made to the project.
		 	]"
	date: "$Date$"
	revision: "$Revision$"

deferred class
	EB_METRIC_CALCULATION_RESULT_AREA_IMP

inherit
	EV_VERTICAL_BOX
		redefine
			initialize, is_in_default_state
		end

feature {NONE}-- Initialization

	initialize is
			-- Initialize `Current'.
		do
			Precursor {EV_VERTICAL_BOX}
			
				-- Create all widgets.
			create l_ev_cell_1
			create metric_area
			create metric_lbl
			create metric_name_text
			create l_ev_cell_2
			create type_lbl
			create l_ev_cell_3
			create type_pixmap
			create type_name_text
			create l_ev_cell_4
			create unit_lbl
			create l_ev_cell_5
			create unit_pixmap
			create unit_name_text
			create l_ev_cell_6
			create value_lbl
			create value_text
			create l_ev_cell_7
			create input_area
			create input_lbl
			create input_grid_area
			create result_grid_holder
			create result_lable
			create result_grid_area
			
				-- Build_widget_structure.
			extend (l_ev_cell_1)
			extend (metric_area)
			metric_area.extend (metric_lbl)
			metric_area.extend (metric_name_text)
			metric_area.extend (l_ev_cell_2)
			metric_area.extend (type_lbl)
			metric_area.extend (l_ev_cell_3)
			metric_area.extend (type_pixmap)
			metric_area.extend (type_name_text)
			metric_area.extend (l_ev_cell_4)
			metric_area.extend (unit_lbl)
			metric_area.extend (l_ev_cell_5)
			metric_area.extend (unit_pixmap)
			metric_area.extend (unit_name_text)
			metric_area.extend (l_ev_cell_6)
			metric_area.extend (value_lbl)
			metric_area.extend (value_text)
			metric_area.extend (l_ev_cell_7)
			extend (input_area)
			input_area.extend (input_lbl)
			input_area.extend (input_grid_area)
			extend (result_grid_holder)
			result_grid_holder.extend (result_lable)
			result_grid_holder.extend (result_grid_area)
			
			create string_constant_set_procedures.make (10)
			create string_constant_retrieval_functions.make (10)
			create integer_constant_set_procedures.make (10)
			create integer_constant_retrieval_functions.make (10)
			create pixmap_constant_set_procedures.make (10)
			create pixmap_constant_retrieval_functions.make (10)
			create integer_interval_constant_retrieval_functions.make (10)
			create integer_interval_constant_set_procedures.make (10)
			create font_constant_set_procedures.make (10)
			create font_constant_retrieval_functions.make (10)
			create pixmap_constant_retrieval_functions.make (10)
			create color_constant_set_procedures.make (10)
			create color_constant_retrieval_functions.make (10)
			
			l_ev_cell_1.set_minimum_height (0)
			metric_area.set_padding_width (3)
			metric_area.disable_item_expand (metric_lbl)
			metric_area.disable_item_expand (metric_name_text)
			metric_area.disable_item_expand (l_ev_cell_2)
			metric_area.disable_item_expand (type_lbl)
			metric_area.disable_item_expand (l_ev_cell_3)
			metric_area.disable_item_expand (type_pixmap)
			metric_area.disable_item_expand (type_name_text)
			metric_area.disable_item_expand (l_ev_cell_4)
			metric_area.disable_item_expand (unit_lbl)
			metric_area.disable_item_expand (l_ev_cell_5)
			metric_area.disable_item_expand (unit_pixmap)
			metric_area.disable_item_expand (unit_name_text)
			metric_area.disable_item_expand (l_ev_cell_6)
			metric_area.disable_item_expand (value_lbl)
			metric_area.disable_item_expand (value_text)
			metric_lbl.set_text ("Metric:")
			metric_lbl.align_text_left
			metric_name_text.set_text ("All features")
			metric_name_text.align_text_left
			l_ev_cell_2.set_minimum_width (10)
			type_lbl.set_text ("Type:")
			l_ev_cell_3.set_minimum_width (2)
			type_pixmap.set_minimum_width (16)
			type_pixmap.set_minimum_height (16)
			type_name_text.set_text ("Compilation")
			type_name_text.align_text_left
			l_ev_cell_4.set_minimum_width (10)
			unit_lbl.set_text ("Unit:")
			unit_lbl.align_text_left
			l_ev_cell_5.set_minimum_width (2)
			unit_pixmap.set_minimum_width (16)
			unit_pixmap.set_minimum_height (16)
			unit_name_text.set_text ("Ratio")
			unit_name_text.align_text_left
			l_ev_cell_6.set_minimum_width (10)
			value_lbl.set_text ("Value:")
			value_lbl.align_text_left
			value_text.align_text_left
			input_area.set_padding_width (3)
			input_lbl.set_text ("Source domain:")
			input_lbl.align_text_left
			input_grid_area.set_background_color (create {EV_COLOR}.make_with_8_bit_rgb (0, 0, 0))
			input_grid_area.set_border_width (1)
			result_grid_holder.set_padding_width (3)
			result_grid_holder.disable_item_expand (result_lable)
			result_lable.set_text ("Result:")
			result_lable.align_text_left
			result_grid_area.set_background_color (create {EV_COLOR}.make_with_8_bit_rgb (0, 0, 0))
			result_grid_area.set_border_width (1)
			set_padding_width (5)
			set_border_width (5)
			disable_item_expand (l_ev_cell_1)
			disable_item_expand (metric_area)
			disable_item_expand (input_area)
			
			set_all_attributes_using_constants
			
				--Connect events.
				-- Close the application when an interface close
				-- request is recieved on `Current'. i.e. the cross is clicked.

				-- Call `user_initialization'.
			user_initialization
		end


feature -- Access

	type_pixmap, unit_pixmap: EV_PIXMAP
	metric_area: EV_HORIZONTAL_BOX
	input_area, input_grid_area, result_grid_holder,
	result_grid_area: EV_VERTICAL_BOX
	metric_lbl, metric_name_text, type_lbl, type_name_text, unit_lbl,
	unit_name_text, value_lbl, value_text, input_lbl, result_lable: EV_LABEL

feature {NONE} -- Implementation

	l_ev_cell_1, l_ev_cell_2, l_ev_cell_3, l_ev_cell_4, l_ev_cell_5, l_ev_cell_6, l_ev_cell_7: EV_CELL

feature {NONE} -- Implementation

	is_in_default_state: BOOLEAN is
			-- Is `Current' in its default state?
		do
			-- Re-implement if you wish to enable checking
			-- for `Current'.
			Result := True
		end
	
	user_initialization is
			-- Feature for custom initialization, called at end of `initialize'.
		deferred
		end
		
feature {NONE} -- Constant setting

	set_attributes_using_string_constants is
			-- Set all attributes relying on string constants to the current
			-- value of the associated constant.
		local
			s: STRING_32
		do
			from
				string_constant_set_procedures.start
			until
				string_constant_set_procedures.off
			loop
				string_constant_retrieval_functions.i_th (string_constant_set_procedures.index).call (Void)
				s := string_constant_retrieval_functions.i_th (string_constant_set_procedures.index).last_result
				string_constant_set_procedures.item.call ([s])
				string_constant_set_procedures.forth
			end
		end
		
	set_attributes_using_integer_constants is
			-- Set all attributes relying on integer constants to the current
			-- value of the associated constant.
		local
			i: INTEGER
			arg1, arg2: INTEGER
			int: INTEGER_INTERVAL
		do
			from
				integer_constant_set_procedures.start
			until
				integer_constant_set_procedures.off
			loop
				integer_constant_retrieval_functions.i_th (integer_constant_set_procedures.index).call (Void)
				i := integer_constant_retrieval_functions.i_th (integer_constant_set_procedures.index).last_result
				integer_constant_set_procedures.item.call ([i])
				integer_constant_set_procedures.forth
			end
			from
				integer_interval_constant_retrieval_functions.start
				integer_interval_constant_set_procedures.start
			until
				integer_interval_constant_retrieval_functions.off
			loop
				integer_interval_constant_retrieval_functions.item.call (Void)
				arg1 := integer_interval_constant_retrieval_functions.item.last_result
				integer_interval_constant_retrieval_functions.forth
				integer_interval_constant_retrieval_functions.item.call (Void)
				arg2 := integer_interval_constant_retrieval_functions.item.last_result
				create int.make (arg1, arg2)
				integer_interval_constant_set_procedures.item.call ([int])
				integer_interval_constant_retrieval_functions.forth
				integer_interval_constant_set_procedures.forth
			end
		end
		
	set_attributes_using_pixmap_constants is
			-- Set all attributes relying on pixmap constants to the current
			-- value of the associated constant.
		local
			p: EV_PIXMAP
		do
			from
				pixmap_constant_set_procedures.start
			until
				pixmap_constant_set_procedures.off
			loop
				pixmap_constant_retrieval_functions.i_th (pixmap_constant_set_procedures.index).call (Void)
				p := pixmap_constant_retrieval_functions.i_th (pixmap_constant_set_procedures.index).last_result
				pixmap_constant_set_procedures.item.call ([p])
				pixmap_constant_set_procedures.forth
			end
		end
		
	set_attributes_using_font_constants is
			-- Set all attributes relying on font constants to the current
			-- value of the associated constant.
		local
			f: EV_FONT
		do
			from
				font_constant_set_procedures.start
			until
				font_constant_set_procedures.off
			loop
				font_constant_retrieval_functions.i_th (font_constant_set_procedures.index).call (Void)
				f := font_constant_retrieval_functions.i_th (font_constant_set_procedures.index).last_result
				font_constant_set_procedures.item.call ([f])
				font_constant_set_procedures.forth
			end	
		end
		
	set_attributes_using_color_constants is
			-- Set all attributes relying on color constants to the current
			-- value of the associated constant.
		local
			c: EV_COLOR
		do
			from
				color_constant_set_procedures.start
			until
				color_constant_set_procedures.off
			loop
				color_constant_retrieval_functions.i_th (color_constant_set_procedures.index).call (Void)
				c := color_constant_retrieval_functions.i_th (color_constant_set_procedures.index).last_result
				color_constant_set_procedures.item.call ([c])
				color_constant_set_procedures.forth
			end
		end
		
	set_all_attributes_using_constants is
			-- Set all attributes relying on constants to the current
			-- calue of the associated constant.
		do
			set_attributes_using_string_constants
			set_attributes_using_integer_constants
			set_attributes_using_pixmap_constants
			set_attributes_using_font_constants
			set_attributes_using_color_constants
		end
					
	string_constant_set_procedures: ARRAYED_LIST [PROCEDURE [ANY, TUPLE [STRING_GENERAL]]]
	string_constant_retrieval_functions: ARRAYED_LIST [FUNCTION [ANY, TUPLE [], STRING_32]]
	integer_constant_set_procedures: ARRAYED_LIST [PROCEDURE [ANY, TUPLE [INTEGER]]]
	integer_constant_retrieval_functions: ARRAYED_LIST [FUNCTION [ANY, TUPLE [], INTEGER]]
	pixmap_constant_set_procedures: ARRAYED_LIST [PROCEDURE [ANY, TUPLE [EV_PIXMAP]]]
	pixmap_constant_retrieval_functions: ARRAYED_LIST [FUNCTION [ANY, TUPLE [], EV_PIXMAP]]
	integer_interval_constant_retrieval_functions: ARRAYED_LIST [FUNCTION [ANY, TUPLE [], INTEGER]]
	integer_interval_constant_set_procedures: ARRAYED_LIST [PROCEDURE [ANY, TUPLE [INTEGER_INTERVAL]]]
	font_constant_set_procedures: ARRAYED_LIST [PROCEDURE [ANY, TUPLE [EV_FONT]]]
	font_constant_retrieval_functions: ARRAYED_LIST [FUNCTION [ANY, TUPLE [], EV_FONT]]
	color_constant_set_procedures: ARRAYED_LIST [PROCEDURE [ANY, TUPLE [EV_COLOR]]]
	color_constant_retrieval_functions: ARRAYED_LIST [FUNCTION [ANY, TUPLE [], EV_COLOR]]
	
	integer_from_integer (an_integer: INTEGER): INTEGER is
			-- Return `an_integer', used for creation of
			-- an agent that returns a fixed integer value.
		do
			Result := an_integer
		end

end -- class EB_METRIC_CALCULATION_RESULT_AREA_IMP
