note
	description: "Summary description for {XML_FILE_INPUT_STREAM}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	XML_FILE_INPUT_STREAM

inherit
	XML_INPUT_STREAM

create
	make

feature {NONE} -- Initialization

	make (a_file: FILE)
			-- Create current stream for file `a_file'
		require
			a_file_attached: a_file /= Void
		do
			name := a_file.name			
			create previous_chunk.make_empty
			current_chunk := previous_chunk
			chunk_size := default_chunk_size
			count := a_file.count
			source := a_file
		end

feature -- Access

	name: STRING
			-- Name of current stream

feature -- Status report

	count: INTEGER

	end_of_input: BOOLEAN
		do
			Result := (chunk_source_upper > 0) and then --| started reading
					index >= chunk_source_upper and ((chunk_source_upper - chunk_source_lower + 1) < chunk_size)
		end

	is_open_read: BOOLEAN
		do
			Result := source.is_open_read
		end

feature -- Access

	index: INTEGER

	line: INTEGER

	column: INTEGER

	last_character: CHARACTER

feature -- Chunk

	chunk_size: INTEGER
			-- Size of buffer to read at once

	maximum_chunk_size: INTEGER
			-- Maximum size of chunk

feature -- Element change

	set_chunk_size (v: like chunk_size)
			-- Set `chunk_size' to `v'
		require
			chunk_size_positive: chunk_size > 0
		do
			chunk_size := v
		end

	compute_smart_chunk_size (a_maximum_chunk_size: INTEGER)
			-- Compute a optimized chunk size under `a_maximum_chunk_size' (if not zero)
		require
			maximum_chunk_size_positive_or_zero: maximum_chunk_size >= 0
		local
			n: INTEGER
		do
			n := count // 100
			if n > chunk_size then
				chunk_size := chunk_size.max (n - (n \\ default_chunk_size))
				if a_maximum_chunk_size > 0 and chunk_size > a_maximum_chunk_size then
					chunk_size := a_maximum_chunk_size
				end
			end
		end

feature -- Basic operation

	start
		do
			source.start
			chunk_source_upper := -1
			chunk_source_lower := -1
			index := 0
			line := 1
			column := 0
			previous_line_count := 0
		end

	close
		do
			chunk_source_upper := -1
			chunk_source_lower := -1
			create previous_chunk.make_empty
			current_chunk := previous_chunk
		end

	read_character
		local
			c: CHARACTER
		do
			index := index + 1
			if index > chunk_source_upper then
				previous_chunk.wipe_out
				previous_chunk.append (current_chunk)

				source.read_stream (chunk_size)
				current_chunk := source.last_string
				chunk_source_lower := index
				chunk_source_upper := chunk_source_lower + current_chunk.count - 1
				debug ("XML")
					print ("read_character: lower="+ chunk_source_lower.out + " upper=" + chunk_source_upper.out)
					print ("%T" +  (100 * chunk_source_upper // count).out + "%%")
					print ("%N")
				end
			end
			if index < chunk_source_lower then
				c := previous_chunk.item (1 + index - chunk_source_lower - chunk_size)
			else
				c := current_chunk.item (1 + index - chunk_source_lower)
			end
--			source.read_character
--			c := source.last_character

			if last_character = '%N' then
				line := line + 1
				previous_line_count := column
				column := 0
			else
				column := column + 1
			end

			last_character := c
		end

	rewind
		do
			index := index - 1
			if index < chunk_source_lower then
				check previous_chunk.count = chunk_size end
				last_character := previous_chunk.item (1 + index - chunk_source_lower + chunk_size)
			else
				last_character := current_chunk.item (1 + index - chunk_source_lower)
			end
			if last_character = '%N' then
				line := line - 1
				column := previous_line_count
				previous_line_count := 0 --| if we rewind more than one line, too bad
			else
				column := column - 1
			end
		end

feature {NONE} -- Implementation

	chunk_source_lower: INTEGER
			-- Lower index of current chunk

	chunk_source_upper: INTEGER
			-- Upper index of current chunk

	current_chunk: STRING
			-- Current chunk

	previous_chunk: STRING
			-- Previous chunk

	previous_line_count: INTEGER
			-- Keep previous line's length
			-- to set the `column' during `rewind'			

	default_chunk_size: INTEGER = 4096
			-- default chunk_size

	source: FILE
			-- Source for the stream

invariant
	source_attached: source /= Void

note
	copyright: "Copyright (c) 1984-2010, Eiffel Software and others"
	license: "Eiffel Forum License v2 (see http://www.eiffel.com/licensing/forum.txt)"
	source: "[
			Eiffel Software
			5949 Hollister Ave., Goleta, CA 93117 USA
			Telephone 805-685-1006, Fax 805-685-6869
			Website http://www.eiffel.com
			Customer support http://support.eiffel.com
		]"
end
