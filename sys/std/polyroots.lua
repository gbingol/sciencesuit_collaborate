local std <const> =std



--currently only monic polynom algorithm implemented


local function IsMonicPoly(vec)
	return math.abs(vec(1) - 1 ) < std.const.tolerance
end



local function MONICPOLY(vec)
	
	--vec is in the form of anxn+...+a0 polynomial
	
	--uses eigen value approach
	--Companion is the companion matrix for a polynomial
	
	
	assert(type(vec) == "Vector", "Argument must be Vector")
	
	
	--If not monic polynomial, make it monic polynomial
	if(IsMonicPoly(vec) == false) then
		vec = vec/vec(1)
	end
		
		
	
	local dim = #vec
	
	local Companion = std.eye(dim -2, dim -2) 
	
	local Zeros=std.Vector.new(dim -2)
	
	
	Companion:insert(Zeros, 1, "col")  -- (dim-2) by (dim-1) 
	
	
	vec[1] = nil
	vec = -vec	
	vec:reverse()
	
	Companion:append(vec, "row") -- (dim -1) * (dim-1)
	
	
	return std.eig(Companion)
end







local function POLYROOTS(...)
	
	local arg=table.pack(...)
	
	if(#arg==1  and type(arg[1])=="table") then
		
		local Polynom, method = nil, "eigen"
		local NTblArgs=0

		for k,v in pairs(arg[1]) do
			
			local key=string.lower(k)
			
			if(key=="poly") then Polynom = v
			elseif(key=="method") then method =string.lower(v)
			
			else 
				error("Usage: {poly=, [method=\"eigen\"]}", std.const.ERRORLEVEL)
			end

			NTblArgs=NTblArgs+1

		end
		
		assert(NTblArgs >= 1, "Usage: {poly=, [method=\"eigen\"]}")
		assert(Polynom ~= nil, "polynomial coefficents undefined")
		
		assert(type(method) == "string", "method must be string")

		if(method =="eigen") then
			return MONICPOLY(Polynom)
		end

	
	elseif (#arg==1) then
		return MONICPOLY(arg[1])

	elseif (#arg==2) then
		local Polynom = arg[1]
		local method = arg[2]
		
		assert(type(method) == "string", "2nd arg must be string")
		
		if(method =="eigen") then
			return MONICPOLY(Polynom)
		else
			error("Undefined method", std.const.ERRORLEVEL)
		end
	end


	error("Usage: {poly=, [method=\"eigen\"]} or (poly=, method=\"eigen\")", std.const.ERRORLEVEL)

end






std.polyroots = POLYROOTS
	
	



-- Author:	Gokhan Bingol (gbingol@sciencesuit.org)
-- License: Subject to end-user license agreement conditions available at www.sciencesuit.org
	