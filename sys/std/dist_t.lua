local std <const> =std



local function TDIST(func, vec, df)
	
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






local function dt(...)
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

		assert(NArgsTbl>0,"Keys can be: x, and df.")
		
		return TDIST(SYSTEM.dt, xval, df)
	end

	return TDIST(SYSTEM.dt, args[1],args[2])

end







local function pt(...)
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

		assert(NTblArgs==2, "Keys can be: q and df.")
		
		return TDIST(SYSTEM.pt, qval,df)
	end

	
	return TDIST(SYSTEM.pt, args[1], args[2])
end







local function qt(...)
	local args=table.pack(...)
	
	if(#args==1 and type(args[1])=="table") then 
		
		local pval, df=nil,nil	
		local NTblArgs=0
		
		for k,v in pairs(args[1]) do
			k=string.lower(k)
			if(k=="p") then pval=v
			elseif(k=="df") then df=v
			else 
				error("Keys: p and df.", std.const.ERRORLEVEL) 
			end

			NTblArgs=NTblArgs+1
		end

		assert(NTblArgs>0, "Keys: p and df.")
		

		return TDIST(SYSTEM.qt, pval,df)
	end

	
	return TDIST(SYSTEM.qt, args[1], args[2])
end






local function RT(n, df)
	
	assert(math.type(n)=="integer","First arg (n) must be integer.")
	assert(n>0,"First arg (n) must be >0")
	
	assert(math.type(df)=="integer","Degrees of freedom (df)  must be integer.")
	assert(df>0,"Degrees of freedom (df)  must be >0")
	
	
	return SYSTEM.rt(n,df)
		
end



local function rt(...)
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

		assert(NTblArgs>0, "Keys: n and df.")
		
		
		return RT(arg1, df)

	end

	return RT(args[1],args[2])

end


std.dt=dt
std.pt=pt
std.qt=qt
std.rt=rt




-- Author:	Gokhan Bingol (gbingol@sciencesuit.org)
-- License: Subject to end-user license agreement conditions available at www.sciencesuit.org
