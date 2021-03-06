note
	legal: "See notice at end of class."
	status: "See notice at end of class."
-- Lines of the form VARIABLES ":" SUM
-- This is the top construct of the Polynomial language

class
	LINE

inherit

	AGGREGATE
		export
			{PROCESS, LINE} all
		redefine
			post_action
		end

	POLYNOM
		undefine
			copy, is_equal
		end

create
	make

feature

	construct_name: STRING
		once
			Result := "LINE"
		end -- construct_name

	production: LINKED_LIST [CONSTRUCT]
		local
			var: VARIABLES
			sum: SUM
		once
			create Result.make
			Result.forth
			create var.make
			put (var)
			keyword (":")
			create sum.make
			put (sum)
		end -- production

	post_action
		local
			l_child: like child
		do
			child_start
			l_child := child
			if l_child /= Void then
				l_child.post_action
			end
			from
				child_finish
			until
				info.end_session
			loop
				info.set_value
				l_child := child
				check l_child /= Void end
				l_child.post_action
				io.putstring ("value: ")
				io.putint (info.child_value)
				io.new_line
			end
		end -- post_action

feature {LINE} -- Implementation

	clone_node (n: like Current): like Current
			-- <precursor>
		do
			create Result.make
			Result.copy_node (n)
		end

	new_tree: like Current
			-- <precursor>
		do
			create Result.make
		end

note
	copyright:	"Copyright (c) 1984-2006, Eiffel Software and others"
	license:	"Eiffel Forum License v2 (see http://www.eiffel.com/licensing/forum.txt)"
	source: "[
			 Eiffel Software
			 356 Storke Road, Goleta, CA 93117 USA
			 Telephone 805-685-1006, Fax 805-685-6869
			 Website http://www.eiffel.com
			 Customer support http://support.eiffel.com
		]"


end -- class LINE

