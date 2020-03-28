-- Author:	Gokhan Bingol (gbingol@sciencesuit.org)
-- License: Subject to end-user license agreement conditions available at www.sciencesuit.org


local function minmax(Container )

	--Container: Lua Table or an iteratable container

	assert(type(Container)~="number" and type(Container)~="string", "ERROR: An iteratable container is required")
      

	local m = getmetatable(Container)
	local n = (m and m["__pairs"] and m["next"])
      
	if(not n) then assert(type(Container)=="table","ERROR: Userdata must support __pairs metamethod") end
      
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

std.minmax=minmax
