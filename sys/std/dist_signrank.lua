-- Author:	Gokhan Bingol (gbingol@sciencesuit.org)
-- License: Subject to end-user license agreement conditions available at www.sciencesuit.org

local std <const> =std


local function DSIGNRANK( arg, n)

	assert(type(arg)=="Vector" or type(arg)=="number","First arg must be either a number or of type Vector!")
	assert(math.type(n)=="integer" and n>0,"Second arg (n) must be an integer >0")

	if(type(arg)=="Vector") then
		local retVec=arg[{}] --clone
		
		std.for_each(retVec,SYSTEM.dsignrank,n)

		return retVec


	elseif(type(arg)=="number") then
		return SYSTEM.dsignrank(arg,n)

	end

	return nil
end


local function dsignrank(...)
	local args=table.pack(...)
	
	if(#args==1 and type(args[1])=="table") then
		
		local xval, n=nil, nil
		local NTblArgs=0
		
		for k,v in pairs(args[1]) do
			
			k=string.lower(k)

			if(k=="x") then xval=v
			elseif(k=="n") then n=v
			else 
				error("Keys can be: x, n.", std.const.ERRORLEVEL) 
			end

			NTblArgs=NTblArgs+1
		
		end

		assert(NTblArgs>0,"Keys: x, n.")

		assert(xval~=nil and n~=nil , "A value must be assigned to all of the table keys (x, n ).")
		
		return DSIGNRANK(xval,n)
		
	end
	
	
	return DSIGNRANK(args[1],args[2])

end


--****************************************

local function PSIGNRANK( arg, n)

	assert(type(arg)=="Vector" or type(arg)=="number","First arg: number or Vector!")
	assert(math.type(n)=="integer" and n>0,"Second arg (n) must be an integer >0")

	if(type(arg)=="Vector") then
		local retVec=arg[{}] --clone
		
		std.for_each(retVec,SYSTEM.psignrank,n)

		return retVec


	elseif(type(arg)=="number") then
		return SYSTEM.psignrank(arg,n)

	end

	return nil
end


local function psignrank(...)
	local args=table.pack(...)
	
	if(#args==1 and type(args[1])=="table") then
		
		local qval, n=nil, nil
		local NTblArgs=0
		
		for k,v in pairs(args[1]) do
			
			k=string.lower(k)

			if(k=="q") then qval=v
			elseif(k=="n") then n=v
			else 
				error("Keys can be: q, n.", std.const.ERRORLEVEL) 
			end

			NTblArgs=NTblArgs+1
		
		end

		assert(NTblArgs>0,"Keys: q, n.")

		assert(qval~=nil and n~=nil , "A value must be assigned to all of the table keys (q, n ).")
		
		return PSIGNRANK(qval,n)
		
	end
	
	
	return PSIGNRANK(args[1],args[2])

end



--****************************************

local function QSIGNRANK( arg, n)

	assert(type(arg)=="Vector" or type(arg)=="number","First arg: number or Vector!")
	assert(math.type(n)=="integer" and n>0,"Second arg (n) must be an integer >0")

	if(type(arg)=="Vector") then
		local retVec=arg[{}] --clone
		
		std.for_each(retVec,SYSTEM.qsignrank,n)

		return retVec


	elseif(type(arg)=="number") then
		return SYSTEM.qsignrank(arg,n)

	end

	return nil
end


local function qsignrank(...)
	local args=table.pack(...)
	
	if(#args==1 and type(args[1])=="table") then
		
		local pval, n=nil, nil
		local NTblArgs=0
		
		for k,v in pairs(args[1]) do
			
			k=string.lower(k)

			if(k=="p") then pval=v
			elseif(k=="n") then n=v
			else 
				error("Kkeys can be: p, n.", std.const.ERRORLEVEL) 
			end

			NTblArgs=NTblArgs+1
		
		end

		assert(NTblArgs>0,"Keys: q, n.")

		assert(pval~=nil and n~=nil , "A value must be assigned to all of the table keys (p, n ).")
		
		return QSIGNRANK(pval,n)
		
	end
	
	
	return QSIGNRANK(args[1],args[2])

end




std.dsignrank=dsignrank
std.psignrank=psignrank
std.qsignrank=qsignrank
