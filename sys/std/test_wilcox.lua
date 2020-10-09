-- Author:	Gokhan Bingol (gbingol@sciencesuit.org)
-- License: Subject to end-user license agreement conditions available at www.sciencesuit.org


local std <const> =std


local function testwilcox1(xvec, mu, alternative, conflevel)

	--Default values
	assert(type(xvec)=="Vector" , "ERROR: Key x must be of type Vector")
	
	assert(type(mu)=="number","ERROR: Key mu must be of type number")
	
	conflevel=conflevel or 0.95
	assert(type(conflevel)=="number","ERROR: Key conflevel must be of type number")
	assert(conflevel>=0 and conflevel<=1,"ERROR: Key conflevel must be in the range [0,1].")

	alternative=alternative or "two.sided"
	assert(type(alternative)=="string","ERROR: Key alternative must be of type string")
	alternative=string.lower(alternative)



	
	local pvalue=nil
	local retTable={}
	
	if(alternative=="two.sided" or alternative=="notequal") then

		

	elseif(alternative=="greater") then
		

	elseif(alternative=="less") then
		
		
	else
		error("ERROR: The values for the argument 'alternative': \"two.sided\" or \"notequal\", \"greater\", \"less\"", std.const.ERRORLEVEL)
	end


	


	return pvalue, retTable

end





local function testwilcox2(xvec,yvec, mu, alternative, conflevel )
end




local function testwilcox(...)
	local args=table.pack(...)
	
	if(#args==1 and type(args[1])=="table") then
		
		local xvec, yvec, alternative, mu, conflevel=nil, nil, nil, nil, nil
		local NArgsTbl=0

		
		for k,v in pairs(args[1]) do
			k=string.lower(k)
			
			if(k=="x") then xvec=v
			elseif(k=="y") then yvec=v
			elseif(k=="mu") then mu=v
			elseif(k=="alternative") then alternative=v
			elseif(k=="conflevel") then conflevel=v
			
			else 
				error("ERROR: Unrecognized key in the table, valid keys: x, y, mu, alternative, conflevel.", std.const.ERRORLEVEL) 
			end

			NArgsTbl=NArgsTbl+1
		
		end

		assert(NArgsTbl>0,"ERROR: Keys: x, y, mu, alternative, conflevel.")
		
		if(yvec==nil) then
			return testwilcox1(xvec, mu, alternative, conflevel)
			
		elseif(type(yvec)=="Vector") then
			return testwilcox2(xvec, yvec, mu, alternative, conflevel)
			
		end
	
	else
		error("ERROR: Argument must be a Lua table with probable keys: x, y, mu, alternative, conflevel.")
	
	end
end


--std.test_wilcox=testwilcox
