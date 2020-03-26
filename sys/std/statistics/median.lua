-- Author:	Gokhan Bingol (gbingol@hotmail.com)
-- License: Subject to end-user license agreement conditions available at www.sciencesuit.org

local function ConvertToTable(container)
	
	local retTab={}
	for key, value in pairs(container) do
		table.insert(retTab,value)
	end

	return retTab
end


local function median(Container)
	
	assert(type(Container)~="number" and type(Container)~="string", "ERROR: An iteratable container is required")

	if(type(Container)=="Range") then
		Container=std.tovector(Container)
	end

	local m = getmetatable(Container)
	
	if(m) then
		local n=m["__pairs"]
		assert(n~=nil,"ERROR: The container is not iteratable")
	end
			
		
	  
	local elem=ConvertToTable(Container)
	
	table.sort(elem)

	local len=#elem
	
	if(len%2==1) then 
		return elem[math.ceil(len/2)]
	
	elseif(len%2==0) then
		
		return (elem[len/2]+elem[len/2+1])/2 
	end
     
end
		

std.median=median
