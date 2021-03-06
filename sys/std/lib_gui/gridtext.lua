require( "iuplua" )

local std <const> =std
local iup <const> =iup

local function gridtext( tbl)

	tbl=tbl or {expand="HORIZONTAL", BGCOLOR="128 255 255"}
	
	local txt=iup.text(tbl )
	local OwnerDialog=iup.GetGlobal("PARENTDIALOG")
	local range=nil
	
	
	
	local function GetVariable(txt)
		local ws=std.activeworksheet()
		local range=ws:selection()
				
		if (range==nil)  then 
			return 
		end
		
		txt.value=tostring(range)
		
		if(OwnerDialog~=nil) then
			OwnerDialog.topmost="no"
		end
		
	end
	
	
	function txt:setOwner(dlg)
		OwnerDialog=dlg
	end
	
	
	function txt:range()
		return range
	end
	
	
	function txt:button_cb()
	
		if(OwnerDialog~=nil) then
			OwnerDialog.topmost="yes"
		end
		
		local ws=std.activeworksheet()
		
		
		ws:connect(GetVariable, txt)
		
	end
	
	
	return txt
end




std.gui.gridtext=gridtext



-- Author:	Gokhan Bingol (gbingol@sciencesuit.org)
-- License: Subject to end-user license agreement conditions available at www.sciencesuit.org


