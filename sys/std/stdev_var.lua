local std <const> =std



local function ComputeVariance(...)
	--INPUT: 	First argument: A vector, matrix, array or range
	--			Second argument is optional
	--OUTPUT:	If only elem is provided then sample variance is computed
	--			variancetype can be either "s" or "p"
	
	local args=table.pack(...)
	local nargs=#args
	
	assert(nargs>0, "At least 1 argument must be supplied")
	
	
	
	if(type(args[1])=="table") then
		local tbl=args[1]
		
		local Container=tbl[1]
		
		local axes=tbl["axes"]
		if(axes==nil) then
			axes=-1
		else
			assert(math.type(axes)=="integer" and axes>=0 and axes<=1,"If provided axes must be an integer with a value of either 0 or 1")
		end
		
		local vartype=tbl["type"] or "s"
		
		
		if(type(Container)=="Matrix") then
			return Container:var(vartype, axes)
			
		elseif(type(Container)=="Vector" or type(Container)=="Array") then
			return Container:var(vartype)
		end
		
	end

	
	
	
	local Container, VarType, Axes=args[1], args[2], args[3]
	
		
	VarType=VarType or "s"
	Axes=Axes or -1
	
	assert(type(VarType)=="string","Second arg must be string")
	
	VarType=string.lower(VarType)
	assert(VarType=="s" or VarType=="p","Second arg must be \"s\" or \"p\"")
	
	if(nargs==3) then
		assert(math.type(Axes)=="integer" and (Axes>=0 and Axes<=1), "If provided 3rd argument must be of type integer and take value of either 0 or 1")
	end
	
	
	if(type(Container)=="Vector" or type(Container)=="Array") then
		return Container:var(VarType)
		
	elseif(type(Container)=="Matrix") then
		return Container:var(VarType, Axes)
	end
		
	
	
	--For general containers
	
	local X,X2=0,0
	local NEntries=0	
	
	for k,v in pairs(Container) do
		
		X=X+v
		X2=X2+v^2
		
		NEntries=NEntries+1
	end
	
	local E_X, E_X2=X/NEntries, X2/NEntries
	
	local varPop=E_X2-(E_X)^2 --Population
	
	local df_Population=NEntries
	local df_Sample=df_Population-1
	
	if(VarType=="p") then
		return varPop
	
	elseif(VarType=="s") then
		return varPop*df_Population/df_Sample
		
	end
	
		
end




local function STDEV(...)
		
	local args=table.pack(...)
	
	local result, ElemsConsidered=std.var(table.unpack(args))
	
	if(ElemsConsidered~=nil) then
		return std.sqrt(result), ElemsConsidered
	end

	
	return std.sqrt(result)
end




std.stdev=STDEV	
std.var=ComputeVariance




-- Author:	Gokhan Bingol (gbingol@sciencesuit.org)
-- License: Subject to end-user license agreement conditions available at www.sciencesuit.org
