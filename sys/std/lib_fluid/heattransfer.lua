-- Author:	Gokhan Bingol (gbingol@sciencesuit.org)
-- License: Subject to end-user license agreement conditions available at www.sciencesuit.org



local function ComputeHeatTransferProperties(FluidName, PropertyTable)
	
	if(type(FluidName) ~= "string") then error("Fluid name must be string", std.const.ERRORLEVEL) end
	if(type(PropertyTable) ~= "table") then error("2nd argument must be table", std.const.ERRORLEVEL) end
	
	local Fluid=std.fluid.new(FluidName, "H")	
	
	local key, value=next(PropertyTable)
			
	local props=std.fluid.searchorderedtable(Fluid, key, value) 
	
	return props
end




std.fluid.heattransfer = ComputeHeatTransferProperties