local std <const> =std


--Not tested 

local function FSOLVE(tblfuncs,v_initial, MAXITERATIONS)
	--Solves a system of non-linear equations using Newton's approach
	--tblfuncs contains table of equations in the format of f(x1,x2,...)=0
	--v initial starting vector

	--USAGE EXAMPLE
      
	-- f1=function(x,y) return x^2+y^2-5 end
	-- f2=function(x,y) return x^2-y^2-1 end
	-- std.fsolve({f1,f2}, std.tovector{1,1})

	--	1.73205   1.41421   COL 

	MAXITERATIONS = MAXITERATIONS or 100

	local v = v_initial({})
	local dim = #v
	local F = std.Vector.new(dim)
	local Jacobi = std.Matrix.new(dim,dim) 
      
      

	for k=1, MAXITERATIONS do
	
		local maxfuncval = 0 --convergence criteria
		local func=nil

		for i=1,dim do
                  func=tblfuncs[i] --a function
                  
                  assert(type(func)=="function","Table entries must be lua functions of form f(x1,x2,...) = 0" ) 
                        
			F[i]=func(table.unpack(std.totable(v)))
		end


		for i=1,dim do
                  
			func=tblfuncs[i]     --function
                  
			for j=1,dim do
				local oldval=v(j)
				v[j]=v(j) + std.const.tolerance -- to find f(xi+dx,...)

				local f_dxi = func(table.unpack(std.totable(v))) --f(xi+dx,...)
				v[j] = oldval

				local f_xi = func(table.unpack(std.totable(v)))  --f(xi,...)
				
				if(std.abs(maxfuncval) < std.abs(f_xi)) then 
					maxfuncval = std.abs(f_xi) 
				end
				
				Jacobi[i][j] = (f_dxi - f_xi) / std.const.tolerance
			end --j
		end --i



		if(std.abs(maxfuncval) < std.const.tolerance)  then 
			return v, k
		end

		local JacobiDetValue=std.abs(std.det(Jacobi))
            
		assert(JacobiDetValue > std.const.tolerance,"Jacobian is singular, try different initial vector values") 
		
		local H=std.solve(Jacobi,F)
		
		v=v-H
            
	end
	
	error("Max iterations exceeded without convergence" , std.const.ERRORLEVEL)
        
end -- function
    



    
local function fsolve(...)
	local arg=table.pack(...)
	
	if(type(arg[1])=="table" and type(arg[2])=="Vector") then
		
		if(type(arg[1][1])=="function") then
			return FSOLVE(arg[1],arg[2])
		end
	
	else
		error("Expected (table, vector)", std.const.ERRORLEVEL)
		
	end

end





std.fsolve=fsolve





-- Author:	Gokhan Bingol (gbingol@sciencesuit.org)
-- License: Subject to end-user license agreement conditions available at www.sciencesuit.org