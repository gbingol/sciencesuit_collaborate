-- Author:	Gokhan Bingol (gbingol@sciencesuit.org)
-- License: Subject to end-user license agreement conditions available at www.sciencesuit.org

local std <const> =std

local function sum(...)
	--Finds the sum of a vector, matrix or range
	
	local args=table.pack(...)
	local nargs=#args
	
	assert(nargs>0, "At least 1 argument must be supplied")
	
	
	if(type(args[1])=="table" and type(args[1][1])=="Matrix") then
		local tbl=args[1]
		
		local Container=tbl[1]
		
		local axes=tbl["axes"]
		
		if(axes==nil) then
			return Container:sum()
		else
			return Container:sum(axes)
		end
		
	end
		
		
	
		
	local Container=args[1]
	
	if(type(Container)=="Vector") then
			
		local n=args[2] or 1

		if(n==1) then
			return Container:sum()
		else
			return Container:sum(n) --exponent
		end
	

	elseif(type(Container)=="Matrix") then
		if(nargs==1) then
			return Container:sum()
		else
			return Container:sum(args[2]) --axes
		end
	end


	--Generalized for other containers (slower)
	
	local n=args[2] or 1
		
	local total, NElem=std.accumulate( Container,0, function(x) return x^n end )


	return total
end


std.sum=sum