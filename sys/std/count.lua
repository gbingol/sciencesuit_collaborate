-- Author:	Gokhan Bingol (gbingol@sciencesuit.org)
-- License: Subject to end-user license agreement conditions available at www.sciencesuit.org

local function count(...)
	local args=table.pack(...)
	local nargs=#args
	
	assert(nargs>0, "At least 1 argument must be supplied")
	
	
	if(nargs==1 and type(args[1])=="table" ) then
		
		local tbl=args[1]
		
		local container, breaks, left, right=tbl[1], "FD", false, true
		
		assert(type(container)=="Array" or type(container)=="Vector", "First argument must be either a Vector or an Array")
		
		for key,val in pairs(args[1]) do
			
			key=string.lower(key)

			if(tonumber(key)==nil) then
			
				if(key == "breaks") then breaks = val
				elseif(key == "left") then left = val
				elseif(key == "right") then right = val
				else 
					error("ERROR: Unrecognized key="..key.. ". Keys can be: breaks, left and right.", ERRORLEVEL) 
				end
			
			end

		
		end

		return SYSTEM.count(container, breaks, left, right)
	end


	
	local container, breaks, left, right=args[1], args[2],args[3], args[4]
	
	if(nargs==1) then
		return SYSTEM.count(container)
	elseif(nargs==2) then
		return SYSTEM.count(container, breaks)
	elseif(nargs==3) then
		return SYSTEM.count(container, breaks, left)
	elseif(nargs==4) then
		return SYSTEM.count(container, breaks, left, right)
	end
	
	
end



std.count=count