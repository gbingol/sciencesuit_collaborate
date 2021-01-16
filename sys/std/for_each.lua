-- Author:	Gokhan Bingol (gbingol@sciencesuit.org)
-- License: Subject to end-user license agreement conditions available at www.sciencesuit.org

local std <const> =std


local function foreach(Container, func,...)

	--func : A function
	-- ... : Possible second, third, fourth etc... arguments of the func
	--Container: Lua Table or an iteratable container

      assert(type(Container)~="number" and type(Container)~="string", "An iteratable container is required")
      
      assert(type(func)=="function", "Second arg must be a unary function ")
      
      local func_args=table.pack(...)
      

	local m = getmetatable(Container)
	local n = (m and m["__pairs"] and m["__newindex"])
	  
	if n then
		--we assume that all containers with metatables support linear access model such as m[{1}] or vec[{1}}
		for key,value in pairs(Container) do
			Container[{key}]=func(value,table.unpack(func_args))
		end
            
	else
		for key, value in pairs(Container) do
			Container[key]=func(value,table.unpack(func_args))
		end
	end
	
	return Container

end

std.for_each=foreach
