require( "iuplua" )

local function GetFormattedString(num)
	if(num>1 or num<-1.0) then
		return string.format("%.2f",num)
		
	elseif((num<1.0 and num>0.1) or (num>-1.0 and num<-0.1))  then
		return string.format("%.3f", num)
		
	elseif((num<0.1 and num>0) or (num>-0.1 and num<0)) then
		return string.format("%.5f", num)
	end
end



local function  dlgTwoSample2Test()


	local lblVar1=iup.label{title="Variable 1 range:"}
	local txtVar1=std.gui.gridtext()

	local lblVar2=iup.label{title="Variable 2 range:"}
	local txtVar2=std.gui.gridtext()

	local lblConfLevel=iup.label{title="Confidence level:"}
	local txtConfLevel=std.gui.numtext{min=0, max=100, value=95}


	local lblDiff=iup.label{title="Assumed mean difference:"}
	local txtDiff=iup.text{value=0,expand="HORIZONTAL"}
	
	local lblAlternative=iup.label{title="Alternative: "}
	local listAlternative = iup.list {"less than", "not equal", "greater than"; value = 2, DROPDOWN="yes"}
	
	local chkEqualVar=iup.toggle{title = "Assume Equal Variances", tip="You can run F-test to see if the variances are equal or not"}
	
	local chkInOneCol=iup.toggle{title = "Samples in one column"}
	
	chkInOneCol.tip="If you have data pairs  in the format of (Subscripts, data) such as (A,10), (B,20) and \n subscripts are stacked in 1 column and data stacked in another column select this option"
	

	local GridboxInput=iup.gridbox{lblVar1, txtVar1,
							lblVar2, txtVar2,
							lblConfLevel, txtConfLevel,
							lblDiff, txtDiff,
							lblAlternative,listAlternative,
							chkInOneCol,chkEqualVar,
							numdiv=2, HOMOGENEOUSCOL="yes",CGAPLIN=10, CGAPCOL=20, orientation="HORIZONTAL"}
							

	local OutputFrame=std.gui.frmOutput()
	

	--main dialog
	
	local BtnOK=iup.button{title="OK", size="30x12"}
	local BtnCancel=iup.button{title="Cancel",size="30x12"}

	local AllLayout=iup.vbox{GridboxInput,
							iup.space{size="x5"},
							OutputFrame , 
							iup.hbox{iup.fill{}, BtnOK, BtnCancel;alignment = "ACENTER"}}


	local icon=std.gui.makeicon(std.const.exedir.."apps/images/t_test2sample.png")

	local MainDlg = iup.dialog{AllLayout; title = "Two-sample t-test", margin="10x10", size="225x195", resize="yes", icon=icon}
	
	txtVar1:setOwner(MainDlg)
	txtVar2:setOwner(MainDlg)
	OutputFrame:setOwner(MainDlg)
	
	MainDlg:show()
	
	iup.Refresh(MainDlg)

	
	function BtnCancel:action()
		MainDlg:hide()
	end
	
	
	local SamplesInTwoCol=true
	
	function chkInOneCol:action(value)
		if(value==1) then
			lblVar1.title="Samples range:"
			lblVar2.title="Subscripts range:"
		
			SamplesInTwoCol=false
		else
			lblVar1.title="Variable 1 range:"
			lblVar2.title="Variable 2 range:"
			
			SamplesInTwoCol=true
		end
	end
	
	local alternative="two.sided"
	function listAlternative:action(text, item, state)
		local alt={"less", "two.sided", "greater"}
		alternative=alt[item]
	end 


	function BtnOK:action()

		if(txtVar1.value=="" or txtVar2.value=="") then
			iup.Message("ERROR","A range must be selected for both variable 1 and 2.")
			return
		end

		
		local conflevel=tonumber(txtConfLevel.value)/100
		local Mu=tonumber(txtDiff.value)
		local varequal=false
		
		if(chkEqualVar.value=="ON") then
			varequal=true
		end
		 
		local rng1=Range.new(std.activeworkbook(), txtVar1.value)
		local rng2=Range.new(std.activeworkbook(), txtVar2.value)

		if(rng1:ncols()>1 or rng2:ncols()>1) then 
			iup.Message("ERROR","The selected range for Variable #1 and Variable #2 must be a single column.") 
			return 
		end
			
		
		local OutputRng=OutputFrame:GetRange()
		
		local WS=nil
		local row, col=0, 0
		
		if(OutputRng~=nil)  then 
			row=OutputRng:coords().r 
			col=OutputRng:coords().c
			WS=OutputRng:parent() 
		else
			WS=std.activeworkbook():add()
			row=1
			col=1
		end
		
		
		local pval,ttable=nil, nil
		local v1, v2=nil, nil
		
		if(SamplesInTwoCol) then
			v1 , v2=std.tovector(rng1) , std.tovector(rng2)
			if(v1==nil or #v1<3) then 
				iup.Message("ERROR","Either there is none or less than 3 valid numeric data in the selected range of Variable #1.") 
				return 
			end
				
			if(v2==nil or #v2<3) then 
				iup.Message("ERROR","Either there is none or less than 3 valid numeric data in the selected range of Variable #2.")  
				return 
			end
			
			
		end
		
		
		if (not SamplesInTwoCol) then
		
			local samples , subscripts=std.tovector(rng1) , std.toarray(rng2)
			
			local uniquesubscripts=subscripts:clone()
			uniquesubscripts:unique()
			
			if(#uniquesubscripts~=2) then
				iup.Message("ERROR","Number of codes pertaining to factors in the subscripts range must be exactly 2")  
				return
			end
			
			
			v1, v2=Vector.new(0), Vector.new(0)
			
			for i=1,  #subscripts do
				if(subscripts[i]==uniquesubscripts[1]) then
					v1:push_back(samples(i))
				
				elseif(subscripts[i]==uniquesubscripts[2]) then
					v2:push_back(samples(i))
				end
			end
	
		end 
			
		pval,ttable=std.test_t{x=v1,y=v2,alternative=alternative, varequal=varequal, mu=Mu, conflevel=conflevel, paired=false}
		

		WS[row][col+1]="Variable 1";   WS[row][col+2]="Variable 2" ; 
		row=row+1
		
		WS[row][col]="Observation"; WS[row][col+1]=ttable.n1;WS[row][col+2]=ttable.n2; 
		row=row+1
		
		WS[row][col]="Mean"; WS[row][col+1]=GetFormattedString(ttable.xaver); WS[row][col+2]=GetFormattedString(ttable.yaver);
		row=row+1
		
		WS[row][col]="Standard Deviation"; WS[row][col+1]=GetFormattedString(ttable.s1);WS[row][col+2]=GetFormattedString(ttable.s2); 
		row=row+1

		row=row+1--Leave one space so that following analysis does not seem to belong variable 1
		if(varequal) then 
			WS[row][col]="Pooled variance" 
			WS[row][col+1]=GetFormattedString(ttable.sp)
			row=row+1
		end

		WS[row][col]="t critical" 
		WS[row][col+1]=GetFormattedString(ttable.tcritical)
		row=row+1
		
		WS[row][col]="p-value" 
		WS[row][col+1]=GetFormattedString(pval); 
		row=row+2
		
		WS[row][col]=tostring(conflevel*100).." Confidence Interval for "..alternative
		
		if(alternative=="less") then
			WS[row+1][col]="(-inf, "..GetFormattedString(ttable.CI_upper)..")"
		elseif(alternative=="greater") then
			WS[row+1][col]="("..GetFormattedString(ttable.CI_lower)..", inf)"
		else
			WS[row+1][col]="("..GetFormattedString(ttable.CI_lower).." , "..GetFormattedString(ttable.CI_upper)..")"
		end

	end 
	
	

end --MainDialog


std.app.TTest2Sample=dlgTwoSample2Test



