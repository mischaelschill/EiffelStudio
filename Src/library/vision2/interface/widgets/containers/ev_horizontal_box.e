indexing

	description: 
		"EiffelVision horizontal box."
	status: "See notice at end of class"
	id: "$Id$"
	date: "$Date$"
	revision: "$Revision$"
	
class 
	EV_HORIZONTAL_BOX

inherit

	EV_BOX
		redefine
			make,			
			implementation
		end
	
creation
	
	make
	
feature {NONE} -- Initialization

        make (parent: EV_CONTAINER) is
                        -- Create a fixed widget with, `parent' as
                        -- parent
		do
			!EV_HORIZONTAL_BOX_IMP!implementation.make (parent)
			Precursor (parent)
		end	
	
feature {NONE} -- Implementation
	
	implementation: EV_HORIZONTAL_BOX_I
			
end -- class EV_HORIZONTAL_BOX
