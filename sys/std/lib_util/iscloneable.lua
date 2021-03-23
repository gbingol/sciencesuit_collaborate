local function iscloneable(container)
	
	--Test whether a container is iteratable or not
	
	--1) Lua tables are iteratable
	--2) if there is no metatable then it is not a container
	--3) if there metatable, it must have methods: "next" and __pairs
	

	if(type(container) == "table") then
		return false
	end

	local meta = getmetatable(container)

	local cloneable = (meta and meta["clone"]) 
	
	if(cloneable ) then
		return true
	end

	return false
end


std.util.iscloneable = iscloneable


-- Author:	Gokhan Bingol (gbingol@sciencesuit.org)
-- License: Subject to end-user license agreement conditions available at www.sciencesuit.org