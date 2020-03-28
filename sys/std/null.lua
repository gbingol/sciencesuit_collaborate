-- Author:	Gokhan Bingol (gbingol@sciencesuit.org)
-- License: Subject to end-user license agreement conditions available at www.sciencesuit.org

local function null(A)

	--Finds the null space of A using svd decomposition
	
	assert(type(A)=="Matrix","ERROR: The argument to null function must be a matrix") 
	
	local m,n=std.size(A)
	local u,s,v=std.svd(A) -- u(m,m) s(m,n) v(n,n)
    
	local rank=0
	
	local rs,cs=std.size(s)
	local ns=0
	if(rs<=cs) then 
		ns=rs 
	else 
		ns=cs 
	end
	
	for i=1,ns do
		if(std.abs(s(i,i))>TOLERANCE) then 
			rank=rank+1 
		end
	end
	
	local NCols=n-rank --Number of columns in the null space
	
	if(NCols==0) then 
		return nil 
	end 

	retMat=Matrix.new(n,NCols)
	local k=1
	for i=1,n do
		for j=rank+1,n do
			retMat[i][k]=v(i,j)
			k=k+1
		end
		k=1
	end

	return retMat
end

std.null=null
    
