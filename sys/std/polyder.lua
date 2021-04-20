-- Author:	Gokhan Bingol (gbingol@sciencesuit.org)
-- License: Subject to end-user license agreement conditions available at www.sciencesuit.org

local std <const> =std




local function POLYDER(...)

	local arg=table.pack(...)
	
	if(#arg==1  and type(arg[1])=="table") then
		local polynom,  order=nil, 1
		
		local NTblArgs=0

		for k,v in pairs(arg[1]) do
			
			local key=string.lower(k)
			
			if(key=="p") then polynom=v
			elseif(key=="m") then order=v
			else 
				error("Usage: {p=, [m=1]}", std.const.ERRORLEVEL)
			end

			NTblArgs=NTblArgs + 1

		end
		
		
		std.util.assert(NTblArgs>=1, "Signature: {p=, [m=1]}")

		std.util.assert(type(polynom) =="Vector", "p must be Vector")
		
		std.util.assert(math.type(order) =="integer", "m must be integer") 
		
		local suc, res=pcall(SYSTEM.polyder, polynom, order)
		
		if(suc) then
			return res
		else
			error(res, std.const.ERRORLEVEL)
		end
		


	elseif (#arg==2 ) then
		if(type(arg[1]) ~="Vector") then error("First param must be Vector", std.const.ERRORLEVEL) end
		
		if(math.type(arg[2]) ~="integer") then error("2nd param must be integer", std.const.ERRORLEVEL) end
		
		
		local suc, res=pcall(SYSTEM.polyder, arg[1], arg[2])
		
		if(suc) then
			return res
		else
			error(res, std.const.ERRORLEVEL)
		end
		
	else
		error("std.polyder accepts either a single param as Lua table or 2 parameters", std.const.ERRORLEVEL)
	end
end
			
			
		
		

	
std.polyder =  POLYDER 