-- Author:	Gokhan Bingol (gbingol@sciencesuit.org)
-- License: Subject to end-user license agreement conditions available at www.sciencesuit.org

local std <const> =std

local function rank(A)

    --Finds the rank of A using svd decomposition

	assert(type(A)=="Matrix", "Matrix expected." ) 
	
	local m,n=std.size(A)
	local u,s,v=std.svd(A) -- u(m,m) s(m,n) v(n,n)
    
	local rnk=0
	
	local ns=s:ncols()

	if(s:nrows()<=s:ncols()) then 
		ns=s:nrows() 
	end
	

	for i=1,ns do

		if(math.abs(s(i,i))>TOLERANCE) then 
			rnk=rnk+1 
		end

	end

	
	return rnk
end


std.rank=rank
