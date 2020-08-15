-- Author:	Gokhan Bingol (gbingol@sciencesuit.org)
-- License: Subject to end-user license agreement conditions available at www.sciencesuit.org


local std <const> =std

local function gcd(...)
	--INPUT: 	Two or more integers
	--OUTPUT: 	Greatest common divisor

	
	local arg=table.pack(...)
	
	if(#arg==1) then
		error("At least 2 arguments of type integer must be provided")
	end
	
	
	if(#arg==2) then
		local val=SYSTEM.gcd(arg[1],arg[2])
		
		return val
	end
	
	local gcds={}
	
	for i=2,#arg do
		
		local val=SYSTEM.gcd(arg[1],arg[i])
		
		if(val==1) then 
			return 1
		end
		
		gcds[i-1]=val
	end
	

	local val= gcd(table.unpack(gcds))
	
	
	if(type(val)=="number") then
		return val
	end

end

std.gcd=gcd
