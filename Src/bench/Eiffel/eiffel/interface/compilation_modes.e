indexing
	description: "Status of current compilation."
	date: "$Date$"
	revision: "$Revision $"

class
	COMPILATION_MODES

feature -- Properties

	is_freezing, is_finalizing,
	is_precompiling, is_quick_melt: BOOLEAN
			-- Type of compilation.

	need_melt: BOOLEAN
			-- Do we need to do a `melt' even if the user choose `quick melt'.

feature -- Update

	set_is_freezing is
			-- Set `is_freezing' to `True'
		do
			is_freezing := True
		end

	set_is_quick_melt is
			-- Set `is_freezing' to `True'
		do
			is_quick_melt := True
		end

	set_need_melt is
			-- Set `need_melt' to `True'.
		do
			need_melt := True
		end

	set_is_finalizing is
			-- Set `is_finalizing' to `True'
		do
			is_finalizing := True
		end

	set_is_precompiling (b: BOOLEAN) is
			-- Set `is_precompiling' to `b'
		do
			is_precompiling := b
		end

feature -- Setting

	reset_modes is
		do
			need_melt := False
			is_quick_melt := False
			is_freezing := False
			is_finalizing := False
			is_precompiling := False
		end

end -- class COMPILATION_MODES
