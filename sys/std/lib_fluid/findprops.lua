-- Author:	Gokhan Bingol (gbingol@hotmail.com)
-- License: Subject to end-user license agreement conditions available at www.sciencesuit.org




local function SEARCHREGULARTABLE(fluid, field, QueryVal) 
	
	--Table must be in the form of, for example
	--	 P	T	s	vf
	--	50	20	2	0.2
	--	70	25	3	0.8
	
	--Search for the value (val) given by parameter field (for example can be P, T, s, vf)
	--Given a QueryValue (QueryVal), for example T=22
	
	--The function then returns a table with keys P, T, s, vf and with values corresponding to T=22 (using interpolation)
	

	assert(fluid ~= nil, "First param \"fluid\" cannot be nil")
	assert(type(field)=="string", "2nd param must be string")
	assert(type(QueryVal)=="number", "3rd param must be number")
	
	
	local strQuery="";
	local db=fluid.Database
	
	if(db == nil) then
		error("Parameter fluid must have Database member", std.const.ERRORLEVEL)
	end
	
	field=string.lower(field)
	
	local AvailableCols=db:columns(fluid.RegTable)
	
	local ColumnNames=""
	
	local ColumnExists=false
	
	for i=1, #AvailableCols do
		if(field==string.lower(AvailableCols[i])) then
			ColumnExists=true
		end
		
		if(i<#AvailableCols) then
			ColumnNames = ColumnNames..AvailableCols[i]..","
		end
	end

	ColumnNames=ColumnNames..AvailableCols[#AvailableCols]

	assert(ColumnExists == true, "Available options:"..ColumnNames)
	
	
	--false for marking it as NOT superheated
	local MinValue, MaxValue = std.fluid.range(fluid, fluid.RegTable, field) 
	
	if(QueryVal < MinValue or QueryVal> MaxValue) then 
		error("Valid range: ["..tostring(MinValue)..", "..tostring(MaxValue).."]", std.const.ERRORLEVEL)
	end
	
	
	
	--Check if the numbers are increasing or decreasing for the given property
	strQuery="SELECT "..field.." FROM "..fluid.RegTable 
	local set,row, col=db:sql(strQuery)

	if(row <= 3) then error("Not enough data for the particular fluid", std.const.ERRORLEVEL) end
	
	
	--We select a value from the middle point of the properties and subtract the value at the very beginning
	-- if Diff>0, then the numbers are increasing otherwise decreasing
	local Diff = set[math.floor(row/2)] - set[1]
	
	
	local QueryLarger="SELECT "..ColumnNames.. " FROM "..fluid.RegTable.." WHERE "..field..">="..tostring(QueryVal) 
	local setLarger,rowLarger = db:sql(QueryLarger)
	
	local QuerySmaller="SELECT "..ColumnNames.. " FROM "..fluid.RegTable.." WHERE "..field.."<="..tostring(QueryVal) 
	local setSmaller,rowSmaller = db:sql(QuerySmaller)
	
	if(Diff < 0) then rowSmaller=1 end
	
	if(Diff > 0) then rowLarger=1 end
	
	
	local tblH, tblL= {}, {}
	
	
	for i=1, #AvailableCols do
		tblH[AvailableCols[i]]=setLarger[rowLarger][i]
		
		tblL[AvailableCols[i]]=setSmaller[rowSmaller][i]
	end
	
	
	
	local RowLoc;
	local x1, x2=0, 0
	
	
	strQuery="SELECT "..field.." FROM "..fluid.RegTable.." WHERE "..field.."<="..tostring(QueryVal) 
	set, row = db:sql(strQuery)
	
	if(Diff > 0) then RowLoc=row else RowLoc=1 end	
	x1=set[RowLoc]
	
		
	
	strQuery="SELECT "..field.." FROM "..fluid.RegTable.." WHERE "..field..">="..tostring(QueryVal)
	set, row = db:sql(strQuery)
	
	if(Diff > 0) then RowLoc=1 else RowLoc=row end
	x2=set[RowLoc]
	
	
	local retTable={}
	
	for i=1, #AvailableCols do
		local index=AvailableCols[i]
		
		retTable[index]=std.fluid.interpolate(x1, tblL[index], x2, tblH[index], QueryVal)
	end
	
	
	if(field=="t" or field=="p") then
		retTable[string.upper(field)]=QueryVal
	else
		retTable[field]=QueryVal
	end



	return retTable
end




std.fluid.findprops = SEARCHREGULARTABLE