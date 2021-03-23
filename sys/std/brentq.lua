local std <const> =std


local function BRENTQ(f,a, b, tolerance, MaxIterations)

        -- Finding root of an equation using Newton-Raphson Method
        -- Input: f a function, X0 is initial guess

	assert(type(f)=="function", "f must be function.") 
	 
	assert(type(a)=="number", "a must be number" ) 
	
	assert(type(b)=="number", "b must be number" ) 
	
	tolerance=tolerance or 1E-5
	MaxIterations=MaxIterations or 100

	assert(math.type(MaxIterations)=="integer" and MaxIterations>0,"maxiter must be positive integer")
	assert(type(tolerance)=="number" and tolerance>0, "tol must be positive number")
	
      return SYSTEM.brentq(f, a, b, tolerance, MaxIterations)
end


local function brentq(...)
	local arg=table.pack(...)
	
	if(#arg==1  and type(arg[1])=="table") then
		local func, a, b, tol, maxiter=nil, nil, nil, nil, nil
		local NTblArgs=0

		for k,v in pairs(arg[1]) do
			
			local key=string.lower(k)
			
			if(key=="f") then func=v
			elseif(key=="a") then a=tonumber(v)
			elseif(key=="b") then b=tonumber(v)
			elseif(key=="tol") then tol=tonumber(v)
			elseif(key=="maxiter") then maxiter=tonumber(v)
			else 
				error("Usage: {f=, a=, b=, tol=1E-5, maxiter=100}", std.const.ERRORLEVEL)
			end

			NTblArgs=NTblArgs+1

		end
		
		assert(NTblArgs>0, "Usage: {f=, a=, b=, tol=1E-5, maxiter=100}")

		
		
		return BRENTQ(func, a, b, tol, maxiter)
			
			
	
	elseif (#arg==3) then	
		return BRENTQ(arg[1], arg[2], arg[3])
	end

end




std.brentq=brentq



-- Author:	Gokhan Bingol (gbingol@sciencesuit.org)
-- License: Subject to end-user license agreement conditions available at www.sciencesuit.org
	
	
