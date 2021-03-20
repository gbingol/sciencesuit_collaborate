local std <const> = std


local function polyfit(...)
	
	local arg=table.pack(...)
	
	if(#arg==1  and type(arg[1])=="table") then
		
		local x, y,n, intercept=nil, nil, nil, nil
		local NTblArgs=0

		for k,v in pairs(arg[1]) do
			
			local key=string.lower(k)
			
			if(key=="x") then x=v
			elseif(key=="y") then y=v
			elseif(key=="n") then n=v
			elseif(key=="intercept") then intercept=v
			
			else 
				error("Usage: {x=, y=, n=, [intercept=]}", std.const.ERRORLEVEL)
			end

			NTblArgs=NTblArgs+1

		end


		
		assert(NTblArgs>0, "Usage: {x=, y=, n=, [intercept=]}")

		if(intercept==nil) then
			return SYSTEM.polyfit(x,y,n)
		
		elseif(intercept~=nil) then
			return SYSTEM.polyfit(x,y,n,intercept)

		end
		
	
	
	elseif (#arg==3) then
		return SYSTEM.polyfit(arg[1],arg[2],arg[3])

	elseif (#arg==4) then
		return SYSTEM.polyfit(arg[1],arg[2],arg[3], arg[4])
	
	end

end




std.polyfit=polyfit
	
	


-- Author:	Gokhan Bingol (gbingol@sciencesuit.org)
-- License: Subject to end-user license agreement conditions available at www.sciencesuit.org