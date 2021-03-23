local std <const> =std

local function diff(v1, v2)
	--INPUT: 		1) A single vector/array of size n 
	--				2) Two containers of size n

	--OUTPUT: 		1) The difference between the consecutive elements, returns n-1 elements 
	--				2) Numerical differentiation dy/dx. Uses forward, central and backward differences algorithms
	
	
	assert(type(v1)=="Vector" or type(v1)=="Array","First arg must be Vector/Array")
	
	
	if(type(v1)=="Array") then
		v1=v1:clone()
		v1:keep_numbers()
		
		assert(#v1 >= 2, "First Array must have at least 2 numeric entries")
	end
	
	
	if(v2==nil) then
		
		local retCont=nil
		
		if(type(v1)=="Vector") then
			 retCont=std.Vector.new(#v1-1)
		else
			retCont=std.Array.new(#v1-1)
		end


		for i=1,#v1-1 do
			retCont[i]=v1(i+1)-v1(i)
		end

		return retCont
	end





	assert(type(v2)=="Vector" or type(v2)=="Array","Second arg must be Vector/Array")	
	
	
	if(type(v2)=="Array") then
		v2=v2:clone()
		v2:keep_numbers()
		
		assert(#v2 >= 2, "Second Array must have at least 2 numeric entries")
	end



	local x,y = v1, v2
	local dimx,dimy=#x, #y
	
	assert(dimx == dimy,"Container lengths must be same") 
	
	
	local retCont=nil

	--if either container is a Vector, return Vector
	if(type(v2)=="Vector" or type(v1)=="Vector") then
		retCont = std.Vector.new(dimx)
	else
		--if both containers are Arrays, return Array
		retCont=std.Array.new(dimx)
	end
	
	
	for i = 1, dimx do
		local val;
		
		if(i==1) then 
			val = (y(i+1) - y(i)) / (x(i+1) - x(i)) --Forward differences
			
		elseif(i == dimx) then 
			val = (y(dimx) - y(dimx-1)) / (x(dimx) - x(dimx-1)) --Backward differences
			
		else 
			val = (y(i+1) - y(i-1)) / (x(i+1) - x(i-1)) --Central differences
		end


		retCont[i]=val
	end



	return retCont
end





std.diff=diff




-- Author:	Gokhan Bingol (gbingol@sciencesuit.org)
-- License: Subject to end-user license agreement conditions available at www.sciencesuit.org
