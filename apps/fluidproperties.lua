-- Author:	Gokhan Bingol (gbingol@sciencesuit.org)
-- License: Subject to end-user license agreement conditions available at www.sciencesuit.org


require( "iuplua" )


local std <const> =std
local iup <const> =iup




--need to distinguish the type (refer to MainTable and field TYPE in database) 
local m_RefrigerantNames=nil




local function Page_SaturatedProps(AvailableRefrigerants)
	
	local SaturatedFluidType= iup.list {value=0, dropdown="YES", expand="HORIZONTAL", table.unpack(AvailableRefrigerants)}
		
		
	local chkT= iup.toggle{title="Temperature (\xB0 C)"} 
	local txtT=iup.text{}
	
	local chkP= iup.toggle{title="P (kPa)"} 
	local txtP=iup.text{}
	
	local chkVf= iup.toggle{title="vf (m\xB3/kg)"} 
	local txtVf=iup.text{}
	
	local chkVg = iup.toggle{title="vg (m\xB3/kg)"} 
	local txtVg=iup.text{}
	
	local chkUf =iup.toggle{title="Uf (kJ/kg)", active="NO"} 
	local txtUf=iup.text{}
	
	local chkUg=iup.toggle{title="Ug (kJ/kg)", active="NO"}
	local txtUg=iup.text{}
	
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
									chkUf, txtUf, chkUg, txtUg,
									chkHf, txtHf, chkHg, txtHg,
									chkSf, txtSf, chkSg, txtSg,
								numdiv=4, HOMOGENEOUSCOL="yes",CGAPLIN=10, CGAPCOL=5, orientation="HORIZONTAL"}
	
	
	local btnSaturatedCalc=iup.button{title="Calculate"}
	
	local page1=iup.vbox{SaturatedFluidType,  iup.space{size="x10"}, Saturated, iup.space{size="x10"}, btnSaturatedCalc; alignment="ACENTER"}
							
	page1.tabtitle="Saturated"
	
	
	
	
	--keys are equivalent to keys returned by std.refrigerant func
	local Properties={ T={chkT, txtT}, P={chkP, txtP}, 
						Vf={chkVf, txtVf}, Vg={chkVg, txtVg}, 
						Uf={chkUf, txtUf}, Ug={chkUg, txtUg}, 
						Hf={chkHf, txtHf}, Hg={chkHg, txtHg}, 
						Sf={chkSf, txtSf}, Sg={chkSg, txtSg}}
	
	
	--selected fluid's name
	local CurFluidName = ""
	
	--selected property name
	local ActiveProperty = "" , ""
	
	--selected property's value
	local CurValue=nil
	
	
	
	
	local function OnSaturatedCalculate()
	
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
			
	end --local function OnSaturatedCalculate()
	
	
	function btnSaturatedCalc:action()
		local status, err=pcall(OnSaturatedCalculate)
		
		if(not status)  then iup.Message("ERROR",err) end
	end 



	
	
	function SaturatedFluidType:action(text, item, state)
		--we are not interested in notifications of deselections
		if(state==0) then return end 
		
		CurFluidName=m_RefrigerantNames[item][1]
	end 
	
	
	
	
	
	local function UncheckChecked(chk)

		for k, v in pairs(Properties) do
			
			local chkBox=v[1]
			
			if(chkBox ~= chk and chkBox.value=="ON") then
				chkBox.value="OFF"
			end
		end
	end


	function chkT:action(v)
		UncheckChecked(chkT)
	end 


	function chkP:action(v)
		UncheckChecked(chkP)
	end

	function chkVf:action(v)
		UncheckChecked(chkVf)
	end  


	function chkVg:action(v)
		UncheckChecked(chkVg)
	end  

	function chkUf:action(v)
		UncheckChecked(chkUf)
	end  

	function chkUg:action(v)
		UncheckChecked(chkUg)
	end  

	function chkHf:action(v)
		UncheckChecked(chkHf)
	end  

	function chkHg:action(v)
		UncheckChecked(chkHg)
	end  

	function chkSf:action(v)
		UncheckChecked(chkSf)
	end  

	function chkSg:action(v)
		UncheckChecked(chkSg)
	end  
	
	
	
	return page1
end










local function Page_SuperHeatedProps(AvailableRefrigerants)
	local ComboFluidType= iup.list {value=0, dropdown="YES", expand="HORIZONTAL", table.unpack(AvailableRefrigerants)}
	
	local lblT = iup.label{title= "Temperature (\xB0 C)"}
	local txtT=std.gui.numtext{min=-200} 
	
	local lblP = iup.label{title= "Pressure (kPa)"}
	local txtP=std.gui.numtext{min=0}
	
	local lblV = iup.label{title="v (m\xB3/kg)"}
	local txtV=iup.text{readonly="yes", expand="horizontal"}
	
	local lblH=iup.label{title="h (kJ/kg)"}
	local txtH=iup.text{readonly="yes", expand="horizontal"}
	
	local lblS=iup.label{title="s (kJ/kg\xB7K)"}
	local txtS=iup.text{readonly="yes", expand="horizontal"}
	
	local GridboxInit=iup.gridbox{lblT, txtT, lblP, txtP,
						numdiv=2, HOMOGENEOUSCOL="yes",CGAPLIN=10, CGAPCOL=5, orientation="HORIZONTAL"}
								
	local SuperHeated=iup.gridbox{lblV, txtV, lblH, txtH, lblS, txtS,
						numdiv=2, HOMOGENEOUSCOL="yes",CGAPLIN=10, CGAPCOL=1, orientation="HORIZONTAL"}
								
								
	local btn=iup.button{title="Calculate"}
								
	local page2=iup.vbox{ComboFluidType,  iup.space{size="x10"},GridboxInit, 
							iup.space{size="x10"}, SuperHeated, btn; alignment="ACENTER"}
	
	page2.tabtitle="Superheated"
	
	
	
	local CurFluidName = ""
	
	
	
	local function OnSuperHeatedCalculate()
	
		if(CurFluidName == "") then
			error("The fluid type must be selected.", std.const.ERRORLEVEL)
		end
			
				
		local P=tonumber(txtP.value)
		local T=tonumber(txtT.value)
		
		if(P == nil) then error("A valid number must be entered for pressure", std.const.ERRORLEVEL) end
			
		if(T == nil) then error("A valid number must be entered for temperature", std.const.ERRORLEVEL) end
		
		
		local props=std.fluid.refrigerant(CurFluidName, {P=P, T=T})
		
		txtV.value = props.v
		txtH.value = props.h
		txtS.value = props.s
			
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
		
		CurFluidName=m_RefrigerantNames[item][1]
	end 
	
	
	
	
	return page2
end







local function FluidProperties()

	--Database which holds the properties of fluids
	local m_DB=nil 
	
	m_DB=std.Database.new()
	m_DB:open(std.const.exedir.."/datafiles/Fluids.db")
	
	
	
		
	local row, col=0, 0
	m_RefrigerantNames, row, col=m_DB:sql("SELECT NAME, ALTERNATIVE FROM MainTable WHERE TYPE=\"R\"")
	
	local AvailableRefrigerants={}
		
	for i=1,row do
		AvailableRefrigerants[i]=m_RefrigerantNames[i][1].."     ".. m_RefrigerantNames[i][2]
	end	
	
	
	
	local page1=Page_SaturatedProps(AvailableRefrigerants)
	
	local page2=Page_SuperHeatedProps(AvailableRefrigerants)
	
	
	-- MAIN DIALOG
	
	local tabs=iup.tabs{page1, page2}
							
							
	local icon=std.gui.makeicon(std.const.exedir.."apps/images/fluid.bmp")
	
	local dlgRefProps=iup.dialog{tabs;margin="10x10", title="Properties of Fluids", resize="YES", icon=icon}
	
	local dlgInitSize=dlgRefProps.size
	
	dlgRefProps:show()
	
end




std.app.FluidProperties = FluidProperties