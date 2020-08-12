-- Author:	Gokhan Bingol (gbingol@sciencesuit.org)
-- License: Subject to end-user license agreement conditions available at www.sciencesuit.org

local std <const> =std

local function ComputeVariance(elem, str)
	--INPUT: 	First argument: A vector, matrix, array or range
	--			Second argument is optional
	--OUTPUT:	If only elem is provided then sample variance is computed
	--			variancetype can be either "s" or "p"
	
	str=str or "s"
	
	assert(type(str)=="string","ERROR: Second argument must be of type string, 's' or 'p'")
	str=string.lower(str)

	assert(str=="s" or str=="p","ERROR: Second argument can be either \"s\" or \"p\"")
	

	
	local X,X2=0,0
	local NEntries=0


	for k,v in pairs(elem) do
		
		X=X+v
		X2=X2+v^2
		
		NEntries=NEntries+1
	end
	
	local E_X, E_X2=X/NEntries, X2/NEntries
	
	local variancePopulation=E_X2-(E_X)^2
	
	local df_Population=NEntries
	local df_Sample=df_Population-1
	
	if(str=="p") then
		return variancePopulation
	
	elseif(str=="s") then
		return variancePopulation*df_Population/df_Sample
		
	end
	
		
end
	

std.var=ComputeVariance
