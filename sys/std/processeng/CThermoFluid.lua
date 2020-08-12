-- Author:	Gokhan Bingol (gbingol@hotmail.com)
-- License: Subject to end-user license agreement conditions available at www.sciencesuit.org

local std <const> =std


ThermoFluid={}
ThermoFluid.__index=ThermoFluid

--str is the name of the fluid, say Water or R134A
--Search for str in the MainTable for both ASHRAE and IUPAC names

function ThermoFluid.new(str) 
	local THERMOFLUID={}
	setmetatable(THERMOFLUID,ThermoFluid) --create the object
	
	local testDBName =std.const.exedir.."/datafiles/ThermoFluids.db"
	local m_database=Database.new()
	m_database:open(testDBName)
	
	local QueryString="SELECT  SATURATIONTABLE, SUPERHEATEDTABLE FROM MainTable where IUPAC=".."\""..str.."\"".."  collate nocase"
	local set,row,col
	set,row,col=m_database:sql(QueryString)
	
	if(row==0 or row==nil) then
		QueryString="SELECT  SATURATIONTABLE, SUPERHEATEDTABLE FROM MainTable where ASHRAE=".."\""..str.."\"".." collate nocase"
		set,row,col=m_database:sql(QueryString)
		
		if(row==0 or row==nil) then 
			return nil 
		end
	end

	THERMOFLUID.m_Database=m_database
	THERMOFLUID.m_FluidName=str
	THERMOFLUID.FluidState=nil ---1 compressed, 0 saturated, 1 superheated
	THERMOFLUID.m_SaturationTable=set[1][1]
	THERMOFLUID.m_SuperHeatedTable=set[1][2]
	
	return THERMOFLUID
end

local function Interpolation(x1, y1, x2, y2, val) 
	-- Given 2 data points (x1,y1) and (x2,y2) we are looking for the y-value of the point x=val 
	if(x1==x2) then 
		return y1 
	end

	local m,n=0, 0
	m = (y2 - y1) / (x2 - x1)
	n = y2 - m * x2

	return m * val + n
end



local function SaturatedProp(fluid,val, param1, val2, param2) --P: kPa, T: C
	local strQuery=nil;
	local db=fluid.m_Database
	local set,row, col
	local PH, TH, VfH, VgH, HfH, HgH, SfH, SgH
	
	param1=string.lower(param1)
	if(param2~=nil) then param2=string.lower(param2) end

	if(param1=="p") then 
		strQuery="SELECT P, T, Vf, Vg, Hf, Hg, Sf, Sg FROM "..fluid.m_SaturationTable.." WHERE P>="..tostring(val) 
		
	elseif(param1=="t") then 
		strQuery="SELECT P, T, Vf, Vg, Hf, Hg, Sf, Sg FROM "..fluid.m_SaturationTable.." WHERE T>="..tostring(val) 
	end  
	
	set,row, col=db:sql(strQuery)
	assert(row~=0,"Selected parameter is out of range. ")
	
	PH, TH=set[1][1] , set[1][2]
	VfH, VgH=set[1][3] , set[1][4]
	HfH, HgH=set[1][5] , set[1][6]
	SfH, SgH=set[1][7] , set[1][8]


	if(param1=="p") then 
		strQuery="SELECT P, T, Vf, Vg, Hf, Hg, Sf, Sg FROM "..fluid.m_SaturationTable.." WHERE P<="..tostring(val)
	elseif(param1=="t") then
		strQuery="SELECT P, T, Vf, Vg, Hf, Hg, Sf, Sg FROM "..fluid.m_SaturationTable.." WHERE T<="..tostring(val)
	end

	set,row, col=db:sql(strQuery)
	assert(set~=nil,"For saturated properties, the parameter "..string.upper(param1).." is out of range for this type of fluid. ")

	local PL, TL=set[row][1] , set[row][2]
	local VfL, VgL=set[row][3] , set[row][4]
	local HfL, HgL=set[row][5] , set[row][6]
	local SfL, SgL=set[row][7] , set[row][8]	
	local x1,x2=nil, nil
	local SaturationPressure, SaturationTemperature=nil , nil 
	local retTable={}
	local quality=0

	if(param1=="p" or param1=="t") then
		if(param1=="p") then
			x1=PL
			x2=PH
			SaturationPressure=val
			SaturationTemperature=Interpolation(x1,TL, x2, TH, val)
			retTable.P=val
			retTable.T=SaturationTemperature
		elseif(param1=="t") then
			x1=TL
			x2=TH
			SaturationPressure=Interpolation(x1,PL, x2, PH, val)
			retTable.T=val
			retTable.P=SaturationPressure
		end
		
		local Vf=Interpolation(x1,VfL,x2,VfH,val)
		local Vg=Interpolation(x1,VgL,x2,VgH,val)
		local Hf=Interpolation(x1,HfL,x2,HfH,val)
		local Hg=Interpolation(x1,HgL,x2,HgH,val)
		local Sf=Interpolation(x1,SfL,x2,SfH,val)
		local Sg=Interpolation(x1,SgL,x2,SgH,val)
		
		local Uf=Hf-SaturationPressure*Vf;
		local Ug=Hg-SaturationPressure*Vg; 
     
		retTable.vf=Vf; retTable.vg=Vg
		retTable.uf=Uf; retTable.ug=Ug
		retTable.hf=Hf; retTable.hg=Hg
		retTable.sf=Sf; retTable.sg=Sg
		
		if(param2=="s")  then 
			quality=(val2-Sf)/(Sg-Sf) 
		elseif(param2=="h") then 
			quality=(val2-Hf)/(Hg-Hf) 	
		elseif(param2=="v") then 
			quality=(val2-Vf)/(Vg-Vf) 
		end
			
		if(param2=="s" or param2=="h" or param2=="v") then 
			retTable.x=quality 
		end
     
		return retTable
	end

end



local function GetMaxMin(fluid, key) --Only use for superheated
	local db=fluid.m_Database
	
	local strQuery="SELECT max("..key..") FROM "..fluid.m_SuperHeatedTable
	
	set,row,col=db:sql(strQuery)
	
	local maxval=tonumber(set[1])
	
	strQuery="SELECT min("..key..") FROM "..fluid.m_SuperHeatedTable
	set,row,col=db:sql(strQuery)
	
	local minval=tonumber(set[1])

	return minval, maxval
end



local function GetVHSProperties(fluid, P, T, msg) --Only use for superheated
	local db=fluid.m_Database
	local strQuery="SELECT V,H,S FROM "..fluid.m_SuperHeatedTable.." WHERE P="..tostring(P).." AND T="..tostring(T)
	
	local set,row,col=db:sql(strQuery)
	
	local errMsg=msg.."\n"
	errMsg=errMsg.."Properties could not be found at P="..tostring(P).." and T="..tostring(T)
	
	assert(set~=nil,errMsg)
		

	return set, row, col
end



local function SuperHeatedProp_PT(fluid, T, P) -- T: C, P: kPa
	local db=fluid.m_Database
	local set,row, col

	local Pmin, Pmax=GetMaxMin(fluid, "P")
	local Tmin, Tmax=GetMaxMin(fluid, "T")

	assert(P<Pmax,"For superheated properties, the pressure value is out of range, max is "..tostring(Pmax) )
	assert(T<Tmax, "For superheated properties, the temperature value is out of range, max is"..tostring(Tmax))
	

	local PL, PH, TL, TH=nil, nil, nil, nil
	local strQuery="SELECT DISTINCT P FROM "..fluid.m_SuperHeatedTable.. " WHERE P<="..tostring(P).." ORDER BY P DESC LIMIT 1"
	set,row, col=db:sql(strQuery)
	
	assert(set~=nil,"ERROR: For superheated properties, the minimum pressure value is:"..tostring(Pmin).." kPa" )
	
	PL=set[1]
	strQuery="SELECT DISTINCT P FROM "..fluid.m_SuperHeatedTable.. " WHERE P>"..tostring(P).." LIMIT 1"
	set,row,col=db:sql(strQuery)
	
	assert(set~=nil,"ERROR: For superheated properties, the maximum pressure value is:"..tostring(Pmax).." kPa" )

	PH=set[1]
	strQuery="SELECT DISTINCT T FROM "..fluid.m_SuperHeatedTable.. " WHERE P<="..tostring(P).." and T<="..tostring(T).." ORDER BY T DESC LIMIT 1"
	set,row,col=db:sql(strQuery)
	TL=set[1]
	
	strQuery="SELECT DISTINCT T FROM "..fluid.m_SuperHeatedTable.. " WHERE P<="..tostring(P).." and T>"..tostring(T).." LIMIT 1"
	set,row,col=db:sql(strQuery)
	TH=set[1]
	
	local v, h, s={}, {} , {}
	
	local msg="The search for pressure is between "..tostring(PL).." and "..tostring(PH).."\n"
	msg=msg.."For temperature is between "..tostring(TL).." and "..tostring(TH).."\n"
	
	--P low and T low
	set,row,col=GetVHSProperties(fluid, PL, TL, msg)
	v[1]=set[1][1]; h[1]=set[1][2] ; s[1]=set[1][3]
	
	--P low and T high
	set,row,col=GetVHSProperties(fluid, PL, TH, msg)
	v[2]=set[1][1]; h[2]=set[1][2] ; s[2]=set[1][3]
	
	--P high and T low
	set,row,col=GetVHSProperties(fluid, PH, TL, msg)
	v[3]=set[1][1]; h[3]=set[1][2] ; s[3]=set[1][3]
	
	--P high and T high
	set,row,col=GetVHSProperties(fluid, PH, TH, msg)
	v[4]=set[1][1]; h[4]=set[1][2] ; s[4]=set[1][3]
     
	local temp1, temp2=0, 0
	temp1=Interpolation(PL,v[1],PH,v[3],P)
	temp2=Interpolation(PL,v[2],PH,v[4],P)
	local retV=Interpolation(TL,temp1,TH,temp2,T)

	temp1=Interpolation(PL,h[1],PH,h[3],P)
	temp2=Interpolation(PL,h[2],PH,h[4],P)
	local retH=Interpolation(TL,temp1,TH,temp2,T)

	temp1=Interpolation(PL,s[1],PH,s[3],P)
	temp2=Interpolation(PL,s[2],PH,s[4],P)
	local retS=Interpolation(TL,temp1,TH,temp2,T)

	local retTable={}
	retTable.v=retV
	retTable.h=retH
	retTable.s=retS

	return retTable
end



local function SuperHeatedProp_PS(fluid, S, P) -- T: C, P: kPa
	local db=fluid.m_Database
	local set,row, col
	
	local Pmin, Pmax=GetMaxMin(fluid, "P")
	local Smin, Smax=GetMaxMin(fluid, "S")
	
	assert(P<Pmax,"For superheated properties, the pressure value is out of range, max is "..tostring(Pmax))
	assert(S<Smax,"For superheated properties, the entropy value is out of range, max is"..tostring(Smax))
	
	local PL, PH, SL, SH
	local strQuery="SELECT DISTINCT P FROM "..fluid.m_SuperHeatedTable.. " WHERE P<="..tostring(P).." ORDER BY P DESC LIMIT 1"
	set,row, col=db:sql(strQuery)
	PL=set[1]
	
	strQuery="SELECT DISTINCT P FROM "..fluid.m_SuperHeatedTable.. " WHERE P>"..tostring(P).." LIMIT 1"
	set,row,col=db:sql(strQuery)
	PH=set[1]

	local VL,VH, TL, TH, HL, HH
	local V, T, H={} , {} ,{}
	--Lower pressure table
	strQuery="SELECT S,V,T,H FROM "..fluid.m_SuperHeatedTable.. " WHERE P="..tostring(PL).." and S<="..tostring(S).." ORDER BY S DESC LIMIT 1"
	set,row,col=db:sql(strQuery)
	SL=set[1][1]; VL=set[1][2] ; TL=set[1][3] ; HL=set[1][4]
	
	strQuery="SELECT S,V,T,H FROM "..fluid.m_SuperHeatedTable.. " WHERE P="..tostring(PL).." and S>"..tostring(S).." LIMIT 1"
	set,row,col=db:sql(strQuery)
	SH=set[1][1] ; VH=set[1][2] ; TH=set[1][3] ; HH=set[1][4]
	V.LowP=Interpolation(SL,VL,SH,VH,S)
	T.LowP=Interpolation(SL,TL,SH,TH,S)
	H.LowP=Interpolation(SL,HL,SH,HH,S)

	--Higher pressure table
	strQuery="SELECT S,V,T,H FROM "..fluid.m_SuperHeatedTable.. " WHERE P="..tostring(PH).." and S<="..tostring(S).." ORDER BY S DESC LIMIT 1"
	set,row,col=db:sql(strQuery)
	SL=set[1][1] ; VL=set[1][2] ; TL=set[1][3] ; HL=set[1][4]
	
	strQuery="SELECT S,V,T,H FROM "..fluid.m_SuperHeatedTable.. " WHERE P="..tostring(PH).." and S>"..tostring(S).." LIMIT 1"
	set,row,col=db:sql(strQuery)
	SH=set[1][1] ; VH=set[1][2] ; TH=set[1][3] ; HH=set[1][4]
	
	V.HighP=Interpolation(SL,VL,SH,VH,S)
	T.HighP=Interpolation(SL,TL,SH,TH,S)
	H.HighP=Interpolation(SL,HL,SH,HH,S)

	V.actual=Interpolation(PL,V.LowP, PH, V.HighP, P)
	T.actual=Interpolation(PL,T.LowP, PH, T.HighP, P)
	H.actual=Interpolation(PL,H.LowP, PH, H.HighP, P)
	
	local retTable={}
	retTable.v=V.actual
	retTable.T=T.actual
	retTable.h=H.actual

	return retTable
end
     


function ThermoFluid:type()
	return "ThermoFluid"
end

function ThermoFluid:__tostring()
	local str=""
	
	local FluidType=self.m_FluidName
	str=str.."Thermodynamic properties of "..FluidType.." can be investigated"

	return str
end



function ThermoFluid:get(t)
	--Saturated 
	if(t.P~=nil and t.T==nil and t.s==nil and t.v==nil and t.h==nil) then --P
		self.FluidState=0
		return SaturatedProp(self, t.P, "P")

	elseif(t.P==nil and t.T~=nil and t.s==nil and t.v==nil and t.h==nil) then --T
		self.FluidState=0
		return SaturatedProp(self, t.T, "T")

	elseif(t.P~=nil and t.T==nil and t.s~=nil and t.v==nil and t.h==nil) then --P,s
		self.FluidState=0
		return SaturatedProp(self, t.P, "P", t.s,"s")

	elseif(t.P~=nil and t.T==nil and t.s==nil and t.v~=nil and t.h==nil) then --P,v
		self.FluidState=0
		return SaturatedProp(self, t.P, "P", t.v,"v")

	elseif(t.P~=nil and t.T==nil and t.s==nil and t.v==nil and t.h~=nil) then --P,h
		self.FluidState=0
		return SaturatedProp(self, t.P, "P", t.h,"h")

	elseif(t.P==nil and t.T~=nil and t.s~=nil and t.v==nil and t.h==nil) then --T,s
		self.FluidState=0
		return SaturatedProp(self, t.T, "T", t.s,"s")

	elseif(t.P==nil and t.T~=nil and t.s==nil and t.v~=nil and t.h==nil) then --T,v
		self.FluidState=0
		return SaturatedProp(self, t.T, "T", t.v,"v")

	elseif(t.P==nil and t.T~=nil and t.s==nil and t.v==nil and t.h~=nil) then --T,h
		self.FluidState=0
		return SaturatedProp(self, t.T, "T", t.h,"h")
	end



	--Superheated
	if(t.T~=nil and t.P~=nil and t.s==nil) then --P,T
		
		local saturated= SaturatedProp(self, t.P, "P")
		
		if(tonumber(saturated.T)<tonumber(t.T)) then 
			self.FluidState=1
			return SuperHeatedProp_PT(self, t.T, t.P)
			
		else -- Compressed
			self.FluidState=-1
			
			local retTable={}
			retTable.s=saturated.sf
			retTable.v=saturated.vf 
			retTable.h=saturated.hf
			
			return retTable
		end
	end


	if(t.T==nil and t.P~=nil and t.s~=nil) then --P,s
		
		local saturated= SaturatedProp(self, t.P, "P")
		
		if(saturated.sg<tonumber(t.s)) then 
			self.FluidState=1
			return SuperHeatedProp_PS(self, t.s, t.P)
			
		else -- Compressed
			self.FluidState=-1
			
			local retTable={}
			retTable.s=saturated.sf 
			retTable.v=saturated.vf 
			retTable.h=saturated.hf
			
			return retTable
		end
	end
	
	
end
