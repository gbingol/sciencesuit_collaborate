-- Author:	Gokhan Bingol (gbingol@sciencesuit.org)
-- License: Subject to end-user license agreement conditions available at www.sciencesuit.org

local std <const> =std

local function LINSPACE(a,b,n)

	assert(type(a)=="number","First arg (a) must be number." ) 
	
	assert(type(b)=="number","Second arg (b) must be number." ) 
	
	assert(math.type(n)=="integer" and n>1,"Third arg (n) must be integer greater than 1." ) 

	assert(b>a, "Second arg (b) must be greater than the first argument (a).") 

	local dx=(b-a)/(n-1) 


	local retVec=std.Vector.new(n)
	local A=a

	for i=1,n do
		retVec[i]=A
		A=A+dx
	end


    return retVec
end


local function linspace(...)
	local args=table.pack(...)
	
	if(#args==1 and type(args[1])=="table") then
		
		local a, b, n=nil, nil, nil
		local NTblArgs=0
		
		for k,v in pairs(args[1]) do
			k=string.lower(k)
			if(k=="a") then a=v
			elseif(k=="b") then b=v
			elseif(k=="n") then n=v
			else 
				error("Usage: {a=, b=, n=}", std.const.ERRORLEVEL) 
			end
			
			NTblArgs=NTblArgs+1 
		
		end
		
		assert(NTblArgs==3, "Usage: {a=, b=, n=}") 
		
		return LINSPACE(a,b,n)
	

	elseif(#args==3) then
		return LINSPACE(args[1], args[2], args[3])
	
	else
		error("Usage: {a=, b=, n=} or (a=, b=, n=)", std.const.ERRORLEVEL)
	end

end



std.linspace=linspace
