local std <const> =std




local function totable(container, Force1DTable) 

	--Converts a matrix, vector, array or a Range to a 1D or 2D Lua Table
	
	
	if(Force1DTable==nil) then
		Force1DTable=false
	end

	assert(type(Force1DTable)=="boolean", "Second arg must be boolean")

	if(Force1DTable==false and (type(container)=="Matrix" or type(container)=="Range")) then
		local r,c=std.size(container)
		local baset={}
		
		for i=1,r do
			baset[i]={}
			
			for j=1,c do
				baset[i][j]=container(i,j)
			end
		end
		
		return baset
	end

    
	local i=1
	local retTable={}
	for key, value in pairs(container) do
		retTable[i]=value
		
		i=i+1
	end

	return retTable

end



std.util.totable=totable



-- Author:	Gokhan Bingol (gbingol@sciencesuit.org)
-- License: Subject to end-user license agreement conditions available at www.sciencesuit.org
