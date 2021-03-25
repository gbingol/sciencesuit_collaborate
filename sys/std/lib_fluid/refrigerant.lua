local function Interpolation(x1, y1, x2, y2, val)

	-- Given 2 data points (x1,y1) and (x2,y2) we are looking for the y-value of the point x=val 
	if(x1 == x2) then 
		return y1 
	end

	local m,n=0, 0
	m = (y2 - y1) / (x2 - x1)
	n = y2 - m * x2

	return m * val + n
end



local function GetRange(fluid, key, IsSuperHeated) 
	local db = fluid.m_Database
	local FluidTable = ""
	
	if(IsSuperHeated==nil or  IsSuperHeated==true) then
		FluidTable=fluid.m_SuperHeatedTable
	else
		FluidTable=fluid.m_SINGLEPARAM
	end
	
	local strQuery="SELECT max("..key..") FROM "..FluidTable
	
	local set,row,col=db:sql(strQuery)
	
	local maxval=tonumber(set[1])
	
	strQuery="SELECT min("..key..") FROM "..FluidTable
	set,row,col=db:sql(strQuery)
	
	local minval=tonumber(set[1])

	return minval, maxval
end




--str is the name of the fluid, say Water or R134A
--Search for str in the MainTable for both ALTERNATIVE and NAME names

local function Initialize(str, ConnectionInfo) 
	
	
	if(ConnectionInfo~=nil) then
		
		if(ConnectionInfo.m_Database~=nil and ConnectionInfo.m_FluidName~=nil 
			and ConnectionInfo.m_SINGLEPARAM~=nil
			and ConnectionInfo.m_SuperHeatedTable~=nil) then
			
			
			return ConnectionInfo
			
		end
	
	end
	
	
	
	local REFRIGERANT={}

	
	local testDBName = std.const.exedir.."/datafiles/Fluids.db"
	local m_database = std.Database.new()
	m_database:open(testDBName)
	
	
	local QueryString="SELECT  SINGLEPARAM, SUPERHEATEDTABLE FROM MAINTABLE where NAME=".."\""..str.."\"".."  collate nocase and TYPE=\"R\""
	local set,row,col
	set,row,col=m_database:sql(QueryString)
	
	if(row==0 or row==nil) then
		QueryString="SELECT  SINGLEPARAM, SUPERHEATEDTABLE FROM MAINTABLE where ALTERNATIVE=".."\""..str.."\"".." collate nocase and TYPE=\"R\""
		set, row, col = m_database:sql(QueryString)
		
		if(row==0 or row==nil) then 
			return nil 
		end
	end

	REFRIGERANT.m_Database=m_database
	REFRIGERANT.m_FluidName=str
	REFRIGERANT.m_SINGLEPARAM=set[1][1]
	REFRIGERANT.m_SuperHeatedTable=set[1][2]
	

	return REFRIGERANT
end







local function SINGLEPARAMSEARCH(fluid, val, param1) --P: kPa, T: C
	local strQuery="";
	local set,row, col=nil, 0, 0
	local db=fluid.m_Database
	
	param1=string.lower(param1)
	
	local AvailableCols=db:columns(fluid.m_SINGLEPARAM)
	
	local ColumnNames=""
	
	local ColumnExists=false
	for key, value in pairs(AvailableCols) do
		if(param1==string.lower(value)) then
			ColumnExists=true
			
			break
		end

		ColumnNames = ColumnNames.."  "..value
	end

	assert(ColumnExists == true, "Available options:"..ColumnNames)
	
	
	--false for marking it as NOT superheated
	local MinValue, MaxValue=GetRange(fluid, param1, false) 
	
	if(val < MinValue or val> MaxValue) then 
		error("Valid range: ["..tostring(MinValue)..", "..tostring(MaxValue).."]", std.const.ERRORLEVEL)
	end
	
	
	
	--Check if the numbers are increasing or decreasing for the given property
	strQuery="SELECT "..param1.." FROM "..fluid.m_SINGLEPARAM 
	set,row, col=db:sql(strQuery)

	if(row<6) then error("Not enough data for the particular fluid", std.const.ERRORLEVEL) end
	
	
	--We select a value from the middle point of the properties and subtract the value at the very beginning
	-- if Diff>0, then the numbers are increasing otherwise decreasing
	local Diff = set[math.floor(row/2)] - set[1]
	
	
	local RowLoc;

	
	strQuery="SELECT P, T, Vf, Vg, Hf, Hg, Sf, Sg FROM "..fluid.m_SINGLEPARAM.." WHERE "..param1..">="..tostring(val) 
	set,row, col=db:sql(strQuery)
	
	if(Diff > 0) then RowLoc=1 else RowLoc=row end
	
	local PH, TH=set[RowLoc][1] , set[RowLoc][2]
	local VfH, VgH=set[RowLoc][3] , set[RowLoc][4]
	local HfH, HgH=set[RowLoc][5] , set[RowLoc][6]
	local SfH, SgH=set[RowLoc][7] , set[RowLoc][8]


	strQuery="SELECT P, T, Vf, Vg, Hf, Hg, Sf, Sg FROM "..fluid.m_SINGLEPARAM.." WHERE "..param1.."<="..tostring(val) 
	set,row, col=db:sql(strQuery)
	
	if(Diff > 0) then RowLoc=row else RowLoc=1 end

	local PL, TL=set[RowLoc][1] , set[RowLoc][2]
	local VfL, VgL=set[RowLoc][3] , set[RowLoc][4]
	local HfL, HgL=set[RowLoc][5] , set[RowLoc][6]
	local SfL, SgL=set[RowLoc][7] , set[RowLoc][8]	
	
	
	
	
	
	local x1, x2=0, 0
	
	strQuery="SELECT "..param1.." FROM "..fluid.m_SINGLEPARAM.." WHERE "..param1.."<="..tostring(val) 
	set,row, col=db:sql(strQuery)
	
	if(Diff > 0) then RowLoc=row else RowLoc=1 end	
	x1=set[RowLoc]
	
		
	
	strQuery="SELECT "..param1.." FROM "..fluid.m_SINGLEPARAM.." WHERE "..param1..">="..tostring(val)
	set,row, col=db:sql(strQuery)
	
	if(Diff > 0) then RowLoc=1 else RowLoc=row end
	x2=set[RowLoc]
	
	
	local retTable={}
	
	
	local T = Interpolation(x1, TL, x2, TH, val)
	local P = Interpolation(x1,PL,x2,PH,val)
	local Vf = Interpolation(x1,VfL,x2,VfH,val)
	local Vg = Interpolation(x1,VgL,x2,VgH,val)
	local Hf = Interpolation(x1,HfL,x2,HfH,val)
	local Hg = Interpolation(x1,HgL,x2,HgH,val)
	local Sf = Interpolation(x1,SfL,x2,SfH,val)
	local Sg = Interpolation(x1,SgL,x2,SgH,val)
	
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
	
		

	return retTable
	

end











local function SuperHeatedProp_PT(fluid, T, P) -- T: C, P: kPa
	local db=fluid.m_Database

	local Pmin, Pmax = GetRange(fluid, "P")
	local Tmin, Tmax = GetRange(fluid, "T")

	if(P>Pmax) then
		error("For superheated properties, the pressure value is out of range, max is "..tostring(Pmax), std.const.ERRORLEVEL )
	end

	if(T>Tmax) then
		error("For superheated properties, the temperature value is out of range, max is"..tostring(Tmax), std.const.ERRORLEVEL)
	end
	

	local PL, PH, TL, TH=nil, nil, nil, nil
	
	local strQuery="SELECT DISTINCT P FROM "..fluid.m_SuperHeatedTable.. " WHERE P<="..tostring(P).." ORDER BY P DESC LIMIT 1"
	local setPL=db:sql(strQuery)
	
	
	strQuery="SELECT DISTINCT P FROM "..fluid.m_SuperHeatedTable.. " WHERE P>"..tostring(P).." LIMIT 1"
	local setPH = db:sql(strQuery)
	
	if(setPL == nil or setPH == nil) then
		error("Bounds are:"..tostring(Pmin)..", "..tostring(Pmax).." kPa" , std.const.ERRORLEVEL)
	end

	PL=setPL[1]
	PH=setPH[1]
	
	
	strQuery="SELECT DISTINCT T FROM "..fluid.m_SuperHeatedTable.. " WHERE P<="..tostring(P).." and T<="..tostring(T).." ORDER BY T DESC LIMIT 1"
	local setTL = db:sql(strQuery)
	
	
	strQuery="SELECT DISTINCT T FROM "..fluid.m_SuperHeatedTable.. " WHERE P<="..tostring(P).." and T>"..tostring(T).." LIMIT 1"
	local setTH = db:sql(strQuery)
	
	
	if(setTL == nil or setTH == nil) then
		error("Could not locate the properties" , std.const.ERRORLEVEL)
	end
	
	TL=setTL[1]
	TH=setTH[1]
	
	
	
	local v, h, s={}, {} , {}
	
	local msg="The search for pressure is between "..tostring(PL).." and "..tostring(PH).."\n"
	msg=msg.."For temperature is between "..tostring(TL).." and "..tostring(TH).."\n"
	
	
	local function GetVHS(fluid, P, T, msg) --Only use for superheated
		local db=fluid.m_Database
		local strQuery="SELECT V,H,S FROM "..fluid.m_SuperHeatedTable.." WHERE P="..tostring(P).." AND T="..tostring(T)
		
		local set, row, col = db:sql(strQuery)
		
		local errMsg = msg.."\n"
		errMsg=errMsg.."Properties could not be found at P="..tostring(P).." and T="..tostring(T)
		
		if(set == nil) then error(errMsg, std.const.ERRORLEVEL) end
			

		return set, row, col
	end
	
	--P low and T low
	local set=nil
	set=GetVHS(fluid, PL, TL, msg)
	v[1]=set[1][1]; h[1]=set[1][2] ; s[1]=set[1][3]
	
	--P low and T high
	set,row,col=GetVHS(fluid, PL, TH, msg)
	v[2]=set[1][1]; h[2]=set[1][2] ; s[2]=set[1][3]
	
	--P high and T low
	set,row,col=GetVHS(fluid, PH, TL, msg)
	v[3]=set[1][1]; h[3]=set[1][2] ; s[3]=set[1][3]
	
	--P high and T high
	set,row,col=GetVHS(fluid, PH, TH, msg)
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

	

	return {v=retV, h=retH, s=retS}
end



local function SuperHeatedProp_PS(fluid, S, P) -- T: C, P: kPa
	local db=fluid.m_Database
	local set,row, col
	
	local Pmin, Pmax=GetRange(fluid, "P")
	local Smin, Smax=GetRange(fluid, "S")
	
	if(P>Pmax) then
		error("For superheated properties, the pressure value is out of range, max is "..tostring(Pmax), std.const.ERRORLEVEL)
	end

	if(S>Smax) then
		error("For superheated properties, the entropy value is out of range, max is"..tostring(Smax), std.const.ERRORLEVEL)
	end
	
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

	local Refrigerant=nil
	local KeepAlive=false --keep database conn alive

	if(type(ConnInfo)=="boolean" and ConnInfo==true) then
		Refrigerant=Initialize(fluidName)
		
		KeepAlive=true
	
	elseif(type(ConnInfo)=="table") then
	
		Refrigerant=Initialize(fluidName, ConnInfo)
		
		KeepAlive=true
		
	else
		Refrigerant=Initialize(fluidName)
		
		KeepAlive=false
	end
		
	

	
	local nargs=0
	
	for key, value in pairs(t) do
		nargs=nargs+1
	end
	
	
	local retTable={}
	
	--nargs==1 then saturated
	if(nargs == 1) then 
		local key, val=next(t)
		
		retTable= SINGLEPARAMSEARCH(Refrigerant, val, key)
	end


	if(nargs>1) then
		--Superheated
		if(t.T~=nil and t.P~=nil and t.s==nil) then --P,T
			
			local saturated= SINGLEPARAMSEARCH(Refrigerant, t.P, "P")
			
			if(tonumber(saturated.T) < tonumber(t.T)) then 
				retTable = SuperHeatedProp_PT(Refrigerant, t.T, t.P)
			end
		end


		if(t.T==nil and t.P~=nil and t.s~=nil) then --P,s
			
			local saturated= SINGLEPARAMSEARCH(Refrigerant, t.P, "P")
			
			if(saturated.sg < tonumber(t.s)) then 
				retTable = SuperHeatedProp_PS(Refrigerant, t.s, t.P)
			end
		end

	end

	
	if(KeepAlive) then
		retTable.conninfo= Refrigerant
	else
		Refrigerant.m_Database:close()
	end


	
	return retTable
		
end





std.fluid.refrigerant = ComputeProperties




-- Author:	Gokhan Bingol (gbingol@hotmail.com)
-- License: Subject to end-user license agreement conditions available at www.sciencesuit.org
