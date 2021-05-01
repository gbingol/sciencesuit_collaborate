local std <const> =std

local function accumulate(Container, initial_val, func)
	  --Container: an iteratable container containing addable entries, such as {a=1,2,3}
	  --initial_val: initial value
	  --func: a unary function such as math.cos(x)

	  --RETURNS: Accumulated total and number of entries

	  --Ex use: std.accumulate(vector, 0, function(x) return x^2 end) --sums the squares of elements in a vector
	  
	assert(initial_val~=nil,"ERROR: An initial value must be provided")
	
	
	
	local total=initial_val
	
	local NEntries=0
	
	
	if(func==nil) then
	
		for k,v in pairs(Container) do
		
			total=total+v
			
			NEntries=NEntries+1
		end
		
		
	
	
	elseif(func~=nil) then
	
		for k,v in pairs(Container) do
			
			total=total+func(v)
			
			NEntries=NEntries+1
		end
	
	end


	return total, NEntries
	  
end


std.algo.accumulate=accumulate



-- Author:	Gokhan Bingol (gbingol@sciencesuit.org)
-- License: Subject to end-user license agreement conditions available at www.sciencesuit.org

