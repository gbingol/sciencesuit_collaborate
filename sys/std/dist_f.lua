-- Author:	Gokhan Bingol (gbingol@sciencesuit.org)
-- License: Subject to end-user license agreement conditions available at www.sciencesuit.org

local std <const> =std


local function DF(arg1, df1, df2)
	
	assert(math.type(df1)=="integer","Degrees of freedom (key: df1)  must be integer.")
	assert(df1>0,"Degrees of freedom (key: df1)  must be >0")

	assert(math.type(df2)=="integer","Degrees of freedom (key: df2)  must be integer.")
	assert(df2>0,"Degrees of freedom (key: df2)  must be >0")
	
	if(type(arg1)=="Vector") then

		local vecSize=#arg1
		local retVec=std.Vector.new(vecSize)
		for i=1,vecSize do
			retVec[i]=SYSTEM.df(arg1(i),df1, df2)
		end
		
		return retVec

	elseif(type(arg1)=="number") then
		return SYSTEM.df(arg1,df1, df2)

	else
		error("First arg (key: x): number or Vector.", std.const.ERRORLEVEL)
	
	end

	return nil
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
		assert(type(xval)=="number" or type(xval)=="Vector", "A number or Vector value must be assigned to the key 'x'. ")
		
		return DF(xval, df1, df2)

	end

	return DF(args[1],args[2], args[3])

end


----------------------------------------------------------------

local function PF(qval, df1, df2)

	assert(math.type(df1)=="integer","Degrees of freedom (key: df1)  must be integer.")
	assert(df1>0,"Degrees of freedom (key: df1)  must be greater than zero.")

	assert(math.type(df2)=="integer","Degrees of freedom (key: df2)  must be integer.")
	assert(df2>0,"Degrees of freedom (key: df2)  must be >0")

	if(type(qval)=="Vector") then

		local vecSize=#qval
		local retVec=std.Vector.new(vecSize)
		for i=1,vecSize do
			retVec[i]=SYSTEM.pf(qval(i),df1, df2)
		end

		return retVec

	elseif(type(qval)=="number") then
		return SYSTEM.pf(qval, df1, df2)

	else
		error("First argument (q): number or Vector.", std.const.ERRORLEVEL)
	end

	return nil
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
		
		assert(type(qval)=="number" or type(qval)=="Vector","'q': number or Vector.")
		
		return PF(qval,df1, df2)
	end

	
	return PF(args[1], args[2], args[3])
end


------------------------------------------------------------

local function QF(prob, df1, df2)

	assert(math.type(df1)=="integer","Degrees of freedom (key: df1)  must be integer.")
	assert(df1>0,"Degrees of freedom (key: df1)  must be >0")

	assert(math.type(df2)=="integer","Degrees of freedom (key: df2)  must be integer.")
	assert(df2>0,"Degrees of freedom (key: df2)  must be >0")

	if(type(prob)=="Vector") then

		local vecSize=#prob
		local retVec=std.Vector.new(vecSize)
		for i=1,vecSize do
			retVec[i]=SYSTEM.qf(prob(i),df1, df2)
		end

		return retVec

	elseif(type(prob)=="number") then
		return SYSTEM.qf(prob, df1, df2)

	else
		error("First argument (p): number or Vector.", std.const.ERRORLEVEL)
	end

	return nil
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
		assert(type(pval)=="number" or type(pval)=="Vector","ERROR: 'p': number or Vector.")
		
		return QF(pval,df1, df2)
	end

	
	return QF(args[1], args[2], args[3])
end



--*************************Random number generation*************************

local function RF(n, df1, df2)
	
	assert(math.type(n)=="integer","First argument (key: n) must be integer.")
	assert(n>0,"First argument (key: n) must be >0.")
	
	assert(math.type(df1)=="integer","(key: df1)  must be integer.")
	assert(df1>0,"(key: df1)  must be >0")

	assert(math.type(df2)=="integer","(key: df2)  must be integer.")
	assert(df2>0,"(key: df2)  must be >0")


	return SYSTEM.rf(n,df1, df2)
		
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


