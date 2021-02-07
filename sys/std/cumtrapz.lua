local std <const> =std

local function CUMTRAPZ_V(v1, v2)
	
	assert(type(v1)=="Vector" or type(v1)=="Array", "First arg must be Vector/Array")
	assert(type(v2)=="Vector" or type(v2)=="Array", "Second arg must be Vector/Array")
	
	
	return SYSTEM.cumtrapz(v1, v2)
end



local function CUMTRAPZ_FV(func, v2)

	assert(type(func)=="function", "First arg must be function")
	assert(type(v2)=="Vector" or type(v2)=="Array", "Second arg must be Vector/Array")
	
	
	return SYSTEM.cumtrapz(func,v2)
end



local function CUMTRAPZ_F(func, a, b, N)

	N=N or 10

	assert(type(func)=="function", "f must be function")
	assert(type(a)=="number" and type(b)=="number", "a and b must be of type number")
	assert(math.type(N)=="integer" and N>3, "inter must be integer > 3")


	return SYSTEM.cumtrapz(func, a, b, N)
end





local function cumtrapz(...)
	
	local arg=table.pack(...)
	local nargs=#arg

	assert(nargs>0,"Usage: {f=, a=, b=, inter=10} or (f=, vec_x=) or (vec_x,= vec_y=)")
    
	
	if(nargs==1 and type(arg[1])=="table") then
		
		local f, a, b, N=nil, nil, nil, 10
		local ContX, ContY = nil, nil
		local Nodes = nil
		
		local NTblArgs=0
		
		for key, value in pairs(arg[1]) do
			key=string.lower(key)

			if(key=="f") then f=value
			elseif(key=="a") then a=value
			elseif(key=="b") then b=value
			elseif(key=="inter") then N=value
			elseif(key=="x") then ContX=value
			elseif(key=="y") then ContY=value
			elseif(key=="nodes") then Nodes=value 
			else 
				error("Keys: {x=, y=, f=, a=, b=, nodes=, inter=10}", std.const.ERRORLEVEL) 
			end

			NTblArgs=NTblArgs+1
		end
		
		assert(NTblArgs>0, "Usage: {[x=], [y=], [f=], [nodes=], [a=], [b=], [inter=10]}")
		
		
		--Min 3 parameters (f, a, b) required for the function integrated within a bound
		if(NTblArgs>=3) then
			assert(f ~=nil and a ~= nil and b~=nil, "If more than 2 params defined f, a and b must be defined")
			
			assert(ContX == nil, "If f, a, b and/or inter are defined, x cant be defined")
			assert(ContY == nil, "If f, a, b and/or inter are defined, y cant be defined")
			assert(Nodes == nil, "If f, a, b and/or inter are defined, nodes cant be defined")
			
			--return type is vector
			return CUMTRAPZ_F(f, a, b, N)
		end

		
		--if not the above combination, then a few checks must be done before selecting the correct function

		--either x or f must be defined
		if(ContX == nil and f == nil) then
			error("Either x or f must be defined.", std.const.ERRORLEVEL)
		end


		--if f defined, at this stage we expect either x or y to be defined
		if(f ~=nil) then
			assert(Nodes ~= nil,"If f is defined, then either breaks OR (a and b) must be defined.")
			assert(ContY == nil or ContX == nil, "If f is defined, then either nodes OR (a and b) must be defined.")
			
			assert(type(Nodes) == "Vector" or type(Nodes) == "Array", "breaks must be Array/Vector")
			
			
			return CUMTRAPZ_FV(f, Nodes)
			
		end


		--At this point, if x defined then y must be defined
		if(ContX ~=nil) then
			assert(ContY ~= nil, "If x is defined, then y also must be defined")
			
			return CUMTRAPZ_V(ContX, ContY)
		end


		--we exhausted all possible combinations
		error("No matching combination deduced", std.const.ERRORLEVEL)
	
	
	elseif(nargs==2) then
		
		--input: Vector, Vector
		if(type(arg[1])=="Vector" or type(arg[1])=="Array") then
			return CUMTRAPZ_V(arg[1], arg[2])
		
		--input: function, Vector/Array
		elseif(type(arg[1])=="function") then
			assert(type(arg[2])=="Vector" or type(arg[2])=="Array", "Vector/Array expected")
			
			return CUMTRAPZ_FV(arg[1], arg[2])
		
		else
			error("(f=, breaks=) or (x=, y=)" , std.const.ERRORLEVEL) 
		end
	

	else 
		error("Usage: {f=, a=, b=, inter=10} or (f=, breaks=) or (x,= y=)" , std.const.ERRORLEVEL) 
	end
end






std.cumtrapz=cumtrapz






-- Author:	Gokhan Bingol (gbingol@sciencesuit.org)
-- License: Subject to end-user license agreement conditions available at www.sciencesuit.org
