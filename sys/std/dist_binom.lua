local std <const> =std


local function DBINOM(vec, size, prob)

	assert(type(size)=="number","Second arg (size) must be number!")
	assert(type(prob)=="number","Third arg (prob) must be number!")

	if(type(vec)=="Vector") then
		local vecSize=#vec
		local retVec=std.Vector.new(vecSize)
		for i=1,vecSize do
			retVec[i]=SYSTEM.dbinom(vec(i),size, prob)
		end

		return retVec

	elseif(type(vec)=="number") then
		return SYSTEM.dbinom(vec,size, prob)

	else
		error("First arg: number or Vector!", std.const.ERRORLEVEL)
	
	end


	return nil
end

local function dbinom(...)
	local args=table.pack(...)
	
	if(#args==1 and type(args[1])=="table") then
		
		local xval, size, prob=nil, nil, nil
		local NTblArgs=0
		
		for k,v in pairs(args[1]) do
			
			k=string.lower(k)

			if(k=="x") then xval=v
			elseif(k=="size") then size=v
			elseif(k=="prob") then prob=v
			else 
				error("Keys can be: x, size and prob.", std.const.ERRORLEVEL) 
			end

			NTblArgs=NTblArgs+1
		
		end

		assert(NTblArgs>0,"Keys: x, size and prob.")

		assert(xval~=nil and size~=nil and prob~=nil, "A value must be assigned to all of the table keys (x, size and prob).")
		
		return DBINOM(xval,size, prob)
		
	end
	
	
	return DBINOM(args[1],args[2], args[3])

end


--****************************************

local function PBINOM(vec, size, prob)

	assert(type(size)=="number","Second arg (size) must be number!")
	assert(type(prob)=="number","Third arg (prob) must be number!")

	if(type(vec)=="Vector") then

		local vecSize=#vec
		local retVec=std.Vector.new(vecSize)
		for i=1,vecSize do
			retVec[i]=SYSTEM.pbinom(vec(i),size, prob)
		end

		return retVec

	elseif(type(vec)=="number") then
		return SYSTEM.pbinom(vec,size, prob)

	else
		error("First arg: number or Vector!", std.const.ERRORLEVEL)
	end

	return nil
end



local function pbinom(...)
	local args=table.pack(...)
	
	if(#args==1 and type(args[1])=="table") then
		
		local qval, size, prob=nil, nil, nil
		local NTblArgs=0
		
		for k,v in pairs(args[1]) do
			
			k=string.lower(k)
			
			if(k=="q") then qval=v
			elseif(k=="size") then size=v
			elseif(k=="prob") then prob=v
			else 
				error("Keys: q, size and prob.", std.const.ERRORLEVEL) 
			end

			NTblArgs=NTblArgs+1
		end

		assert(NTblArgs>0,"Keys: q, size and prob.") 

		assert(qval~=nil and size~=nil and prob~=nil,"A value must be assigned to all of the table keys (q, size and prob).")
		
		return PBINOM(qval,size, prob)
	end
		
	
	return PBINOM(args[1], args[2], args[3])
end


--*******************************************

local function QBINOM(vec, size, prob)

	assert(math.type(size)=="integer","Second arg (size) must be integer.")
	assert(type(prob)=="number","Third arg (prob) must be number.")

	if(type(vec)=="Vector") then

		local vecSize=#vec
		local retVec=std.Vector.new(vecSize)
		for i=1,vecSize do
			retVec[i]=SYSTEM.qbinom(vec(i),size, prob)
		end

		return retVec

	elseif(type(vec)=="number") then
		return SYSTEM.qbinom(vec,size, prob)

	else
		error("First arg (p): number or Vector.", std.const.ERRORLEVEL)
	end

	return nil
end

local function qbinom(...)
	local args=table.pack(...)
	
	if(#args==1 and type(args[1])=="table") then 
		
		local pval, size, prob=nil,nil, nil
		local NTblArgs=0	
		
		for k,v in pairs(args[1]) do
			
			k=string.lower(k)

			if(k=="p") then pval=v
			elseif(k=="size") then size=v
			elseif(k=="prob") then prob=v
			else 
				error("Keys: p, size and prob.", std.const.ERRORLEVEL) 
			end

			NTblArgs=NTblArgs+1
		end
		
		assert(NTblArgs>0,"Keys: p, size and prob.")			
	
		assert(pval~=nil and size~=nil and prob~=nil,"A value to all table keys must be assigned: p, size and prob")
		
		return QBINOM(pval,size, prob)
	end

	
	return QBINOM(args[1], args[2], args[3])
end


--*************************************

local function RBINOM(n, size, prob)
	
	assert(math.type(n)=="integer" and n>0, "First arg (n) must be integer >0")
	
	assert(math.type(size)=="integer" and size>0,"Second arg (size) must be integer >0")
	
	assert(type(prob)=="number","Third arg (prob) must be number")

	return SYSTEM.rbinom(n, size, prob)
end



local function rbinom(...)
	local args=table.pack(...)
	
	if(#args==1 and type(args[1])=="table") then
		
		local arg1, size, prob=nil,nil, nil
		local NTblArgs=0
		
		for k,v in pairs(args[1]) do
			
			k=string.lower(k)

			if(k=="n") then arg1=v
			elseif(k=="size") then size=v
			elseif(k=="prob") then prob=v
			else 
				error("Keys: n, size and prob.", std.const.ERRORLEVEL) 
			end
		
			NTblArgs=NTblArgs+1
		end

		assert(NTblArgs>0,"Keys: n, size and prob.")

		assert(arg1~=nil and size~=nil and prob~=nil,"A value must be assigned to all keys: n, size and prob.")
		
		return RBINOM(arg1, size, prob)

	end

	return RBINOM(args[1],args[2], args[3])

end




std.dbinom=dbinom
std.pbinom=pbinom
std.qbinom=qbinom
std.rbinom=rbinom





-- Author:	Gokhan Bingol (gbingol@sciencesuit.org)
-- License: Subject to end-user license agreement conditions available at www.sciencesuit.org
