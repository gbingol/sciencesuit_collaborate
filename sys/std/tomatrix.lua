-- Author:	Gokhan Bingol (gbingol@sciencesuit.org)
-- License: Subject to end-user license agreement conditions available at www.sciencesuit.org

--Converts Lua Table, Array, Range and Vector to Matrix

local std <const> =std


local function Table1DToMatrix(tbl, row, col)

	local N=#tbl
	
	assert(N==row*col," Requested matrix has a larger/smaller size than the table.", std.const.ERRORLEVEL) 
	
	local retMat=std.Matrix.new(row,col)
	local r,c=1,1
	
	for i=1,N do
		assert(type(tbl[i])=="number","Table must contain only numeric entries") 
		
		retMat[r][c]=tbl[i]
		
		c=c+1
		
		if(c>col) then 
			c=1 
			r=r+1 
		end
	end
	
	return retMat
	
end--function


local function Table2DtoMatrix(tbl)
	local row=#tbl
	local col=#tbl[1]
	local mat=std.Matrix.new(row,col)
	for i=1,row do
		assert(type(tbl[i])=="table","Table is not a 2D table")
	
		if(i<row) then
			assert(#tbl[i]==#tbl[i+1],"The sizes of the nested tables must be equal.")
		end
		
		for j=1,col do
			local val=tbl[i][j]
			assert(type(val)=="number","The elements of 2D table must be of type number.")
			
			mat[i][j]= val
		end
		
	end
	
	return mat
end
	

local function VectorToMatrix(elem, row, col)
	
	assert(#elem==row*col,"Requested matrix has a larger size than the vector" ) 
	
	retMat=std.Matrix.new(row,col)
	k=0
	for i=1,row do
		for j=1,col do
			k=k+1
			retMat[i][j]=elem(k)
		end
	end
	
	return retMat	
end



local function RangeToMatrix(rng, row, col)
	local r,c=std.size(rng)
	
	assert(r==row and c==col,"Dimensions of the requested Matrix is larger than Range." ) 
	
	local retMat=std.Matrix.new(row,col)
	
	for i=1,r do
		for j=1,c do
			
			assert(type(rng(i,j))=="number","Selected range contains non-numeric entries" )  
			
			retMat[i][j]=rng(i,j)
		end
	end
	
	return retMat
end



local function tomatrix(elem, row, col)
	
	local function CheckBounds()
		assert(row>1 and col>1,"Number of rows and columns must be greater than 1") 
	end
	
	if(type(elem)=="Vector") then
		CheckBounds()
		return VectorToMatrix(elem,row,col)

	elseif(type(elem)=="Array") then 
		CheckBounds()
		local v=tovector(elem)
		return VectorToMatrix(v,row,col)

	elseif(type(elem)=="Range") then 
		CheckBounds()
		return RangeToMatrix(elem, row, col)
		
	elseif(type(elem)=="table") then
		if(row==nil and col==nil) then
			return Table2DtoMatrix(elem)
		else
			CheckBounds()
			return Table1DToMatrix(elem, row, col)
		end
		
	else
		error("First arg can be Vector, Array, Range or Lua Table.", std.const.ERRORLEVEL)
	end


end

std.tomatrix=tomatrix
