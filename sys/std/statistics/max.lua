-- Author:	Gokhan Bingol (gbingol@hotmail.com)
-- License: Subject to end-user license agreement conditions available at www.sciencesuit.org

local function max(elem)
	local min, max=std.minmax(elem)

     return max
end

std.max=max