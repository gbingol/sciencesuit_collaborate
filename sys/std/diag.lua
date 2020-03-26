-- Author:	Gokhan Bingol (gbingol@hotmail.com)
-- License: Subject to end-user license agreement conditions available at www.sciencesuit.org

local function diag(m)
	--Output: A vector containing diagonal elements of a matrix
	--Input: m is a matrix, rectangular or square
	
	assert(type(m)=="Matrix","ERROR: diag command is only applicable to matrices.")
	
	local row,col=std.size(m)
	local k=row
	
	if(row>col) then 
		k=col 
	end

	local retVec=Vector.new(k)
	for i=1,k do
		retVec[i]=m[i][i]
	end

	return retVec
end

std.diag=diag
