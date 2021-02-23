local std <const> =std



local function toarray(Container, Arr)

	--If the entry is a matrix then it returns the elements in a row-order sequence
	--If the entry is a 1D table then it is converted to vector
	
	if(Arr==nil) then
		Arr=std.Array.new(0)
	end

	for k, v in pairs(Container) do
		
		local typ=type(v)
		
		if(typ=="number" or typ=="string" or typ=="Complex") then
			Arr:push_back(v)
		else
			toarray(v, Arr)
		end
		
	end

	return Arr

end




std.toarray=toarray



-- Author:	Gokhan Bingol (gbingol@sciencesuit.org)
-- License: Subject to end-user license agreement conditions available at www.sciencesuit.org

