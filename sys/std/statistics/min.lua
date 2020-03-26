-- Author:	Gokhan Bingol (gbingol@hotmail.com)
-- License: Subject to end-user license agreement conditions available at www.sciencesuit.org

local function min(elem)
     local min, max=std.minmax(elem)

     return min
end

std.min=min
