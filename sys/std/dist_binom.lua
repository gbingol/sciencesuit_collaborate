local std <const> =std


local function BINOM(func, vec, size, prob)


	--func: SYSTEM.dbinom, SYSTEM.pbinom, SYSTEM.qbinom
	assert(type(func)=="function", "First arg must be function")

	assert(type(vec)=="Vector" or type(vec)=="Array" or type(vec)=="number","First arg, number/Vector/Array")

	assert(type(size)=="number","Second arg (size) must be number")
	assert(type(prob)=="number","Third arg (prob) must be number")


	if(type(vec)=="Vector" or type(vec)=="Array") then
		local retCont=nil
		
		if(type(vec)=="Array") then
			vec=vec:clone()
			vec:keep_realnumbers()
			
			retCont=std.Array.new(#vec)
			
		else
			retCont=std.Vector.new(#vec)
		end


		for i=1,#vec do
			retCont[i]= func(vec(i),size, prob)
		end


		return retCont

	end
		
		
	return func(vec,size, prob)
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

		
		return BINOM(SYSTEM.dbinom, xval,size, prob)
		
	end
	
	
	return BINOM(SYSTEM.dbinom, args[1],args[2], args[3])

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

		
		return BINOM(SYSTEM.pbinom, qval,size, prob)
	end
		
	
	return BINOM(SYSTEM.pbinom, args[1], args[2], args[3])
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
		
		return BINOM(SYSTEM.qbinom, pval,size, prob)
	end

	
	return BINOM(SYSTEM.qbinom, args[1], args[2], args[3])
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
