require( "iuplua" )

local std <const> =std
local iup <const> =iup


local function initvaltext(tbl)

	local properties=tbl or {expand="HORIZONTAL"}
	
	properties.expand=nil or "HORIZONTAL"
	properties.bgcolor=nil or "150 150 150"
	
	local txt=iup.text(properties )
	
	local FirstTimeClick=false
	
	
	function txt:button_cb()

             if(FirstTimeClick==false) then
                 txt.value=""
                 txt.bgcolor="255 255 255"
                  FirstTimeClick=true
              end
              
	end
	
	return txt
	
end



std.gui.initvaltext=initvaltext



-- Author:	Gokhan Bingol (gbingol@sciencesuit.org)
-- License: Subject to end-user license agreement conditions available at www.sciencesuit.org
