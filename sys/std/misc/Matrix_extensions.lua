-- Author:	Gokhan Bingol (gbingol@hotmail.com)
-- License: Subject to end-user license agreement conditions available at www.sciencesuit.org

local function IsEqual(m1,m2)
    
	local r1, c1=std.size(m1)
	local r2, c2=std.size(m2)
	
	if(r1~=r2 or c1~=c2) then 
		return false 
	end
    
	for i=1, r1 do
		for j=1, c1 do
			if(std.abs(m1(i,j)-m2(i,j)) > TOLERANCE ) then 
				return false 
			end
		end
	end
    
	
	return true
end

local function IsLessThan(m1,m2) --m1<m2
    
	local r1, c1=std.size(m1)
	local r2, c2=std.size(m2)

	if(r1~=r2 or c1~=c2) then 
		return false 
	end

	for i=1, r1 do
		for j=1, c1 do
			if(m1(i,j)>m2(i,j) ) then 
				return false 
			end
		end
	end
	
	return true
end

local function IsLessThanEqualTo(m1,m2) --m1<=m2
	local r1, c1=std.size(m1)
	local r2, c2=std.size(m2)

	if(r1~=r2 or c1~=c2) then 
		return false 
	end

	for i=1, r1 do
		for j=1, c1 do
			if(m1(i,j)>m2(i,j) ) then 
				return false 
			end
		end
	end
	
	return true
end


function Matrix.dotmul(self, m)
    --Matrix dot multiplication, such as m1.*m2, where m1 and m2 are matrix
    local r1,c1=std.size(self)
    local r2,c2=std.size(m)

	assert(r1==r2 and c1==c2,"ERROR:Dimensions of the matrix do not match.")
    
    local r,c=r1,c1

    local retMat=Matrix.new(r,c)
    for i=1,r do
        for j=1,c do
            retMat:set(i,j,self(i,j)*m(i,j))
        end
    end
    
    return retMat
end


local function Pairs(m)

	-- Iterator function takes the table and an index and returns the next index and associated value
	-- or nil to end iteration
  
	local function stateless_iter(m, k)
		local v
	  	-- Implement your own key,value selection logic in place of next
	  	k, v = next(m, k)
	  	if v then 
			return k,v 
		end
	end
  
	-- Return an iterator function, the table, starting point
	return stateless_iter, tbl, nil
  end
 


Matrix.__eq=IsEqual
Matrix.__lt=IsLessThan
Matrix.__le=IsLessThanEqualTo
