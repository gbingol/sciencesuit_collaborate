local std <const> =std

local function ApplytoTypes(Entry,func,... )

	--func : a function from Lua math library taking a single argument
	-- ... : Possible second, third etc. arguments of func
	--Container: a number, Lua Table or an iteratable container
	
	local func_args=table.pack(...)

	if(type(Entry)=="number") then
		return func(Entry,table.unpack(func_args))
	end

	local m = getmetatable(Entry)
	local n = (m and m["__pairs"] and m["clone"])

	local retEntry=nil
	
	if n then
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
	end
	
	return  ApplytoTypes(entry, math.abs) 
end





std.acos=function(entry) 
	
	if(type(entry)=="Vector" or type(entry)=="Matrix"  or type(entry)=="Array") then
		local retEntry=entry:clone()

		retEntry:acos()
		
		return retEntry
		
	elseif(type(entry)=="Complex") then
		return entry:acos()
	end
	
	
	return  ApplytoTypes(entry, math.acos) 
end





std.asin=function(entry) 
	
	if(type(entry)=="Vector" or type(entry)=="Matrix"  or type(entry)=="Array") then
		local retEntry=entry:clone()
		retEntry:asin()
		
		return retEntry
		
	elseif(type(entry)=="Complex") then
		return entry:asin()
	end
	
	return  ApplytoTypes(entry, math.asin) 
end





std.atan=function(entry) 
	
	if(type(entry)=="Vector" or type(entry)=="Matrix"  or type(entry)=="Array") then
		local retEntry=entry:clone()

		retEntry:atan()
		
		return retEntry
	
	elseif(type(entry)=="Complex") then
		return entry:atan()
	end
	
	return  ApplytoTypes(entry, math.atan) 
end




std.ceil=function(entry) 
		
	if(type(entry)=="Vector" or type(entry)=="Matrix"  or type(entry)=="Array") then
		local retEntry=entry:clone()

		retEntry:ceil()
		
		return retEntry
		
	elseif(type(entry)=="Complex") then
		error("std.ceil does not support complex numbers", std.const.ERRORLEVEL)
	end
	
	return  ApplytoTypes(entry, math.ceil) 
end




std.cos=function(entry) 
	
	if(type(entry)=="Vector" or type(entry)=="Matrix"  or type(entry)=="Array") then
		local retEntry=entry:clone()

		retEntry:cos()
		
		return retEntry
	
	elseif(type(entry)=="Complex") then
		return entry:cos()
	end
	
	return  ApplytoTypes(entry,math.cos) end




std.cosh=function(entry) 
	
	if(type(entry)=="Vector" or type(entry)=="Matrix"  or type(entry)=="Array") then
		local retEntry=entry:clone()

		retEntry:cosh()
		
		return retEntry
	
	elseif(type(entry)=="Complex") then
		return entry:cosh()
	end
	
	return  ApplytoTypes(entry,math.cosh) 
end




std.exp=function(entry)  
	if(type(entry)=="Vector" or type(entry)=="Matrix"  or type(entry)=="Array") then
		local retEntry=entry:clone()

		retEntry:exp()
		
		return retEntry
	
	elseif(type(entry)=="Complex") then
		return entry:exp()
	end

	return  ApplytoTypes(entry,math.exp)  
end





std.floor=function(entry) 
	
	if(type(entry)=="Vector" or type(entry)=="Matrix"  or type(entry)=="Array") then
		local retEntry=entry:clone()

		retEntry:floor()
		
		return retEntry
	
	elseif(type(entry)=="Complex") then
		error("std.floor does not support complex numbers", std.const.ERRORLEVEL)
	end
	
	return  ApplytoTypes(entry,math.floor) 
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
	end
	

	base=base or math.exp(1)	
	
	return  ApplytoTypes(entry,math.log, base) 
end






std.ln=function(entry) 
	return  std.log(entry,math.exp(1)) 
end






std.log10=function(entry) 
	return  std.log(entry,10.0)
end





std.pow=function(entry, power)  

	if(type(entry)=="Vector" or type(entry)=="Matrix"  or type(entry)=="Array") then
		local retEntry=entry:clone()

		retEntry:pow(power)
		
		return retEntry
	
	elseif(type(entry)=="Complex") then
		return entry:pow(power)
	end


	
	return ApplytoTypes(entry, math.pow, power) 
end






std.sqrt=function(entry) 
	if(type(entry)=="Vector" or type(entry)=="Matrix"  or type(entry)=="Array") then
		local retEntry=entry:clone()

		retEntry:sqrt()
		
		return retEntry
	
	elseif(type(entry)=="Complex") then
		return entry:sqrt()
	end

	return  ApplytoTypes(entry,math.sqrt)   
end





std.sin=function(entry) 
	
	if(type(entry)=="Vector" or type(entry)=="Matrix"  or type(entry)=="Array") then
		local retEntry=entry:clone()

		retEntry:sin()
		
		return retEntry
	
	elseif(type(entry)=="Complex") then
		return entry:sin()
	end
	
	return  ApplytoTypes(entry,math.sin) 
end





std.sinh=function(entry) 
		
	if(type(entry)=="Vector" or type(entry)=="Matrix"  or type(entry)=="Array") then
		local retEntry=entry:clone()

		retEntry:sinh()
		
		return retEntry
	
	elseif(type(entry)=="Complex") then
		return entry:sinh()
	end
	
	return  ApplytoTypes(entry,math.sinh) 
end




std.tan=function(entry) 
	
	if(type(entry)=="Vector" or type(entry)=="Matrix"  or type(entry)=="Array") then
		local retEntry=entry:clone()

		retEntry:tan()
		
		return retEntry
	
	elseif(type(entry)=="Complex") then
		return entry:tan()
	end
	
	return  ApplytoTypes(entry,math.tan) 
end





std.tanh=function(entry) 

	if(type(entry)=="Vector" or type(entry)=="Matrix"  or type(entry)=="Array") then
		local retEntry=entry:clone()

		retEntry:tanh()
		
		return retEntry
	
	elseif(type(entry)=="Complex") then
		return entry:tanh()
	end
	
	return  ApplytoTypes(entry,math.tanh) 
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
