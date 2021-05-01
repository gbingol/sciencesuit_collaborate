-- Author:	Gokhan Bingol (gbingol@sciencesuit.org)
-- License: Subject to end-user license agreement conditions available at www.sciencesuit.org


local std <const> =std


local function findfirst_if(Container, func)
    
	local tbl=std.algo.find_if(Container, func)

	if(type(tbl)=="table") then
		return tbl[1]
	end


	return nil

end




std.algo.findfirst_if = findfirst_if