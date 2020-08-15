-- Author:	Gokhan Bingol (gbingol@sciencesuit.org)
-- License: Subject to end-user license agreement conditions available at www.sciencesuit.org

local std <const> =std


local function plot(...)
	
	local arg=table.pack(...)
	
	if(#arg==1 and type(arg[1])=="table") then
		
		return std.scatter(arg[1])

	
	elseif (#arg==2) then
            return std.scatter{x=arg[1],y=arg[2]}
            
      elseif (#arg==3) then
		return std.scatter{x=arg[1],y=arg[2], name=arg[3]}

	else
		error("Please see std.scatter for keys of Lua table or simply use as std.plot(x=, y=, [name=])", ERRORLEVEL)
	end

end


std.plot=plot
