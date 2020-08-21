-- Author:	Gokhan Bingol (gbingol@sciencesuit.org)
-- License: Subject to end-user license agreement conditions available at www.sciencesuit.org

local std <const> =std


local TOLERANCE=std.const.tolerance


local function FitZeroIntercept(yobs, factor)
	--Equation to be solved: a1.x=y1, a2.x=y2 ..... an.x=yn
	--Best solution is: trans(A)*A*x=trans(A)*b	where A is a matrix with first column a's and second column 0s
	--trans(A)*A = a1^2+a2^2+...+an^2
	--trans(A)*b = a1*b1+a2*b2+...+an*bn
	--x=(trans(A)*b) / (trans(A)*A)
	
	--Also note that (important for coefficient analysis)
	--var(beta1)=var(sum(xy)/sum(x^2)) = [1/sum(x^2)]^2 * sum(x^2)*var(population)
	--sd(beta1)=S(population)/sqrt(sum(x^2))
	
	local sum_x2=0
	local sum_xy=0
	
	for i=1,#yobs do
		sum_x2=sum_x2+factor(i)^2
		sum_xy=sum_xy+factor(i)*yobs(i)
	end
	
	return sum_xy/sum_x2
end


local function SLM(yobs, factor, IsIntercept, Alpha)
	
	--yobs		:       Observed variable (dependent) of type vector
	-- factor 	:      	Independent variable (factor) of type vector

	
	Alpha=Alpha or 0.05
	

	assert(type(yobs)=="Vector","ERROR: First argument (dependent variable) must be of type Vector")
	assert(type(factor)=="Vector" ,"ERROR: Second argument (factor) must be of type Vector")
	
	assert(#yobs==#factor,"ERROR: Length of the vectors must be equal") 
	
	if(IsIntercept==nil) then
		IsIntercept=true
	end
	
	-- simple linear model
	local coeffs=nil
	
	if(IsIntercept) then
		coeffs=std.polyfit(factor, yobs,1)  -- an*x^n+...+a0
	else
		coeffs=Vector.new(2,0)
		coeffs[1]=FitZeroIntercept(yobs, factor)
	end
	
	
	
	
	local mt={}
	local retTable={}
	
	setmetatable(retTable, mt)
	
	function mt.__tostring()
		
		if(IsIntercept) then 
			return tostring(coeffs[1]).."*x + "..tostring(coeffs[2])
		end
			
		return tostring(coeffs[1]).."*x"
		
	end
	
	
	retTable.yobs=yobs
	retTable.factor=factor
	retTable.name="slm" --simple linear model
	
	retTable.coefficients=coeffs
	retTable.IsIntercept=IsIntercept
	retTable.Alpha=Alpha
	
	return retTable
	
	
end



local function SLM_Summary(retTable)
	
	assert(type(retTable)=="table" ,"Argument must be of type Lua table")
	
	local coeffs=retTable.coefficients
	
	local beta1, beta0=coeffs[1], coeffs[2]
	
	local yobs=retTable.yobs
	local factor=retTable.factor
	
	local Alpha=retTable.Alpha
	
	local N=#yobs
	
	local mean_x, mean_y=std.mean(factor), std.mean(yobs)
	
	
	local sum_xy, sum_x2, sum_y2, sum_y, sum_x, sum_mean_x, SS_Total=0, 0, 0, 0, 0, 0, 0
	
	for i=1,N do
		local xi, yi= factor[i], yobs[i]
		
		sum_x=sum_x+xi
		
		sum_y=sum_y+yi
		
		sum_x2=sum_x2+xi^2
		
		sum_y2=sum_y2+yi^2
		
		sum_xy=sum_xy+xi*yi
		
		sum_mean_x=sum_mean_x+(xi-mean_x)^2
		
		SS_Total=SS_Total+(yi-mean_y)^2 --total variability (SS total)
	end

	
	local df=N-2
	if(not retTable.IsIntercept) then
		df=N-1
		SS_Total=sum_y2
	end

	--Forming the ANOVA table for regression

	local fit_y=std.polyval(coeffs, factor)
	local residual=yobs-fit_y
	
	local residual_2=residual^2  --vector of squares of residuals
	
	local SS_Residual=std.sum(residual_2)
	
	local SS_Regression=SS_Total - SS_Residual
	
	local MS_Regression, MS_Residual=SS_Regression, SS_Residual/df
	
	
	local ANOVA={DF_Residual=df, SS_Residual=SS_Residual, MS_Residual=MS_Residual,
				DF_Regression=1,SS_Regression=SS_Regression,MS_Regression=MS_Regression, 
				SS_Total=SS_Total}
	
	ANOVA.Fvalue=MS_Regression/MS_Residual
	ANOVA.pvalue=1-std.pf(ANOVA.Fvalue, ANOVA.DF_Regression, ANOVA.DF_Residual)
	
	
	-- std error of population 
	local s=math.sqrt(MS_Residual) 
	
	local tbl0, tbl1=nil, nil
	local CoefStats=nil
	
	--tbl1
	
	local SE_beta1=s/math.sqrt(sum_mean_x)
	
	if(not retTable.IsIntercept) then 
		SE_beta1=s/math.sqrt(sum_x2)
	end
	
	local t_beta1=beta1/SE_beta1
	
	
		
	
	
	local pvalue=0
	
	if(t_beta1<=0) then
		pvalue=std.pt{q=t_beta1, df=df}+ (1-std.pt{q=math.abs(t_beta1), df=df}) --area on the left of tcrit + area on the right of positive
			
	elseif(t_beta1>0) then
		pvalue=(1-std.pt{q=t_beta1, df=df}) +std.pt{q=-t_beta1, df=df} --area on the right of positive tcritical + area on the left of negative tcritical
	end


	tbl1={coeff=beta1, pvalue=pvalue, tvalue=t_beta1,SE=SE_beta1 }
	
	local invTval=std.qt(Alpha/2.0, ANOVA.DF_Residual)
		
	local val1=beta1-SE_beta1*invTval
	local val2=beta1+SE_beta1*invTval
		
	tbl1.CILow=math.min(val1,val2)
	tbl1.CIHigh=math.max(val1,val2)
	
	
	--tbl0
	
	if(retTable.IsIntercept) then
	
		local SE_beta0=s*math.sqrt(sum_x2)/(math.sqrt(N)*math.sqrt(sum_mean_x))
		
		local t_beta0=beta0/SE_beta0
		
		pvalue=0
		
		if(t_beta0<=0) then
			pvalue=std.pt{q=t_beta0, df=df}+ (1-std.pt{q=math.abs(t_beta0), df=df}) 
				
		elseif(t_beta0>0) then
			pvalue=(1-std.pt{q=t_beta0, df=df}) +std.pt{q=-t_beta0, df=df} 
		end

		
		tbl0={coeff=beta0,pvalue=pvalue, tvalue=t_beta0, SE=SE_beta0  }
		
		local invTval=std.qt(Alpha/2.0, ANOVA.DF_Residual)
		
		local val1=beta0-SE_beta0*invTval
		local val2=beta0+SE_beta0*invTval
		
		tbl0.CILow=math.min(val1,val2)
		tbl0.CIHigh=math.max(val1,val2)
		
		
		CoefStats={tbl0, tbl1}
	
	else
		CoefStats={tbl1}
	end
	
	
	
	--Arranging return values
	
	local R2=SS_Regression/SS_Total
	
	local retTable={CoefStats=CoefStats, ANOVA=ANOVA, R2=R2, SE=s}
	
	
	
	return retTable
	
	
end






local function MLR(yobs,factmat, IsIntercept, Alpha)  
      --yobs:           Observed variable (dependent) of type vector
      -- factmat :      Independent variables (factors) of type matrix
      --IsIntercept:    Is there an intercept

	if(IsIntercept==nil) then
		IsIntercept=true
	end

	Alpha=Alpha or 0.05

	assert(type(yobs)=="Vector","ERROR: First argument (dependent variable) must be of type Vector")
	assert(type(factmat)=="Matrix" ,"ERROR: Second argument(independent variables) must be of type Matrix") 
	assert(type(IsIntercept)=="boolean", "ERROR: Third argument must be of type boolean")
	      
	assert(#yobs==factmat:nrows(),"Number of rows of matrix must be equal to the dimension of the Vector.")
	
	assert(std.rank(factmat)==factmat:ncols(), "There are linearly dependent columns, please remove and then continue")  
	
	

	local mat=factmat:clone()
	
	
	
	-- if constant is not zero then we have to add 1s
	if(IsIntercept) then 
		local ones=Vector.new(factmat:nrows(),1)
		mat:insert(ones, 1, "col")
	end


     
	local coeffs=std.solve(mat, yobs)
	
		
	local mt={}
	local retTable={}
	
	setmetatable(retTable, mt)
	
	function mt.__tostring()
		local str=""
		local len=#coeffs
		
		local start=1
		
		if(IsIntercept) then
			str=str..tostring(coeffs[1]).." + "
			
			for i=2,len-1 do
				str=str..tostring(coeffs[i]).."*x"..tostring(i-1).." + "
			end
			
			str=str..tostring(coeffs[len]).."*x"..tostring(len-1)
			
		else	
		
			for i=start,len-1 do
				str=str..tostring(coeffs[i]).."*x"..tostring(i).." + "
			end
			
			str=str..tostring(coeffs[len]).."*x"..tostring(len)
		end

		
		
		return str
	end
	
	
	retTable.yobs=yobs
	retTable.factor=mat
	retTable.factor_original=factmat
	retTable.name="mlr" --multiple linear regression
	
	retTable.coefficients=coeffs
	
	retTable.Alpha=Alpha
	retTable.IsIntercept=IsIntercept
	
	return retTable
	
end


local function MLR_Summary(retTable)
	
	assert(type(retTable)=="table" ,"Argument must be of type Lua table")
	
	local coeff=retTable.coefficients
	local yobs=retTable.yobs
	
	local  mat=retTable.factor
	local factmat=retTable.factor_original
	
	local MeanYObs=std.mean(yobs)
	
	local ypredicted=Vector.new(mat:nrows())
	local SS_Total, SS_Residual=0,0
	
	local sum_y2=0
	
	for i=1,mat:nrows() do 
		ypredicted[i]=mat(i)*coeff --row vector * col vector = number
		
		SS_Total=SS_Total+(MeanYObs-yobs(i))^2
		SS_Residual=SS_Residual+ (yobs[i]-ypredicted[i])^2
		
		sum_y2=sum_y2+yobs(i)^2
	end
	
	local NObservations=factmat:nrows()

	local DF_Regression=factmat:ncols()
	local DF_Residual=NObservations-(DF_Regression+ 1)
	
	
	if(not retTable.IsIntercept) then
		DF_Residual=NObservations-DF_Regression
		SS_Total=sum_y2
	end

	local DF_Total=DF_Regression+DF_Residual

	local SS_Regression=SS_Total-SS_Residual
	
	local ANOVA={SS_Total=SS_Total, SS_Residual=SS_Residual, SS_Regression=SS_Regression} 
	
	ANOVA.DF_Regression=DF_Regression
	
	ANOVA.DF_Residual=DF_Residual
	
	ANOVA.MS_Residual=SS_Residual/ANOVA.DF_Residual
	
	ANOVA.MS_Regression=SS_Regression/ANOVA.DF_Regression
	
	ANOVA.Fvalue=ANOVA.MS_Regression/ANOVA.MS_Residual
	ANOVA.pvalue=1-std.pf(ANOVA.Fvalue, ANOVA.DF_Regression, ANOVA.DF_Residual)
      
	local SEMat=std.inv(std.trans(mat)*mat)
	local SE=std.sqrt(std.diag(SEMat) )*std.sqrt(ANOVA.MS_Residual)--Standard Error of Estimate --> Vector


	--Statistics on each coefficient
	--Coeff     StdError    Tvalue      p-value      CI
	local CoefStats={}
	
	for i=1,#coeff do
		CoefStats[i]={}
		
		CoefStats[i].coeff=coeff(i)
		CoefStats[i].SE=SE(i)
		
		local Tvalue=coeff(i)/SE(i)
		CoefStats[i].tvalue=Tvalue
		
		if(Tvalue>=0) then
			CoefStats[i].pvalue=2*(1-std.pt{q=Tvalue,df=factmat:nrows()-1})
		else
			CoefStats[i].pvalue=2*std.pt{q=Tvalue,df=factmat:nrows()-1} 
		end
		
		
		
		local invTval=std.qt(retTable.Alpha/2.0, ANOVA.DF_Residual)
		
		local val1=coeff(i)-SE(i)*invTval
		local val2=coeff(i)+SE(i)*invTval 
		
		CoefStats[i].CILow=math.min(val1,val2)
		CoefStats[i].CIHigh=math.max(val1,val2)
		
	end
	
	local R2=SS_Regression/ANOVA.SS_Total
	
	local retTable={CoefStats=CoefStats, ANOVA=ANOVA, R2=R2}
	

	return retTable
end





local function summary(tbl)
	if(tbl.name=="slm") then
		return SLM_Summary(tbl)
		
	elseif(tbl.name=="mlr") then
		return MLR_Summary(tbl)
		
	else
		error("Are you using the return value of lm function as an argument?")
	end

	return nil
end




local mt={}
local lm={summary=summary}

setmetatable(lm, mt)



function mt:__call(...)
	local arg=table.pack(...)
	
	if(type(arg[2])=="Matrix") then
		return MLR(table.unpack(arg))
		
	elseif(type(arg[2])=="Vector") then
		return SLM(table.unpack(arg))
		
	else
		error("Second argument must be either a Vector or a Matrix")
	end
	
	return nil
end



std.lm=lm
