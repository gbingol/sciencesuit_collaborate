local std <const> =std

local function diff(v1, v2)
	--INPUT: 		1) A single vector of size n 
	--			2) Two vectors of sizes n

	--OUTPUT: 		1) The difference between the consecutive elements, returns n-1 elements 
	--			2) Numerical differentiation dy/dx. Uses forward, central and backward differences algorithms
	
	assert(type(v1)=="Vector","First arg must be of type Vector")
	
	if(v2==nil) then
		local dim=#v1
		local retVec=std.Vector.new(dim-1)
		for i=1,dim-1 do
			retVec[i]=v1(i+1)-v1(i)
		end

		return retVec
	end


	assert(type(v2)=="Vector","Second arg must be of type Vector")	

	local x,y=v1, v2
	local dimx,dimy=#x, #y
	
	assert(dimx==dimy,"Vector lengths must be same") 
	
	local retVec=std.Vector.new(dimx)
	for i=1,dimx do
		local val;
		if(i==1) then 
			val=(y(i+1)-y(i)) / (x(i+1)-x(i)) --Forward differences
		elseif(i==dimx) then 
			val=(y(dimx)-y(dimx-1)) / (x(dimx)-x(dimx-1)) --Backward differences
		else 
			val=(y(i+1)-y(i-1)) / (x(i+1)-x(i-1)) --Central differences
		end

		retVec[i]=val
	end

	return retVec

end



std.diff=diff




-- Author:	Gokhan Bingol (gbingol@sciencesuit.org)
-- License: Subject to end-user license agreement conditions available at www.sciencesuit.org
