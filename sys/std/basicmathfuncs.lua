local std <const> =std

local function ApplytoTypes(Entry,func,... )

	--func : a function from Lua math library taking a single argument
	-- ... : Possible second, third etc. arguments of func
	--Container: a number, Lua Table or an iteratable container
	
	local func_args=table.pack(...)

	if(type(Entry)=="number") then
		return func(Entry,table.unpack(func_args))
	end

	

	local retEntry=nil
	
	if (std.util.isiteratable(Entry) and std.util.iscloneable(Entry)) then
		retEntry=Entry:clone()
	else
		retEntry={}
		
		for k,v in pairs(Entry) do
			retEntry[k]=v
		end
		
	end
	  
	
	std.for_each(retEntry,func, table.unpack(func_args))



	return retEntry
end






--Lua Math library

std.abs=function(entry) 

	if(type(entry)=="Vector" or type(entry)=="Matrix"  or type(entry)=="Array") then
		local retEntry=entry:clone()

		retEntry:abs()
		
		return retEntry
	
	elseif(type(entry)=="Complex") then
		return entry:abs()
	
	elseif(type(entry)=="number") then
		return math.abs(entry)
	end
	
	return  ApplytoTypes(entry, std.abs) 
end





std.acos=function(entry) 
	
	if(type(entry)=="Vector" or type(entry)=="Matrix"  or type(entry)=="Array") then
		local retEntry=entry:clone()

		retEntry:acos()
		
		return retEntry
		
	elseif(type(entry)=="Complex") then
		return entry:acos()
		
	elseif(type(entry)=="number") then
		return math.acos(entry)
	end
	
	
	return  ApplytoTypes(entry, std.acos) 
end





std.asin=function(entry) 
	
	if(type(entry)=="Vector" or type(entry)=="Matrix"  or type(entry)=="Array") then
		local retEntry=entry:clone()
		retEntry:asin()
		
		return retEntry
		
	elseif(type(entry)=="Complex") then
		return entry:asin()
		
	elseif(type(entry)=="number") then
		return math.asin(entry)
	end
	
	return  ApplytoTypes(entry,std.asin) 
end





std.atan=function(entry) 
	
	if(type(entry)=="Vector" or type(entry)=="Matrix"  or type(entry)=="Array") then
		local retEntry=entry:clone()

		retEntry:atan()
		
		return retEntry
	
	elseif(type(entry)=="Complex") then
		return entry:atan()
		
	elseif(type(entry)=="number") then
		return math.atan(entry)
	end
	
	return  ApplytoTypes(entry,std.atan) 
end




std.ceil=function(entry) 
		
	if(type(entry)=="Vector" or type(entry)=="Matrix"  or type(entry)=="Array") then
		local retEntry=entry:clone()

		retEntry:ceil()
		
		return retEntry
		
	elseif(type(entry)=="Complex") then
		error("std.ceil does not support complex numbers", std.const.ERRORLEVEL)
		
	elseif(type(entry)=="number") then
		return math.ceil(entry)
	end
	
	return  ApplytoTypes(entry,std.ceil) 
end




std.cos=function(entry) 
	
	if(type(entry)=="Vector" or type(entry)=="Matrix"  or type(entry)=="Array") then
		local retEntry=entry:clone()

		retEntry:cos()
		
		return retEntry
	
	elseif(type(entry)=="Complex") then
		return entry:cos()
		
	elseif(type(entry)=="number") then
		return math.cos(entry)
	end
	
	return  ApplytoTypes(entry, std.cos) end




std.cosh=function(entry) 
	
	if(type(entry)=="Vector" or type(entry)=="Matrix"  or type(entry)=="Array") then
		local retEntry=entry:clone()

		retEntry:cosh()
		
		return retEntry
	
	elseif(type(entry)=="Complex") then
		return entry:cosh()
		
	elseif(type(entry)=="number") then
		return math.cosh(entry)
	end
	
	return  ApplytoTypes(entry,std.cosh) 
end




std.exp=function(entry)  
	if(type(entry)=="Vector" or type(entry)=="Matrix"  or type(entry)=="Array") then
		local retEntry=entry:clone()

		retEntry:exp()
		
		return retEntry
	
	elseif(type(entry)=="Complex") then
		return entry:exp()
	
	elseif(type(entry)=="number") then
		return math.exp(entry)
	end

	return  ApplytoTypes(entry,std.exp)  
end





std.floor=function(entry) 
	
	if(type(entry)=="Vector" or type(entry)=="Matrix"  or type(entry)=="Array") then
		local retEntry=entry:clone()

		retEntry:floor()
		
		return retEntry
	
	elseif(type(entry)=="Complex") then
		error("std.floor does not support complex numbers", std.const.ERRORLEVEL)
		
	elseif(type(entry)=="number") then
		return math.floor(entry)
	end
	
	return  ApplytoTypes(entry, std.floor) 
end





std.log=function(entry, base) 
		
	if(type(entry)=="Vector" or type(entry)=="Matrix"  or type(entry)=="Array") then
		local retEntry=entry:clone()
		
		if(base==nil) then
			retEntry:log()
		else
			retEntry:log(base)
		end

		return retEntry
	
	elseif(type(entry)=="Complex") then
		if(base == nil) then
			return entry:log()
		end
	
		return entry:log(base)
		
	elseif(type(entry)=="number") then
		if(base==nil) then
			base=math.exp(1)
		end
	
		return math.log(entry, base)
	end
	

	base=base or math.exp(1)	
	
	return  ApplytoTypes(entry, std.log, base) 
end






std.ln=function(entry) 
	return  std.log(entry, math.exp(1)) 
end






std.log10=function(entry) 
	return  std.log(entry, 10.0)
end





std.pow=function(entry, exponent)  

	assert(exponent ~= nil, "Second arg cannot be nil")

	if(type(entry)=="Vector" or type(entry)=="Matrix"  or type(entry)=="Array") then
		local retEntry=entry:clone()

		retEntry:pow(exponent)
		
		return retEntry
	
	elseif(type(entry)=="Complex") then
		return entry:pow(exponent)
		
	elseif(type(entry)=="number") then
		return math.pow(entry, exponent)
	end


	
	return ApplytoTypes(entry, std.pow, exponent) 
end






std.sqrt=function(entry) 
	if(type(entry)=="Vector" or type(entry)=="Matrix"  or type(entry)=="Array") then
		local retEntry=entry:clone()

		retEntry:sqrt()
		
		return retEntry
	
	elseif(type(entry)=="Complex") then
		return entry:sqrt()
		
	elseif(type(entry)=="number") then
		return math.sqrt(entry)
	end

	return  ApplytoTypes(entry, std.sqrt)   
end





std.sin=function(entry) 
	
	if(type(entry)=="Vector" or type(entry)=="Matrix"  or type(entry)=="Array") then
		local retEntry=entry:clone()

		retEntry:sin()
		
		return retEntry
	
	elseif(type(entry)=="Complex") then
		return entry:sin()
		
	elseif(type(entry)=="number") then
		return math.sin(entry)
	end
	
	return  ApplytoTypes(entry, std.sin) 
end





std.sinh=function(entry) 
		
	if(type(entry)=="Vector" or type(entry)=="Matrix"  or type(entry)=="Array") then
		local retEntry=entry:clone()

		retEntry:sinh()
		
		return retEntry
	
	elseif(type(entry)=="Complex") then
		return entry:sinh()
		
	elseif(type(entry)=="number") then
		return math.sinh(entry)
	end
	
	return  ApplytoTypes(entry, std.sinh) 
end




std.tan=function(entry) 
	
	if(type(entry)=="Vector" or type(entry)=="Matrix"  or type(entry)=="Array") then
		local retEntry=entry:clone()

		retEntry:tan()
		
		return retEntry
	
	elseif(type(entry)=="Complex") then
		return entry:tan()
	
	elseif(type(entry)=="number") then
		return math.tan(entry)
	end
	
	return  ApplytoTypes(entry, std.tan) 
end





std.tanh=function(entry) 

	if(type(entry)=="Vector" or type(entry)=="Matrix"  or type(entry)=="Array") then
		local retEntry=entry:clone()

		retEntry:tanh()
		
		return retEntry
	
	elseif(type(entry)=="Complex") then
		return entry:tanh()
	
	elseif(type(entry)=="number") then
		return math.tanh(entry)
	end
	
	return  ApplytoTypes(entry, std.tanh) 
end







--SYSTEM functions

std.beta=function(entry, y) 
	return  ApplytoTypes(entry, SYSTEM.beta, y) 
end


std.gamma=function(entry) return  
	ApplytoTypes(entry, SYSTEM.gamma) 
end


std.gammaln=function(entry) 
	return  ApplytoTypes(entry, SYSTEM.gammaln) 
end
	
	
std.besselj=function(entry, order) 
	return ApplytoTypes(entry, SYSTEM.besselj, order) 
end





-- Author:	Gokhan Bingol (gbingol@sciencesuit.org)
-- License: Subject to end-user license agreement conditions available at www.sciencesuit.org
