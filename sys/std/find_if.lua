local std <const> =std

local function find_if(Container, func)
    
	--Container: an iteratable container
	--func: a Unary Predicate (a function that takes a single value and return true or false)

	--Note that find_if returns the positions, whereas search_if returns the values satisfying the condition imposed by function func

	assert(Container ~= nil, "An iteratable container must be provided.")
	
	assert(type(func) == "function", "A Unary Predicate function, such as 'function(x) return x>5 end' must be provided")

	local retTable = {}
	local IsFound = false

	local NEntries=0

	for key, value in pairs(Container) do

	        NEntries=NEntries+1

	        if (func(value)) then
			table.insert(retTable, key)
			IsFound = true
	        end

	end
    
	if (IsFound) then 
		return retTable
	end 
    
    
    return nil

end



std.find_if = find_if



-- Author:	Gokhan Bingol (gbingol@sciencesuit.org)
-- License: Subject to end-user license agreement conditions available at www.sciencesuit.org
