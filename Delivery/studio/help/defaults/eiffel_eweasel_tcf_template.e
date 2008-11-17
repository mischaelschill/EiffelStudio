
indexing
	description: "[
			Summary description for {$TEST_CLASS_NAME}.
			This class is generated by {EW_EQA_TEST_EWEASEL_TCF_CONVERTER}
																			]"


class
	$TEST_CLASS_NAME

inherit
	EW_EQA_TEST_CONTROL_INSTRUCTIONS
		redefine
			on_prepare
		end

feature {NONE} -- Initialization

	test_setup: EW_EQA_WINDOWS_SETUP
			-- Helper for setup testing environment

	on_prepare is
			-- Setup testing environment
		do
			make
			create test_setup.make
			test_setup.setup
		end

feature -- Command$TCF_CONTENT

end
