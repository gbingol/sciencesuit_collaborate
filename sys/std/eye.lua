-- Author:	Gokhan Bingol (gbingol@sciencesuit.org)
-- License: Subject to end-user license agreement conditions available at www.sciencesuit.org


local function eye(nrow, ncol)
	--INPUT: 		1) An unsigned integer number (>0)
	--				2) Two unsigned integer numbers
	
	--OUTPUT:		1) Identity matrix (square)
	--				2) Identity matrix( square or rectangular)
	
	
	assert(math.type(nrow)=="integer" and nrow>0 ,"ERROR: First argument must be a positive integer")
	
	if(ncol==nil) then
		local m=Matrix.new(nrow,nrow)
		for i=1,nrow do 
			m[i][i]=1.0
		end
		
		return m
		
     
	elseif(ncol~=nil) then
		assert(math.type(ncol)=="integer" and ncol>0 ,"ERROR: Second argument must be a positive integer")
		
		local n=nrow
		
		if(ncol<nrow) then 
			n=ncol 
		end
		
		local m=Matrix.new(nrow,ncol)
		
		for i=1,n do 
			m[i][i]=1.0 
		end
		
		return m
          
	end
	
	

	
end

std.eye=eye
