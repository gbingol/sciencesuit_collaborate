local std <const> =std


local function SIGNRANK(func, vec, n)

	assert(type(func)=="function", "function expected")
	
	
	assert(type(vec)=="Vector" or type(vec)=="Array" or type(vec)=="number","number/Vector/Array expected")
	
	assert(math.type(n)=="integer" and n > 0,"Second arg (n) must be an integer >0")


	if(type(vec)=="Vector" or type(vec)=="Array") then
		local retCont=nil
		
		if(type(vec)=="Array") then
			vec=vec:clone()
			vec:keep_numbers()
			
			retCont=std.Array.new(#vec)
			
		else
			retCont=std.Vector.new(#vec)
		end


		for i=1,#vec do
			retCont[i]=func(vec(i), n)
		end
		
		
		return retCont

	end


	return func(vec, n)
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
				error("Keys: x, n.", std.const.ERRORLEVEL) 
			end

			NTblArgs=NTblArgs+1
		
		end

		assert(NTblArgs>0,"Keys: x, n.")


		return SIGNRANK(SYSTEM.dsignrank, xval,n)
		
	end
	
	
	return SIGNRANK(SYSTEM.dsignrank, args[1],args[2])

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
		
		
		return SIGNRANK(SYSTEM.psignrank, qval,n)
		
	end
	
	
	return SIGNRANK(SYSTEM.psignrank, args[1],args[2])

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
				error("Keys: p, n.", std.const.ERRORLEVEL) 
			end

			NTblArgs=NTblArgs+1
		
		end

		assert(NTblArgs>0,"Keys: q, n.")


		
		return SIGNRANK(SYSTEM.qsignrank, pval,n)
		
	end
	
	
	return SIGNRANK(SYSTEM.qsignrank, args[1],args[2])

end







std.dsignrank=dsignrank
std.psignrank=psignrank
std.qsignrank=qsignrank






-- Author:	Gokhan Bingol (gbingol@sciencesuit.org)
-- License: Subject to end-user license agreement conditions available at www.sciencesuit.org
