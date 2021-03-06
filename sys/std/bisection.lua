local std <const> =std

local function bisect(...)
	
	local arg=table.pack(...)

	assert(#arg>=3 or type(arg[1])=="table", "At least 3 args or a table expected.")
	
	if(#arg==1 and type(arg[1])=="table") then
		local func, a, b, tol, maxiter, method, modified=nil, nil, nil, nil, nil, nil, false
		local NTblArgs=0

		for k,v in pairs(arg[1]) do
			
			local key=string.lower(k)
			
			if(key=="f") then func=v
			elseif(key=="a") then a=tonumber(v)
			elseif(key=="b") then b=tonumber(v)
			elseif(key=="tol") then tol=tonumber(v)
			elseif(key=="maxiter") then maxiter=tonumber(v)
			elseif(key=="method") then method=v
			elseif(key=="modified") then modified=v
			else 
				error("Signature: {f, a, b, tol=1E-5, maxiter=100, method=\"bf\", modified=false}", std.const.ERRORLEVEL)
			end

			NTblArgs=NTblArgs+1

		end
		
		
		
		assert(NTblArgs>0, "Usage: {f, a, b, tol=1E-5, maxiter=100, method=\"bf\",modified=false}")

		assert(type(func)=="function", "First arg must be a unary function")
		assert(type(a)=="number", "Second arg must be a number")
		assert(type(b)=="number", "Third arg must be a number")


		maxiter=maxiter or 100
		tol=tol or 1E-5
		method=method or "bf"



		assert(math.type(maxiter)=="integer" and maxiter>0,"Key maxiter must be a positive integer.")
		
		assert(type(tol)=="number" and tol>0, "Key tol must be >0")
		
		assert(type(method)=="string" and (method=="bf" or method=="rf"), "Key method must be string and \"bf\" or \"rf\"")
		
		assert(type(modified)=="boolean", "Key modified must be boolean. true for Modified False Position.")
		
		
		
		if(string.lower(method)=="bf" and modified==true) then
			error("Key modified is only taken into account when the method is False Position") 
		end
		
		
		return SYSTEM.bisection(func, a, b, tol, maxiter, method, modified)
	
	elseif(#arg==3) then
		assert(type(arg[1])=="function", "First arg must be a function")
		assert(type(arg[2])=="number" and type(arg[3])=="number", "Second and third args must be number.")
		
		
		return SYSTEM.bisection(arg[1], arg[2], arg[3])

		
	else
		error("Usage: {f=, a=, b=, tol=1E-5, maxiter=100, method=\"bf\",modified=false} or (f=, a=, b=)", std.const.ERRORLEVEL)
	
	end
	
end
			



std.bisection=bisect




-- Author:	Gokhan Bingol (gbingol@sciencesuit.org)
-- License: Subject to end-user license agreement conditions available at www.sciencesuit.org
