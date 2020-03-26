
local function DT(x, df)
	
	assert(type(x)=="Vector" or type(x)=="number","ERROR: First argument (x) must be either a number or of type Vector")
	
	assert(math.type(df)=="integer","ERROR: Degrees of freedom (key: df)  must be an integer.")
	assert(df>0,"ERROR: Degrees of freedom (key: df)  must be greater than zero.")
	
	if(type(x)=="Vector") then

		local vecSize=#x
		local retVec=Vector.new(vecSize)
		for i=1,vecSize do
			retVec[i]=SYSTEM.dt(x(i),df)
		end
		
		return retVec
	end

	return SYSTEM.dt(x,df)

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
				error("ERROR: Unrecognized key in the table, keys can be: x and df.", ERRORLEVEL) 
			end

			NArgsTbl=NArgsTbl+1
		
		end

		assert(NArgsTbl>0,"ERROR: Keys can be: x, and df.")
		
		return DT(xval, df)
	end

	return DT(args[1],args[2])

end




local function PT(qval, df)

	assert(type(qval)=="Vector" or type(qval)=="number","ERROR: First argument (q) must be either a number or of type Vector.")
	
	assert(math.type(df)=="integer","ERROR: Degrees of freedom (key: df)  must be an integer.")
	assert(df>0,"ERROR: Degrees of freedom (key: df)  must be greater than zero.")
	
	if(type(qval)=="Vector") then

		local vecSize=#qval
		local retVec=Vector.new(vecSize)
		for i=1,vecSize do
			retVec[i]=SYSTEM.pt(qval(i),df)
		end

		return retVec
	end

	
	return SYSTEM.pt(qval,df)

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
				error("ERROR: Unrecognized key in the table, keys can be: q and df.", ERRORLEVEL) 
			end

			NTblArgs=NTblArgs+1
		end

		assert(NTblArgs==2, "ERROR: Keys can be: q and df.")
		
		return PT(qval,df)
	end

	
	return PT(args[1], args[2])
end



-- *******************************************************************

local function QT(prob, df)

	assert(type(prob)=="number" or type(prob)=="Vector","ERROR: First argument (p) must be either a number or of type Vector.")

	assert(math.type(df)=="integer","ERROR: Degrees of freedom (key: df)  must be an integer.")
	assert(df>0,"ERROR: Degrees of freedom (key: df)  must be greater than zero.")

	if(type(prob)=="Vector") then

		local vecSize=#prob
		local retVec=Vector.new(vecSize)
		for i=1,vecSize do
			retVec[i]=SYSTEM.qt(prob(i),df)
		end

		return retVec

	end

	return SYSTEM.qt(prob,df)

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
				error("ERROR: Unrecognized key in the table, keys can be: p and df.", ERRORLEVEL) 
			end

			NTblArgs=NTblArgs+1
		end

		assert(NTblArgs>0, "ERROR: Keys can be: p and df.")
		

		return QT(pval,df)
	end

	
	return QT(args[1], args[2])
end



--*************************Random number generation*************************

local function RT(n, df)
	
	assert(math.type(n)=="integer","ERROR: First argument (key: n) must be an integer.")
	assert(n>0,"ERROR: First argument (key: n) must be greater than zero.")
	
	assert(math.type(df)=="integer","ERROR: Degrees of freedom (key: df)  must be an integer.")
	assert(df>0,"ERROR: Degrees of freedom (key: df)  must be greater than zero.")
	
	
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
				error("ERROR: Unrecognized key in the table, keys can be: n and df.", ERRORLEVEL) 
			end

			NTblArgs=NTblArgs+1
		
		end

		assert(NTblArgs>0, "ERROR: Table keys: n and df.")
		
		
		return RT(arg1, df)

	end

	return RT(args[1],args[2])

end


std.dt=dt
std.pt=pt
std.qt=qt
std.rt=rt

