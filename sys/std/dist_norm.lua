-- Author:	Gokhan Bingol (gbingol@sciencesuit.org)
-- License: Subject to end-user license agreement conditions available at www.sciencesuit.org

local std <const> =std


local function DNORM(vec, mean, sd)
	mean=mean or 0
	sd=sd or 1

	assert(type(vec)=="Vector" or type(vec)=="number","ERROR: First argument must be either a number or of type Vector")

	assert(type(mean)=="number","ERROR: Second argument must be of type number")
	assert(type(sd)=="number", "ERROR: Third argument must be of type number")

	if(type(vec)=="Vector") then

		local vecSize=#vec
		local retVec=std.Vector.new(vecSize)
		for i=1,vecSize do
			retVec[i]=SYSTEM.dnorm(vec(i),mean, sd)
		end
		
		return retVec

	end
		
	return SYSTEM.dnorm(vec,mean, sd)

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
				error("ERROR: Unrecognized key in the table, valid keys: x, mean and sd.", std.const.ERRORLEVEL) 
			end

			NArgsTbl=NArgsTbl+1
		
		end

		assert(NArgsTbl>0,"ERROR: Keys: x, mean and sd.")

		assert(type(xval)=="number" or type(xval)=="Vector","ERROR: A number or Vector value must be assigned to the key 'x'.")
			
		return DNORM(xval, mean, sd)
		
	end

	return DNORM(args[1],args[2], args[3])

end



--***********************************************************************************************


local function PNORM(vec, mean, sd)

	mean=mean or 0
	sd=sd or 1
	
	assert(type(vec)=="Vector" or type(vec)=="number","ERROR: First argument (q) must be either a number or of type Vector")

	assert(type(mean)=="number","ERROR: Second argument (mean) must be a number.")
	assert(type(sd)=="number", "ERROR: Third argument (sd) must be a number.")
	
	if(type(vec)=="Vector") then
	
		local vecSize=#vec
		local retVec=std.Vector.new(vecSize)
		for i=1,vecSize do
			retVec[i]=SYSTEM.pnorm(vec(i),mean, sd)
		end

		return retVec
		
	end
		
	return SYSTEM.pnorm(vec,mean, sd)
		
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
				error("ERROR: Unrecognized key in the table, valid keys: q, mean and sd.", std.const.ERRORLEVEL) end
		end
		
		return PNORM(qval,mean, sd)
		
	end
	
	
	return PNORM(args[1], args[2], args[3])
	
end


--************************************************************



local function QNORM(vec, mean, sd)

	mean=mean or 0
	sd=sd or 1

	assert(type(vec)=="Vector" or type(vec)=="number","ERROR: First argument (p) must be either a number or of type Vector")

	assert(type(mean)=="number","ERROR: Second argument (mean) must be a number.")
	assert(type(sd)=="number","ERROR: Third argument (sd) must be a number.")
	

	if(type(vec)=="Vector") then

		local vecSize=#vec
		local retVec=std.Vector.new(vecSize)
		
		for i=1,vecSize do
			retVec[i]=SYSTEM.qnorm(vec(i),mean, sd)
		end

		return retVec
	end

	
	return SYSTEM.qnorm(vec,mean, sd)

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
				error("ERROR: Unrecognized key in the table, valid keys: p, mean and sd.", std.const.ERRORLEVEL) 
			end

			NTblArgs=NTblArgs+1
		end
	
		assert(NTblArgs>0,"ERROR: Keys are p, mean and sd.")

		return QNORM(pval,mean, sd)
	end

	
	return QNORM(args[1], args[2], args[3])
end


--********************************************************************************

local function RNORM(n, mean, sd)
	mean=mean or 0
	sd=sd or 1

	assert(math.type(n)=="integer" and n>0,"ERROR: First argument (n) must be an integer greater than zero.")
	assert(type(mean)=="number", "ERROR: Second argument must be of type number")
	assert(type(sd)=="number", "ERROR: Third argument must be of type number")
	
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
				error("ERROR: Unrecognized key in the table, valid keys: n, mean and sd.", std.const.ERRORLEVEL) 
			end
		
			NTblArgs=NTblArgs+1
		end

		assert(NTblArgs>0,"ERROR: Keys are n, mean and sd.")
		
		return RNORM(arg1, mean, sd)
		
	end

	return RNORM(args[1],args[2], args[3])

end



std.dnorm=dnorm
std.pnorm=pnorm
std.qnorm=qnorm
std.rnorm=rnorm



