-- Author:	Gokhan Bingol (gbingol@sciencesuit.org)
-- License: Subject to end-user license agreement conditions available at www.sciencesuit.org

local function STDEV(elem, str)
	--INPUT: 	First argument: A vector, matrix, array or range
	--			Second argument is optional
	--OUTPUT:	If only elem is provided then sample variance is computed
	--			variancetype can be either "s" or "p"
	
	str=str or "s"
	
	assert(type(str)=="string","ERROR: Second argument must be of type string, 's' or 'p'")
	str=string.lower(str)

	assert(str=="s" or str=="p","ERROR: Second argument can be either \"s\" or \"p\"")


	return std.sqrt(std.var(elem,str))
end

std.stdev=STDEV
	
