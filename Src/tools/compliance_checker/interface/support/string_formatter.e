indexing
	description: "[
		Permits argument-based formatting of STRING instances.
	]"
	author     : "$Author$"
	date       : "$Date$"
	revision   : "$Revision$"

class
	EC_STRING_FORMATTER

inherit
	EXCEPTIONS
		export
			{NONE} all
		end

feature -- Conversion

	format (a_str: STRING; a_args: TUPLE): STRING is
			-- Replaces each format item in `a_str' with the text equivalent of a corresponding to 
			-- and object's value at `a_args' @ i.
			--
			-- Example:
			--     format ("Hello there {1}", ["Mr. Dobbs"])
			-- Yields:
			--     Hello there Mr. Dobbs.
			--
			-- The '{' '}' are defined by `open_char' and `close_char' respectivly. To escape open and close
			-- parameters qualifiers simply double them up.
			--
			-- Example:
			--     format ("He}}llo there {{", ["Mr. Dobbs"])
			-- Yields:
			--     He}llo there {
		require
			a_str_not_void: a_str /= Void
			not_a_str_is_empty: not a_str.is_empty
			a_args_not_void: a_args /= Void
			not_a_args_is_empty: not a_args.is_empty
		local
			l_count: INTEGER
			l_arg_count: INTEGER
			l_match: BOOLEAN
			l_skip: BOOLEAN
			l_digit: STRING
			l_index: INTEGER
			i: INTEGER
			c, n: CHARACTER
			o, cl: CHARACTER
		do
			l_count := a_str.count
			l_arg_count := a_args.count
			o := open_char
			cl := close_char

			create l_digit.make (2)
			create Result.make (l_count * 2)

			from
				i := 1
			until
				i > l_count
			loop
				c := a_str @ i
				if i < l_count then
					n := a_str @ (i + 1)
				end
				if c = o then
					if i < l_count then
						l_match := n /= o
						if not l_match then
							i := i + 1
							Result.append_character (n)
						end
					end
				elseif c = cl then
					l_skip := False
					if i < l_count then
						if n = cl then
							Result.append_character (n)
							i := i + 1
							l_skip := True
						end
					end
					if l_match and not l_skip then
						l_match := False
						if l_digit.is_integer then
							l_index := l_digit.to_integer
							if l_index > 0 and l_index <= l_arg_count then
								Result.append ((a_args @ l_index).out)
							else
								raise ("Invalid format index '" + l_index.out + "'")
							end
						else
							raise ("NaN '" + l_digit + "'")
						end
						l_digit.wipe_out						
					end
				elseif l_match then
					l_digit.append_character (c)
				else
					Result.append_character (c)
				end
				i := i + 1
			end
		ensure
			result_not_void: Result /= Void
			not_result_is_empty: not Result.is_empty
		end
		
feature {NONE} -- Symbols

	open_char: CHARACTER is '{'
			-- Index open character

	close_char: CHARACTER is '}'
			-- Index close character

end -- class EC_STRING_FORMATTER
