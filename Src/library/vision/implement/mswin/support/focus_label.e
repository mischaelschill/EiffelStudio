indexing

	description:
		"Windows implementation of a focus label.";
	status: "See notice at end of class";
	date: "$Date$";
	revision: "$Revision$"

class FOCUS_LABEL

inherit
	FOCUS_LABEL_I;
	G_ANY_IMP; 
	WEL_TTF_CONSTANTS
		export
			{NONE} all
		end;
	WEL_WS_CONSTANTS
		export
			{NONE} all
		end

create
	initialize

feature -- Initialization

	initialize (a_parent: COMPOSITE) is
			-- Initialize Current.
		do
			create fs_list.make (20);
			init_common_controls_dll
		end;

	initialize_widget (a_focusable: FOCUSABLE) is
			-- Platform specific initialization of the focusable widget.
		do
			fs_list.extend (a_focusable)
		end;

	initialize_focusables (initializer: TOOLTIP_INITIALIZER) is
			-- Actual initialization for Windows.
		require else
			fs_list_not_void: fs_list /= Void
		local
			widget: WIDGET
			wti: WEL_TOOL_INFO;
			ww: WEL_WINDOW;
			wcw: WEL_COMPOSITE_WINDOW;
		do
			if not fs_list.is_empty then
				wcw ?= initializer.tooltip_parent.implementation;
				if tooltip = Void then
					create tooltip.make (wcw, -1);
					-- tooltip will be collected when initializer
					-- is collected
					initializer.set_tooltip (tooltip);
				end
				from
					fs_list.start;
				until
					fs_list.after
				loop
					widget ?= fs_list.item
					check
						widget /= Void
					end
					ww ?= widget.implementation;
					check 
						ww /= Void
					end
					create wti.make;
					fs_list.item.set_tool_info (wti);
					wti.set_window (ww);
					wti.set_rect (ww.client_rect);
					wti.set_flags (Ttf_subclass);
					wti.set_text (fs_list.item.focus_string);
					tooltip.add_tool (wti);
					fs_list.forth
				end
			end
		end;

	fs_list: ARRAYED_LIST [FOCUSABLE]
			-- List of FOCUSABLEs

feature {NONE}

	tooltip: WEL_TOOLTIP

end -- class FOCUS_LABEL

--|----------------------------------------------------------------
--| EiffelVision: library of reusable components for ISE Eiffel.
--| Copyright (C) 1985-2004 Eiffel Software. All rights reserved.
--| Duplication and distribution prohibited.  May be used only with
--| ISE Eiffel, under terms of user license.
--| Contact Eiffel Software for any other use.
--|
--| Interactive Software Engineering Inc.
--| dba Eiffel Software
--| 356 Storke Road, Goleta, CA 93117 USA
--| Telephone 805-685-1006, Fax 805-685-6869
--| Contact us at: http://www.eiffel.com/general/email.html
--| Customer support: http://support.eiffel.com
--| For latest info on our award winning products, visit:
--|	http://www.eiffel.com
--|----------------------------------------------------------------

