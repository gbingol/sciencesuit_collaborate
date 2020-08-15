-- Author:	Gokhan Bingol (gbingol@sciencesuit.org)
-- License: Subject to end-user license agreement conditions available at www.sciencesuit.org


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

std.abs=function(entry) return  ApplytoTypes(entry, math.abs) end

std.acos=function(entry) return  ApplytoTypes(entry, math.acos) end

std.asin=function(entry) return  ApplytoTypes(entry, math.asin) end

std.atan=function(entry) return  ApplytoTypes(entry, math.atan) end

std.ceil=function(entry) return  ApplytoTypes(entry, math.ceil) end

std.cos=function(entry) return  ApplytoTypes(entry,math.cos) end

std.cosh=function(entry) return  ApplytoTypes(entry,math.cosh) end

std.exp=function(entry) return  ApplytoTypes(entry,math.exp) end

std.floor=function(entry) return  ApplytoTypes(entry,math.floor) end

std.log=function(entry, base) 
	base=base or math.exp(1)	
	
	return  ApplytoTypes(entry,math.log, base) 
end

std.ln=function(entry) return  ApplytoTypes(entry,math.log) end

std.log10=function(entry) return  ApplytoTypes(entry,math.log10) end

std.sqrt=function(entry) return  ApplytoTypes(entry,math.sqrt) end

std.sin=function(entry) return  ApplytoTypes(entry,math.sin) end

std.sinh=function(entry) return  ApplytoTypes(entry,math.sinh) end

std.tan=function(entry) return  ApplytoTypes(entry,math.tan) end

std.tanh=function(entry) return  ApplytoTypes(entry,math.tanh) end

std.pow=function(entry,power) return ApplytoTypes(entry, math.pow,power) end



--SYSTEM functions

std.beta=function(entry, y) return  ApplytoTypes(entry, SYSTEM.beta, y) end
std.gamma=function(entry) return  ApplytoTypes(entry, SYSTEM.gamma) end
std.gammaln=function(entry) return  ApplytoTypes(entry, SYSTEM.gammaln) end
	
std.besselj=function(entry, order) return ApplytoTypes(entry, SYSTEM.besselj, order) end
