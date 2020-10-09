-- Author:	Gokhan Bingol (gbingol@sciencesuit.org)
-- License: Subject to end-user license agreement conditions available at www.sciencesuit.org


local std <const> =std



local function Cp(component, T) --component can be water, CHO...; T is temperature in Celcius 
	if(component=="water" ) then
		return 4.1289-9.0864E-05*T+5.4731*10^-6.0*T^2 

	elseif(component=="protein") then 
		return 2.0082 + 1.2089*10^-3.0*T-1.3129*10.0^-6.0*T^2.0 

	elseif(component=="lipid")  then 
		return 1.9842+1.4733*10.0^-3.0*T-4.8008*10.0^-6.0*T^2.0 

	elseif(component=="CHO") then 
		return 1.5488+1.9625*10.0^-3.0*T-5.9399*10.0^-6.0*T^2.0 
		
	elseif(component=="ash")  then 
		return 1.0926+1.8896*10.0^-3.0*T-3.6817*10.0^-6.0*T^2.0 
		
	elseif (component == "salt") then   --Engineering Toolbox
		return 0.88

	else
		error("Component must be water, lipid, protein, CHO, ash or salt", ERRORLEVEL)
	end
end


local function ThermConduct (component, T) --T in celcius, result W/mK
	if(component=="water") then 
		return 4.57109E-01+1.7625E-03*T-6.7036E-06*T^2.0 
	
	elseif(component=="protein")  then 
		return 1.7881E-01+1.1958E-03*T-2.7178E-06*T^2.0 
		
	elseif(component=="lipid")  then 
		return 1.8071E-01-2.7604E-04*T-1.7749E-07*T^2.0 
		
	elseif(component=="CHO")  then
		 return 2.0141E-01+1.3874E-03*T-4.3312E-06*T^2.0 
		 
	elseif(component=="ash")  then 
		return 3.2962E-01+1.4011E-03*T-2.9069E-06*T^2.0 
		
	elseif (component == "salt") then 
		--5.704 molal solution at 20C, Riedel L. (1962),Thermal Conductivities of Aqueous Solutions of Strong Electrolytes Chem.-1ng.-Technik., 23 (3) P.59 - 64
		return 0.574 

	else
		error("Component must be water, lipid, protein, CHO, ash or salt", ERRORLEVEL)
	end	 
end



local function Rho(component, T) -- T celcius, result kg/m3
	if(component=="water") then 
		return 997.18+3.1439E-03*T-3.7574E-03*T^2.0 
		
	elseif(component=="protein")  then 
		return 1329.9-5.1840E-01*T 
		 
	elseif(component=="lipid")  then 
		return 925.59-4.1757E-01*T 
		
	elseif(component=="CHO")  then 
		return 1599.1-3.1046E-01*T 
	
	elseif(component=="ash")  then 
		return 2423.8-2.8063E-01*T 
		
	elseif (component == "salt") then 
		return 2165 --Wikipedia

	else
		error("Component must be water, lipid, protein, CHO, ash or salt", ERRORLEVEL)
	end
	 
end


local function Norrish(food)
	--Norrish equation
	
	--CHO is considered as fructose
	local NCHO=food.CHO/180.16 
	
	--lipid is considered as glycerol
	local NLipid=food.lipid/ 92.0944 
	
	-- protein is considered as alanine
	local NProtein=food.protein/89.09 
	
	local NWater=food.water/18.02

	local Nsolute=NCHO + NLipid + NProtein

	-- Norrish equation K values using Ferro-Chirife-Boquet equation
	local K=NCHO/Nsolute*(-2.15)+NLipid/Nsolute*(-1.16)+NProtein/Nsolute*(-2.52) 
	
	-- Mole fraction of solute
	local XSolute=Nsolute/(Nsolute+NWater) 

	-- Mole fraction of water
	local XWater=NWater/(Nsolute+NWater) 
	
	local retVal=XWater*math.exp(K*XSolute^2)

	return retVal
end


--mostly used in confectionaries
local function MoneyBorn(confectionary)
	-- amount of CHO in 100 g water (equation considers thus way) 
	local WeightCHO=100*confectionary.CHO/confectionary.water 
	
	--CHO is considered as fructose
	local NCHO=WeightCHO/180.16 
	

	return 1.0/(1.0+0.27*NCHO)
end


local function ComputeAw(food)

	--if no matching conditon is found return water activity as 0.92
	local retVal=0.92
	
	local water=food.water --%
	local CHO=food.CHO --%
	local lipid=food.lipid --%
	local protein=food.protein --%
	local ash=food.ash --%
	local salt=food.salt --%
	local Msolute=CHO+lipid+protein+ash+salt

	if(water<std.const.tolerance) then
		return 0.01 --There is virtually (<1E-5 %) no water
	end

	
	-- Dilute solution, as the total percentage is less than 1% therefore "most likely" very high water activity
	if(Msolute<1) then 
		return 0.99 
	end 
	
	
	--Non-electrolytes solutions
	if(math.abs(salt)<std.const.tolerance) then
		if(water>99.0) then
			return 0.98
		
		elseif(water<1.0 and protein<1.0 and lipid<1.0 and ash<1.0 and CHO>98.0) then -- almost all CHO
			return 0.70
		
		elseif(lipid<1.0 and protein<1.0 and ash<1.0 and water>1.0 and water<5.0 and CHO>5.0) then -- most likely a candy
			retVal=MoneyBorn(food)
		
		elseif(water>5.0 and CHO>5.0) then
			retVal=Norrish(food)
		end
	end
	
	
	local T=food.temperature

	local Cp_20=water/100*Cp("water",20)+protein/100*Cp("protein",20)+lipid/100*Cp("lipid",20) +CHO/100*Cp("CHO",20)+ash/100*Cp("ash",20)+salt/100*Cp("salt",20)
	local Cp_T=water/100*Cp("water",T)+protein/100*Cp("protein",T)+lipid/100*Cp("lipid",T) +CHO/100*Cp("CHO",T)+ash/100*Cp("ash",T)+salt/100*Cp("salt",T)

	local Cp_avg=(Cp_20+Cp_T)/2.0	
	local Qs=Cp_avg*(T-20) --kJ/kg

	local MWavg=water/100*18.02+CHO/100*180.16+lipid/100*92.0944+protein/100*89.09+salt/100*58.44
	
	local Ravg=8.314/MWavg -- kPa*m^3/kgK
	
	local aw2=retVal*math.exp(Qs/Ravg*(1/293.15 - 1/(T+273.15)))

	assert(aw2<=1 and aw2>=0,"ERROR: Water activity is beyond range [0,1]")
	
	
	return aw2
	
end --computeAw



--Food class
std.Food={}
std.Food.__index=std.Food
function std.Food.new(tbl)

	assert(type(tbl)=="table","ERROR: Cannot create a Food item without a valid Lua table")

	local FOOD={}--create the object
	setmetatable(FOOD,std.Food) 
	
	local m_Water, m_CHO, m_Protein, m_Lipid, m_Ash, m_Salt =0 , 0, 0, 0, 0,0 -- Percentages
	
	
	for key, value in pairs(tbl) do
		
		key=string.lower(key)

		if(key=="water") then m_Water=value 
		elseif(key=="cho") then m_CHO=value
		elseif(key=="protein") then m_Protein=value
		elseif(key=="lipid" or key=="oil" or key=="fat") then m_Lipid=value
		elseif(key=="ash") then m_Ash=value
		elseif(key=="salt") then m_Salt=value
		else 
			error("ERROR: Keys are CHO, Protein, Lipid(Fat, Oil), Ash, Water, Salt" , ERRORLEVEL)
		end
	end

	-- User does not necessarily create a food material where percentage sum is 100
	-- Therefore it needs an adjustment where total percentage is ALWAYS 100
	local PercentageSum=m_Ash+m_Lipid+m_Protein+m_CHO+m_Water + m_Salt
	

	FOOD.water=m_Water/PercentageSum*100
	FOOD.CHO=m_CHO/PercentageSum*100
	FOOD.protein=m_Protein/PercentageSum*100
	FOOD.lipid=m_Lipid/PercentageSum*100
	FOOD.ash=m_Ash/PercentageSum*100
	FOOD.salt=m_Salt/PercentageSum*100
	
	
	--Initial values
	FOOD.m_ph=6.0 --No internal function provided for calculation
	
	--In the following cases an internal function is provided, however, user is allowed to provide a function or a value
	--When that is the case, use the values provided by user. Therefore, __m_aw_userdef variable is defined
	FOOD.__m_aw=0.92
	FOOD.__m_aw_userdef=false 
	
	FOOD.__m_k=0.45
	FOOD.m_k_userdef=false
	
	FOOD.m_rho=990
	FOOD.m_rho_userdef=false
	
	FOOD.m_cp=3.80
	FOOD.m_cp_userdef=false
	
	
	FOOD.temperature=20
	FOOD.weight=1.0 -- Unit weight
	FOOD.name="Food"

	return FOOD
end



function std.Food:cp(arg)

	if(arg==nil) then
	
		if(self.m_cp_userdef==false) then
			
			local T=self.temperature

			return (self.water/100)*Cp("water",T)+(self.protein/100)*Cp("protein",T)+(self.lipid/100)*Cp("lipid",T)
				+(self.CHO/100)*Cp("CHO",T)+(self.ash/100)*Cp("ash",T)+(self.salt/100)*Cp("salt",T)
	
		else
		
			return self.m_cp
		end
	
	
	elseif(type(arg)=="number") then
		assert(arg>=0,"ERROR: Cp cannot be equal to or smaller than zero")
		
		self.m_cp_userdef=true
		self.m_cp=arg
	
	
	elseif(type(arg)=="function") then
		
		local retVal=arg(self)
		
		assert(type(retVal)=="number" and retVal>0, "ERROR: The provided function must return a number value greater than zero.")
		
		self.m_cp_userdef=true
		self.m_cp=retVal
	
	else
		error("ERROR: The arguments to the function must be either a nil value, a number or a function")
	
	end

end



function std.Food:k(arg)
	
	if(arg==nil) then
	
		if(self.m_k_userdef==false) then
			local T=self.temperature

			return (self.water/100)*ThermConduct("water",T)+(self.protein/100)*ThermConduct("protein",T)+(self.lipid/100)*ThermConduct("lipid",T)
					+(self.CHO/100)*ThermConduct("CHO",T)+(self.ash/100)*ThermConduct("ash",T)+(self.salt/100)*ThermConduct("salt",T)
		
		else
		
			return self.__m_k
		end
	
	
	elseif(type(arg)=="number") then
		assert(arg>=0,"ERROR: k cannot be equal to or smaller than zero")
		
		self.m_k_userdef=true
		self.__m_k=arg
	
		
	elseif(type(arg)=="function") then
		local retVal=arg(self)
		
		assert(type(retVal)=="number" and retVal>0, "ERROR: The provided function must return a number value greater than zero.")
		
		self.m_k_userdef=true
		self.__m_k=retVal
	
	else
		error("ERROR: The arguments to the function can be either a nil value, a number or a function")
	
	end
	
end



function std.Food:rho(arg)
	
	if(arg==nil) then
	
		if(self.m_rho_userdef==false) then
			local T=self.temperature

			return (self.water/100)*Rho("water",T)+(self.protein/100)*Rho("protein",T)+(self.lipid/100)*Rho("lipid",T)
					+(self.CHO/100)*Rho("CHO",T)+(self.ash/100)*Rho("ash",T)+(self.salt/100)*Rho("salt",T)
		
		else
		
			return self.m_rho
		end
	
		
	elseif(type(arg)=="number") then
		assert(arg>=0,"ERROR: Density cannot be equal to or smaller than zero")
		
		self.m_rho_userdef=true
		self.m_rho=arg
	
		
	elseif(type(arg)=="function") then
		local retVal=arg(self)
		
		assert(type(retVal)=="number" and retVal>0, "ERROR: The provided function must return a number value greater than zero.")
		
		self.m_rho_userdef=true
		self.m_rho=retVal
	
	else
		error("ERROR: The arguments to the function can be either a nil value, a number or a function")
	
	end
	
end



function std.Food:T(num)
	
	if(num==nil) then 
		return self.temperature 
	end

	assert(type(num)=="number", "ERROR: Argument must be of type number.")
	
	self.temperature=num 
end



function std.Food:aw(arg)

	if(arg==nil) then
	
		if(self.__m_aw_userdef==false) then 
			return ComputeAw(self)
		
		else
			return self.__m_aw
		end
	
	
	elseif(type(arg)=="number") then
		assert(arg>0 and arg<=1,"ERROR: Water activity must be in the range of (0,1].")
		
		self.__m_aw_userdef=true
		self.__m_aw=arg
	
		
	elseif(type(arg)=="function") then
		local retVal=arg(self)
		
		assert(type(retVal)=="number", "ERROR: The provided function must return a number value.")
		assert(retVal>0 and retVal<=1,"ERROR: The provided function must return a water activity in the range of (0,1].")
		
		self.__m_aw_userdef=true
		self.__m_aw=retVal
	
	else
		error("ERROR: The arguments to the function can be either a nil value, a number or a function")
	
	end
	
end



function std.Food:ph(arg)
	
	if(arg==nil) then
		return self.m_ph
	
	
	elseif(type(arg)=="number") then
		assert(arg>0 and arg<14,"ERROR: pH must be in the range of (0,14).")
		self.m_ph=arg
	
		
	elseif(type(arg)=="function") then
		local retVal=arg(self)
		
		assert(type(retVal)=="number", "ERROR: The provided function must return a number value.")
		assert(retVal>0 and retVal<14,"ERROR: The provided function must return a pH in the range of (0,14).")
		
		self.m_ph=retVal
	
	else
		error("ERROR: The arguments to the function can be either a nil value, a number or a function")
	
	end
	
end


----For many cases, NOT Recommended to set the weight externally
function std.Food:SetWeight(num) 
	assert(type(num)=="number","ERROR: Argument must be of type number.")
	
	self.weight=num  
end


function std.Food:GetWeight() 
	
	return self.weight
end


function std.Food:normalize()
	self.weight=1.0
end


function std.Food:get()
	--Only return macromolecules
	local tbl={}
	
	tbl.water=self.water
	tbl.CHO=self.CHO
	tbl.protein=self.protein
	tbl.lipid=self.lipid
	tbl.ash=self.ash
	tbl.salt=self.salt

	return tbl
end


function std.Food:__name()
	return "Food"
end


local function Addition(foodA, foodB)

	assert(type(foodA)=="Food" and type(foodB)=="Food","Both right and left hand side of + operator must be of type Food") 

	local tbl={}
	local ma, mb=foodA:GetWeight(),  foodB:GetWeight()
	local Ta, Tb=foodA:T(), foodB:T()
	local cpa, cpb=foodA:cp(), foodB:cp()

	local water=ma*foodA:get().water+ mb*foodB:get().water
	local CHO=ma*foodA:get().CHO + mb*foodB:get().CHO
	local lipid=ma*foodA:get().lipid + mb*foodB:get().lipid
	local protein=ma*foodA:get().protein + mb*foodB:get().protein
	local ash=ma*foodA:get().ash + mb* foodB:get().ash
	local salt=ma*foodA:get().salt + mb* foodB:get().salt

	local sum=water+CHO+lipid+protein+ash+salt
	tbl.water=water/sum*100
	tbl.CHO=CHO/sum*100	
	tbl.lipid=lipid/sum*100
	tbl.protein=protein/sum*100 
	tbl.ash=ash/sum*100
	tbl.salt=salt/sum*100

	local retFood=std.Food.new(tbl)
	retFood:SetWeight(ma+mb)
	
	if(math.abs(Ta-Tb)<=std.const.tolerance) then
		retFood:T(Ta)
	
	else
		local E1 , E2=ma*cpa*Ta, mb*cpb*Tb
		local cp_avg=(cpa + cpb)/2.0
		local mtot=ma+mb
		local Tmix=(E1+E2)/(mtot*cp_avg)
	
		retFood:T(Tmix)
	end

	return retFood
end



local function Subtraction (foodA, foodB)
	
	assert(type(foodA)=="Food" and type(foodB)=="Food","Both right and left hand side of - operator must be of type Food") 
	
	local ma , mb=foodA:GetWeight() , foodB:GetWeight()
	local Ta , Tb=foodA:T() , foodB:T()
	local mdiff=ma-mb;

	assert(mdiff>=0,"ERROR: Weight can not be smaller than or equal to zero")   
	assert(math.abs(Ta-Tb)<std.const.tolerance,"ERROR: In subtraction Food's cannot have different temperatures.") 

	local fA, fB=foodA:get(), foodB:get()
	local diff_tbl={}

	for k,v in pairs(fA) do
		if(fB[k]~=nil) then
			local diff_val=ma*v-mb*fB[k]
			assert(diff_val>=0, "ERROR:Weight of "..k.." can not be smaller than zero")
			
			if(diff_val<std.const.tolerance) then diff_val=0	end
			
			diff_tbl[k]=diff_val
		end
	end 	

	local tbl={}
	--Recalculate the percentages
	local sum=std.accumulate(diff_tbl,0) 
	
	for k,v in pairs(diff_tbl) do
		tbl[k]=v/sum*100
	end
	
	local retFood=std.Food.new(tbl)
	retFood:SetWeight(ma-mb)

	return retFood

end


local function Multiplication(elemA,elemB)
	
	if(type(elemA)=="Food" and type(elemB)=="Food") then 
		error("Both right and left hand side of * operator cannot be of type Food",ERRORLEVEL) 
	end
	
	
	local food, num=nil, 0

	if( type(elemA)=="Food" and type(elemB)=="number") then 
		food=elemA 
		num=elemB

	elseif (type(elemA)=="number" and type(elemB)=="Food"  ) then 
		food=elemB 
		num=elemA

	else
		error("ERROR: Food types can only be multiplied by numbers",ERRORLEVEL)
	end


	local tbl={}
	local fd=food:get()

	for k,v in pairs(fd) do
		tbl[k]=v
	end

	local retFood=std.Food.new(tbl)
	retFood:SetWeight(food:GetWeight()*num)

	return retFood
end


local function Equal(foodA, foodB)
	assert(type(foodA)=="Food" and type(foodB)=="Food","Both right and left hand side of == operator must be of type Food")
	
	local fA, fB=foodA:get(), foodB:get()

	--fA and fB have the same keys but different values: v is the value for fA and fB[k] returns corresponding key value in foodB
	for k,v in pairs(fA) do
		if(fB[k]==nil) then
			return false
		end

		if(math.abs(v-fB[k])>std.const.tolerance) then
			return false
		end
	end

	return true
end

std.Food.__add=Addition
std.Food.__sub=Subtraction
std.Food.__mul=Multiplication
std.Food.__eq=Equal


function std.Food:__tostring()
	
	local str=""
	
	local aw=nil
	
	if(self.__m_aw_userdef==false) then 
		aw= ComputeAw(self)
		
	else
		aw= self.__m_aw
	end
	
	if(self.name~="") then 
		str=str..self.name.."\n"
	end

	str=str.."Weight (unit weight)="..string.format("%.2f",self.weight).."\n"
	str=str.."Temperature (C)="..string.format("%.2f",self.temperature).."\n"

	if(self.water>0) then 
		str=str.."Water (%)="..string.format("%.2f",self.water).."\n" 
	end

	if(self.protein>0) then 
		str=str.."Protein (%)="..string.format("%.2f",self.protein).."\n" 
	end

	if(self.CHO>0) then 
		str=str.."CHO (%)="..string.format("%.2f",self.CHO).."\n" 
	end

	if(self.lipid>0) then 
		str=str.."Lipid (%)="..string.format("%.2f",self.lipid).."\n"
	end

	if(self.ash>0) then 
		str=str.."Ash (%)="..string.format("%.2f",self.ash).."\n" 
	end

	if(self.salt>0) then 
		str=str.."Salt (%)="..string.format("%.2f",self.salt).."\n" 
	end

	str=str.."Aw="..string.format("%.3f",aw).."\n"
	str=str.."pH="..string.format("%.2f",self.m_ph).."\n"

	return str
end



