local std <const> =std


local function NORM(func, vec, mean, sd)
	
	--func: SYSTEM.dnorm, SYSTEM.pnorm, SYSTEM.qnorm
	assert(type(func)=="function", "First arg must be function")
	
	mean=mean or 0
	
	sd=sd or 1


	assert(type(vec)=="Vector" or type(vec)=="Array" or type(vec)=="number","First arg, number/Vector")

	assert(type(mean)=="number","Second arg must be number")
	assert(type(sd)=="number", "Third arg must be number")


	if(type(vec)=="Vector" or type(vec)=="Array") then
		local retCont=nil
		
		retCont=std.Vector.new(#vec)
		
		if(type(vec)=="Array") then
			vec=vec:clone()
			vec:keep_numbers()
			
			retCont=std.Array.new(#vec)
		end
		
		
		for i=1,#vec do
			retCont[i]=func(vec(i),mean, sd)
		end
		
		return retCont

	end
		
		
	return func(vec,mean, sd)

end



local function dnorm(...)
	local args=table.pack(...)
	
	if(#args==1 and type(args[1])=="table") then
		local xval, mean, sd=nil, 0, 1
		local NArgsTbl=0
		
		for k,v in pairs(args[1]) do
			
			k=string.lower(k)

			if(k=="x") then xval=v
			elseif(k=="mean") then mean=v
			elseif(k=="sd") then sd=v
			else 
				error("Keys: x, mean and sd.", std.const.ERRORLEVEL) 
			end

			NArgsTbl=NArgsTbl+1
		
		end


		assert(NArgsTbl>0,"Keys: x, mean and sd.")

		assert(type(xval)=="number" or type(xval)=="Vector"  or type(xval)=="Array","Number/Vector/Array expected for key 'x'.")
			
			
		return NORM(SYSTEM.dnorm, xval, mean, sd)
		
	end


	return NORM(SYSTEM.dnorm, args[1],args[2], args[3])

end








local function pnorm(...)
	local args=table.pack(...)
	
	if(#args==1 and type(args[1])=="table") then 
		
		local qval, mean, sd=nil, 0, 1 -- default values
		

		for k,v in pairs(args[1]) do
			
			k=string.lower(k)

			if(k=="q") then qval=v
			elseif(k=="mean") then mean=v
			elseif(k=="sd") then sd=v
			else 
				error("Keys: q, mean and sd.", std.const.ERRORLEVEL) end
		end
		
		return NORM(SYSTEM.pnorm, qval,mean, sd)
		
	end
	
	
	return NORM(SYSTEM.pnorm, args[1], args[2], args[3])
	
end






local function qnorm(...)
	local args=table.pack(...)
	
	if(#args==1 and type(args[1])=="table") then 
		
		local pval, mean, sd=nil, 0, 1 -- default values
		local IsVector=false
		local NTblArgs=0
		
		for k,v in pairs(args[1]) do
		
			k=string.lower(k)

			if(k=="p") then pval=v
			elseif(k=="mean") then mean=v
			elseif(k=="sd") then sd=v
			else 
				error("Keys: p, mean and sd.", std.const.ERRORLEVEL) 
			end

			NTblArgs=NTblArgs+1
		end
	
		assert(NTblArgs>0,"Keys are p, mean and sd.")

		return NORM(SYSTEM.qnorm, pval,mean, sd)
	end

	
	return NORM(SYSTEM.qnorm, args[1], args[2], args[3])
end








local function RNORM(n, mean, sd)
	mean=mean or 0
	sd=sd or 1

	assert(math.type(n)=="integer" and n>0,"First arg (n) must be an integer >0")
	assert(type(mean)=="number", "Second arg must be number")
	assert(type(sd)=="number", "Third arg must be number")
	
	return SYSTEM.rnorm(n, mean, sd)

end



local function rnorm(...)
	local args=table.pack(...)
	
	if(#args==1 and type(args[1])=="table") then
		
		local arg1, mean, sd=nil, 0, 1
		local NTblArgs=0
		
		for k,v in pairs(args[1]) do
			
			k=string.lower(k)

			if(k=="n") then arg1=v
			elseif(k=="mean") then mean=v
			elseif(k=="sd") then sd=v
			else 
				error("Keys: n, mean and sd.", std.const.ERRORLEVEL) 
			end
		
			NTblArgs=NTblArgs+1
		end

		assert(NTblArgs>0,"Keys are n, mean and sd.")
		
		return RNORM(arg1, mean, sd)
		
	end

	return RNORM(args[1],args[2], args[3])

end







std.dnorm=dnorm
std.pnorm=pnorm
std.qnorm=qnorm
std.rnorm=rnorm




-- Author:	Gokhan Bingol (gbingol@sciencesuit.org)
-- License: Subject to end-user license agreement conditions available at www.sciencesuit.org

