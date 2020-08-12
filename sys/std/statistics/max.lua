-- Author:	Gokhan Bingol (gbingol@sciencesuit.org)
-- License: Subject to end-user license agreement conditions available at www.sciencesuit.org

local std <const> =std


local function max(elem)
	local min, max=std.minmax(elem)

     return max
end

std.max=max