local std <const> =std


local function DPOIS(vec, lambda)
	
	assert(type(vec)=="Vector" or type(vec)=="number","First arg (x): number or Vector")

	assert(type(lambda)=="number","Second arg (lambda) must be number.")

	if(type(vec)=="Vector") then
		local vecSize=#vec
		local retVec=std.Vector.new(vecSize)
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
				error("Keys: x and lambda.", std.const.ERRORLEVEL) 
			end

			NTblArgs=NTblArgs+1
		
		end

		assert(NTblArgs>0, "Keys: x and lambda.")
		
		return DPOIS(xval,lambda)
		
	end
	
	
	return DPOIS(args[1],args[2])

end


--******************************************************

local function PPOIS(vec, lambda)

	assert(type(vec)=="Vector" or type(vec)=="number","First arg (q): number or Vector.")

	assert(type(lambda)=="number","Second arg (lambda) must be number.")

	if(type(vec)=="Vector") then

		local vecSize=#vec
		local retVec=std.Vector.new(vecSize)
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
				error("Keys: q and lambda.", std.const.ERRORLEVEL) 
			end

			NTblArgs=NTblArgs+1
		end

		assert(NTblArgs>0,"Keys: q and lambda.")
	
		return PPOIS(qval,lambda)
	end
			
	
	return PPOIS(args[1], args[2])
end


--****************************************************

local function QPOIS(vec, lambda)

	assert(type(vec)=="Vector" or type(vec)=="number","First arg (p): number or Vector.")

	assert(type(lambda)=="number","Second arg (lambda) must be number.")

	if(type(vec)=="Vector") then

		local vecSize=#vec
		local retVec=std.Vector.new(vecSize)
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
				error("Keys: p and lambda.", std.const.ERRORLEVEL) 
			end

			NTblArgs=NTblArgs+1
		end

		assert(NTblArgs>0,"Keys: p and lambda.") 
		

		return QPOIS(pval,lambda)
	end

	
	return QPOIS(args[1], args[2])
end


--************************

local function RPOIS(n, lambda)
	
	assert(math.type(n)=="integer" and n>0,"First arg (key: n) must be an integer >0")
	assert(type(lambda)=="number","Second arg (lambda) must be number")

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
				error("Keys: n and lambda.", std.const.ERRORLEVEL) 
			end

			NTblArgs=NTblArgs+1
		
		end

		assert(NTblArgs>0,"Keys: n and lambda.")
		
		return RPOIS(arg1, lambda)
		
	end

	
	return RPOIS(args[1],args[2])

end




std.dpois=dpois
std.ppois=ppois
std.qpois=qpois
std.rpois=rpois



-- Author:	Gokhan Bingol (gbingol@sciencesuit.org)
-- License: Subject to end-user license agreement conditions available at www.sciencesuit.org

