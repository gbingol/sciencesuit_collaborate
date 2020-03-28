-- Author:	Gokhan Bingol (gbingol@sciencesuit.org)
-- License: Subject to end-user license agreement conditions available at www.sciencesuit.org


local function DPOIS(vec, lambda)
	
	assert(type(vec)=="Vector" or type(vec)=="number","ERROR: First argument (x) must be either a number or of type Vector")

	assert(type(lambda)=="number","ERROR: Second argument (lambda) must be a number!")

	if(type(vec)=="Vector") then
		local vecSize=#vec
		local retVec=Vector.new(vecSize)
		for i=1,vecSize do
			retVec[i]=SYSTEM.dpois(vec(i),lambda)
		end

		return retVec
	end

	return SYSTEM.dpois(vec, lambda)

end


local function dpois(...)
	local args=table.pack(...)
	
	if(#args==1 and type(args[1])=="table") then
		
		local xval, lambda= nil, nil
		local NTblArgs=0
		
		for k,v in pairs(args[1]) do
			k=string.lower(k)
			if(k=="x") then xval=v
			elseif(k=="lambda") then lambda=v
			else 
				error("ERROR: Unrecognized key in the table, keys: x and lambda.", ERRORLEVEL) 
			end

			NTblArgs=NTblArgs+1
		
		end

		assert(NTblArgs>0, "ERROR: Keys: x and lambda.")
		
		return DPOIS(xval,lambda)
		
	end
	
	
	return DPOIS(args[1],args[2])

end


--******************************************************

local function PPOIS(vec, lambda)

	assert(type(vec)=="Vector" or type(vec)=="number","ERROR: First argument (q) must be either a number or of type Vector")

	assert(type(lambda)=="number","ERROR: Second argument (lambda) must be a number!")

	if(type(vec)=="Vector") then

		local vecSize=#vec
		local retVec=Vector.new(vecSize)
		for i=1,vecSize do
			retVec[i]=SYSTEM.ppois(vec(i),lambda)
		end

		return retVec
	end

	return SYSTEM.ppois(vec,lambda)
	
end


local function ppois(...)
	local args=table.pack(...)
	
	if(#args==1 and type(args[1])=="table") then 
		
		local qval, lambda=nil,nil
		local NTblArgs=0
		
		for k,v in pairs(args[1]) do
			k=string.lower(k)
			if(k=="q") then qval=v
			elseif(k=="lambda") then lambda=v
			else 
				error("ERROR: Unrecognized key in the table, valid keys: q and lambda.", ERRORLEVEL) 
			end

			NTblArgs=NTblArgs+1
		end

		assert(NTblArgs>0,"ERROR: Keys: q and lambda.")
	
		return PPOIS(qval,lambda)
	end
			
	
	return PPOIS(args[1], args[2])
end


--****************************************************

local function QPOIS(vec, lambda)

	assert(type(vec)=="Vector" or type(vec)=="number","ERROR: First argument (p) must be either a number or of type Vector")

	assert(type(lambda)=="number","ERROR: Second argument (lambda) must be a number!")

	if(type(vec)=="Vector") then

		local vecSize=#vec
		local retVec=Vector.new(vecSize)
		for i=1,vecSize do
			retVec[i]=SYSTEM.qpois(vec(i),lambda)
		end

		return retVec
	end

	return SYSTEM.qpois(vec,lambda)

end

local function qpois(...)
	local args=table.pack(...)
	
	if(#args==1 and type(args[1])=="table") then 
		
		local pval, lambda=nil,nil
		local NTblArgs=0	
		
		for k,v in pairs(args[1]) do
			k=string.lower(k)
			if(k=="p") then pval=v
			elseif(k=="lambda") then lambda=v
			else 
				error("ERROR: Unrecognized key in the table, valid keys: p and lambda.", ERRORLEVEL) 
			end

			NTblArgs=NTblArgs+1
		end

		assert(NTblArgs>0,"ERROR: Keys: p and lambda.") 
		

		return QPOIS(pval,lambda)
	end

	
	return QPOIS(args[1], args[2])
end


--************************

local function RPOIS(n, lambda)
	
	assert(math.type(n)=="integer" and n>0,"ERROR: First argument (key: n) must be an integer greater than zero.")
	assert(type(lambda)=="number","ERROR: Second argument (lambda) must be of type number")

	return SYSTEM.rpois(n, lambda)

end



local function rpois(...)
	local args=table.pack(...)
	
	if(#args==1 and type(args[1])=="table") then
		
		local arg1, lambda=nil,nil
		local NTblArgs=0
		
		for k,v in pairs(args[1]) do
			k=string.lower(k)
			if(k=="n") then arg1=v
			elseif(k=="lambda") then lambda=v
			else 
				error("ERROR: Unrecognized key in the table, valid keys: n and lambda.", ERRORLEVEL) 
			end

			NTblArgs=NTblArgs+1
		
		end

		assert(NTblArgs>0,"ERROR: Keys: n and lambda.")
		
		return RPOIS(arg1, lambda)
		
	end

	
	return RPOIS(args[1],args[2])

end




std.dpois=dpois
std.ppois=ppois
std.qpois=qpois
std.rpois=rpois

