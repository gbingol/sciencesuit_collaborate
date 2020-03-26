-- Author:	Gokhan Bingol (gbingol@hotmail.com)
-- License: Subject to end-user license agreement conditions available at www.sciencesuit.org

local function CUMTRAPZ_V(v1,v2)
	
	assert(type(v1)=="Vector", "ERROR: First argument must be of type Vector")
	assert(type(v2)=="Vector", "ERROR: Second argument must be of type Vector")
	
	
	return SYSTEM.cumtrapz(v1,v2)
end



local function CUMTRAPZ_FV(func, v2)

	assert(type(func)=="function", "ERROR: First argument must be of type function")
	assert(type(v2)=="Vector", "ERROR: Second argument must be of type Vector")
	
	
	return SYSTEM.cumtrapz(func,v2)
end



local function CUMTRAPZ_F(func, a, b, N)

	N=N or 10

	assert(type(func)=="function", "ERROR: First argument must be of type function")
	assert(type(a)=="number" and type(b)=="number", "ERROR: Second and third arguments must be of type number")
	assert(math.type(N)=="integer" and N>3, "ERROR: Fourth argument must be of type integer greater than 3")


	return SYSTEM.cumtrapz(func,a,b,N)
end





local function cumtrapz(...)
	
	local arg=table.pack(...)
	local nargs=#arg

	assert(nargs>0,"Usage: {f=, a=, b=, inter=10} or (f=, vec_x=) or (vec_x,= vec_y=)")
    
	
	if(nargs==1 and type(arg[1])=="table") then
		
		local f, a, b, N=nil, nil, nil, 10
		
		local NTblArgs=0
		
		for key, value in pairs(arg[1]) do
			key=string.lower(key)

			if(key=="f") then f=value
			elseif(key=="a") then a=value
			elseif(key=="b") then b=value
			elseif(key=="inter") then N=value
			else 
				error("ERROR: Unexpected key found, Usage: {f=, a=, b=, inter=10}", ERRORLEVEL) 
			end

			NTblArgs=NTblArgs+1
		end
		
		assert(NTblArgs>0, "Usage: {f=, a=, b=, inter=10}")
		
		
		return CUMTRAPZ_F(f, a, b, N)
			
	
	
	elseif(nargs==2) then
		
		--input: Vector, Vector
		if(type(arg[1])=="Vector") then
			
			return CUMTRAPZ_V(arg[1], arg[2])
		
		--input: function, Vector
		elseif(type(arg[1])=="function") then
			
			return CUMTRAPZ_FV(arg[1], arg[2])
		
		else
			
			error("(f=, vec_x=) or (vec_x,= vec_y=)" , ERRORLEVEL) 
		end
	

	else 
		error("Usage: {f=, a=, b=, inter=10} or (f=, vec_x=) or (vec_x,= vec_y=)" , ERRORLEVEL) 
	end
end



std.cumtrapz=cumtrapz
