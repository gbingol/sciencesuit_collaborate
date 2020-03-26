-- Author:	Gokhan Bingol (gbingol@hotmail.com)
-- License: Subject to end-user license agreement conditions available at www.sciencesuit.org


local function findfirst_if(Container, func)
    
	local tbl=std.find_if(Container, func)

	if(type(tbl)=="table") then
		return tbl[1]
	end


	return nil

end

std.findfirst_if = findfirst_if
