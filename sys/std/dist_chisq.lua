local std <const> =std


local function CHISQ(func, vec, df)
	
	assert(type(func)=="function", "function expected")
	
	assert(type(vec)=="Vector" or type(vec)=="Array" or type(vec)=="number","First arg, number/Vector/Array")
	
	assert(math.type(df)=="integer" and df>0,"(df)  must be integer >0")

	
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
			retCont[i]=func(vec(i), df)
		end
		
		
		return retCont

	end


	return func(vec, df)
end






local function dchisq(...)
	local args=table.pack(...)
	
	if(#args==1 and type(args[1])=="table") then
		
		local xval, df=nil, nil
		local NArgsTbl=0
		
		for k,v in pairs(args[1]) do
			k=string.lower(k)
			if(k=="x") then xval=v
			elseif(k=="df") then df=v
			else 
				error("Keys can be: x and df.", std.const.ERRORLEVEL) 
			end

			NArgsTbl=NArgsTbl+1
		end

		assert(NArgsTbl>0,"Keys: x, and df.")

			
		return CHISQ(SYSTEM.dchisq, xval, df)
		

	end



	return CHISQ(SYSTEM.dchisq, args[1],args[2])

end






local function pchisq(...)
	local args=table.pack(...)
	
	if(#args==1 and type(args[1])=="table") then 
		
		local qval, df=nil,nil	
		local NTblArgs=0
		
		for k,v in pairs(args[1]) do
			k=string.lower(k)
			if(k=="q") then qval=v
			elseif(k=="df") then df=v
			else 
				error("Keys can be: q and df.", std.const.ERRORLEVEL) 
			end

			NTblArgs=NTblArgs+1
		end

		assert(NTblArgs==2, "Keys: q and df.")
	
	
		return CHISQ(SYSTEM.pchisq, qval,df)
	end

	
	return CHISQ(SYSTEM.pchisq, args[1], args[2])
end







local function qchisq(...)
	local args=table.pack(...)
	
	if(#args==1 and type(args[1])=="table") then 
		
		local pval, df=nil,nil	
		local NTblArgs=0
		
		for k,v in pairs(args[1]) do
			k=string.lower(k)
			if(k=="p") then pval=v
			elseif(k=="df") then df=v
			else 
				error("Keys can be: p and df.", std.const.ERRORLEVEL) 
			end

			NTblArgs=NTblArgs+1
		end

		assert(NTblArgs>0,"Keys: p and df.")

		
		return CHISQ(SYSTEM.qchisq, pval,df)
	end

	
	return CHISQ(SYSTEM.qchisq, args[1], args[2])
end







local function RCHISQ(n, df)
	
	assert(math.type(n)=="integer" and n>0,"First arg (key: n) must be integer >0")
	assert(math.type(df)=="integer" and df>0,"Second arg (key: df) must be integer >0")
	
	return SYSTEM.rchisq(n,df)
		
end



local function rchisq(...)
	local args=table.pack(...)
	
	if(#args==1 and type(args[1])=="table") then
		
		local arg1, df=nil,nil
		local NTblArgs=0
		
		for k,v in pairs(args[1]) do
			k=string.lower(k)
			if(k=="n") then arg1=v
			elseif(k=="df") then df=v
			else 
				error("Keys: n and df.", std.const.ERRORLEVEL) 
			end

			NTblArgs=NTblArgs+1
		
		end

		assert(NTblArgs>0,"Keys: n and df.")
		
		return RCHISQ(arg1, df)

	end

	return RCHISQ(args[1],args[2])

end






std.dchisq=dchisq
std.pchisq=pchisq
std.qchisq=qchisq
std.rchisq=rchisq





-- Author:	Gokhan Bingol (gbingol@sciencesuit.org)
-- License: Subject to end-user license agreement conditions available at www.sciencesuit.org

