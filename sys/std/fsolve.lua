local std <const> =std



local function FSOLVE(Funcs,vinitial, MAXITERATIONS)
	--Solves a system of non-linear equations using Newton's approach
	--Funcs contains table of equations in the format of f(x1,x2,...)=0
	--v initial starting vector

	--USAGE EXAMPLE
      
	--function f1(t) return t[1]^2+t[2]^2-5 end
	--function f2(t) return t[1]^2-t[2]^2-1 end
	-- roots, iter=std.fsolve({f1,f2}, {1,1})
	--print(roots, "  iter:", iter) 1.73205	1.41421	iter:5
	--print(f1(roots), " ", f2(roots)) 9.428e-09    9.377e-09 
	
	
	--check parameters and their conditions
	assert(type(vinitial)=="table", "Initial values must be table")
	assert(#vinitial >= 2, "At least 2 initial values are required")
      
	assert(#Funcs >= 2, "At least 2 functions are required")
	
	assert(#Funcs == #vinitial, "Number of functions must be equal to number of initial conditions")
	
	

	MAXITERATIONS = MAXITERATIONS or 100

	--v will be the solution vector
	local v = std.std.util.tovector(vinitial)
	local dim = #v

	local F = std.Vector.new(dim)

	local Jacobi = std.Matrix.new(dim, dim) 
      


	for iter=1, MAXITERATIONS do
	
		local maxfuncval = 0 --convergence criteria
		local func= nil

	
		for i=1, dim do
                  
			func = Funcs[i]     --function
			
			assert(type(func)=="function","Table entries must be lua functions of form f(t) = 0" ) 
			
			F[i] = func(std.std.util.totable(v))
                  
		
			for j=1, dim do
				local oldval = v(j)
				
				--Note that vector contains (xi+dx,...)
				v[j] = v(j) + std.const.tolerance  
				
				--evaluate function with (xi+dx,...)
				local f_dxi = func(std.util.totable(v)) 
				
				--restore the old value, vector again contains (xi,...)
				v[j] = oldval
				
				--evaluate function with (xi,...)
				local f_xi = func(std.util.totable(v))  
				
				if(std.abs(maxfuncval) < std.abs(f_xi)) then 
					maxfuncval = std.abs(f_xi) 
				end
				
				--register the derivative with respect to xi to Jacobian matrix
				Jacobi[i][j] = (f_dxi - f_xi) / std.const.tolerance
			end --j
		end --i


		--return solution vector (as table) and number of iterations
		if(std.abs(maxfuncval) < std.const.tolerance)  then 
			return std.util.totable(v),  iter
		end

		local DetJacobi = std.abs(std.det(Jacobi))
            
		assert(DetJacobi > std.const.tolerance, "At iter="..tostring(iter).." Jacobian Det="..tostring(DetJacobi)..", try different initial values") 
		
		
		v = v - std.solve(Jacobi, F)
            
	end
	
	
	error("Max iterations exceeded without convergence" , std.const.ERRORLEVEL)
        
end -- function
    



    
local function fsolve(...)
	local arg=table.pack(...)
	
	if(type(arg[1])=="table" and type(arg[2])=="table") then
		
		if(type(arg[1][1])=="function") then
			return FSOLVE(arg[1],arg[2])
		end
	
	else
		error("Expected (table of functions, vector)", std.const.ERRORLEVEL)
		
	end

end





std.fsolve=fsolve





-- Author:	Gokhan Bingol (gbingol@sciencesuit.org)
-- License: Subject to end-user license agreement conditions available at www.sciencesuit.org