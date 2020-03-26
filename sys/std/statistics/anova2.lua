-- Author:	Gokhan Bingol (gbingol@hotmail.com)
-- License: Subject to end-user license agreement conditions available at www.sciencesuit.org

local  function GetAveragePerCol(matrix)
	local retVec=Vector.new(0)
	for i=1,matrix:ncols() do
		local col=matrix({},i)
		local avg=std.mean(col)
		
		retVec:push_back(avg)
	end
	
	return retVec
end


local function anova2(yobs, x1, x2)
	--Balanced Two factor Anova
	--yobs: Observed variable
	--x1,x2: factors

	assert(type(yobs)=="Vector","ERROR: First argument, response, must be of type Vector")
	assert(type(x1)=="Vector" or type(x1)=="Array","ERROR: Second argument, factor #1, must of either type Vector or Array")
	assert(type(x2)=="Vector" or type(x2)=="Array","ERROR: Third argument, factor #2, must of either type Vector or Array") 
	
	v1, v2 =x1[{}], x2[{}]
	v1:unique()
	v2:unique()
	

	--prepare a 3D table
	tbl={}
	for i=1, #v2 do
		tbl[i]={}
		for j=1,#v1 do
			tbl[i][j]={}
		end
	end
      
	--parse the data that comes in the format of y, x1, x2 to columns of x1 (v1 columns) and rows of x2 (v1 columns)
	--The formatted data looks like how Excel accepts data for 2-factor ANOVA 
	for k=1, #yobs do
		local i,j=0, 0
		repeat i=i+1 until x2(k)==v2(i)
		repeat j=j+1 until x1(k)==v1(j)
		
		local pos=#tbl[i][j]
		
		if(pos==nil) then 
			tbl[i][j][1]=yobs(k) 
		else 
			tbl[i][j][pos+1]=yobs(k) 
		end
	end
	

	local MatAverage=Matrix.new(#v2, #v1)
	for i=1, #v2 do
		local m=std.trans(std.tomatrix(tbl[i]))
		local vec=std.trans(GetAveragePerCol(m))
		for j=1, #vec do 
			MatAverage[i][j]=vec(j) 
		end
	end

	local RowPerEntryMatrix=Matrix.new(#v2, #v1) --to check whether balanced or not
	local GrandMean=std.mean(MatAverage)
	local SSerror=0
	
	
	for i=1, #v2 do
		for j=1,#v1 do
			local sz=#tbl[i][j]
			RowPerEntryMatrix[i][j]=sz
			for k=1, sz do
				SSerror=SSerror +(tbl[i][j][k]-MatAverage(i,j))^2
			end
		end
	end

	local cmpMat=RowPerEntryMatrix:equal(RowPerEntryMatrix(1,1))
	
	local rcmp, ccmp=std.size(cmpMat)
	if(std.sum(cmpMat)<rcmp*ccmp) then
		error( "ERROR: This function correctly works for balanced data",ERRORLEVEL)
	end

	local Nreplicate=#tbl[1][1] -- assuming balanced
	local DFerror=(Nreplicate-1)*(#v1)*(#v2)
	local MSerror=SSerror/DFerror
	local SSFact1, SSFact2=0, 0
	local DFFact1, DFFact2=(#v1)-1 , (#v2)-1
	local MSFact1, MSFact2=0, 0
	local SSinteract, DFinteract, MSinteract= 0 , 0 , 0
	local FvalFact1, FvalFact2, Fvalinteract= 0 , 0 , 0
	local pvalFact1, pvalFact2, pvalinteract= 0, 0, 0

	SSFact1=std.sum( GetAveragePerCol(MatAverage)-GrandMean, 2) *Nreplicate*(#v2)
	SSFact2=std.sum( GetAveragePerCol(std.trans(MatAverage))-GrandMean, 2) *Nreplicate*(#v1)
	
	MSFact1=SSFact1/DFFact1
	MSFact2=SSFact2/DFFact2
		 
	local meanj=GetAveragePerCol(MatAverage)
	local meani=GetAveragePerCol(std.trans(MatAverage))    
	for i=1, std.size(v2) do
		for j=1, std.size(v1) do
			SSinteract=SSinteract+(MatAverage(i,j)-meanj(j) -meani(i)+GrandMean)^2
		end
	end
	
	SSinteract=SSinteract*Nreplicate
	DFinteract=DFFact1*DFFact2
	MSinteract=SSinteract/DFinteract
	FvalFact1=MSFact1/MSerror
	FvalFact2=MSFact2/MSerror
	Fvalinteract=MSinteract/MSerror 

	pvalFact1=1-std.pf(FvalFact1, DFFact1, DFerror)
	pvalFact2=1-std.pf(FvalFact2, DFFact2, DFerror)
	pvalinteract=1-std.pf(Fvalinteract, DFinteract, DFerror)
	
	local AnovaTable={}
	AnovaTable.name="anova2"
	AnovaTable.SSFact1=SSFact1
	AnovaTable.SSFact2=SSFact2
	AnovaTable.SSinteract=SSinteract
	AnovaTable.DFFact1=DFFact1
	AnovaTable.DFFact2=DFFact2
	AnovaTable.DFinteract=DFinteract
	AnovaTable.MSFact1=MSFact1
	AnovaTable.MSFact2=MSFact2
	AnovaTable.MSinteract=MSinteract
	AnovaTable.FvalFact1=FvalFact1
	AnovaTable.FvalFact2=FvalFact2
	AnovaTable.Fvalinteract=Fvalinteract
	AnovaTable.SSError=SSerror
	AnovaTable.DFError=DFerror
	AnovaTable.MSError=MSerror
	
	local retVec=Vector.new(3)
	retVec[1]=pvalFact1
	retVec[2]=pvalFact2
	retVec[3]=pvalinteract

	return retVec, AnovaTable

end

std.anova2=anova2
