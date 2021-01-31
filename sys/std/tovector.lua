local std <const> =std



local function tovector(Container, retVec)

	--If the entry is a matrix then it returns the elements in a row-order sequence
	--If the entry is a 1D table then it is converted to vector
	if(retVec==nil) then
		retVec=std.Vector.new(0)
		retVec:reserve(1000)
	end
	
	local Nonnumeric=0
	local numeric=0

	for k, v in pairs(Container) do
		
		if(type(v)=="table") then
			retVec=tovector(v,retVec)
		end
		
		local num=tonumber(v)
		if(num~=nil) then 
			retVec:push_back(num)
			numeric=numeric+1
		else
			Nonnumeric=Nonnumeric+1
		end
		
	end

	if(numeric==0) then
		return nil
	end
	

	return retVec, Nonnumeric

end



std.tovector=tovector



-- Author:	Gokhan Bingol (gbingol@sciencesuit.org)
-- License: Subject to end-user license agreement conditions available at www.sciencesuit.org
