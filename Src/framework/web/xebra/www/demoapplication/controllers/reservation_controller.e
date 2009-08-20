note
	description: "[
		no comment yet
	]"
	legal: "See notice at end of class."
	status: "Pre-release"
	date: "$Date$"
	revision: "$Revision$"

class
	RESERVATION_CONTROLLER

inherit
	DEMOAPPLICATION_CONTROLLER

create
	default_create

feature -- Status Change	

	get_res_id_from_args: STRING
			-- Retrieve reservartion ID from request arguments
		do
			Result := ""
			if attached {STRING} current_request.argument_table["id"] as id then
				if attached {RESERVATION} global_state.db.reservation_by_id (id.to_integer_32) as res then
					Result := res.id.out
				end
			end
		ensure
			Result_attached: Result /= Void
		end

	save (a_bean: ANY)
		do
			if attached {RESERVATION} a_bean as l_reservation then
				global_state.db.reservations.extend (l_reservation)
			end
		end

	delete (a_bean: detachable ANY)
		do
			if attached {RESERVATION} a_bean as l_reservation then
				global_state.db.reservations.start
				global_state.db.reservations.prune (l_reservation)
			end
		end

	get_res_name_from_args: STRING
			-- Retrieve reservartion name from request arguments
		do
			Result := ""
			if attached {STRING} current_request.argument_table["id"] as id then
				if attached {RESERVATION} global_state.db.reservation_by_id (id.to_integer_32) as res then
					Result := res.name
				end
			end
		ensure
			Result_attached: Result /= Void
		end

	get_res_date_from_args: DATE
			-- Retrieve reservartion date from request arguments
		do
			create Result.make_now
			if attached {STRING} current_request.argument_table["id"] as id then
				if attached {RESERVATION} global_state.db.reservation_by_id (id.to_integer_32) as res then
					Result := res.date
				end
			end
		ensure
			Result_attached: Result /= Void
		end

	get_res_persons_from_args: STRING
			-- Retrieve reservartion persons from request arguments
		do
			Result := ""
			if attached {STRING} current_request.argument_table ["id"] as id then
				if attached {RESERVATION} global_state.db.reservation_by_id (id.to_integer_32) as res then
					Result := res.persons.out
				end
			end
		ensure
			Result_attached: Result /= Void
		end

	get_res_description_from_args: STRING
			-- Retrieve reservartion description from request arguments
		do
			Result := ""
			if attached {STRING} current_request.argument_table ["id"] as id then
				if attached {RESERVATION} global_state.db.reservation_by_id (id.to_integer_32) as res then
					Result := res.description
				end
			end
		ensure
			Result_attached: Result /= Void
		end

	logged_in_name: STRING
			-- Retrieve the name of the person logged in
		do
			Result := ""
			if attached {USER} session.item ("auth") as user then
				Result := user.name
			end
		ensure
			Result_attached: attached Result
		end

end
