-- Author:	Gokhan Bingol (gbingol@hotmail.com)
-- License: Subject to end-user license agreement conditions available at www.sciencesuit.org



local function CreateFluid(fluidName, FluidType) 
	
	--fluidName is the name of the fluid, say Water or R134A
	--FluidType is either R for refrigerant or H for heat transfer

	--if a fluid is already created then we can provide it as argument
	
	
	if(type(fluidName)~="string") then error("fluidName must be string", std.const.ERRORLEVEL) end
	if(type(FluidType)~="string") then error("FluidType must be string", std.const.ERRORLEVEL) end
	
	
	
	local FLUID={}

	
	local testDBName = std.const.exedir.."/datafiles/Fluids.db"
	local database = std.Database.new()
	database:open(testDBName)
	
	
	--Check if FluidType is valid
	local QueryFLType="SELECT Type FROM MAINTABLE where TYPE=".."\""..FluidType.."\""
	local setFLType,rowFLType = database:sql(QueryFLType)
	
	if(setFLType == nil or rowFLType <1) then
		error("Fluid type does not exist", std.const.ERRORLEVEL)
	end
	
	
	
	local set,row = nil, 0
	
	local QueryString="SELECT  ORDEREDTABLE, SUPERHEATEDTABLE FROM MAINTABLE where NAME=".."\""..fluidName.."\"".."  collate nocase and TYPE=".."\""..FluidType.."\""
	
	set,row = database:sql(QueryString)
	
	if(row==0 or row==nil) then
		QueryString="SELECT  ORDEREDTABLE, SUPERHEATEDTABLE FROM MAINTABLE where ALTERNATIVE=".."\""..fluidName.."\"".." collate nocase and TYPE=".."\""..FluidType.."\""
		set, row = database:sql(QueryString)
		
		if(row==0 or row==nil) then 
			return nil 
		end
	end

	FLUID.Database=database
	FLUID.FluidName=fluidName
	FLUID.OrderedTable=set[1][1]
	FLUID.SuperHeatedTable=set[1][2]
	
	FLUID.Type="Fluid"
	

	return FLUID
end





std.fluid.new = CreateFluid



