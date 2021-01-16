-- Author:	Gokhan Bingol (gbingol@sciencesuit.org)
-- License: Subject to end-user license agreement conditions available at www.sciencesuit.org


local std <const> =std

local function simpson(...)
	
	local arg=table.pack(...)
	local nargs=#arg

	-- input: Lua table
	if(nargs==1 and type(arg[1]=="table")) then

		local f, a, b, inter=nil, nil, nil, 100

		local NTableArgs=0

		for key, value in pairs(arg[1]) do

			local key=string.lower(key)

			if(key=="f") then f=value
			elseif(key=="a") then a=value
			elseif(key=="b") then b=value
			elseif(key=="inter") then inter=value
			else 
				error("Usage: {f=, a=, b=, inter=100}", std.const.ERRORLEVEL) 
			end

			NTableArgs=NTableArgs+1
		end

		assert(NTableArgs>=3,"Usage: {f=, a=, b=, inter=100}")

		assert(type(f)=="function","f must be function.")
		
		assert(type(a)=="number" and type(b)=="number","a and b must be numbers.")
		
		assert(math.type(inter)=="integer" and inter>3 and inter%2==0, "inter must be an even integer greater than 3.")
		
		return SYSTEM.simpson(f, a, b, inter)
			

	--Input: f, a, b
	elseif(nargs==3 ) then 
		assert(type(arg[1])=="function","First arg must be of type function.")
		assert(type(arg[2])=="number" and type(arg[3])=="number","Second and third args must be numbers")

		local f,a,b=arg[1], arg[2], arg[3]
	
		return SYSTEM.simpson(f,a,b,100)
        
	--no match
	else 
		error("Usage: {f=, a=, b=, inter=100} or (f=, a=, b=)" , std.const.ERRORLEVEL) 
	end
end



std.simpson=simpson
