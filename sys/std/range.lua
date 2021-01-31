local std <const> =std


local function range(elem)
	--Finds the range: max-min

	local min, max=nil, nil
     	min, max=std.minmax(elem)

     return max-min
	
end



std.range=range



-- Author:	Gokhan Bingol (gbingol@sciencesuit.org)
-- License: Subject to end-user license agreement conditions available at www.sciencesuit.org