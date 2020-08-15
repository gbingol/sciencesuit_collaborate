-- Author:	Gokhan Bingol (gbingol@sciencesuit.org)
-- License: Subject to end-user license agreement conditions available at www.sciencesuit.org


require( "iuplua" )


local std <const> =std
local iup <const> =iup


local function RefrigerantProperties()

	
	local m_DB=nil --Database
	local m_FluidName=nil
	local m_Fluid=nil
	
	
	m_DB=Database.new()
	m_DB:open(std.const.exedir.."/datafiles/ThermoFluids.db")
		
	local row, col=0, 0
	m_FluidName, row, col=m_DB:sql("SELECT ASHRAE, IUPAC FROM MainTable")
	
	local AvailableFluids={}
		
	for i=1,row do
		AvailableFluids[i]=m_FluidName[i][1].."     ".. m_FluidName[i][2]
	end	
	
	local FluidType= iup.list {value=0, dropdown="YES", expand="HORIZONTAL", table.unpack(AvailableFluids)}
	
	local lblFluidState=iup.label{title="FLUID STATE: UNKNOWN",expand="HORIZONTAL"}
	
	local chkT = iup.toggle{title= "Temperature (\xB0 C)"}
	local txtT=std.gui.numtext{min=-200} --Todo: Check the lowest temp
	
	local chkP = iup.toggle{title= "Pressure (kPa)"}
	local txtP=std.gui.numtext{min=0}
	
	--Saturated
		
	local lblVf =iup.label{title="vf (m\xB3/kg)"}
	local txtVf=iup.text{readonly="yes"}
	
	local lblVg =iup.label{title="vg (m\xB3/kg)"}
	local txtVg=iup.text{readonly="yes"}
	
	local lblUf =iup.label{title="Uf (kJ/kg)"}
	local txtUf=iup.text{readonly="yes"}
	
	local lblUg=iup.label{title="Ug (kJ/kg)"}
	local txtUg=iup.text{readonly="yes"}
	
	local lblHf = iup.label{title="hf (kJ/kg)"}
	local txtHf=iup.text{readonly="yes"}
	
	local lblHg = iup.label{title="hg (kJ/kg)"}
	local txtHg=iup.text{readonly="yes"}
	
	local lblSf = iup.label{title="Sf (kJ/kg\xB7K)"}
	local txtSf=iup.text{readonly="yes"}
	
	local lblSg = iup.label{title="Sf (kJ/kg\xB7K)"}
	local txtSg=iup.text{readonly="yes"}
	
	--Superheated or Compressed
	
	local lblV = iup.label{title="v (m\xB3/kg)"}
	local txtV=iup.text{readonly="yes", expand="horizontal"}
	
	local lblH=iup.label{title="h (kJ/kg)"}
	local txtH=iup.text{readonly="yes", expand="horizontal"}
	
	local lblS=iup.label{title="s (kJ/kg\xB7K)"}
	local txtS=iup.text{readonly="yes", expand="horizontal"}
	
	
	local GridboxInit=iup.gridbox{chkT, txtT,
										chkP, txtP,
								numdiv=2, HOMOGENEOUSCOL="yes",CGAPLIN=10, CGAPCOL=5, orientation="HORIZONTAL"}
								
	local Saturated=iup.gridbox{lblVf, txtVf, lblVg, txtVg,
									lblUf, txtUf, lblUg, txtUg,
									lblHf, txtHf, lblHg, txtHg,
									lblSf, txtSf, lblSg, txtSg,
								numdiv=4, HOMOGENEOUSCOL="yes",CGAPLIN=10, CGAPCOL=5, orientation="HORIZONTAL"}
								
	local SuperHeated=iup.gridbox{lblV, txtV,
									lblH, txtH,
									lblS, txtS,
								numdiv=2, HOMOGENEOUSCOL="yes",CGAPLIN=10, CGAPCOL=1, orientation="HORIZONTAL"}
			
		
	local btnCalc=iup.button{title="Calculate"}
	
	local vbox=iup.vbox{FluidType, iup.space{size="x10"}, lblFluidState, iup.space{size="x10"},GridboxInit, 
							iup.space{size="x10"}, btnCalc; alignment="ACENTER"}
							
							
	local icon=std.gui.makeicon(std.const.exedir.."apps/images/fluid.bmp")
	
	local dlgRefProps=iup.dialog{vbox;margin="10x10", title="Thermodynamic Properties of Fluids", resize="YES", icon=icon}
	
	local dlgInitSize=dlgRefProps.size
	
	dlgRefProps:show()
	
	
	
	local NofCheckedBoxes=0
	local space=iup.space{size="x10"}
	
	
	local function OnCheckBox(chkBox)
		
		if(chkBox.value=="ON") then  
			NofCheckedBoxes=NofCheckedBoxes+1 
		else  
			NofCheckedBoxes=NofCheckedBoxes-1  
		end
		
		if(NofCheckedBoxes==0) then
			dlgRefProps.size=dlgInitSize
			lblFluidState.title="Fluid State: Unknown"
			
			iup.Detach(Saturated)
			iup.Detach(SuperHeated)
			iup.Detach(space)
			
			iup.Refresh(dlgRefProps)
		
		elseif(NofCheckedBoxes==1) then
			iup.Detach(SuperHeated)
			
			dlgRefProps.size="230x210"
			lblFluidState.title="Fluid State: Saturated"
			
			iup.Detach(SuperHeated)
			iup.Detach(space)
			
			iup.Insert(vbox,btnCalc, Saturated)
			iup.Insert(vbox,btnCalc, space)
			iup.Map(Saturated)
			iup.Map(space)
			
			iup.Refresh(dlgRefProps)
			
		elseif(NofCheckedBoxes==2 ) then
			iup.Detach(Saturated)
			iup.Detach(space)
			
			dlgRefProps.size="200x190"
			lblFluidState.title="Fluid State: Unknown"
			
			iup.Insert(vbox,btnCalc, SuperHeated)
			iup.Insert(vbox,btnCalc, space)
			iup.Map(SuperHeated)
			iup.Map(space)
			
			iup.Refresh(dlgRefProps)
			
		end
	end 

	
	
	
	function FluidType:action(text, item, state)
		if(state==0) then return end --we are not interested in notifications of deselections
		
		m_Fluid=ThermoFluid.new(m_FluidName[item][1])
	end 
	
	local m_IsP=0
	local m_IsT=0
	
	function chkT:action(state)
		OnCheckBox(chkT)
		m_IsT=state
	end 
	
	function chkP:action(state)
		OnCheckBox(chkP)
		m_IsP=state
	end 
	

	local function OnCalculate()
	
		if(m_Fluid==nil) then
			iup.Message("ERROR","The fluid type must be selected.")
			
			return
			
		elseif(m_IsP==0 and m_IsT==0) then 
			iup.Message("ERROR","At least one selection must be made")
			
			return

		elseif(m_IsP==1 and txtP.value=="") then
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
			props=m_Fluid:get({P=P}) 
			
			NofSel=NofSel+1
			
			txtT.value=string.format("%.2f",tostring(props.T))
			
		elseif(m_IsP==0 and m_IsT==1) then 
			props=m_Fluid:get({T=T}) 
			
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
			props=m_Fluid:get({P=P, T=T})
			local status=tonumber(m_Fluid.FluidState)
			
			if(status==1) then 
				lblFluidState.title="Fluid State: Superheated"
				
			elseif(status==-1) then
				lblFluidState.title="Fluid State: Compressed"
			end
			
			txtV.value=string.format("%.4f", tostring(props.v))
			txtH.value=string.format("%.2f",tostring(props.h))
			txtS.value=string.format("%.3f",tostring(props.s))
		end
	end
	
	function btnCalc:action()
		local status, err=pcall(OnCalculate)
		if(not status)  then 
			iup.Message("ERROR",err) 
		end
		
	end 
	
	
end
            
      
std.app.ThermodynamicPropFluid=RefrigerantProperties
	
