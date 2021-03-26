-- Author:	Gokhan Bingol (gbingol@hotmail.com)
-- License: Subject to end-user license agreement conditions available at www.sciencesuit.org



local function BracketPressure(fluid, P)
	local db=fluid.Database

	local Pmin, Pmax = std.fluid.range(fluid, fluid.SuperHeatedTable, "P")

	if(P > Pmax) then
		error("the pressure value is out of range, max is "..tostring(Pmax), std.const.ERRORLEVEL )
	end
	

	local PL, PH=nil, nil
	
	local strQuery="SELECT DISTINCT P FROM "..fluid.SuperHeatedTable.. " WHERE P<="..tostring(P).." ORDER BY P DESC LIMIT 1"
	local setPL=db:sql(strQuery)
	
	
	strQuery="SELECT DISTINCT P FROM "..fluid.SuperHeatedTable.. " WHERE P>"..tostring(P).." LIMIT 1"
	local setPH = db:sql(strQuery)
	
	if(setPL == nil or setPH == nil) then
		error("Bounds are:"..tostring(Pmin)..", "..tostring(Pmax).." kPa" , std.const.ERRORLEVEL)
	end



	PL=setPL[1]
	PH=setPH[1]
	
	return PL, PH
end






local function BracketProperty(fluid, Pressure, PropertyName, PropertyValue)
	local db=fluid.Database

	local MinMax="SELECT Min("..PropertyName.."), Max("..PropertyName..") FROM "..fluid.SuperHeatedTable.. " WHERE P="..tostring(Pressure)
	local setMinMax=db:sql(MinMax)
	
	local Min, Max = setMinMax[1][1], setMinMax[1][2]
	
	
	if(PropertyValue < Min or PropertyValue > Max) then
		local ErrMsg="At P="..tostring(Pressure).." bounds for "..PropertyName..": ["..tostring(Min)..", "..tostring(Max).."]"
		
		error(ErrMsg, std.const.ERRORLEVEL)
	end 
	
	
	local strQuery="SELECT DISTINCT "..PropertyName.." FROM "..fluid.SuperHeatedTable.. " WHERE P="..tostring(Pressure).." and "..PropertyName.."<="..tostring(PropertyValue).." ORDER BY "..PropertyName.." DESC LIMIT 1"
	local setPropLower = db:sql(strQuery)
	
	
	strQuery="SELECT DISTINCT "..PropertyName.." FROM "..fluid.SuperHeatedTable.. " WHERE P="..tostring(Pressure).." and "..PropertyName..">"..tostring(PropertyValue).." LIMIT 1"
	local setPropUpper= db:sql(strQuery)
	
	if(setPropLower == nil or setPropUpper == nil) then
		error("Could not locate the properties" , std.const.ERRORLEVEL)
	end
	
	return setPropLower[1], setPropUpper[1]
end
	
	
	
	
	
	
local function ComputeOtherProperties(fluid, Pressure, PropertyName, PropertyValue, QueriedProps) 
	
	local db=fluid.Database
	
	local v, h, s={}, {} , {}
	
	local PropL, PropH = BracketProperty(fluid, Pressure, PropertyName, PropertyValue)
	
	
	strQuery="SELECT " ..QueriedProps.." FROM "..fluid.SuperHeatedTable.." WHERE P="..tostring(Pressure).." AND "..PropertyName.."="..tostring(PropL)
	
	local set = db:sql(strQuery)

	v[1]=set[1][1]; h[1]=set[1][2] ; s[1]=set[1][3]
	
	
	
	strQuery="SELECT " ..QueriedProps.." FROM "..fluid.SuperHeatedTable.." WHERE P="..tostring(Pressure).." AND "..PropertyName.."="..tostring(PropH)
	
	local set = db:sql(strQuery)
	
	v[2]=set[1][1]; h[2]=set[1][2] ; s[2]=set[1][3]
	
	

	local retV = std.fluid.interpolate(PropL,v[1],PropH,v[2], PropertyValue)
	local retH = std.fluid.interpolate(PropL,h[1],PropH, h[2], PropertyValue)
	local retS = std.fluid.interpolate(PropL,s[1],PropH, s[2], PropertyValue)

	return retV, retH, retS

end
	
	





local function SuperHeatedProp_PT(fluid, P, T) -- T: C, P: kPa
	local db=fluid.Database

	local Tmin, Tmax = std.fluid.range(fluid, fluid.SuperHeatedTable, "T")
	
	if(T<Tmin or T>Tmax) then
		error("Temperature is expected to be in ["..tostring(Tmin)..", "..tostring(Tmax).."]", std.const.ERRORLEVEL)
	end



	local PL, PH= BracketPressure(fluid, P)
	
	
	local v, h, s={}, {} , {}
	
	
	v[1], h[1], s[1] = ComputeOtherProperties(fluid, PL, "T", T, "V, H, S") 
	v[2], h[2], s[2] = ComputeOtherProperties(fluid, PH, "T", T, "V, H, S") 
	
	
	
	
	local retV = std.fluid.interpolate(PL,v[1],PH,v[2], P)
	local retH = std.fluid.interpolate(PL,h[1],PH,h[2], P)
	local retS = std.fluid.interpolate(PL,s[1],PH,s[2], P)

	

	return {v=retV, h=retH, s=retS}
end




local function SuperHeatedProp_PS(fluid, P, S) 
	local db=fluid.Database
	
	local Smin, Smax = std.fluid.range(fluid, fluid.SuperHeatedTable, "s")
	
	if(S<Smin or S>Smax) then
		error("Entropy is expected to be in ["..tostring(Smin)..", "..tostring(Smax).."]", std.const.ERRORLEVEL)
	end



	local PL, PH= BracketPressure(fluid, P)
	
	
	local T, v, h={}, {} , {}
	
	
	T[1], v[1], h[1] = ComputeOtherProperties(fluid, PL, "s", S, "T, V, h") 
	T[2], v[2], h[2] = ComputeOtherProperties(fluid, PH, "s", S, "T, V, h") 
	
	
	
	
	local retT = std.fluid.interpolate(PL,T[1],PH,T[2], P)
	local retV = std.fluid.interpolate(PL,v[1],PH,v[2], P)
	local retH = std.fluid.interpolate(PL,h[1],PH,h[2], P)

	

	return {T=retT, h=retH, v=retV}
end








local function ComputeProperties(Arg, ParamTable)
	
	--Arg is either:
	--1) Fluid's name like "Water", "R134A"...  
	--2) Fluid itself (user has already created using std.fluid.new)
	
	--If Arg is #2, then user is responsible to close the database connection (therefore we keep it alive)

	local Refrigerant=nil
	local KeepAlive = false

	if(type(Arg)=="string") then
		Refrigerant = std.fluid.new(Arg, "R")
		
		if(Refrigerant == nil) then error("Could not create the refrigerant", std.const.ERRORLEVEL) end
	
	elseif(type(Arg)=="table") then

		if(Arg.Type ~="Fluid") then error("Invalid fluid", std.const.ERRORLEVEL) end
	
		Refrigerant = Arg
		
		KeepAlive=true
	end
		
	

	
	local nargs=0
	
	for key, value in pairs(ParamTable) do
		nargs=nargs+1
	end

	
	
	if(nargs == 0) then
		error("No key found in the parameter table", std.const.ERRORLEVEL)
	end
	
	
	local retTable=nil
	
	--nargs==1 then saturated
	if(nargs == 1) then 
		local key, val=next(ParamTable)
		retTable= std.fluid.findprops(Refrigerant, key, val)
		
		if(KeepAlive == false) then
			Refrigerant.Database:close()
		end


		return retTable
	end

	
	--Superheated
	
	local PValue=ParamTable.P or ParamTable.p
	local TValue=ParamTable.T or ParamTable.t
	local SValue= ParamTable.S or ParamTable.s

	local saturated= std.fluid.findprops(Refrigerant, "P", ParamTable.P)
	
	if(PValue == nil) then
		error("Pressure must be defined", std.const.ERRORLEVEL)
	end
	
	
	
	if(TValue ~=nil) then --P,T
		if(tonumber(saturated.T) < tonumber(TValue)) then 
			retTable = SuperHeatedProp_PT(Refrigerant, PValue, TValue)
		end


	elseif(SValue ~= nil) then --P,s
		
		if(saturated.sg < tonumber(SValue)) then 
			retTable = SuperHeatedProp_PS(Refrigerant, PValue, SValue)
		end

	end

	
	
	if(KeepAlive == false) then
		Refrigerant.Database:close()
	end


	if(retTable == nil) then
		error("With givens, properties could not be computed.", std.const.ERRORLEVEL)
	end
	
	
	return retTable
		
end





std.fluid.refrigerant = ComputeProperties

