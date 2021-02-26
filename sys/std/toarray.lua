local std <const> =std


local function stringtovariant(str)
	local realNum=tonumber(str)
	
	if(realNum ~=nil) then
		return realNum
	end

	local success, complexNum=pcall(std.Complex.new, str)
	
	if(success) then
		return complexNum
	end

	return str
end



local function toarray(Container, StrToType, Arr)

	--If the entry is a matrix then it returns the elements in a row-order sequence
	--If the entry is a 1D table then it is converted to vector
	
	--StrToType: By default it is true and if true, then string entries will be attempted to convert to real or complex number type
	
	assert(std.util.isiteratable(Container) == true, "Iteratable container expected")
	
	if(Arr==nil) then
		Arr=std.Array.new(0)
	end

	if(StrToType == nil) then
		StrToType=true
	end

	assert(type(StrToType)=="boolean", "Second arg must be boolean")

	for k, v in pairs(Container) do
		
		local typ=type(v)
		
		--basic types
		if(typ=="number" or typ=="string" or typ=="Complex") then
			
			--can we convert the string to number of complex number
			if(typ == "string" and StrToType == true) then
				Arr:push_back(stringtovariant(v))
			
			--push as is
			else
				Arr:push_back(v)
			end

		--an iteratable container, i.e. matrix, vector, table...
		else
			toarray(v, Arr)
		end
		
	end --for k, v


	return Arr
end




std.toarray=toarray



-- Author:	Gokhan Bingol (gbingol@sciencesuit.org)
-- License: Subject to end-user license agreement conditions available at www.sciencesuit.org

