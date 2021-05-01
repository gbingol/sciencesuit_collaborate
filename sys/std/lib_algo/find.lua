-- Author:	Gokhan Bingol (gbingol@sciencesuit.org)
-- License: Subject to end-user license agreement conditions available at www.sciencesuit.org


local std <const> =std


local function find(Container, value, tolerance)

	tolerance=tolerance or std.const.tolerance
    
    if(type(value)=="number") then
        return std.algo.findfirst_if(Container, function(x) return math.abs(x-value)<tolerance end)     
    end


    return std.algo.findfirst_if(Container, function(x) return x==value end)
end
    



std.algo.find = find




