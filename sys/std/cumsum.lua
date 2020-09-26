-- Author:	Gokhan Bingol (gbingol@sciencesuit.org)
-- License: Subject to end-user license agreement conditions available at www.sciencesuit.org

local std <const> =std

local function cumsum(Container, axes)
	
	local retElem=nil

	if(type(Container)=="Vector") then
		local retElem=Container:clone()
		
		retElem:cumsum()
		
		return retElem
		
	elseif(type(Container)=="Matrix") then
		local retElem=Container:clone()
		
		retElem:cumsum(axes)
		
		return retElem
	end
		

	local sum=0
	retElem={}
	
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
