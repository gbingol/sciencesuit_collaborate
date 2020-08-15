-- Author:	Gokhan Bingol (gbingol@sciencesuit.org)
-- License: Subject to end-user license agreement conditions available at www.sciencesuit.org


local std <const> =std

local function logfit(...)
	
	local arg=table.pack(...)
	
	if(#arg==1  and type(arg[1])=="table") then
		
		local x, y=nil, nil
		local NTblArgs=0

		for k,v in pairs(arg[1]) do
			
			local key=string.lower(k)
			
			if(key=="x") then x=v
			elseif(key=="y") then y=v
			
			else 
				error("Usage: {x=, y= }", ERRORLEVEL)
			end

			NTblArgs=NTblArgs+1

		end
		
		assert(NTblArgs>0, "Usage: {x=, y= }")

		return SYSTEM.logfit(x,y)

		
		
	
	
	elseif (#arg==2) then
		return SYSTEM.logfit(arg[1],arg[2])

	else
		error("Usage: (x=, y= )", ERRORLEVEL)
	end

end


std.logfit=logfit
	
	
