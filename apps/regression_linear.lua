-- Author:	Gokhan Bingol (gbingol@sciencesuit.org)
-- License: Subject to end-user license agreement conditions available at www.sciencesuit.org

require( "iuplua" )

local std <const> =std
local iup <const> =iup


local function LinearRegression()
	
	local lblResponse=iup.label{title="Response:"}
	local txtResponse=std.gui.gridtext()
	
	local lblFactors=iup.label{title="Factor(s):"}
	local txtFactors=std.gui.gridtext()
	
	local lblConfidence=iup.label{title="Confidence Level:"}
	local txtConfidence=std.gui.numtext{min=0, max=100, value=95}
	
	
	local chkConstantZero = iup.toggle{title = "intercept=0"}
	
	local chkIncludeStats = iup.toggle{title = "Include Statistics (ANOVA, R2, Table of Coefficients ...)", value="ON"}
	
	local Input=iup.gridbox{lblResponse, txtResponse,
					lblFactors, txtFactors,
					lblConfidence, txtConfidence,
					chkConstantZero, iup.fill{},
					chkIncludeStats,iup.fill{},
					numdiv=2, HOMOGENEOUSCOL="yes",CGAPLIN=10, CGAPCOL=5, orientation="HORIZONTAL"}
	
	
	
	local OutputFrm=std.gui.frmOutput()
	
	local btnOK=iup.button{title="  OK  "}
	local btnCancel=iup.button{title="Cancel"}
	local btns=iup.hbox{iup.fill{}, btnOK,btnCancel}
	
	local vbox=iup.vbox{Input,OutputFrm,btns}
	
	local dlgMultRegres=iup.dialog{vbox; margin="10x10",title="Linear Regression", size="220x170"}
	
	OutputFrm:setOwner(dlgMultRegres)
	txtResponse:setOwner(dlgMultRegres)
	txtFactors:setOwner(dlgMultRegres)
	
	dlgMultRegres:show()
	
	

	std.gui.PrepareAppForPreSelection({txt=txtResponse, row=1,col=1, nrows=-1, ncols=1},{txt=txtFactors, row=1,col=2, nrows=-1, ncols=-1})
	
	
	
	function btnCancel:action()
		dlgMultRegres:hide()
	end





	local IsThereIntercept=true --by default
	local ShouldIncludeStats=1 -- by default

	function chkConstantZero:action(v)
		if(v==0) then 
			IsThereIntercept=true
		else
			IsThereIntercept=false
		end
	end

	function chkIncludeStats:action(v)
		ShouldIncludeStats=v
	end





	function btnOK:action()

		if(txtResponse.value=="" or txtFactors.value=="") then
			iup.Message("ERROR","Response or factors range cannot be empty, a selection must be made")
			
			return
		end


		local rngResponse=Range.new(txtResponse.value)
		local rngFactors=Range.new(txtFactors.value) 
		
		if(rngResponse:ncols()>1 ) then 
			iup.Message("ERROR","Response variable must be a single column.") 
			
			return 
		end
		
		if(rngResponse:nrows()~=rngFactors:nrows()) then 
			iup.Message("ERROR","Factors and response variable must have same number of rows.") 
			
			return 
		end



		local outRng=OutputFrm:GetRange()

		local Row, Col=1, 1
		local WS=nil
		
		if(outRng~=nil)  then 
			Row=outRng:coords().r 
			Col=outRng:coords().c
			WS=outRng:parent() 
		else
			WS=std.appendworksheet()
		end


			
		local factors=nil
		if(rngFactors:ncols()>1) then
			factors=std.tomatrix(rngFactors, rngFactors:nrows(), rngFactors:ncols())
		else
			factors=std.tovector(rngFactors)
		end
		
		local yobs=std.tovector(rngResponse)
		
		
		local Alpha=1-tonumber(txtConfidence.value)/100
		if(Alpha<=0 or Alpha>=1) then 
			iup.Message("Error", "Confidence Level must be in the range of (0, 100)")
			
			return
		end
		
		
		
		
		local RegresResult=std.lm(yobs, factors, IsThereIntercept, Alpha)
		
		--Just print the regression equation and return
		if(ShouldIncludeStats==0) then
			WS[Row][Col]=tostring(RegresResult)
			
			return
			
		end

		
		--User is asking a full statistics on coefficients, which is normally the usual case
		
		local ResTbl=std.lm.summary(RegresResult)
		
            -- ANOVA output
		WS[Row][Col]= "Linear Regression Table"

		Row=Row+1
		
		WS[Row][1]="R2"
		WS[Row][2]=string.format("%.3f",ResTbl.R2)
		
		
		Row=Row+2
		
		local Headers={"df","SS","MS","F","p-value"}

		for i=1,#Headers do
			WS[Row][Col+i]=Headers[i]
		end
 
		Row=Row+1
		
		Headers={"Regression","Residual","Total"}
		for i=1,#Headers do
			WS[Row+i-1][Col]=Headers[i]
		end

		local ANOVA=ResTbl.ANOVA

		local Regression={ANOVA.DF_Regression,ANOVA.SS_Regression,ANOVA.MS_Regression, ANOVA.Fvalue,ANOVA.pvalue}
		local Residual={ANOVA.DF_Residual, ANOVA.SS_Residual,ANOVA.MS_Residual }
		local Total={ANOVA.DF_Residual+ANOVA.DF_Regression, ANOVA.SS_Regression+ANOVA.SS_Residual }

		local Vals={Regression, Residual, Total}
		  
		

		for i=1, #Vals do
			local tbl=Vals[i]

			for j=1,#tbl do
				WS[Row][Col+j]=std.toformattedstring(tbl[j])
			end

			Row=Row+1
		end
		

		--Coefficients and Statistics
		Row=Row+2

		Headers={"Coefficient","Std Error","T value","p-value","CI" }
		for i=1,#Headers do
			WS[Row][Col+i]=Headers[i]
		end
		
		
		Row=Row+1
		
		local CoefStats=ResTbl.CoefStats
		
		for i=1, #CoefStats do
			
			if(IsThereIntercept) then 
				if(i==1) then
					WS[Row][Col]="Intercept" 
				else
					WS[Row][Col]="Variable "..tostring(i-1)
				end
			end
				
			
			if(IsThereIntercept==false) then 
				WS[Row][Col]= "Variable "..tostring(i) 
			end
			
			
			Vals=nil
			Vals={CoefStats[i].coeff, 
					CoefStats[i].SE,
					CoefStats[i].tvalue,
					CoefStats[i].pvalue
				}

			for j=1,#Vals do
				WS[Row][Col+j]=std.toformattedstring(Vals[j])
			end
			

			local ColPos=Col+#Vals+1
			WS[Row][ColPos]=std.toformattedstring(CoefStats[i].CILow).." , "..std.toformattedstring(CoefStats[i].CIHigh)
			
			Row=Row+1
		end
		
		
	end 

end

std.app.LinearRegression=LinearRegression

      
