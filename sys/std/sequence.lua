-- Author:	Gokhan Bingol (gbingol@sciencesuit.org)
-- License: Subject to end-user license agreement conditions available at www.sciencesuit.org

local std <const> =std


local function seq(from, to, by)
	--Sequential increment from=from to=to by=by
	--returns a vector

	assert(type(from)=="number" and type(to)=="number","Args cannot be nil. Usage: seq(from, to, by)") 
	
	by=by or 1

	assert(type(by)=="number","ERROR: Third arg must be number")

	--seq(1,10) --> from<to
	if(from<to) then 
		
		assert(by>0,"Third arg must be positive") --seq(1,10, -1)
		assert((to-from)>by, "Third arg is too large for the requested range.") --seq(1,10,10)
	
	--seq(10,1) -->from>to
	elseif(from>to) then  
		
		assert(by<0,"Third arg must be negative") --seq(10,1, +1)
		assert((from+by)>to,"The absolute value of the third argument is too large for the requested range.") --seq(10,1,-10)
	end
	
	
	local NElem=std.floor(std.abs(to-from)/std.abs(by))+1
	local retVec=std.Vector.new(NElem)
		
	for i=1,NElem do
		retVec[i]=from+(i-1)*by
	end
	
	return retVec
end

local function sequence(...)
	local args=table.pack(...)
	
	--seq{from=f, to=t, by=b}
	if(#args==1 and type(args)=="table") then
		
		local from, to, by=nil, nil, nil
		local NTblArgs=0
		for k,v in pairs(args[1]) do
			assert(type(v)=="number","Values in the table must be numbers.")
			k=string.lower(k)
			
			if(k=="from") then from=v
			elseif(k=="to") then to=v
			elseif(k=="by") then by=v
			else 
				error("Keys: from, to and by.", std.const.ERRORLEVEL) 
			end
			NTblArgs=NTblArgs+1
		end
		
		assert(NTblArgs>0, "Usage: from, to and by" )

		return seq(from, to, by)
	
		
	elseif(#args==2 and type(args[1])=="number" and type(args[2])=="number") then
		return seq(args[1], args[2])
	
	elseif(#args==3 and type(args[1])=="number" and type(args[2])=="number" and type(args[3])=="number") then
		return seq(args[1], args[2], args[3])
	
	else
		error("Usage: sequence(from, to, by) OR sequence{from=, to=, by=}", std.const.ERRORLEVEL) 
	end

end

std.sequence=sequence	
