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
	local txtT=iup.text{readonly="yes"}
	
	local chkP= iup.toggle{title="P (kPa)"} 
	local txtP=iup.text{readonly="yes"}
	
	local chkVf= iup.toggle{title="vf (m\xB3/kg)"} 
	local txtVf=iup.text{readonly="yes"}
	
	local chkVg = iup.toggle{title="vg (m\xB3/kg)"} 
	local txtVg=iup.text{readonly="yes"}
	
	local chkUf =iup.toggle{title="Uf (kJ/kg)"} 
	local txtUf=iup.text{readonly="yes"}
	
	local chkUg=iup.toggle{title="Ug (kJ/kg)"}
	local txtUg=iup.text{readonly="yes"}
	
	local chkHf = iup.toggle{title="hf (kJ/kg)"}
	local txtHf=iup.text{readonly="yes"}
	
	local chkHg = iup.toggle{title="hg (kJ/kg)"}
	local txtHg=iup.text{readonly="yes"}
	
	local chkSf = iup.toggle{title="Sf (kJ/kg\xB7K)"}
	local txtSf=iup.text{readonly="yes"}
	
	local chkSg = iup.toggle{title="Sg (kJ/kg\xB7K)"}
	local txtSg=iup.text{readonly="yes"}
	
	
	
	local Saturated=iup.gridbox{    chkT, txtT, chkP, txtP,
									chkVf, txtVf, chkVg, txtVg,
									chkUf, txtUf, chkUg, txtUg,
									chkHf, txtHf, chkHg, txtHg,
									chkSf, txtSf, chkSg, txtSg,
								numdiv=4, HOMOGENEOUSCOL="yes",CGAPLIN=10, CGAPCOL=5, orientation="HORIZONTAL"}
	
	
	local btnSaturatedCalc=iup.button{title="Calculate"}
	
	local page1=iup.vbox{SaturatedFluidType,  iup.space{size="x10"}, Saturated, iup.space{size="x10"}, btnSaturatedCalc; alignment="ACENTER"}
							
	page1.tabtitle="Saturated"
	
	
	
	
	local ChkBoxes={chkT, chkP, chkVf, chkVg, chkUf, chkUg, chkHf, chkHg,chkSf, chkSg}
	
	local ActiveProperty={"T", "P", "Vf", "Vg", "Uf", "Ug", "Hf", "Hg", "Sf", "Sg"}
	
	local CurFluidName=""
	
	
	local function OnSaturatedCalculate()
	
		assert(CurFluidName~="", "The fluid type must be selected.")
			
		assert(GetCheckBoxes("ON") < 1, "At least one selection must be made")
			
		
		local props={}
		
		if(m_IsP==1 and m_IsT==0) then 
			props=std.thermofluid(m_CurFluidName, {P=P}) 
			
			NofSel=NofSel+1
			
			txtT.value=string.format("%.2f",tostring(props.T))
			
		elseif(m_IsP==0 and m_IsT==1) then 
			props=std.thermofluid(m_CurFluidName, {T=T}) 
			
			NofSel=NofSel+1 
			
			txtP.value=string.format("%.2f",tostring(props.P))
		end
		
		if(NofSel==1) then
			local txts={txtVf,txtVg, txtUf, txtUg, txtHf, txtHg, txtSf, txtSg}
			
			local keys={"vf", "vg", "uf", "ug", "hf", "hg", "sf", "sg"}
			
			local format={"%.4f","%.3f","%.2f","%.2f","%.2f","%.2f","%.3f","%.3f"}
			
			for i=1, #txts do
				txts[i].value=string.format(format[i],tostring(props[keys[i]]))
			end
		end
		
		
		if(m_IsP==1 and m_IsT==1) then 
			props=std.thermofluid(m_CurFluidName,{P=P, T=T})
			local status=tonumber(props.state)
			
			txtV.value=string.format("%.4f", tostring(props.v))
			txtH.value=string.format("%.2f",tostring(props.h))
			txtS.value=string.format("%.3f",tostring(props.s))
		end
	end
	
	
	
	
	function SaturatedFluidType:action(text, item, state)
		if(state==0) then 
			return 
		end --we are not interested in notifications of deselections
		
		CurFluidName=m_RefrigerantNames[item][1]
	end 
	
	
	
	function btnSaturatedCalc:action()
		local status, err=pcall(OnSaturatedCalculate)
		if(not status)  then 
			iup.Message("ERROR",err) 
		end
		
	end 


	
	local function GetCheckBoxes(state)
		local N=0
		for i=1, #ChkBoxes do
			if(ChkBoxes[i].value==state) then
				N=N+1
			end
		end

		return N
	end
	

	local function UncheckChecked(chk)
		for i=1, #ChkBoxes do
			if(ChkBoxes[i]~=chk and ChkBoxes[i].value=="ON") then
				ChkBoxes[i].value="OFF"
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
	
	
	--PAGE 2 (Superheated or Compressed)
	
	local SuperHeatedFluidType= iup.list {value=0, dropdown="YES", expand="HORIZONTAL", table.unpack(AvailableRefrigerants)}
	
	local chkT = iup.toggle{title= "Temperature (\xB0 C)"}
	local txtT=std.gui.numtext{min=-200} --Todo: Check the lowest temp
	
	local chkP = iup.toggle{title= "Pressure (kPa)"}
	local txtP=std.gui.numtext{min=0}
	
	local lblV = iup.label{title="v (m\xB3/kg)"}
	local txtV=iup.text{readonly="yes", expand="horizontal"}
	
	local lblH=iup.label{title="h (kJ/kg)"}
	local txtH=iup.text{readonly="yes", expand="horizontal"}
	
	local lblS=iup.label{title="s (kJ/kg\xB7K)"}
	local txtS=iup.text{readonly="yes", expand="horizontal"}
	
	local GridboxInit=iup.gridbox{chkT, txtT,
										chkP, txtP,
								numdiv=2, HOMOGENEOUSCOL="yes",CGAPLIN=10, CGAPCOL=5, orientation="HORIZONTAL"}
								
	local SuperHeated=iup.gridbox{lblV, txtV,
									lblH, txtH,
									lblS, txtS,
								numdiv=2, HOMOGENEOUSCOL="yes",CGAPLIN=10, CGAPCOL=1, orientation="HORIZONTAL"}
								
								
	local btnSuperHeatedCalc=iup.button{title="Calculate SuperHeated"}
								
	local page2=iup.vbox{SuperHeatedFluidType,  iup.space{size="x10"},GridboxInit, 
							iup.space{size="x10"}, SuperHeated, btnSuperHeatedCalc; alignment="ACENTER"}
	
	page2.tabtitle="Superheated"
			
		
	
	-- MAIN DIALOG
	
	local tabs=iup.tabs{page1, page2}
							
							
	local icon=std.gui.makeicon(std.const.exedir.."apps/images/fluid.bmp")
	
	local dlgRefProps=iup.dialog{tabs;margin="10x10", title="Properties of Fluids", resize="YES", icon=icon}
	
	local dlgInitSize=dlgRefProps.size
	
	dlgRefProps:show()
	
	
	
	
	



	





	local function OnSuperHeatedCalculate()
	
		assert(m_CurFluidName~="", "The fluid type must be selected.")
			
		assert(m_IsP~=0 or m_IsT~=0, "At least one selection must be made")
			
		
		if(m_IsP==1 and txtP.value=="") then
			iup.Message("ERROR","Pressure field cannot be empty, since it is checked.")
			
			return
			
		elseif(m_IsT==1 and txtT.value=="") then
			iup.Message("ERROR","Temperature field cannot be empty, since it is checked.")
			
			return 
		end
		
		local P=tonumber(txtP.value)
		local T=tonumber(txtT.value)
		
		local NofSel=0
		local props={}
		
		if(m_IsP==1 and m_IsT==0) then 
			props=std.thermofluid(m_CurFluidName, {P=P}) 
			
			NofSel=NofSel+1
			
			txtT.value=string.format("%.2f",tostring(props.T))
			
		elseif(m_IsP==0 and m_IsT==1) then 
			props=std.thermofluid(m_CurFluidName, {T=T}) 
			
			NofSel=NofSel+1 
			
			txtP.value=string.format("%.2f",tostring(props.P))
		end
		
		if(NofSel==1) then
			local txts={txtVf,txtVg, txtUf, txtUg, txtHf, txtHg, txtSf, txtSg}
			
			local keys={"vf", "vg", "uf", "ug", "hf", "hg", "sf", "sg"}
			
			local format={"%.4f","%.3f","%.2f","%.2f","%.2f","%.2f","%.3f","%.3f"}
			
			for i=1, #txts do
				txts[i].value=string.format(format[i],tostring(props[keys[i]]))
			end
		end
		
		
		if(m_IsP==1 and m_IsT==1) then 
			props=std.thermofluid(m_CurFluidName,{P=P, T=T})
			local status=tonumber(props.state)
			
			txtV.value=string.format("%.4f", tostring(props.v))
			txtH.value=string.format("%.2f",tostring(props.h))
			txtS.value=string.format("%.3f",tostring(props.s))
		end
	end
	
	
	
	
	
	



	function btnSuperHeatedCalc:action()
		local status, err=pcall(OnSuperHeatedCalculate)
		if(not status)  then 
			iup.Message("ERROR",err) 
		end
		
	end 
	
	
end
            
      
std.app.FluidProperties = FluidProperties
	
