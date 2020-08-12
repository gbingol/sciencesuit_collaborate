-- Author:	Gokhan Bingol (gbingol@sciencesuit.org)
-- License: Subject to end-user license agreement conditions available at www.sciencesuit.org


require( "iuplua" )

local std <const> =std
local iup <const> =iup

local function frm()

	local IsThereSelection=false
	
	local NewSheet=iup.toggle{title="New Sheet"}
	local Selection=iup.toggle{title="Selection"}
	
	local RadioBox=iup.vbox{NewSheet,iup.space{size="x5"}, Selection}
	local RadioButtons=iup.radio{RadioBox}

	local txtSelection=std.gui.gridtext()
	txtSelection.active="NO"

	local GridboxOutput=iup.gridbox{RadioButtons,iup.hbox{txtSelection, alignment="acenter"}; 
							numdiv=2, HOMOGENEOUSCOL="yes",CGAPLIN=5, orientation="HORIZONTAL"}

	local OutputFrame=iup.frame{GridboxOutput, title="Output Options"}
	
	
	function Selection:action()
		txtSelection.active="YES"
		IsThereSelection=true
	end

	function NewSheet:action()
		txtSelection.active="NO"
		IsThereSelection=false
	end
	
	function OutputFrame:GetRange()
		if(IsThereSelection) then
			return Range.new(txtSelection.value)
		end
	
		return nil
	end
	
	function OutputFrame:setOwner(dlg)
		txtSelection:setOwner(dlg)
	end
		
	
	return OutputFrame
end


std.gui.frmOutput=frm
