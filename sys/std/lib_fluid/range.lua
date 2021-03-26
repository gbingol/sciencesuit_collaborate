local function GetRange(Fluid, TableName, Field) 

	if(Fluid == nil and Fluid.Type ~= "Fluid") then
		error("Invalid fluid", std.const.ERRORLEVEL)
	end

	if(type(TableName)~="string") then
		error("Table name must be string", std.const.ERRORLEVEL)
	end

	if(type(Field)~="string") then
		error("Field name must be string", std.const.ERRORLEVEL)
	end
	
	
	
	local db = Fluid.Database
	
	
	
	local strQuery="SELECT max("..Field..") FROM "..TableName
	local set = db:sql(strQuery)
	
	if(set == nil) then
		error("Max value could not be found", std.const.ERRORLEVEL)
	end
	
	local maxval=tonumber(set[1])
	
	
	
	strQuery="SELECT min("..Field..") FROM "..TableName
	set = db:sql(strQuery)
	
	if(set == nil) then
		error("Min value could not be found", std.const.ERRORLEVEL)
	end
	
	local minval=tonumber(set[1])



	return minval, maxval
end





std.fluid.range=GetRange