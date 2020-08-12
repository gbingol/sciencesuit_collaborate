-- Author:	Gokhan Bingol (gbingol@sciencesuit.org)
-- License: Subject to end-user license agreement conditions available at www.sciencesuit.org


local std <const> =std

local function find_minmax(Container)

	--Container: Lua Table or an iteratable container
	
	--Returns the locations which has the minimum and maximum value
	
	assert(type(Container)~="number" and type(Container)~="string", "ERROR: An iteratable container is required")
      

	local m = getmetatable(Container)
	local n = (m and m["__pairs"] and m["next"])
	
	if(not n) then 
		assert(type(Container)=="table","ERROR: Userdata must support __pairs metamethod") 
	end
	
      
	local min, max=nil, nil
	  
	if n then
		local key=nil
		key,min=next(Container,nil)
	else
		key,min=next(Container,nil)
	end

	max=min
	
	local keymin, keymax=nil, nil

	for key,value in pairs(Container) do
		if(value<=min) then 
			min=value 
			keymin=key
		end
		
		if(value>=max) then 
			keymax=key
			max=value 
		end
	end
	
            
	return keymin, keymax

end

std.find_minmax=find_minmax
