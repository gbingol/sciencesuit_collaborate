-- Author:	Gokhan Bingol (gbingol@hotmail.com)
-- License: Subject to end-user license agreement conditions available at www.sciencesuit.org



local function Interpolation(x1, y1, x2, y2, val)
	
	-- Used within fluids library and performs simple linear interpolation

	assert(x1 ~= nil and y1 ~= nil and x2 ~= nil and y2 ~= nil and val ~= nil, "Five params required (all numbers)")

	-- Given 2 data points (x1,y1) and (x2,y2) we are looking for the y-value of the point x=val 
	if(x1 == x2) then 
		return y1 
	end

	local m,n=0, 0
	m = (y2 - y1) / (x2 - x1)
	n = y2 - m * x2

	return m * val + n
end



std.fluid.interpolate = Interpolation