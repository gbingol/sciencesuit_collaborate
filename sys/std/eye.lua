local std <const> =std

local function eye(nrow, ncol)
	--INPUT: 		1) An unsigned integer number (>0)
	--				2) Two unsigned integer numbers
	
	--OUTPUT:		1) Identity matrix (square)
	--				2) Identity matrix( square or rectangular)
	
	if(ncol == nil) then
		return SYSTEM.eye(nrow)
	end

	return SYSTEM.eye(nrow, ncol)
	
end



std.eye=eye



-- Author:	Gokhan Bingol (gbingol@sciencesuit.org)
-- License: Subject to end-user license agreement conditions available at www.sciencesuit.org
