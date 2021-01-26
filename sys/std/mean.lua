local std <const> =std


local function mean(...)
	--Finds the mean value of an iteratable and addable container
	local args=table.pack(...)
	local nargs=#args
	
	assert(nargs>0, "At least 1 argument must be supplied")
	
	
	if(type(args[1])=="table" and args[1][1]=="Matrix") then
		local tbl=args[1]
		
		local Container=tbl[1]
		
		local axes=tbl["axes"]
		
		if(axes==nil) then
			return Container:sum()/#Container
		else
		
			assert(math.type(axes)=="integer" and (axes==0 or axes==1), "Axes must be an integer either 0 or 1")
			
			local vec= Container:sum(axes)
			
			if(axes==0) then 
				return vec/Container:nrows()
			else
				return vec/Container:ncols()
			end
		end
		
	end
		
		
	--Argument is not table	
	local Container=args[1]
	
	if(type(Container)=="Vector") then
			
		local n=args[2] or 1

		if(n==1) then
			return Container:sum()/#Container
		else
			return Container:sum(n)/#Container --exponent
		end
	

	elseif(type(Container)=="Matrix") then
		if(nargs==1) then
			return Container:sum()/#Container
		else
			local axes=args[2]
			
			assert(math.type(axes)=="integer" and (axes==0 or axes==1), "Axes must be an integer either 0 or 1")

			local vec=Container:sum(axes) 
			
			if(axes==0) then 
				return vec/Container:nrows()
			else
				return vec/Container:ncols()
			end
		end


	elseif(type(Container)=="Array") then
	
		--elemconsid is the count of numbers in the array
		local total, elemconsid=std.sum(Container)
		
		if(elemconsid ~= 0) then
			return total/elemconsid, elemconsid
		end
		
		return nil

	end

	
	
	local n=args[2] or 1
	
	--generalized
	local sum, nelem=std.accumulate(Container, 0, function(x) return x^n end)

	return sum/nelem
	
end



std.aver=mean
std.mean=mean



-- Author:	Gokhan Bingol (gbingol@sciencesuit.org)
-- License: Subject to end-user license agreement conditions available at www.sciencesuit.org
