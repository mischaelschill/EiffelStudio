note
	description: "[
		{EC_TAG_TREE_NODE} representing Eiffel features.
	]"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	EC_TAG_TREE_FEATURE_NODE [G -> TAG_ITEM]

inherit
	EC_TAG_TREE_NODE [G, E_FEATURE]

create
	make

feature {NONE} -- Implementation

	process_ec_node (a_visitor: EC_TAG_TREE_NODE_VISITOR [G])
			-- <Precursor>
		do
			a_visitor.process_feature_node (Current)
		end

	retrieve_item (a_project: EC_PROJECT_ACCESS): like item
			-- <Precursor>
		local
			l_classc: CLASS_C
		do
			if attached {EC_TAG_TREE_NODE [G, CLASS_I]} parent as l_parent then
				if attached l_parent.item (a_project) as l_classi then
					if l_classi.is_compiled then
						l_classc := l_classi.compiled_class
						if l_classc.has_feature_table then
							Result := l_classc.feature_with_name_32 (name)
						end
					end
				end
			end
		end

note
	copyright: "Copyright (c) 1984-2010, Eiffel Software"
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
