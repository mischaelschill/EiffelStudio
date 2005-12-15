indexing
	description: "AST representation of an `all' structure."
	date: "$Date$"
	revision: "$Revision$"

class ALL_AS

inherit
	FEATURE_SET_AS

create
	initialize

feature {NONE} -- Initialization

	 initialize (a_as: KEYWORD_AS) is
			-- Create a new ALL AST node.
		do
			-- Do nothing.
			all_keyword := a_as
		ensure
			all_keyword_set: all_keyword = a_as
		end

feature -- Visitor

	process (v: AST_VISITOR) is
			-- process current element.
		do
			v.process_all_as (Current)
		end

feature -- Roundtrip

	all_keyword: KEYWORD_AS
		-- Keyword "all" assoicated with this structure

feature -- Comparison

	is_equivalent (other: like Current): BOOLEAN is
			-- Is `other' equivalent to the current object ?
		do
			Result := True
		end

feature -- Location

	start_location: LOCATION_AS is
			-- Starting point for current construct.
		do
			Result := null_location
		end

	end_location: LOCATION_AS is
			-- Ending point for current construct.
		do
			Result := null_location
		end

end -- class ALL_AS
