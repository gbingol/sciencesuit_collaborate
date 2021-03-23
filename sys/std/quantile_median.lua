local std <const> =std


local function ConvertToTable(container)
	
	local retTab={}
	for key, value in pairs(container) do
		table.insert(retTab,value)
	end

	return retTab
end


local function QUANTILE(Container, probs)
	
	assert(std.util.isiteratable(Container) == true, "An iteratable container is required")
	
	assert(type(probs)=="number", "prob must be number") 
	assert(probs>=0 and probs<=1, "prob outside [0,1]")

	if(type(Container)=="Range") then
		Container=std.util.tovector(Container)
			
	elseif (type(Container)=="Array") then
		Container=Container:clone()
		Container:keep_realnumbers()
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
				error("Keys: x and prob.", std.const.ERRORLEVEL) 
			end

			NTblArgs=NTblArgs+1
		
		end

		assert(NTblArgs>0,"Keys: x and prob.")

		assert(xval~=nil and prob~=nil, "A value must be assigned to all of the table keys (x and prob).")
		
		return QUANTILE(xval, prob)
		
	end
	
	if(#args==2) then
		return QUANTILE(args[1],args[2])
	end

	error("quantile accepts either a table {x=, prob=} or 2 arguments (x=, prob=)")

end





local function median(Container)
	
	return quantile(Container, 0.5)
		
end




std.quantile=quantile
std.median=median




-- Author:	Gokhan Bingol (gbingol@sciencesuit.org)
-- License: Subject to end-user license agreement conditions available at www.sciencesuit.org