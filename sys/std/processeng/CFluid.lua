-- Author:	Gokhan Bingol (gbingol@hotmail.com)
-- License: Subject to end-user license agreement conditions available at www.sciencesuit.org

Fluid={}
Fluid.__index=Fluid

--FluidName is the name of the fluid, say Water or Air

function Fluid.new(FluidName)  
	local FLUID={}
	setmetatable(FLUID,Fluid) --create the object
	
	local m_database=Database.new()
	m_database:open(std.const.exedir.."/databases/Fluids.db")
	
	local AvailableTables=m_database:tables()
	
	local FluidNameExists=false
	
	for key,value in pairs(AvailableTables) do
		if(string.upper(FluidName)==string.upper(value)) then 
			FluidNameExists=true 
			break
		end
		
	end 
	
	if(FluidNameExists==false) then 
		return nil 
	end
	
	FLUID.m_Database=m_database
	FLUID.m_FluidName=FluidName
	
	return FLUID
end


local function Interpolation(x1, y1, x2, y2, val) 
	-- Given 2 data points (x1,y1) and (x2,y2) we are looking for the y-value of the point x=val 
	if(x1==x2) then return y1 end
	local m,n=0, 0
	m = (y2 - y1) / (x2 - x1)
	n = y2 - m * x2;
	return m * val + n
end



local function FindProperties(fluid, key, value) 
	-- key is the property we are looking for and value is its value, the function finds the rest of the properties
	local strQuery=nil;
	local db=fluid.m_Database
	local AvailableProperties=db:fields(fluid.m_FluidName)
	local PosKey=-1 --Position of the key in the columns
	
	strQuery="SELECT "
	for i=1,#AvailableProperties do
		strQuery=strQuery..tostring(AvailableProperties[i])
		
		if(i<#AvailableProperties) then 
			strQuery=strQuery.."," 
		end
		
		if(string.upper(key)==string.upper(AvailableProperties[i])) then 
			PosKey=i 
		end
	end
	
	assert(PosKey>=0,"ERROR: The property you are looking for is not available, have you used member function get() to query available properties")
	
	strQuery=strQuery.." FROM "..fluid.m_FluidName.." WHERE "..tostring(key)
	
	local Upper, Lower={}, {}
	
	local set,row, col=db:sql(strQuery..">="..tostring(value))
	if(row==0) then error("Selected parameter is out of range. ",ERRORLEVEL) end
	for j=1,col do
		table.insert(Upper,set[1][j])
	end

	set,row, col=db:sql(strQuery.."<="..tostring(value))
	assert(set~=nil,"For properties, the parameter "..string.upper(key).." is out of range for this type of fluid. " )
	
	for j=1,col do
		table.insert(Lower,set[row][j])
	end

	local retTable={}
	local x1, x2=Lower[PosKey], Upper[PosKey]
	for i=1,#AvailableProperties do
		if(i~=PosKey) then
			local tblKey=AvailableProperties[i]
			retTable[tblKey]=Interpolation(x1,Lower[i],x2,Upper[i],value)
		end
	end
	
	return retTable

end



local function GetMinMax(fluid, key) 
	-- Given a key, such as Temperature, get the maximum and minimum numbers in the database
	assert(type(key)=="string","ERROR: Second argument, key, must be of type string.")
	
	local db=fluid.m_Database
	
	local strQuery="SELECT max("..key..") FROM "..fluid.m_FluidName
	set,row,col=db:sql(strQuery)
	local maxval=tonumber(set[1][1])
	
	strQuery="SELECT min("..key..") FROM "..fluid.m_FluidName
	set,row,col=db:sql(strQuery)
	local minval=tonumber(set[1][1])

	return minval, maxval
end



function Fluid:type()
	return "Fluid"
end


function Fluid:__tostring()
	
	return "Properties of "..self.m_FluidName.." can be investigated"
end



function Fluid:get(t)
	local db=self.m_Database
	local AvailableProperties=db:fields(self.m_FluidName)
	
	if(t==nil) then
		return AvailableProperties
	end
	
	assert(type(t)=="table", "Argument must be of type Lua table")
		
	local NEntries=0
	local key, value=nil, nil
	for k, v in pairs(t) do
		NEntries=NEntries+1
		key=k
		value=v
	end
	if(NEntries>1) then error("ERROR: You cannot query more than one property at a time.", ERRORLEVEL) end
	if(key==nil or type(value)~="number") then error("ERROR: You should provide an valid key (call get() to query) and a valid number value.", ERRORLEVEL) end
	
	local KeyIsValid=false
	for i=1,#AvailableProperties do
		if(string.upper(key)==string.upper(AvailableProperties[i])) then
			KeyIsValid=true
			break
		end
	end
	
	if(KeyIsValid==false) then error("ERROR: "..tostring(key).." is not a valid key (call get() to query valid keys).", ERRORLEVEL) end
	
	local minval, maxval=GetMinMax(self, key)
	if(value<minval) then error("ERROR: Minimum value for "..tostring(key).." is "..tostring(minval), ERRORLEVEL) end
	if(value>maxval) then error("ERROR: Maximum value for "..tostring(key).." is "..tostring(maxval), ERRORLEVEL) end
	
	return FindProperties(self, key, value)
	
	
end
