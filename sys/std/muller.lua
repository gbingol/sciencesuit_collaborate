local std <const> =std


local function MULLER(...)

	local arg=table.pack(...)
	
	if(#arg==1  and type(arg[1])=="table") then
		local func, x0, x1, x2, h , tol, maxiter=nil, nil, nil, nil, nil, nil, nil
		
		local NTblArgs=0

		for k,v in pairs(arg[1]) do
			
			local key=string.lower(k)
			
			if(key=="f") then func=v
			elseif(key=="x0") then x0=v
			elseif(key=="x1") then x1=v
			elseif(key=="x2") then x2=v
			elseif(key=="h") then h=v
			elseif(key=="tol") then tol=tonumber(v)
			elseif(key=="maxiter") then maxiter=tonumber(v)
			else 
				error("Usage: {f=, x0=, [h=0.5], [x1=nil], [x2=nil], [tol=1E-5], [maxiter=100]}", std.const.ERRORLEVEL)
			end

			NTblArgs=NTblArgs + 1

		end
		
		--we need at least 2 values
		assert(NTblArgs>=2, "Signature: {f=, x0=, [h=0.5], [x1=nil], [x2=nil], [tol=1E-5], [maxiter=100]}")

		
		--In all cases f and x0 must be provided
		assert(type(func)=="function", "\"f\" must be function")
		
		assert(type(x0) == "number" or type(x0) == "Complex", "x0 must be Complex/real number")
		
		
		
		maxiter=maxiter or 100
		
		tol=tol or 1E-5
		
		assert(math.type(maxiter)=="integer" and maxiter>0,"Key maxiter must be positive integer")
		assert(type(tol)=="number" and tol>0, "Key tol must be positive number")
		
		--if x1 and x2 provided, then no need for h
		if(x1 ~= nil and x2 ~= nil) then
			assert(type(x1) == "number" or type(x1) == "Complex", "x1 must be Complex/real number")
			assert(type(x2) == "number" or type(x2) == "Complex", "x2 must be Complex/real number")
			
			assert(h == nil, "if x1 and x2 provided, h cannot be used")
			
			return SYSTEM.muller_x012(func, x0, x1, x2, tol, maxiter)
		end



		h=h or 0.5
		
		assert(type(h) == "number" or type(h) == "Complex", "h must be Complex/real number")
		
		assert(x1 == nil and x2 == nil, "if h is provided, x1 and x2 cannot be used")
		
		return SYSTEM.muller_x0(func, x0, h, tol, maxiter)
		


	elseif (#arg==2 ) then
		assert(type(arg[1]) == "function", "second param must be Complex/real number")
		assert(type(arg[2]) == "number" or type(arg[2]) == "Complex", "second param must be Complex/real number")

		return SYSTEM.muller_x0(arg[1], arg[2])
		
	else
		error("std.muller accepts either a single param as Lua table or 2 parameters", std.const.ERRORLEVEL)
	end
end
			
			
		
		

	
std.muller =  MULLER		





-- Author:	Gokhan Bingol (gbingol@sciencesuit.org)
-- License: Subject to end-user license agreement conditions available at www.sciencesuit.org