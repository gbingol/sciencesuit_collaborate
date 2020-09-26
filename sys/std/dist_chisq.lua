-- Author:	Gokhan Bingol (gbingol@sciencesuit.org)
-- License: Subject to end-user license agreement conditions available at www.sciencesuit.org

local std <const> =std


local function DCHISQ(arg1, df)
	
	assert(math.type(df)=="integer" and df>0,"ERROR: Degrees of freedom (key: df)  must be an integer greater than zero.")

	if(type(arg1)=="Vector") then
		local vecSize=#arg1
		local retVec=Vector.new(vecSize)
		for i=1,vecSize do
			retVec[i]=SYSTEM.dchisq(arg1(i),df)
		end
		
		return retVec

	elseif(type(arg1)=="number") then
		return SYSTEM.dchisq(arg1,df)

	else
		error("ERROR: First argument (key: x) must be either a number or of type Vector!", ERRORLEVEL)
	
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
				error("ERROR: Unrecognized key in the table, keys can be: x and df.", ERRORLEVEL) 
			end

			NArgsTbl=NArgsTbl+1
		end

		assert(NArgsTbl>0,"ERROR: Keys: x, and df.")

		assert(type(xval)=="number" or type(xval)=="Vector","ERROR: A number or Vector value must be assigned to the key 'x'." )
			
		return DCHISQ(xval, df)
		

	end

	return DCHISQ(args[1],args[2])

end




local function PCHISQ(qval, df)

	assert(math.type(df)=="integer" and df>0,"ERROR: Degrees of freedom (key: df) must be an integer greater than zero.")

	if(type(qval)=="Vector") then
		local retVec=Vector.new(#qval)
		for i=1,#qval do
			retVec[i]=SYSTEM.pchisq(qval(i),df)
		end

		return retVec

	elseif(type(qval)=="number") then
		return SYSTEM.pchisq(qval,df)

	else
		error("ERROR: First argument (q) must be either a number or of type Vector.", ERRORLEVEL)
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
				error("ERROR: Unrecognized key in the table, keys can be: q and df.", ERRORLEVEL) 
			end

			NTblArgs=NTblArgs+1
		end

		assert(NTblArgs==2, "ERROR: Keys: q and df.")
	
		assert(type(qval)=="number" or type(qval)=="Vector","ERROR: 'q' must be either a number or a Vector.")
	
		return PCHISQ(qval,df)
	end

	
	return PCHISQ(args[1], args[2])
end



-- *******************************************************************

local function QCHISQ(prob, df)

	assert(math.type(df)=="integer" and df>0,"ERROR: Degrees of freedom (key: df) must be an integer greater than zero.")

	if(type(prob)=="Vector") then
		local retVec=Vector.new(#prob)
		for i=1,#prob do
			retVec[i]=SYSTEM.qchisq(prob(i),df)
		end

		return retVec

	elseif(type(prob)=="number") then
		return SYSTEM.qchisq(prob,df)

	else
		error("ERROR: First argument (p) must be either a number or of type Vector.", ERRORLEVEL)
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
				error("ERROR: Unrecognized key in the table, keys can be: p and df.", ERRORLEVEL) 
			end

			NTblArgs=NTblArgs+1
		end

		assert(NTblArgs>0,"ERROR: Keys: p and df.")

		assert(type(pval)=="number" or type(pval)=="Vector","ERROR: 'p' must be either a number or a Vector.")
		
		return QCHISQ(pval,df)
	end

	
	return QCHISQ(args[1], args[2])
end



--*************************Random number generation*************************

local function RCHISQ(n, df)
	
	assert(math.type(n)=="integer" and n>0,"ERROR: First argument (key: n) must be an integer greater than zero.")
	assert(math.type(df)=="integer" and df>0,"ERROR: Second argument (key: df) must be an integer greater than zero.")
	
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
				error("ERROR: Unrecognized key in the table. Valid keys: n and df.", ERRORLEVEL) 
			end

			NTblArgs=NTblArgs+1
		
		end

		assert(NTblArgs>0,"ERROR: Keys: n and df.")
		
		return RCHISQ(arg1, df)

	end

	return RCHISQ(args[1],args[2])

end


std.dchisq=dchisq
std.pchisq=pchisq
std.qchisq=qchisq
std.rchisq=rchisq

