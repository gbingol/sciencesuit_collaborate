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



local function GetRange(fluid, key, IsSuperHeated) 
	local db=fluid.m_Database
	local FluidTable=""
	
	if(IsSuperHeated==nil or  IsSuperHeated==true) then
		FluidTable=fluid.m_SuperHeatedTable
	else
		FluidTable=fluid.m_SaturationTable
	end
	
	local strQuery="SELECT max("..key..") FROM "..FluidTable
	
	set,row,col=db:sql(strQuery)
	
	local maxval=tonumber(set[1])
	
	strQuery="SELECT min("..key..") FROM "..FluidTable
	set,row,col=db:sql(strQuery)
	
	local minval=tonumber(set[1])

	return minval, maxval
end




--str is the name of the fluid, say Water or R134A
--Search for str in the MainTable for both ASHRAE and IUPAC names

local function Initialize(str, ConnectionInfo) 
	
	if(ConnectionInfo~=nil) then
		
		if(ConnectionInfo.m_Database~=nil and ConnectionInfo.m_FluidName~=nil 
			and ConnectionInfo.FluidState~=nil and ConnectionInfo.m_SaturationTable~=nil
			and ConnectionInfo.m_SuperHeatedTable~=nil) then
			
			
			return ConnectionInfo
			
		end
	
	end
	
	
	
	local THERMOFLUID={}
	
	
	local testDBName =std.const.exedir.."/datafiles/ThermoFluids.db"
	local m_database=std.Database.new()
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
	THERMOFLUID.FluidState=nil -- -1 compressed, 0 saturated, 1 superheated
	THERMOFLUID.m_SaturationTable=set[1][1]
	THERMOFLUID.m_SuperHeatedTable=set[1][2]
	
	return THERMOFLUID
end







local function SaturatedProp(fluid,val, param1, qValue, Quality) --P: kPa, T: C
	local strQuery="";
	local set,row, col=nil, 0, 0
	local db=fluid.m_Database
	
	param1=string.lower(param1)
	
	local AvailableCols=db:columns(fluid.m_SaturationTable)
	
	local ColumnNames=""
	
	local ColumnExists=false
	for key, value in pairs(AvailableCols) do
		if(param1==string.lower(value)) then
			ColumnExists=true
			
			break
		end

		ColumnNames=ColumnNames.."  "..value
	end

	assert(ColumnExists==true, "Available options:"..ColumnNames)
	
	
	--false for marking it as NOT superheated
	local MinValue, MaxValue=GetRange(fluid, param1, false) 
	assert(val>=MinValue and val<=MaxValue,"Valid range: ["..tostring(MinValue)..", "..tostring(MaxValue).."]")
	
	
	
	--Check if the numbers are increasing or decreasing for the given property
	strQuery="SELECT "..param1.." FROM "..fluid.m_SaturationTable 
	set,row, col=db:sql(strQuery)

	assert(row>6, "Not enough data for the particular fluid")
	
	local Diff=set[math.floor(row/2)]-set[1]
	
	--this would probably never gonna happen
	assert(Diff~=0, "Parameter is not linear in the first half")
	
	local IsIncreasing=false
	if(Diff>0) then IsIncreasing=true end
	
	local RowLoc;

	
	strQuery="SELECT P, T, Vf, Vg, Hf, Hg, Sf, Sg FROM "..fluid.m_SaturationTable.." WHERE "..param1..">="..tostring(val) 
	set,row, col=db:sql(strQuery)
	
	if(IsIncreasing) then RowLoc=1 else RowLoc=row end
	
	local PH, TH=set[RowLoc][1] , set[RowLoc][2]
	local VfH, VgH=set[RowLoc][3] , set[RowLoc][4]
	local HfH, HgH=set[RowLoc][5] , set[RowLoc][6]
	local SfH, SgH=set[RowLoc][7] , set[RowLoc][8]


	strQuery="SELECT P, T, Vf, Vg, Hf, Hg, Sf, Sg FROM "..fluid.m_SaturationTable.." WHERE "..param1.."<="..tostring(val) 
	set,row, col=db:sql(strQuery)
	
	if(IsIncreasing) then RowLoc=row else RowLoc=1 end

	local PL, TL=set[RowLoc][1] , set[RowLoc][2]
	local VfL, VgL=set[RowLoc][3] , set[RowLoc][4]
	local HfL, HgL=set[RowLoc][5] , set[RowLoc][6]
	local SfL, SgL=set[RowLoc][7] , set[RowLoc][8]	
	
	
	
	
	
	local x1, x2=0, 0
	
	strQuery="SELECT "..param1.." FROM "..fluid.m_SaturationTable.." WHERE "..param1.."<="..tostring(val) 
	set,row, col=db:sql(strQuery)
	
	if(IsIncreasing) then RowLoc=row else RowLoc=1 end	
	x1=set[RowLoc]
	
		
	
	strQuery="SELECT "..param1.." FROM "..fluid.m_SaturationTable.." WHERE "..param1..">="..tostring(val)
	set,row, col=db:sql(strQuery)
	
	if(IsIncreasing) then RowLoc=1 else RowLoc=row end
	x2=set[RowLoc]
	
	
	local retTable={}
	
	
	local T=Interpolation(x1, TL, x2, TH, val)
	local P=Interpolation(x1,PL,x2,PH,val)
	local Vf=Interpolation(x1,VfL,x2,VfH,val)
	local Vg=Interpolation(x1,VgL,x2,VgH,val)
	local Hf=Interpolation(x1,HfL,x2,HfH,val)
	local Hg=Interpolation(x1,HgL,x2,HgH,val)
	local Sf=Interpolation(x1,SfL,x2,SfH,val)
	local Sg=Interpolation(x1,SgL,x2,SgH,val)
	
	local Uf=Hf-P*Vf;
	local Ug=Hg-P*Vg; 

	retTable.T=T
	retTable.P=P
	retTable.vf=Vf; 
	retTable.vg=Vg
	retTable.uf=Uf; 
	retTable.ug=Ug
	retTable.hf=Hf; 
	retTable.hg=Hg
	retTable.sf=Sf; 
	retTable.sg=Sg
	
	if(param1=="t" or param1=="p") then
		retTable[string.upper(param1)]=val
	else
		retTable[param1]=val
	end
	
	if(Quality~=nil) then 
		Quality=string.lower(Quality) 
	end
	
	if(Quality=="s")  then 
		retTable.x=(qValue-Sf)/(Sg-Sf) 
	elseif(Quality=="h") then 
		retTable.x=(qValue-Hf)/(Hg-Hf) 	
	elseif(Quality=="v") then 
		retTable.x=(qValue-Vf)/(Vg-Vf) 
	end
		

	return retTable
	

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

	local Pmin, Pmax=GetRange(fluid, "P")
	local Tmin, Tmax=GetRange(fluid, "T")

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
	
	local Pmin, Pmax=GetRange(fluid, "P")
	local Smin, Smax=GetRange(fluid, "S")
	
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
     





local function ComputeProperties(fluidName, t, ConnInfo)
	--Saturated 

	local ThermFluid=nil
	local KeepAlive=false --keep database conn alive

	if(type(ConnInfo)=="boolean" and ConnInfo==true) then
		ThermFluid=Initialize(fluidName)
		
		KeepAlive=true
	
	elseif(type(ConnInfo)=="table") then
	
		ThermFluid=Initialize(fluidName, ConnInfo)
		
		KeepAlive=true
		
	else
		ThermFluid=Initialize(fluidName)
		
		KeepAlive=false
	end
		
	
	
	
	local retTable={}
	
	
	ThermFluid.FluidState=0
	
	local nargs=0
	
	for key, value in pairs(t) do
		nargs=nargs+1
	end
	
	
	--nargs==1 then saturated
	if(nargs==1) then 
		local key, val=next(t)
		retTable= SaturatedProp(ThermFluid, val, key)
	end


	if(nargs>1) then
		--Superheated
		if(t.T~=nil and t.P~=nil and t.s==nil) then --P,T
			
			local saturated= SaturatedProp(ThermFluid, t.P, "P")
			
			if(tonumber(saturated.T)<tonumber(t.T)) then 
				ThermFluid.FluidState=1
				
				retTable= SuperHeatedProp_PT(ThermFluid, t.T, t.P)
				
			else -- Compressed
				ThermFluid.FluidState=-1
				
				retTable={}
				retTable.s=saturated.sf
				retTable.v=saturated.vf 
				retTable.h=saturated.hf
				
			end
		end


		if(t.T==nil and t.P~=nil and t.s~=nil) then --P,s
			
			local saturated= SaturatedProp(ThermFluid, t.P, "P")
			
			if(saturated.sg<tonumber(t.s)) then 
				ThermFluid.FluidState=1
				
				retTable= SuperHeatedProp_PS(ThermFluid, t.s, t.P)
				
			else -- Compressed
				ThermFluid.FluidState=-1
				
				retTable={}
				retTable.s=saturated.sf 
				retTable.v=saturated.vf 
				retTable.h=saturated.hf
				
			end
		end

	end

	
	retTable.state=ThermFluid.FluidState
	
	if(KeepAlive) then
		retTable.conninfo= ThermFluid
	else
		ThermFluid.m_Database:close()
	end


	
	return retTable
		
end


std.thermofluid=ComputeProperties




-- Author:	Gokhan Bingol (gbingol@hotmail.com)
-- License: Subject to end-user license agreement conditions available at www.sciencesuit.org
