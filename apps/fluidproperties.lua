-- Author:	Gokhan Bingol (gbingol@sciencesuit.org)
-- License: Subject to end-user license agreement conditions available at www.sciencesuit.org


require( "iuplua" )


local std <const> =std
local iup <const> =iup




--need to distinguish the type (refer to MainTable and field TYPE in database) 
local m_Refrigerants=nil
local m_HeatFluids=nil



local function Page_SaturatedProps(AvailableRefrigerants)
	
	local FluidType= iup.list {value=0, dropdown="YES", expand="HORIZONTAL", table.unpack(AvailableRefrigerants)}
		
		
	local chkT= iup.toggle{title="Temperature (\xB0 C)"} 
	local txtT=iup.text{}
	
	local chkP= iup.toggle{title="P (kPa)"} 
	local txtP=iup.text{}
	
	local chkVf= iup.toggle{title="vf (m\xB3/kg)"} 
	local txtVf=iup.text{}
	
	local chkVg = iup.toggle{title="vg (m\xB3/kg)"} 
	local txtVg=iup.text{}
	
	local chkHf = iup.toggle{title="hf (kJ/kg)"}
	local txtHf=iup.text{}
	
	local chkHg = iup.toggle{title="hg (kJ/kg)"}
	local txtHg=iup.text{}
	
	local chkSf = iup.toggle{title="Sf (kJ/kg\xB7K)"}
	local txtSf=iup.text{}
	
	local chkSg = iup.toggle{title="Sg (kJ/kg\xB7K)"}
	local txtSg=iup.text{}
	
	
	
	local Saturated=iup.gridbox{    chkT, txtT, chkP, txtP,
									chkVf, txtVf, chkVg, txtVg,
									chkHf, txtHf, chkHg, txtHg,
									chkSf, txtSf, chkSg, txtSg,
								numdiv=4, HOMOGENEOUSCOL="yes",CGAPLIN=10, CGAPCOL=5, orientation="HORIZONTAL"}
	
	
	local btnCalc=iup.button{title="Calculate"}
	
	local page=iup.vbox{FluidType,  iup.space{size="x10"}, Saturated, iup.space{size="x10"}, btnCalc; alignment="ACENTER"}
							
	page.tabtitle="Saturated"
	
	
	
	
	--keys are equivalent to keys returned by std.refrigerant func
	local Properties={ T={chkT, txtT}, P={chkP, txtP}, 
						Vf={chkVf, txtVf}, Vg={chkVg, txtVg}, 
						Hf={chkHf, txtHf}, Hg={chkHg, txtHg}, 
						Sf={chkSf, txtSf}, Sg={chkSg, txtSg}}
	
	
	--selected fluid's name
	local CurFluidName = ""
	
	--selected property name
	local ActiveProperty = "" , ""
	
	--selected property's value
	local CurValue=nil
	
	

	
	local function OnCalculate()
	
		if(CurFluidName == "") then
			error("The fluid type must be selected.", std.const.ERRORLEVEL)
		end
		
		--To check if anything checked
		local NChecked=0
		
		for k, v in pairs(Properties) do
			local chk=v[1]
			local txt=v[2]
			
			if(chk.value=="ON") then
				NChecked = NChecked + 1
				
				ActiveProperty = k
				
				CurValue=tonumber(txt.value)
				
				if(type(CurValue)~="number") then
					error(chk.title.." is checked but no valid value provided", std.const.ERRORLEVEL)
				end
			end
		end

			
		if(NChecked ==0) then 
			error("At least one selection must be made", std.const.ERRORLEVEL)
		end
			
		
		local props=std.fluid.refrigerant(CurFluidName, {[ActiveProperty]=CurValue}) 
		
		
		for key, value in pairs (Properties) do
			local txtBox=value[2]
			key=string.lower(key)
			
			for k, computedValue in pairs (props) do
				k=string.lower(k)
				
				if(key == k) then
					txtBox.value = computedValue
				end

			end
		end
			
	end --local function OnCalculate()
	
	
	function btnCalc:action()
		local status, err=pcall(OnCalculate)
		
		if(not status)  then iup.Message("ERROR",err) end
	end 



	
	
	function FluidType:action(text, item, state)
		--we are not interested in notifications of deselections
		if(state==0) then return end 
		
		CurFluidName=m_Refrigerants[item][1]
	end 
	
	
	
	
	
	local function UncheckChecked(chk)

		for k, v in pairs(Properties) do
			
			local chkBox=v[1]
			
			if(chkBox ~= chk and chkBox.value=="ON") then
				chkBox.value="OFF"
			end
		end
	end



	local function CreateChkEvents()

		for k, v in pairs(Properties) do
			
			local chkBox=v[1]
			
			function chkBox:action(v)
				UncheckChecked(chkBox)
			end
		end
	end


	
	CreateChkEvents()
	
	
	return page
end










local function Page_SuperHeatedProps(AvailableRefrigerants)
	local ComboFluidType= iup.list {value=0, dropdown="YES", expand="HORIZONTAL", table.unpack(AvailableRefrigerants)}
	
	local chkT = iup.toggle{title= "Temperature (\xB0 C)"}
	local txtT=std.gui.numtext{} 
	
	local chkP = iup.toggle{title= "Pressure (kPa)",  value="ON", active="NO"}
	local txtP=std.gui.numtext{min=0}
	
	local chkV = iup.toggle{title="v (m\xB3/kg)"}
	local txtV = std.gui.numtext{min=0}
	
	local chkH = iup.toggle{title="h (kJ/kg)"}
	local txtH = std.gui.numtext{}
	
	local chkS = iup.toggle{title="s (kJ/kg\xB7K)"}
	local txtS = std.gui.numtext{min=0}
	
	
								
	local SuperHeated=iup.gridbox{chkT, txtT, 
									chkP, txtP, 
									chkV, txtV, 
									chkH, txtH, 
									chkS, txtS,
						numdiv=2, HOMOGENEOUSCOL="yes",CGAPLIN=10, CGAPCOL=1, orientation="HORIZONTAL"}
								
								
	local btn=iup.button{title="Calculate", active="NO"}
								
	local page=iup.vbox{ComboFluidType,  iup.space{size="x10"}, SuperHeated, iup.space{size="x10"}, btn; alignment="ACENTER"}
	
	page.tabtitle="Superheated"
	
	
	
	local CurFluidName = ""
	
	
	--keys are equivalent to keys returned by std.refrigerant func
	local Properties={ T={chkT, txtT}, 
						P={chkP, txtP}, 
						v={chkV, txtV},  
						h={chkH, txtH}, 
						s={chkS, txtS}}
	
	
	
	
	
	local function OnSuperHeatedCalculate()
		
		local RequestedProps={}
		
		local NChecked = 0
	
		--Clear all textboxes
		for k, v in pairs (Properties) do
			local txtBox=v[2]
			local chk=v[1]
			
			if(chk.value=="ON" and txtBox.value=="") then
				error(chk.title.." is checked, but no value provided", std.const.ERRORLEVEL)
				
			elseif(chk.value=="ON") then
				RequestedProps[k]=tonumber(txtBox.value)
				
				NChecked = NChecked + 1
				
			else
				txtBox.value = ""
			end
		end
		
	
		if(CurFluidName == "") then
			error("The fluid type must be selected.", std.const.ERRORLEVEL)
		end
			
				
		local P=tonumber(txtP.value)
		
		if(P == nil) then error("A valid number must be entered for pressure", std.const.ERRORLEVEL) end
			
		
		
		local props=std.fluid.refrigerant(CurFluidName, RequestedProps)
		
		
		for key, value in pairs (Properties) do
			local txtBox=value[2]
			key=string.lower(key)
			
			for k, computedValue in pairs (props) do
				k=string.lower(k)
				
				if(key == k) then
					txtBox.value = computedValue
				end

			end
		end
	end
	
	
	

	
	function btn:action()
		local status, err=pcall(OnSuperHeatedCalculate)
		if(not status)  then 
			iup.Message("ERROR",err) 
		end
		
	end




	function ComboFluidType:action(text, item, state)
		--we are not interested in notifications of deselections
		if(state==0) then return end 
		
		CurFluidName=m_Refrigerants[item][1]
	end 
	
	
	--Pressure is always checked and disabled
	local NChecked = 1
	
	local function DisableUnchecked()
		for k, v in pairs(Properties) do
			
			local chkBox=v[1]
			
			if(chkBox.value=="OFF") then
				chkBox.active="NO"
			end
		end
	end


	local function EnableChecks()
		for k, v in pairs(Properties) do
			
			local chkBox=v[1]
			
			if(chkBox ~= chkP and chkBox.active=="NO") then
				chkBox.active="YES"
			end
		end
	end
	
	
	local function CreateChkEvents()

		for k, v in pairs(Properties) do
			
			local chkBox=v[1]
			
			function chkBox:action(v)
				if(v==1) then
					NChecked = NChecked + 1
				else
					NChecked = NChecked - 1
				end
				
				if(NChecked==2) then
					DisableUnchecked()
					btn.active="YES"
				else
					EnableChecks()
					btn.active="NO"
				end

			end
		end
	end


	
	CreateChkEvents()
	
	
	
	return page
end











local function Page_HeatTransfer(HeatFluids)
	
	local FluidType= iup.list {value=0, dropdown="YES", expand="HORIZONTAL", table.unpack(HeatFluids)}
		
		
	local chkT= iup.toggle{title="Temperature (\xB0 C)"} 
	local txtT=iup.text{}
	
	local chkRho= iup.toggle{title="Density (kg/m\xB3)"} 
	local txtRho=iup.text{}
	
	local chkCp = iup.toggle{title="Cp (kJ/ (kg \xB0 C)"} 
	local txtCp=iup.text{}
	
	local chkK = iup.toggle{title="k (W/mK)"}
	local txtK=iup.text{}
	
	local chkMu = iup.toggle{title="Viscosity (Pa s)"}
	local txtMu=iup.text{}
	
	local chkPr = iup.toggle{title="Pr"}
	local txtPr=iup.text{}
	
	
	
	
	local Saturated=iup.gridbox{    chkT, txtT, 
									chkRho, txtRho, 
									chkCp, txtCp, 
									chkK, txtK,
									chkMu, txtMu, 
									chkPr, txtPr,
								numdiv=4, HOMOGENEOUSCOL="yes",CGAPLIN=10, CGAPCOL=5, orientation="HORIZONTAL"}
	
	
	local btnCalc=iup.button{title="Calculate"}
	
	local page=iup.vbox{FluidType,  iup.space{size="x10"}, Saturated, iup.space{size="x10"}, btnCalc; alignment="ACENTER"}
							
	page.tabtitle="Heat Transfer"
	
	
	
	
	--keys are equivalent to keys returned by std.refrigerant func
	local Properties={ T={chkT, txtT}, rho={chkRho, txtRho}, 
						cp={chkCp, txtCp}, k={chkK, txtK}, 
						mu={chkMu, txtMu}, Pr={chkPr, txtPr}}
	
	
	--selected fluid's name
	local CurFluidName = ""
	
	--selected property name
	local ActiveProperty = "" , ""
	
	--selected property's value
	local CurValue=nil
	
	

	
	local function OnCalculate()
	
		if(CurFluidName == "") then
			error("The fluid type must be selected.", std.const.ERRORLEVEL)
		end
		
		--To check if anything checked
		local NChecked=0
		
		for k, v in pairs(Properties) do
			local chk=v[1]
			local txt=v[2]
			
			if(chk.value=="ON") then
				NChecked = NChecked + 1
				
				ActiveProperty = k
				
				CurValue=tonumber(txt.value)
				
				if(type(CurValue)~="number") then
					error(chk.title.." is checked but no valid value provided", std.const.ERRORLEVEL)
				end
			end
		end

			
		if(NChecked ==0) then 
			error("At least one selection must be made", std.const.ERRORLEVEL)
		end

		

		local Fluid=std.fluid.new(CurFluidName, "H")
			
		
		local props=std.fluid.searchorderedtable(Fluid, ActiveProperty, CurValue) 
		
		
		for key, value in pairs (Properties) do
			local txtBox=value[2]
			key=string.lower(key)
			
			for k, computedValue in pairs (props) do
				k=string.lower(k)
				
				if(key == k) then
					txtBox.value = computedValue
				end

			end
		end
			
	end --local function OnCalculate()
	
	
	function btnCalc:action()
		local status, err=pcall(OnCalculate)
		
		if(not status)  then iup.Message("ERROR",err) end
	end 



	
	
	function FluidType:action(text, item, state)
		--we are not interested in notifications of deselections
		if(state==0) then return end 
		
		CurFluidName=m_HeatFluids[item][1]
	end 
	
	
	
	
	
	local function UncheckChecked(chk)

		for k, v in pairs(Properties) do
			
			local chkBox=v[1]
			
			if(chkBox ~= chk and chkBox.value=="ON") then
				chkBox.value="OFF"
			end
		end
	end



	local function CreateChkEvents()

		for k, v in pairs(Properties) do
			
			local chkBox=v[1]
			
			function chkBox:action(v)
				UncheckChecked(chkBox)
			end
		end
	end


	
	CreateChkEvents()
	
	
	return page
end












local function FluidProperties()

	--Database which holds the properties of fluids
	local m_DB=nil 
	
	m_DB=std.Database.new()
	m_DB:open(std.const.exedir.."/datafiles/Fluids.db")
	
	
	
		
	local row, col=0, 0
	m_Refrigerants, row, col=m_DB:sql("SELECT NAME, ALTERNATIVE FROM MainTable WHERE TYPE=\"R\"")
	
	local AvailableRefrigerants={}
		
	for i=1,row do
		AvailableRefrigerants[i]=m_Refrigerants[i][1].."     ".. m_Refrigerants[i][2]
	end	
	
	
	
	local AvailableHeatFluids={}
	
	row, col=0, 0
	m_HeatFluids, row, col=m_DB:sql("SELECT NAME, ALTERNATIVE FROM MainTable WHERE TYPE=\"H\"")
	
	for i=1,row do
		AvailableHeatFluids[i]=m_HeatFluids[i][1].."     ".. m_HeatFluids[i][2]
	end	
	
	
	local page1=Page_SaturatedProps(AvailableRefrigerants)
	
	local page2=Page_SuperHeatedProps(AvailableRefrigerants)
	
	local page3 = Page_HeatTransfer(AvailableHeatFluids)
	
	
	-- MAIN DIALOG
	
	local tabs=iup.tabs{page1, page2, page3}
							
							
	local icon=std.gui.makeicon(std.const.exedir.."apps/images/fluid.bmp")
	
	local dlgRefProps=iup.dialog{tabs;margin="10x10", title="Properties of Fluids", resize="YES", icon=icon}
	
	local dlgInitSize=dlgRefProps.size
	
	dlgRefProps:show()
	
end




std.app.FluidProperties = FluidProperties