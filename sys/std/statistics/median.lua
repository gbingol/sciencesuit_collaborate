-- Author:	Gokhan Bingol (gbingol@sciencesuit.org)
-- License: Subject to end-user license agreement conditions available at www.sciencesuit.org

local function ConvertToTable(container)
	
	local retTab={}
	for key, value in pairs(container) do
		table.insert(retTab,value)
	end

	return retTab
end


local function QUANTILE(Container, probs)
	
	assert(type(Container)~="number" and type(Container)~="string", "ERROR: An iteratable container is required")
	
	assert(type(probs)=="number", "ERROR: prob must be of type number") 
	assert(probs>=0 and probs<=1, "ERROR: prob outside [0,1]")

	if(type(Container)=="Range") then
		Container=std.tovector(Container)
	end

	local m = getmetatable(Container)
	
	if(m) then
		local n=m["__pairs"]
		
		assert(n~=nil,"ERROR: The container is not iteratable")
	end
			
		
	  
	local elem=ConvertToTable(Container)
	
	table.sort(elem)

	local Size=#elem

	local h=(Size-1)*probs + 1
	
	
	local h_floor=math.floor(h)
	
	
	--only happens when probs=1
	if(h_floor==Size) then
		return elem[Size]
	end
	
	
	return elem[h_floor]+(h-h_floor)*(elem[h_floor+1]-elem[h_floor])
     
end




local function quantile(...)
	local args=table.pack(...)
	
	if(#args==1 and type(args[1])=="table") then
		
		local xval, prob=nil, nil
		local NTblArgs=0
		
		for k,v in pairs(args[1]) do
			
			k=string.lower(k)

			if(k=="x") then xval=v
			elseif(k=="prob") then prob=v
			else 
				error("ERROR: Unrecognized key in the table, keys can be: x and prob.", ERRORLEVEL) 
			end

			NTblArgs=NTblArgs+1
		
		end

		assert(NTblArgs>0,"ERROR: Keys: x and prob.")

		assert(xval~=nil and prob~=nil, "ERROR: A value must be assigned to all of the table keys (x and prob).")
		
		return QUANTILE(xval, prob)
		
	end
	
	if(#args==2) then
		return QUANTILE(args[1],args[2])
	end

	error("ERROR: quantile accepts either a table {x=, prob=} or 2 arguments (x=, prob=)")

end





local function median(Container)
	
	return quantile(Container, 0.5)
		
end


std.quantile=quantile
std.median=median

