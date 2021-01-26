local std <const> =std



local function minmax(Container, Axes )

	--Container: Lua Table or an iteratable container

	assert(Container~=nil, "Container cannot be nil value")
	
	assert(type(Container)~="number" and type(Container)~="string", "An iteratable container is required")
      
      
      
      
	if(type(Container)=="Vector" or type(Container)=="Array") then
		return Container:minmax()
		
	elseif(type(Container)=="Matrix") then
		
		if(Axes==nil) then
			return Container:minmax()
			
		else
			assert(math.type(Axes)=="integer" and(Axes==0 or Axes==1), "Axes must be an integer with a value of 0 or 1")
			
			return Container:minmax(Axes)
		end
	end

	
	
	
	--Generalized version

	local m = getmetatable(Container)
	local n = (m and m["__pairs"] and m["next"])
      
	if(not n) then 
		assert(type(Container)=="table","Userdata must support __pairs metamethod")
	end  
      
	local min, max=nil, nil
	  
     
	local key=nil
	key,min=next(Container,nil)

	max=min

	for key,value in pairs(Container) do
		
		if(value<=min) then min=value end
		
		if(value>=max) then max=value end
		
	end

            
	return min, max

end










local function min(Container, Axes)
	
	local min, max=nil, nil
	
	
	
	if(type(Container)=="table" and (type(Container[1])=="Vector" or type(Container[1])=="Matrix")) then
		
		local Elem=Container[1]
		
		min, max=minmax(Elem, Container["axes"])
		
		return min
		
	end
	
	
	min, max=minmax(Container, Axes)

	return min
end








local function max(Container, Axes)
	
	local min, max=nil, nil
	

	if(type(Container)=="table" and (type(Container[1])=="Vector" or type(Container[1])=="Matrix")) then
		
		min, max=minmax(Container[1], Container["axes"])
		
		return max
		
	end
	
	
	min, max=minmax(Container, Axes)

	return max
end






std.minmax=minmax
std.min=min
std.max=max




-- Author:	Gokhan Bingol (gbingol@sciencesuit.org)
-- License: Subject to end-user license agreement conditions available at www.sciencesuit.org
