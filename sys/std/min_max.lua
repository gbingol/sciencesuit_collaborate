-- Author:	Gokhan Bingol (gbingol@sciencesuit.org)
-- License: Subject to end-user license agreement conditions available at www.sciencesuit.org

local std <const> =std



local function min(Container, Axes)
	
	local min, max=nil, nil
	
	
	
	if(type(Container)=="table" and (type(Container[1])=="Vector" or type(Container[1])=="Matrix")) then
		
		local Elem=Container[1]
		
		min, max=std.minmax(Elem, Container["axes"])
		
		return min
		
	end
	
	
	min, max=std.minmax(Container, Axes)

	return min
end




local function max(Container, Axes)
	
	local min, max=nil, nil
	

	if(type(Container)=="table" and (type(Container[1])=="Vector" or type(Container[1])=="Matrix")) then
		
		min, max=std.minmax(Container[1], Container["axes"])
		
		return max
		
	end
	
	
	min, max=std.minmax(Container, Axes)

	return max
end




std.min=min
std.max=max
