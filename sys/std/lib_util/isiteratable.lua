
local function isiteratable(container)
	
	--Test whether a container is iteratable or not
	
	--1) Lua tables are iteratable
	--2) if there is no metatable then it is not a container
	--3) if there metatable, it must have methods: "next" and __pairs
	

	if(type(container) == "table") then
		return true
	end

	local m = getmetatable(container)

	local iteratable = (m and m["next"] and m["__pairs"]) 
	
	if(iteratable) then
		return true
	end

	return false
end


std.util.isiteratable=isiteratable


-- Author:	Gokhan Bingol (gbingol@sciencesuit.org)
-- License: Subject to end-user license agreement conditions available at www.sciencesuit.org