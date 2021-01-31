local std <const> =std



local function read_csv(...)
	--Input: v1 and v2 as vectors
	local arg=table.pack(...)
	local nargs=#arg
	
	if(nargs==0) then
		error("Usage: {file=, header=true, encode=false} or (file=, header=true, encode=false)", std.const.ERRORLEVEL)
    
    
	-- input: Lua table
	elseif(nargs==1 and type(arg[1])=="table") then
		local file, header, encode=nil, true, false
		
		local NTblArgs=0
		
		for key, value in pairs(arg[1]) do
			key=string.lower(key)

			if(key=="file") then file=value
			elseif(key=="header") then header=value
			elseif(key=="encode") then encode=value
			else 
				error("Keys: {file=, header=true, encode=false}", std.const.ERRORLEVEL) 
			end

			NTblArgs=NTblArgs+1
		end
		
		assert(type(file)=="string", "file path must be string")
		assert(type(header)=="boolean", "header must be boolean")
		assert(type(encode)=="boolean", "encode must be boolean")
		
		assert(NTblArgs>0,"Usage: file=, header=true, encode=false")

		local status, err=pcall(SYSTEM.read_csv,file, header, encode)
		
		if(status) then
			return err
		end

		error(err, std.const.ERRORLEVEL)
			
	
	
	
	elseif(nargs==1 and type(arg[1])=="string") then
		return SYSTEM.read_csv(arg[1])

	elseif(nargs==2 ) then 
		assert(type(arg[1])=="string", "1st arg must be string")
		assert(type(arg[2])=="boolean", "2nd arg must be boolean")
	
		return SYSTEM.read_csv(arg[1],arg[2])

	
	elseif(nargs==3 ) then 
		assert(type(arg[1])=="string", "1st arg must be string")
		assert(type(arg[2])=="boolean", "2nd arg must be boolean")
		assert(type(arg[3])=="boolean", "3rd must be boolean")
	
		return SYSTEM.read_csv(arg[1],arg[2],arg[3])
        
	--no match
	else 
		error("Usage: {file=, header=true, encode=false} or (file=, header=true, encode=false)" , std.const.ERRORLEVEL) 
	end
	
	
end



std.read_csv=read_csv



-- Author:	Gokhan Bingol (gbingol@sciencesuit.org)
-- License: Subject to end-user license agreement conditions available at www.sciencesuit.org

