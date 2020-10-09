-- Author:	Gokhan Bingol (gbingol@sciencesuit.org)
-- License: Subject to end-user license agreement conditions available at www.sciencesuit.org

require( "iuplua" )

local std <const> =std
local iup <const> =iup


local function numtext(tbl)

	local properties=tbl or {expand="HORIZONTAL"}
	
	properties.expand=nil or "HORIZONTAL"
	
	local min=tonumber(properties.min)
	local max=tonumber(properties.max)
	
	local txt=iup.text(properties )
	
	
	if(min~=nil and max~=nil) then
		txt.tip="["..tostring(min)..","..tostring(max).."]"
		
	elseif(min~=nil) then
		txt.tip=">="..tostring(min)
		
	elseif(max~=nil) then
		txt.tip="<="..tostring(max)
	
	end
	
	
	function txt:valuechanged_cb()
		
		local curVal=txt.value
		local length=curVal:len()
		
		txt.bgcolor="255 255 255"
		
		if(length==0) then
			txt.bgcolor="255 255 255"
			return
		end
		
		if(length==1) then
			local c=string.byte(curVal)
			if((c>=65 and c<=90) or (c>=97 and c<=122)) then
				txt.value=""
				
				return
			end
		end
		
		
		local numval=tonumber(curVal)
		
		if(numval==nil) then
			txt.bgcolor="255 0 0"
			
			return
			
		else
			txt.bgcolor="255 255 255"
		end


		--It is not mandatory for user to specify a min value
		if(min~=nil) then
			if(numval<min) then 
				txt.bgcolor="255 255 0"
			end
		end
		
		
		--It is not mandatory for user to specify a max value
		if(max~=nil) then
			if(numval>max) then 
				txt.bgcolor="255 255 0"
			end
		end

	end
	
	return txt
end


std.gui.numtext=numtext
