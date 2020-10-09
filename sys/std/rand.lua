-- Author:	Gokhan Bingol (gbingol@sciencesuit.org)
-- License: Subject to end-user license agreement conditions available at www.sciencesuit.org

local std <const> =std


local function rand(m,n)
     
	if(m==nil and n==nil) then 
		return std.runif()(1) 
	end --runif() returns a vector 
	     
	if(n==nil) then 
		return std.runif(m) 
	end 

	assert(math.type(m)=="integer" and math.type(n)=="integer" and m>0 and n>0,"First and second arguments must be an integer greater than zero.")

	local row,col=m , n

	local v=std.runif(row*col)
	
	local retMat=std.Matrix.new(row,col)
	
	local k=1
	
	for i=1,row do
		for j=1,col do
			retMat[i][j]=v[k]
			
			k=k+1
		end
	end
	
	
	return retMat
     
end

std.rand=rand
