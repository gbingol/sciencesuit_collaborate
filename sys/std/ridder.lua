-- Author:	Gokhan Bingol (gbingol@sciencesuit.org)
-- License: Subject to end-user license agreement conditions available at www.sciencesuit.org



local std <const> =std

local function ridder(...)
	
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
			else 
				error("Signature: {f, a, b, tol=1E-5, maxiter=100}", std.const.ERRORLEVEL)
			end

			NTblArgs=NTblArgs+1

		end
		
		
		
		if(NTblArgs==0) then error("Usage: {f, a, b, tol=1E-5, maxiter=100}", std.const.ERRORLEVEL) end

		if(type(func)~="function") then error("First arg must be a unary function", std.const.ERRORLEVEL) end
		if(type(a)~="number") then error("Second arg must be a number", std.const.ERRORLEVEL) end
		if(type(b)~="number") then error("Third arg must be a number", std.const.ERRORLEVEL) end


		maxiter=maxiter or 100
		tol=tol or 1E-5


		if(math.type(maxiter)~="integer" or maxiter <= 0) then error("Key maxiter must be a positive integer.",std.const.ERRORLEVEL) end
		
		if(type(tol)~="number" or tol <= 0) then error("Key tol must be >0", std.const.ERRORLEVEL) end
		
		
		local status, root, numiter=pcall(SYSTEM.ridder, func, a, b, tol, maxiter)
		
		if(status) then	
			return root, numiter
		else
			return root
		end
	
	
	elseif(#arg==3) then
		assert(type(arg[1])=="function", "First arg must be a function")
		assert(type(arg[2])=="number" and type(arg[3])=="number", "Second and third args must be number.")
		
		
		local status, root, numiter=pcall(SYSTEM.ridder, arg[1], arg[2], arg[3])
		
		if(status) then	
			return root, numiter
		else
			return root
		end
		
		
	else
		error("Usage: {f=, a=, b=, tol=1E-5, maxiter=100} or (f=, a=, b=)", std.const.ERRORLEVEL)
	
	end
	
end
			



std.ridder=ridder





