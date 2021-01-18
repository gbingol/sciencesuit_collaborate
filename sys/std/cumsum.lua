-- Author:	Gokhan Bingol (gbingol@sciencesuit.org)
-- License: Subject to end-user license agreement conditions available at www.sciencesuit.org

local std <const> =std

local function cumsum(Container, axes)
	
	
	if(type(Container)=="Vector" or type(Container)=="Array") then
		Container=Container:clone()
		
		Container:cumsum()
		
		return Container
		
	elseif(type(Container)=="Matrix") then
		Container=Container:clone()
		
		Container:cumsum(axes)
		
		return Container
	end
		

	local sum=0
	local retElem={}
	
	local i=1
	for key, value in pairs(Container) do
		if(math.type(key)=="integer" and type(value)=="number") then
			sum=sum + value
			
			retElem[i]=sum
			
			i=i+1
		end
	end
		
		
	return retElem

end



std.cumsum=cumsum
