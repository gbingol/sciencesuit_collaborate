-- Author:	Gokhan Bingol (gbingol@hotmail.com)
-- License: Subject to end-user license agreement conditions available at www.sciencesuit.org


local function tdma(A, b)

	--Solves Tridiagonal Matrix using Thomas Algorithm

	--  A is the tridiagonal matrix
	--  b is a vector containing right handside values of the equation
	-- The function changes b, therefore it is cloned in the first line

	assert(type(A)=="Matrix","First argument must be a tridiagonal matrix") 
	assert(type(b)=="Vector","Second argument must be a vector") 
	
	local d=b:clone()
	local row, col=std.size(A)
	
	assert(row==#d,"ERROR: matrix row number and vector dimensions do not match in tdma") 
		
	local vecA=Vector.new(row)
	local vecB=Vector.new(row)
	local vecC=Vector.new(row-1)
		
	for i=1,row do
		if(i>=2) then 
			vecA[i]=A(i,i-1) 
		end
		vecB[i]=A(i,i)
		
		if(i<row) then 
			vecC[i]=A(i,i+1) 
		end
	end

	for k=2,row do
		local m=vecA(k)/vecB(k-1)

		vecB[k]=vecB(k)-m*vecC(k-1)
		d[k]=d(k)-m*d(k-1)
	end

	local retVec=Vector.new(row)

	-- Backward substitution

	retVec[row]=d(row)/vecB(row)

	local n=row-1
	for  k=n,1 ,-1 do
		retVec[k]=(d(k)-vecC(k)*retVec(k+1))/vecB(k)
	end

	return retVec
end


local function solve(A, b, IsTridiagonal)
	
	--Solves a linear system given

	--Input: 		A: A matrix
	--			b: right-hand side vector
	
	--Output: x: solution vector
	
	assert( type(A)=="Matrix" and type(b)=="Vector","ERROR: First argument must be of type Matrix and second argument of type Vector")
		
	local matrix=A:clone()
	local vec=b[{}]
	
	-- If possible solve using tridiagonal matrix algorithm
	if(IsTridiagonal)  then 
		return tdma(matrix,vec)  
	end 
		
	local row,column=std.size(matrix)
	local dim=#vec
		
	assert(std.abs(dim-row)==0,"The number of right hand side numbers does not match the number of equations") 
		
	if(row==column) then
		--Solve Ax=b --> QRx=b --> trans(Q)*Q*R*x=trans(Q)*b --> R*x=trans(Q)*b --> R*x=b2
		local q,r=std.qr(matrix)
		local b2=std.trans(q)*vec
		return SYSTEM.forwardsubs(r,b2) --forward substitution
	end
	
	--Try to get the "best" solution -->A'*A*x=A'*b
	if(row>column) then 
		return solve(std.trans(matrix)*matrix, std.trans(matrix)*vec) 
	end -- 
	
	assert(row>column,"Impossible to reach a solution with givens as there are fewer equations than unknowns") 
end

std.solve=solve
