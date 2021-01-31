local std <const> =std

local function findfirst_if(Container, func)
    
	local tbl=std.find_if(Container, func)

	if(type(tbl)=="table") then
		return tbl[1]
	end


	return nil

end




std.findfirst_if = findfirst_if



-- Author:	Gokhan Bingol (gbingol@sciencesuit.org)
-- License: Subject to end-user license agreement conditions available at www.sciencesuit.org
