-- Author:	Gokhan Bingol (gbingol@sciencesuit.org)
-- License: Subject to end-user license agreement conditions available at www.sciencesuit.org


local std <const> =std

local function EVAL(v,x)
	local dim=#v
	local val=v(1)

	for i=2,dim do
		val=val*x+v(i)
	end
	
	return val
end


local function Compute(v, Entry)

	--Using Horner's algorithm for polynomial evaluation
	--the Polynom is in the form of:  a*x^n+b*x^(n-1)....+x0

	assert(type(v)=="Vector","ERROR: First argument must be a vector containing coefficients") 
	assert(type(Entry)=="number" or type(Entry)=="Vector","ERROR: Second argument must be either a number or a Vector") 

	

	if(type(Entry)=="number")  then 
		return EVAL(v,Entry) 
	
	
	elseif(type(Entry)=="Vector") then
		local dim=#Entry
		local retVec=Vector.new(dim)
		for i=1,dim do
			retVec[i]=EVAL(v,Entry(i))
		end
		
		return retVec
	end
end


local function polyval(...)
	
	local arg=table.pack(...)

	assert(#arg==2 or type(arg[1])=="table", "ERROR: At least 2 arguments or a single argument of type table must be supplied")
	
	
	if(#arg==1 and type(arg[1])=="table") then
		
		local v1, v2=nil, nil
		local NTblArgs=0

		for key,value in pairs(arg[1]) do
			if(key==1) then v1=value
			elseif(key==2) then v2=value
			else 
				error("ERROR: Signature: {v1, arg}", ERRORLEVEL)
			end

			NTblArgs=NTblArgs+1

		end

		assert(NTblArgs==2,"Usage: {Vector, Vector} or {Vector, number}")

		return Compute(v1,v2)
	
	elseif(#arg==2) then
		return Compute(arg[1],arg[2])

	end

end

std.polyval=polyval
