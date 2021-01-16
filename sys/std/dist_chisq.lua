-- Author:	Gokhan Bingol (gbingol@sciencesuit.org)
-- License: Subject to end-user license agreement conditions available at www.sciencesuit.org

local std <const> =std


local function DCHISQ(arg1, df)
	
	assert(math.type(df)=="integer" and df>0,"(key: df)  must be integer >0")

	if(type(arg1)=="Vector") then
		local vecSize=#arg1
		local retVec=std.Vector.new(vecSize)
		for i=1,vecSize do
			retVec[i]=SYSTEM.dchisq(arg1(i),df)
		end
		
		return retVec

	elseif(type(arg1)=="number") then
		return SYSTEM.dchisq(arg1,df)

	else
		error("First arg (key: x): number or Vector!", std.const.ERRORLEVEL)
	
	end

	return nil
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

		assert(type(xval)=="number" or type(xval)=="Vector","A number or Vector value must be assigned to the key 'x'." )
			
		return DCHISQ(xval, df)
		

	end

	return DCHISQ(args[1],args[2])

end




local function PCHISQ(qval, df)

	assert(math.type(df)=="integer" and df>0,"Degrees of freedom (key: df) must be integer >0")

	if(type(qval)=="Vector") then
		local retVec=std.Vector.new(#qval)
		for i=1,#qval do
			retVec[i]=SYSTEM.pchisq(qval(i),df)
		end

		return retVec

	elseif(type(qval)=="number") then
		return SYSTEM.pchisq(qval,df)

	else
		error("First argument (q): number or Vector.", std.const.ERRORLEVEL)
	end

	return nil
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
	
		assert(type(qval)=="number" or type(qval)=="Vector","'q': number or Vector.")
	
		return PCHISQ(qval,df)
	end

	
	return PCHISQ(args[1], args[2])
end



-- *******************************************************************

local function QCHISQ(prob, df)

	assert(math.type(df)=="integer" and df>0,"Degrees of freedom (key: df) must be integer >0")

	if(type(prob)=="Vector") then
		local retVec=std.Vector.new(#prob)
		for i=1,#prob do
			retVec[i]=SYSTEM.qchisq(prob(i),df)
		end

		return retVec

	elseif(type(prob)=="number") then
		return SYSTEM.qchisq(prob,df)

	else
		error("First argument (p): number or Vector.", std.const.ERRORLEVEL)
	end

	return nil
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

		assert(type(pval)=="number" or type(pval)=="Vector","'p': number or Vector.")
		
		return QCHISQ(pval,df)
	end

	
	return QCHISQ(args[1], args[2])
end



--*************************Random number generation*************************

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

