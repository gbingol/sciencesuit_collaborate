-- Author:	Gokhan Bingol (gbingol@sciencesuit.org)
-- License: Subject to end-user license agreement conditions available at www.sciencesuit.org



local function ComputeHeatTransferProperties(Arg, PropertyTable)
	
	if(type(PropertyTable) ~= "table") then error("2nd argument must be table", std.const.ERRORLEVEL) end
	
	local Fluid = nil
	
	local keepAlive = false
	
	
	
	if(type(Arg) == "string") then
		Fluid= std.fluid.new(Arg, "H")
	
	elseif (type(Arg)== "table") then 
		if(Arg.Type~="Fluid") then error("Invalid fluid", std.const.ERRORLEVEL) end
		if(Arg.Database == nil) then error("No valid database connection", std.const.ERRORLEVEL) end
		if(Arg.OrderedTable == nil) then error("No valid database table", std.const.ERRORLEVEL) end
		
		Fluid = Arg
		
		keepAlive=true
	
	else
		error("Either fluid name or an abstract fluid is expected", std.const.ERRORLEVEL)
	end
	
	
	
	
	local key, value=next(PropertyTable)
			
	local ComputedProperties=std.fluid.searchorderedtable(Fluid, key, value) 
	
	
	if(keepAlive==false) then
		Fluid.Database:close()
	end
	
	
	return ComputedProperties
end




std.fluid.heattransfer = ComputeHeatTransferProperties