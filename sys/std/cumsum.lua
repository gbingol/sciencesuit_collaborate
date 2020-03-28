-- Author:	Gokhan Bingol (gbingol@sciencesuit.org)
-- License: Subject to end-user license agreement conditions available at www.sciencesuit.org


local function cumsum(vec)

	-- Finds the cumulative sum
	-- Returns a Vector containing cumulative sums
	assert(type(vec)=="Vector", "ERROR: Argument must be of type Vector.")

	local sum=0
	local retVec=Vector.new(#vec)
	for i=1,#vec do
		sum=sum+vec(i)
		retVec[i]=sum
	end
		
	return retVec

end

std.cumsum=cumsum
