-- Author:	Gokhan Bingol (gbingol@sciencesuit.org)
-- License: Subject to end-user license agreement conditions available at www.sciencesuit.org

local function FindMode(Container)
	
	assert(type(Container)~="number" and type(Container)~="string", "ERROR: An iteratable container is required")

	local tbl={}
	local NElem=0

	for key, value in pairs(Container) do

		if(tbl[value]==nil) then 
			tbl[value]=1
			NElem=NElem+1
		else
			tbl[value]=tbl[value]+1
		end
		
	end


	if(std.sum(tbl)==NElem) then 
		return nil 
	end -- all elements are 1


	local retTab={}

	local max=next(tbl,nil)

	for key, value in pairs(tbl) do
		
		if(value>max) then
			max=value
			retTab={}
			table.insert( retTab,key )

		elseif(value==max) then
			table.insert( retTab,key )
		end
	end
		

	if(#retTab==1) then
		return retTab[1] -- there is only a single mode
	end


	return retTab -- there are multiple modes
	
end

std.mode=FindMode
