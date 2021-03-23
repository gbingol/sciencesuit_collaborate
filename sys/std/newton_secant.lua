local std <const> =std


local function NewtonRaphson(f,X0, fprime, tolerance, MaxIterations)

        -- Finding root of an equation using Newton-Raphson Method
        -- Input: f a function, X0 is initial guess

	assert(type(f)=="function", "f must be function.") 
	 
	assert(type(X0)=="number", "x0 must be number" ) 
	
	assert(type(fprime)=="function", "fprime must be function.") 
	
	tolerance=tolerance or 1E-5
	MaxIterations=MaxIterations or 100
	
      return SYSTEM.newtonraphson(f, X0, fprime, tolerance, MaxIterations)
end


local function Secant(f,X0, X1, tolerance, MaxIterations)

        -- Finding root of an equation using Newton-Raphson Method
        -- Input: f a function, X0 is initial guess

	assert(type(f)=="function", "f must be function.") 
	 
	assert(type(X0)=="number", "x0 must be number" ) 
	
	assert(type(X1)=="number", "x1 must be number" ) 
	
	tolerance=tolerance or 1E-5
	MaxIterations=MaxIterations or 100
	
      return SYSTEM.secant(f, X0, X1, tolerance, MaxIterations)
end


local function newton_secant(...)
	local arg=table.pack(...)
	
	if(#arg==1  and type(arg[1])=="table") then
		local func, x0,x1, fprime, tol, maxiter=nil, nil, nil, nil, nil, nil
		local NTblArgs=0

		for k,v in pairs(arg[1]) do
			
			local key=string.lower(k)
			
			if(key=="f") then func=v
			elseif(key=="x0") then x0=tonumber(v)
			elseif(key=="x1") then x1=tonumber(v)
			elseif(key=="fprime") then fprime=v
			elseif(key=="tol") then tol=tonumber(v)
			elseif(key=="maxiter") then maxiter=tonumber(v)
			else 
				error("Usage: {f=, x0=, fprime=, x1=nil, tol=1E-5, maxiter=100}", std.const.ERRORLEVEL)
			end

			NTblArgs=NTblArgs+1

		end
		
		assert(NTblArgs>0, "Signature: {f=, x0=, fprime=, x1=nil, tol=1E-5, maxiter=100}")


		maxiter=maxiter or 100
		tol=tol or 1E-5
		
		assert(math.type(maxiter)=="integer" and maxiter>0,"Key maxiter must be positive integer")
		assert(type(tol)=="number" and tol>0, "Key tol must be positive number")
		
		
		if(type(fprime)=="function") then
			return NewtonRaphson(func, x0, fprime, tol, maxiter)
		
		elseif(fprime==nil and type(x1)=="number") then
			return Secant(func, x0, x1, tol, maxiter)
		
		else
			error("Usage: {f=, x0=, fprime=, tol=1E-5, maxiter=100} OR {f=, x0=, x1=, tol=1E-5, maxiter=100}", std.const.ERRORLEVEL)
		end
			
			
	
	elseif (#arg==3) then
		assert(type(arg[1])=="function", "First arg must be function")
		assert(type(arg[2])=="number", "Second arg must be number.")
		
		if(type(arg[3])=="function") then
			return NewtonRaphson(arg[1], arg[2], arg[3])
		
		elseif(arg[3]==nil and type(arg[3])=="number") then
			return Secant(arg[1], arg[2], arg[3])
		
		else
			error("Usage: (f=, x0=, fprime=) OR (f=, x0=, x1=)", std.const.ERRORLEVEL)
		end
	
	end

end



std.newton=newton_secant



-- Author:	Gokhan Bingol (gbingol@sciencesuit.org)
-- License: Subject to end-user license agreement conditions available at www.sciencesuit.org
	
	
