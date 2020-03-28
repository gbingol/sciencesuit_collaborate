-- Author:	Gokhan Bingol (gbingol@sciencesuit.org)
-- License: Subject to end-user license agreement conditions available at www.sciencesuit.org

require( "iuplua" )

local TOLERANCE=std.const.tolerance


--Finds the vector containing consecutive averages [elem(i)+elem(i-1)] / 2
local function FindAvg(vec)
	local retVec=Vector.new(0)
	
	for i=2,#vec do
		local avg=(vec(i)+vec(i-1))/2
		
		retVec:push_back(avg)
	end


	return retVec 
end
	



local function FoodThermalProcessing()

	local m_Food=nil
	local m_database=nil
	local m_QuerySet=nil
	
	--Design of Page 1
	
	local  lblFoodVar=iup.label{title="Variable:"}
	local txtFoodVar=iup.text{expand="horizontal"}
	local btnShowOrganism=iup.button{title="Show Organisms"}
	
	local FoodVars=iup.hbox{lblFoodVar,txtFoodVar,btnShowOrganism}
	
	local lblListHeading=iup.label{title="Possible Organisms in the Food"}
	
	local lstOrganisms=iup.list{expand="yes"}

	
	local lblMinpH=iup.label{title="Min pH:"}
	local txtMinpH=std.gui.numtext{min=0, max=14}
	
	local lblMinAw=iup.label{title="Min aw:"}
	local txtMinAw=std.gui.numtext{min=0, max=1}
	
	local lblDTime=iup.label{title="D (time):"}
	local txtDTime=std.gui.numtext{min=0}
	
	local lblDTemperature=iup.label{title="D (temperature):"}
	local txtDTemperature=std.gui.numtext{min=0}
	
	local lblZVal=iup.label{title="z-value:"}
	local txtZVal=std.gui.numtext{min=0}
	
	local lblFoodMedia=iup.label{title="Food Media:"}
	local txtFoodMedia=iup.text{expand="horizontal"}
	
	local lblRef=iup.label{title="Reference:"}
	local txtRef=iup.text{expand="YES", multiline="YES", wordwrap="YES"}
	
	
	local leftSide=iup.vbox{iup.space{size="x5"},FoodVars,iup.space{size="x10"}, lblListHeading,lstOrganisms}
	
	local GridRight=iup.gridbox{lblMinpH, txtMinpH,
										lblMinAw, txtMinAw,
										lblDTime, txtDTime,
										lblDTemperature, txtDTemperature,
										lblZVal, txtZVal,
										lblFoodMedia, txtFoodMedia,
								numdiv=2, HOMOGENEOUSCOL="yes",CGAPLIN=10, CGAPCOL=5, orientation="HORIZONTAL"}
								
	local page1=iup.hbox{leftSide,iup.space{size="20x"}, iup.vbox{GridRight,iup.space{size="x15"}, iup.hbox{lblRef, txtRef}}}
	page1.tabtitle="Microorganism Properties"
	
	
	
	--Design of Page 2
	
	local lblTime=iup.label{title="Time:"}
	local txtTime=std.gui.gridtext()
	
	local lblTemperature=iup.label{title="Temperature:"}
	local txtTemperature=std.gui.gridtext()
	
	local lblRefTemp=iup.label{title="Reference Temperature:"}
	local txtRefTemp=std.gui.numtext{min=1, max=150, value=121}
	
	local btnCalc=iup.button{title="Calculate"}
	
	local TimeTemps=iup.gridbox{lblTime, txtTime,
										lblTemperature, txtTemperature,
										lblRefTemp, txtRefTemp,
								numdiv=2, HOMOGENEOUSCOL="yes",CGAPLIN=10, CGAPCOL=5, orientation="HORIZONTAL"}
								
	
	local vbox1=iup.vbox{iup.space{size="x5"},TimeTemps,iup.space{size="x20"}, alignment="ALEFT"}
	local vbox2=iup.vbox{btnCalc,alignment="acenter"}
	local vboxes=iup.vbox{vbox1,vbox2, alignment="acenter"}
	
	local page2=iup.hbox{vboxes, iup.space{size="10x"}}
	
	page2.tabtitle="Thermal Process Calc"
	
	local m_tabs=iup.tabs{page1,page2}
	
	local icon=std.gui.makeicon(std.const.exedir.."apps/images/thermalprocessing.jpg")
	
	local dlgThermalProcess = iup.dialog{m_tabs, title="Thermal Processing", size="350x200", icon=icon}
	
	txtTime:setOwner(dlgThermalProcess)
	txtTemperature:setOwner(dlgThermalProcess)

	dlgThermalProcess:show()




	function btnShowOrganism:action()
		local FoodName=txtFoodVar.value
		
		if(FoodName=="") then  
			iup.Message("ERROR","You have forgotten to enter the food variable name") 
			
			return 
		end
          
		local f=load("return  "..tostring(FoodName))
		m_Food=f()
		
		if(m_Food==nil) then 
			iup.Message("ERROR","ERROR: Cannot access the variable "..FoodName.." Have you forgotten to create the variable?")
			
			return
		end
		
		local Aw=m_Food:aw()
		local pH=m_Food:ph()

		
		if(Aw<=0 or Aw>1) then
			iup.Message("ERROR","Water activity of the food material is not in the range of (0,1] not seem to be valid.")
			
			return
		end
          
		if(pH<=0 or pH>14) then
			iup.Message("ERROR","pH value of the food material is not in the range of (0-14]")
			return
		end
		
		 
		local testDBName =std.const.exedir.."/datafiles/Microorganism.db" 
		m_database=Database.new()
		m_database:open(testDBName)
		
		local row, col=0,0

		local QueryString="SELECT OrganismName, minPH, minAw, DValueTemperature, Dvalue, ZValue,Medium, Publication FROM Microorganism where MinAw<="..tostring(Aw).." and MinPH<="..tostring(pH)

		m_QuerySet,row,col = m_database:sql(QueryString)
		
		for i=1,row do
			lstOrganisms[i]=m_QuerySet[i][1]
		end
	
		
	end 
	
	
	
	
	function lstOrganisms:action(text, item, state)
		local txts={txtMinpH, txtMinAw, txtDTemperature, txtDTime,  txtZVal, txtFoodMedia, txtRef}
		
		for i=1, #txts do
			if(m_QuerySet[item][i+1]~=nil) then 
				txts[i].value=m_QuerySet[item][i+1] 
			end  
		end
		
	end
	
	
	
	
	function  btnCalc:action()
		
		local txts={{txtZVal,"Z value can not be blank"},
					{txtDTime,"DValue  can not be blank"},
					{txtDTemperature,"Reference Temperature for D value can not be blank"}	}
		
		
		for i=1,#txts do
			if(txts[i][1].value=="") then 
				iup.Message("Error",txts[i][2]) 
				
				return 
			end

		end
		
		
		local zvalue=tonumber(txtZVal.value)

		local Dvalue_Temp, Dvalue_Time=tonumber(txtDTemperature.value) , tonumber(txtDTime.value)
		
		if(Dvalue_Time<=0 or  zvalue<=0) then 
			iup.Message("Error","Neither D-value nor z-value can not be smaller or equal to zero") 
			
			return 
		end
		
		
		local range_time=Range.new(std.activeworkbook(),txtTime.value)
		local range_T=Range.new(std.activeworkbook(), txtTemperature.value)
		
		local vtime,vTemp=std.tovector(range_time), std.tovector(range_T)
		
		if(#vtime ~=#vTemp) then 
			iup.Message("ERROR"," The length of time and temperature data are not equal.")
			
			return 
		end 
		
		if(math.abs(vtime(1))>TOLERANCE) then 
			iup.Message("ERROR","Time sequence does not start from 0") 
			
			return 
		end
		
		
		local WS=std.activeworkbook():add()
		local row, col=1,1 --which row shall we print on the grid
		
		local Headers={"Time ", "Temperature", "Lethality Rate", "D Value","Total Log Reduction", "F-Value"}
		for i=1,#Headers do
			WS[row][col]=Headers[i]
			col=col+1
		end
		
		row=row+1; col=1
		
		local RefTemp=tonumber(txtRefTemp.value)
		local DValue=Dvalue_Time*10.0^((Dvalue_Temp-vTemp)/zvalue) --vector
		
		local LethalRate=10.0^((vTemp-RefTemp)/zvalue) --vector
		local FValue=std.cumtrapz(vtime, LethalRate) --returns a vector
		
		local dt=std.diff(vtime)
		local avg_T=FindAvg(vTemp)
		local DVal_avg=Dvalue_Time*10.0^((Dvalue_Temp-avg_T)/zvalue)
		local LogRed=dt/DVal_avg
		
		local TotalLogRed=std.cumsum(LogRed)
		TotalLogRed:insert(1,0) -- at time=0 TotalLogRed(1)=0
		
		
		
		for i=1,#vtime do
			WS[row+i][col]=vtime(i)
			WS[row+i][col+1]=vTemp(i)
			WS[row+i][col+2]=string.format("%.3f",tostring(LethalRate(i)))
			WS[row+i][col+3]=string.format("%.3f",tostring(DValue(i)))
			WS[row+i][col+4]=string.format("%.2f",tostring(TotalLogRed(i)))
			WS[row+i][col+5]=string.format("%.2f",tostring(FValue(i)))
		end
		
	end
	
	
end



std.app.FoodThermalProcessing=FoodThermalProcessing



--HISTORY

--v1.8.3: testDBName =EXEDIR.."/databases/Microorganism.db" 
--was causing an error as the directory name is now datafiles. This bug was reported and corrected by Dr Pablo Coronel. 
--A corrected version was released on v1.8.4

