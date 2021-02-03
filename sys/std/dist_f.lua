local std <const> =std


local function FDIST(func, vec, df1, df2)
	
	
	assert(type(func)=="function", "function expected")
	
	assert(type(vec)=="Vector" or type(vec)=="Array" or type(vec)=="number","First arg, number/Vector/Array")
	
	
	assert(math.type(df1) == "integer","Degrees of freedom (df1)  must be integer.")
	assert(df1 > 0,"Degrees of freedom (df1)  must be >0")

	assert(math.type(df2) == "integer","Degrees of freedom (df2)  must be integer.")
	assert(df2 > 0,"Degrees of freedom (df2)  must be >0")
	
	
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
			retCont[i]=func(vec(i), df1, df2)
		end
		
		
		return retCont
		
	end

	
	return func(vec,df1, df2)
end






local function df(...)
	local args=table.pack(...)
	
	if(#args==1 and type(args[1])=="table") then
		
		local xval, df1, df2=nil, nil, nil
		local NArgsTbl=0
		
		for k,v in pairs(args[1]) do
			k=string.lower(k)
			if(k=="x") then xval=v
			elseif(k=="df1") then df1=v
			elseif(k=="df2") then df2=v
			else 
				error("Kkeys: x, df1 and df2.", std.const.ERRORLEVEL) 
			end

			NArgsTbl=NArgsTbl+1
		
		end

		assert(NArgsTbl>0,"Keys: x, df1 and df2.")
		
		
		return FDIST(SYSTEM.df, xval, df1, df2)

	end

	return FDIST(SYSTEM.df, args[1],args[2], args[3])

end







local function pf(...)
	local args=table.pack(...)
	
	if(#args==1 and type(args[1])=="table") then 
		
		local qval, df1, df2=nil,nil, nil
		local NTblArgs=0
		
		for k,v in pairs(args[1]) do
			k=string.lower(k)
			if(k=="q") then qval=v
			elseif(k=="df1") then df1=v
			elseif(k=="df2") then df2=v
			else 
				error("Keys: q, df1 and df2.", std.const.ERRORLEVEL) 
			end

			NTblArgs=NTblArgs+1
		end

		assert(NTblArgs>0,"Keys: q, df1 and df2.")
		
		
		return FDIST(SYSTEM.pf, qval,df1, df2)
	end

	
	return FDIST(SYSTEM.pf, args[1], args[2], args[3])
end








local function qf(...)
	local args=table.pack(...)
	
	if(#args==1 and type(args[1])=="table") then 
		
		local pval, df1, df2=nil,nil, nil
		local NTblArgs=0
		
		for k,v in pairs(args[1]) do
			k=string.lower(k)
			if(k=="p") then pval=v
			elseif(k=="df1") then df1=v
			elseif(k=="df2") then df2=v
			else 
				error("Keys: p, df1 and df2.", std.const.ERRORLEVEL) 
			end

			NTblArgs=NTblArgs+1
		end

		assert(NTblArgs>0,"Keys: p, df1 and df2.")
	
		
		return FDIST(SYSTEM.qf, pval,df1, df2)
	end

	
	return FDIST(SYSTEM.qf, args[1], args[2], args[3])
end








local function RF(n, df1, df2)
	
	assert(math.type(n)=="integer","First argument (key: n) must be integer.")
	assert(n > 0, "First argument (key: n) must be >0.")
	
	assert(math.type(df1) == "integer", "(key: df1)  must be integer.")
	assert(df1 > 0,"(key: df1)  must be >0")

	assert(math.type(df2)=="integer","(key: df2)  must be integer.")
	assert(df2 > 0,"(key: df2)  must be >0")


	return SYSTEM.rf(n, df1, df2)
		
end



local function rf(...)
	local args=table.pack(...)
	
	if(#args==1 and type(args[1])=="table") then
		
		local arg1, df1, df2=nil,nil, nil
		local NTblArgs=0
		
		for k,v in pairs(args[1]) do
			
			k=string.lower(k)
			
			if(k=="n") then arg1=v
			elseif(k=="df1") then df1=v
			elseif(k=="df2") then df2=v
			else 
				error("Keys: n, df1 and df2.", std.const.ERRORLEVEL) 
			end

			NTblArgs=NTblArgs+1
		
		end

		assert(NTblArgs>0, "Keys: n, df1 and df2.")
		
		return RF(arg1, df1, df2)

	end

	return RF(args[1],args[2], args[3])

end







std.df=df
std.pf=pf
std.qf=qf
std.rf=rf





-- Author:	Gokhan Bingol (gbingol@sciencesuit.org)
-- License: Subject to end-user license agreement conditions available at www.sciencesuit.org

