-- Author:	Gokhan Bingol (gbingol@sciencesuit.org)
-- License: Subject to end-user license agreement conditions available at www.sciencesuit.org


local std <const> =std

local function find(Container, value, tolerance)

	tolerance=tolerance or 1E-5
    
    if(type(value)=="number") then
        return std.findfirst_if(Container, function(x) return math.abs(x-value)<tolerance end)
	        
    else
        return std.findfirst_if(Container, function(x) return x==value end)

    end
end
    

std.find = find
