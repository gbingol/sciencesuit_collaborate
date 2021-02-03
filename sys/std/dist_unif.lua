local std <const> =std


local function DUNIF(x, min, max)
	min=min or 0
	max=max or 1
	
	assert(type(min)=="number", "min must be number")
	assert(type(max)=="number", "max must be number")
	
	assert(min<max, "min < max expected")
	
	assert(type(x)=="number" or type(x)=="Vector" or type(x)=="Array", "Key x: number/Vector/Array")
	
	if(type(x)=="number") then
		if(x<min or x>max) then
			return 0.0
		else
			return 1/(max-min)
		end
	
	elseif(type(x)=="Vector" or type(x)=="Array") then
		local retCont= nil
		
		if(type(x)=="Array") then
			x=x:clone()
			x:keep_numbers()
			
			retCont=std.Array.new(#x)
		
		else
			retCont=std.Vector.new(#x)
		end
		
		
		for i=1, #x do
			retCont[i]=DUNIF(x(i),min, max)
		end
		
		
		return retCont
	end
	
end



local function dunif(...)
	local args=table.pack(...)
	
	if(#args==1 and type(args[1])=="table") then
		
		local x, min, max=nil, 0, 1
		
		for k,v in pairs(args[1]) do
			k=string.lower(k)
			
			if(k=="x") then x=v
			elseif(k=="min") then min=v
			elseif(k=="max") then max=v
			else 
				error("Usage: {x=, min=0, max=1}", std.const.ERRORLEVEL) 
			end
		end
		
		return DUNIF(x, min, max)
	
	elseif(#args==1 ) then
		return DUNIF(args[1],0, 1)
	
	elseif(#args==3 ) then
		return DUNIF(args[1], args[2], args[3])
	
	else
		error("Usage: dunif(x=, min=0, max=1) OR dunif{x=, min=0 , max=1}", std.const.ERRORLEVEL) 
	end

end








local function PUNIF(q, min, max)
	min=min or 0
	max=max or 1
	
	assert(type(min)=="number", "Key min must be number")
	assert(type(max)=="number", "Key max must be number")
	
	assert(min<max, "min must be < max")
	
	assert(type(q)=="number" or type(q)=="Vector" or type(q)=="Array", "Key q: number/Vector/Array")
	
	
	if(type(q)=="number") then
		if(q<=min) then
			return 0.0
		elseif (q>=max) then
			return 1.0
		else
			return (q-min)/(max-min)
		end
	
	
	elseif(type(q)=="Vector" or type(q)=="Array") then
		local retCont= nil
		
		if(type(q)=="Array") then
			q=q:clone()
			q:keep_numbers()
			
			retCont=std.Array.new(#q)
		
		else
			retCont=std.Vector.new(#q)
		end


		for i=1, #q do
			retCont[i]=PUNIF(q(i),min, max)
		end
		
		
		return retCont
	end
	
end




local function punif(...)
	local args=table.pack(...)
	
	if(#args==1 and type(args[1])=="table") then
		
		local q, min, max=nil, 0, 1
		
		for k,v in pairs(args[1]) do
			k=string.lower(k)
			
			if(k=="q") then q=v
			elseif(k=="min") then min=v
			elseif(k=="max") then max=v
			else 
				error("Usage: {q=, min=0, max=1}", std.const.ERRORLEVEL) 
			end
		end
		
		return PUNIF(q, min, max)
	
	elseif(#args==1) then
		return PUNIF(args[1],0, 1)
	
	elseif(#args==3 ) then
		return PUNIF(args[1], args[2], args[3])
	
	else
		error("Usage: punif(q, min=0, max=1) OR punif{q=, min=0 , max=1}", std.const.ERRORLEVEL) 
	end

end








local function QUNIF(p, min, max)
	min=min or 0
	max=max or 1
	
	assert(type(min)=="number", "Key min must be number")
	assert(type(max)=="number", "Key max must be number")
	
	assert(min<max, "min must be < max")
	
	assert(type(p)=="number" or type(p)=="Vector" or type(p)=="Array", "Key p (probability): number/Vector/Array.")
	
	
	if(type(p)=="number") then
		assert(p>=0 and p<=1, "Key p (probability) must be in [0,1]")
		
		return p*(max-min)+min
		
	elseif(type(p)=="Vector" or type(p)=="Array") then
		local retCont= nil
		
		if(type(p)=="Array") then
			p=p:clone()
			p:keep_numbers()
			
			retCont=std.Array.new(#p)
		
		else
			retCont=std.Vector.new(#p)
		end


		for i=1, #p do
			retCont[i]=QUNIF(p(i),min, max)
		end
		
		return retCont
		
	end
		
end




local function qunif(...)
	local args=table.pack(...)
	
	
	if(#args==1 and type(args[1])=="table") then
		
		local p, min, max=nil, 0, 1
		
		for k,v in pairs(args[1]) do
			k=string.lower(k)
			
			if(k=="p") then p=v
			elseif(k=="min") then min=v
			elseif(k=="max") then max=v
			else 
				error("Keys: {p=, min=0, max=1}", std.const.ERRORLEVEL) 
			end
		end
		
		return QUNIF(p, min, max)
	
	
	elseif(#args==1 ) then
		return QUNIF(args[1],0, 1)
	
	elseif(#args==3 ) then
		return QUNIF(args[1], args[2], args[3])
	
	else
		error("Usage: qunif(p, min=0, max=1) OR qunif{p=, min=0 , max=1}", std.const.ERRORLEVEL) 
	end

end






local function RUNIF(n, min, max)

	min=min or 0
	max=max or 1
	
	assert(math.type(n)=="integer" and n>=1,"Key n must be integer >=1")
	
	assert(type(min)=="number", "Key min must be number")
	assert(type(max)=="number", "Key max must be number")
	
	assert(min<max, "min must be < max")
	
	return SYSTEM.runif(n, min, max)
end
	


local function runif(...)
	local args=table.pack(...)
	
	if(#args==1 and type(args[1])=="table") then
		
		local n, min, max=nil, 0, 1
		
		for k,v in pairs(args[1]) do
			k=string.lower(k)
			
			if(k=="n") then n=v
			elseif(k=="min") then min=v
			elseif(k=="max") then max=v
			else 
				error("Usage: {n=, min=0, max=1}", std.const.ERRORLEVEL) 
			end
		end
		
		return RUNIF(n, min, max)
	
	elseif(#args==1 and type(args[1])=="number") then
		return RUNIF(args[1],0, 1)
	
	elseif(#args==3 and type(args[1])=="number" and type(args[2])=="number" and type(args[3])=="number") then
		return RUNIF(args[1], args[2], args[3])
	
	else
		error("Usage: runif(n, min=0, max=1) OR runif{n=, min=0 , max=1}", std.const.ERRORLEVEL) 
	end

end








std.dunif=dunif
std.punif=punif
std.qunif=qunif
std.runif=runif







-- Author:	Gokhan Bingol (gbingol@sciencesuit.org)
-- License: Subject to end-user license agreement conditions available at www.sciencesuit.org
