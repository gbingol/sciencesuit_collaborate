-- Author:	Gokhan Bingol (gbingol@sciencesuit.org)
-- License: Subject to end-user license agreement conditions available at www.sciencesuit.org

local std <const> =std

local function trapezoidal(...)
	--Input: v1 and v2 as vectors
	local arg=table.pack(...)
	local nargs=#arg
	
	if(nargs==0) then
		error("Usage: {f=, a=, b=, inter=} or (f=, a=, b=)", std.const.ERRORLEVEL)
    
    
	-- input: Lua table
	elseif(nargs==1) then
		local f, a, b, N=nil, nil, nil, 100
		
		local NTblArgs=0
		
		for key, value in pairs(arg[1]) do
			key=string.lower(key)

			if(key=="f") then f=value
			elseif(key=="a") then a=value
			elseif(key=="b") then b=value
			elseif(key=="inter") then N=value
			else 
				error("ERROR: Unexpected key found.", std.const.ERRORLEVEL) 
			end

			NTblArgs=NTblArgs+1
		end
		
		assert(math.type(N)=="integer" and N>=2, "ERROR:Number of intervals must be a positive integer, >=2")
		
		assert(NTblArgs>0,"Usage: f=, a=, b=, inter=100")

		return SYSTEM.trapz_f(f, a, b, N)
			
	
	
	--input: v1, v2
	elseif(nargs==2) then
		assert(type(arg[1])=="Vector" and type(arg[2])=="Vector","ERROR: Both arguments must be of type Vector.")
        
		return SYSTEM.trapz_v(arg[1],arg[2])


	--Input: f, a, b
	elseif(nargs==3 ) then 
		assert(type(arg[1])=="function","ERROR: First argument must be of type function.")
		assert(type(arg[2])=="number" and type(arg[3])=="number","ERROR: Second and third arguments must be numbers")
		
		local f,a,b=arg[1], arg[2], arg[3]
	
		return SYSTEM.trapz_f(f,a,b)
        
	--no match
	else 
		error("ERROR: The combination of the type of arguments could not be found." , std.const.ERRORLEVEL) 
	end
	
	
end



std.trapz=trapezoidal
