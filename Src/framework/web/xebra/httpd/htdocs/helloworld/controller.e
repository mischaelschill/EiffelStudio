note
	description: "[
		Provides features for the servlets
	]"
	legal: "See notice at end of class."
	date: "$Date$"
	revision: "$Revision$"

class
	CONTROLLER

inherit
	XWA_CONTROLLER redefine	make end

create
	make

feature {NONE} -- Initialization	

	make
			-- Initializes 'Current'
		do
			Precursor
		end

feature -- Basic Operations

	world: STRING
			-- Displays 'WORLD' or world depending on the current time
		local
			l_time: TIME
		do
			create l_time.make_now

			if l_time.second \\ 2 = 0 then
				Result := "WORLD"
			else
				Result := "world"
			end
		end


end
