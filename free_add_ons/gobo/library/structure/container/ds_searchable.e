indexing

	description:

		"Data structures that can be searched"

	library:    "Gobo Eiffel Structure Library"
	author:     "Eric Bezault <ericb@gobosoft.com>"
	copyright:  "Copyright (c) 1999, Eric Bezault and others"
	license:    "Eiffel Forum Freeware License v1 (see forum.txt)"
	date:       "$Date$"
	revision:   "$Revision$"

deferred class DS_SEARCHABLE [G]

inherit

	DS_CONTAINER [G]

feature -- Status report

	has (v: G): BOOLEAN is
			-- Does container include `v'?
			-- (Use `equality_tester''s comparison criterion
			-- if not void, use `=' criterion otherwise.)
		deferred
		ensure
			not_empty: Result implies not is_empty
		end

feature -- Measurement

	occurrences (v: G): INTEGER is
			-- Number of times `v' appears in container
			-- (Use `equality_tester''s comparison criterion
			-- if not void, use `=' criterion otherwise.)
		deferred
		ensure
			positive: Result >= 0
			has: has (v) implies Result >= 1
		end

feature -- Access

	equality_tester: DS_EQUALITY_TESTER [G]
			-- Equality tester;
			-- A void equality tester means that `='
			-- will be used as comparison criterion.

feature -- Setting

	set_equality_tester (a_tester: like equality_tester) is
			-- Set `equality_tester' to `a_tester'.
			-- A void equality tester means that `='
			-- will be used as comparison criterion.
		do
			equality_tester := a_tester
		ensure
			equality_tester_set: equality_tester = a_tester
		end

end -- class DS_SEARCHABLE
