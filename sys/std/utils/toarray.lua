-- Author:	Gokhan Bingol (gbingol@sciencesuit.org)
-- License: Subject to end-user license agreement conditions available at www.sciencesuit.org


local function toarray(Container)

	--If the entry is a matrix then it returns the elements in a row-order sequence
	--If the entry is a 1D table then it is converted to vector
	
	local retArr=Array.new(0)
	local Num, NonNum=0, 0

	for k, v in pairs(Container) do
		
		local typ=type(v)
		
		if(typ=="number") then 
			retArr:push_back(v)
			Num=Num+1
			
		elseif(typ=="string") then
			local val=tonumber(v)
			
			if(val~=nil) then
				retArr:push_back(val)
				Num=Num+1
			else
				retArr:push_back(v)
				NonNum=NonNum+1
			end
		else
			error("ERROR: Unknown type, supported types are string and number")
		end
		
	end

	return retArr, Num, NonNum

end


std.toarray=toarray
