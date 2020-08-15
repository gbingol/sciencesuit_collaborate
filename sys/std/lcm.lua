-- Author:	Gokhan Bingol (gbingol@sciencesuit.org)
-- License: Subject to end-user license agreement conditions available at www.sciencesuit.org

local std <const> =std

local function lcm(...)
	--INPUT: 	Two or more integers
	--OUTPUT: 	Least common multiplier

	
	local arg=table.pack(...)
	
	if(#arg==1) then
		error("At least 2 arguments of type integer must be provided")
	end
	
	
	if(#arg==2) then
		local val=SYSTEM.lcm(arg[1],arg[2])
		
		return val
	end
	
	local LCMS={}
	
	for i=2,#arg do
		
		local val=SYSTEM.lcm(arg[1],arg[i])
		
		if(val==1) then 
			return 1
		end
		
		LCMS[i-1]=val
	end
	

	local val= lcm(table.unpack(LCMS))
	
	
	if(type(val)=="number") then
		return val
	end

end


std.lcm=lcm
