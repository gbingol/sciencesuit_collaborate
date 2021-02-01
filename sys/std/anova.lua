local std <const> =std


local function SingleFactorANOVA(...)
	
	local args=table.pack(...)
	
	local SS_Treatment, SS_Error, SS_Total=0, 0, 0
	
	local NEntries=0 -- Number of entries
	
	--C is a variable defined to speed up computations (see Larsen Marx Chapter 12 on ANOVA)	
	local C=0
	
	local Averages={}
	local SampleSizes={}
		
		
	
	for i=1, #args do
		
		local vec=args[i] --Each entry of args is a Vector/Array

		assert(type(vec)=="Vector" or type(vec)=="Array", "Each entry must be Vector or Array")
		
		if(type(vec)=="Array") then
			vec=vec:clone()
			
			vec:keep_numbers()
		end
		
		local vecSize=#vec
		
		local LocalSum=0
		
		for j=1,#vec do
			LocalSum=LocalSum+vec(j)
			
			SS_Total=SS_Total+vec(j)^2
		end
		
		--Required for Tukey test
		Averages[i]=LocalSum/vecSize
		
		SampleSizes[i]=vecSize
		
		C=C+LocalSum
		
		NEntries=NEntries+ vecSize
		
		SS_Treatment=SS_Treatment+LocalSum^2/vecSize
			
	end
	
	
	C=C^2/NEntries
	
	SS_Total=SS_Total-C
	
	SS_Treatment=SS_Treatment-C
	
	SS_Error=SS_Total - SS_Treatment
	
	
	local DF_Error, DF_Treatment= NEntries-#args, #args-1 
	local DF_Total=DF_Error + DF_Treatment
	
	
	local MS_Treatment, MS_Error=SS_Treatment/DF_Treatment , SS_Error/DF_Error
	
	local Fvalue=MS_Treatment/MS_Error
	
	local pvalue=1-std.pf{q=Fvalue, df1=DF_Treatment, df2=DF_Error}
	
	local anovatable={name="anova1", Fvalue=Fvalue,pvalue=pvalue,
						DF_Treatment=DF_Treatment, SS_Treatment=SS_Treatment, MS_Treatment=MS_Treatment,
						DF_Error=DF_Error, SS_Error=SS_Error, MS_Error=MS_Error,
						DF_Total=DF_Total, SS_Total=SS_Total	,
						Averages=Averages, SampleSizes=SampleSizes}
	
	
	
	return  pvalue ,  anovatable
end






local function tukey(AnovaTable, Alpha)
	--H0: Mean(i)=Mean(j)
	
	
	assert(type(AnovaTable)=="table","ERROR: First argument must be of type Lua table.")
	assert(AnovaTable.name=="anova1","ERROR: First argument is not generated by a 1-way ANOVA test.")
	
	assert(type(Alpha)=="number" and Alpha<1 and Alpha>0, "ERROR: Second argument must be a number in the range (0,1).")
	
      
	local TukeyTable={}
	local mt={}
	
	setmetatable(TukeyTable,mt)
	
	TukeyTable.name="tukey"
	
	local Averages=AnovaTable.Averages
	local SampleSizes=AnovaTable.SampleSizes
	local MS_Error=AnovaTable.MS_Error
	
	local DF_Treatment=AnovaTable.DF_Treatment
	local DF_Error=AnovaTable.DF_Error
	
	local NResponses=#Averages
	
	
	
	local D= std.misc.qdist(1-Alpha, DF_Treatment+1, DF_Error) / math.sqrt(AnovaTable.SampleSizes[1])
	local ConfIntervalLength=D*math.sqrt(MS_Error)
	
	
	
	local ComparisonNum=0
	
	for i=1,NResponses do
		for j=i+1,NResponses do
			
			ComparisonNum=ComparisonNum+1
			
			TukeyTable[ComparisonNum]={}
			
			
			local MeanValueDiff=Averages[i]-Averages[j]
			local ConfInterval1=MeanValueDiff-ConfIntervalLength
			local ConfInterval2=MeanValueDiff+ConfIntervalLength
			
			
			TukeyTable[ComparisonNum].a=i
			TukeyTable[ComparisonNum].b=j 
	
			TukeyTable[ComparisonNum].MeanValueDiff=MeanValueDiff
			TukeyTable[ComparisonNum].CILow=math.min(ConfInterval1,ConfInterval2)
			TukeyTable[ComparisonNum].CIHigh=math.max(ConfInterval1,ConfInterval2)
		end 
	end 


	function mt:__tostring()
		local str="Pairs \t \t Diff  \t \t Tukey Interval"
		str=str.."\n"
		
		for i=1,#TukeyTable do
			local Entry=TukeyTable[i]
			
			local CILow=std.misc.tostring(Entry.CILow)
			local CIHigh=std.misc.tostring(Entry.CIHigh)
			
			str=str..std.misc.tostring(Entry.a).."-"..std.misc.tostring(Entry.b).."\t \t"..std.misc.tostring(Entry.MeanValueDiff).."\t \t"..CILow..","..CIHigh	
			str=str.."\n"
		end

		return str
	end

	
	return TukeyTable 
end





local mt={}
local anova={tukey=tukey}

setmetatable(anova, mt)


function mt:__call(...)
	return SingleFactorANOVA(...)
end


	
std.anova=anova



-- Author:	Gokhan Bingol (gbingol@sciencesuit.org)
-- License: Subject to end-user license agreement conditions available at www.sciencesuit.org

