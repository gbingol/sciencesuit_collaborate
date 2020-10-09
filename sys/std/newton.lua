-- Author:	Gokhan Bingol (gbingol@sciencesuit.org)
-- License: Subject to end-user license agreement conditions available at www.sciencesuit.org

local std <const> =std


local function NewtonRaphson(f,X0, fprime, tolerance, MaxIterations)

        -- Finding root of an equation using Newton-Raphson Method
        -- Input: f a function, X0 is initial guess

	assert(type(f)=="function", "ERROR: f must be a function.") 
	 
	assert(type(X0)=="number", "ERROR: x0 must be a number" ) 
	
	assert(type(fprime)=="function", "ERROR: fprime must be a function.") 
	
	tolerance=tolerance or 1E-5
	MaxIterations=MaxIterations or 100
	
      return SYSTEM.newtonraphson(f, X0, fprime, tolerance, MaxIterations)
end


local function Secant(f,X0, X1, tolerance, MaxIterations)

        -- Finding root of an equation using Newton-Raphson Method
        -- Input: f a function, X0 is initial guess

	assert(type(f)=="function", "ERROR: f must be a function.") 
	 
	assert(type(X0)=="number", "ERROR: x0 must be a number" ) 
	
	assert(type(X1)=="number", "ERROR: x1 must be a number" ) 
	
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
		
		assert(math.type(maxiter)=="integer" and maxiter>0,"ERROR: Key maxiter must be a positive integer")
		assert(type(tol)=="number" and tol>0, "ERROR: Key tol must be a positive number")
		
		
		if(type(fprime)=="function") then
			return NewtonRaphson(func, x0, fprime, tol, maxiter)
		
		elseif(fprime==nil and type(x1)=="number") then
			return Secant(func, x0, x1, tol, maxiter)
		
		else
			error("Usage: {f=, x0=, fprime=, tol=1E-5, maxiter=100} OR {f=, x0=, x1=, tol=1E-5, maxiter=100}", std.const.ERRORLEVEL)
		end
			
			
	
	elseif (#arg==3) then
		assert(type(arg[1])=="function", "ERROR: First argument must be a function")
		assert(type(arg[2])=="number", "ERROR: Second argument must be of type number.")
		
		if(type(arg[3])=="function") then
			return NewtonRaphson(arg[1], arg[2], arg[3])
		
		elseif(arg[3]==nil and type(arg[3])=="number") then
			return Secant(arg[1], arg[2], arg[3])
		
		else
			error("Usage: (f=, x0=, fprime=) OR (f=, x0=, x1=)", std.const.ERRORLEVEL)
		end
	
	end

end


local function Newton_SystemNonlinearEqs(tblfuncs,v_initial)
	--Solves a system of non-linear equations using Newton's approach
        --tblfuncs contains table of equations in the format of f(x1,x2,...)=0
        --v initial starting vector

	local v=v_initial({})
	local dim=#v
	local F=std.Vector.new(dim)
	local Jacobi=std.Matrix.new(dim,dim) -- Jacobian
	
	for k=1,MAXITERATIONS do
	
		local maxfuncval=0 --convergence criteria
		local func=nil

		for i=1,dim do
			func=tblfuncs[i] --a function
			assert(type(func)=="function","ERROR: Table entries must be lua functions of form f(x1,x2,...)=0" ) 
			F[i]=f(unpack(totable(v)))
		end

		for i=1,dim do
			func=tblfunc[i]     --function
			for j=1,dim do
				local oldval=v(j)
				v[j]=v(j)+TOLERANCE -- to find f(xi+dx,...)

				local f_dxi=f(unpack(std.totable(v))) --f(xi+dx,...)
				v[j]=oldval

				local f_xi=f(unpack(std.totable(v)))  --f(xi,...)
				
				if(std.abs(maxfuncval)<std.abs(f_xi)) then 
					maxfuncval=std.abs(f_xi) 
				end
				
				Jacobi[i][j]=(f_dxi-f_xi)/TOLERANCE
			end --j
		end --i

		if(std.abs(maxfuncval)<TOLERANCE)  then return v  end

		local JacobiDetValue=std.abs(std.det(J))
		assert(JacobiDetValue>TOLERANCE,"ERROR: Jacobian is singular, try different initial vector values") 
		
		local H=std.solve(J,F)
		v=v-H
	end
	
        error("ERROR: Maximum iterations have been reached without convergence" , std.const.ERRORLEVEL)
        
    end -- function
    
    
local function newton_funcs(...)
	local arg=table.pack(...)
	
	if(#arg==2 and type(arg[1])=="table" and type(arg[2])=="Vector") then
		if(type(arg[1][1])=="function") then
			return Newton_SystemNonlinearEqs(arg[1],arg[2])
		end
	
	else
		error("ERROR: Unexpected argument types", std.const.ERRORLEVEL)
		
	end

end

std.newton=newton_secant
std.newton_funcs=newton_funcs
	
	
