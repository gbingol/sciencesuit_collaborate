-- Author:	Gokhan Bingol (gbingol@sciencesuit.org)
-- License: Subject to end-user license agreement conditions available at www.sciencesuit.org


local function totable(elem) 

	--Converts a matrix, vector, array or a Range to a 1D or 2D Lua Table

	if(type(elem)=="Matrix" or type(elem)=="Range") then
		local r,c=std.size(elem)
		local baset={}
		for i=1,r do
			baset[i]={}
			for j=1,c do
				baset[i][j]=elem(i,j)
			end
		end
		
		return baset
	end

    
	if(type(elem)=="Vector" or type(elem)=="Array") then
		local dim=std.size(elem)
		local t={}
		for i=1,dim do
			t[i]=elem(i)
		end
		
		return t
	end

end

std.totable=totable
