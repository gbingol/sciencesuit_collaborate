-- Author:	Gokhan Bingol (gbingol@sciencesuit.org)
-- License: Subject to end-user license agreement conditions available at www.sciencesuit.org


local std <const> =std


local function testwilcox1(xvec, mu, alternative, conflevel)

	--Default values
	assert(type(xvec)=="Vector" , "Key x must be Vector")
	
	assert(type(mu)=="number","Key mu must be number")
	
	conflevel=conflevel or 0.95
	assert(type(conflevel)=="number","Key conflevel must be number")
	assert(conflevel>=0 and conflevel<=1,"Key conflevel must be in [0,1].")

	alternative=alternative or "two.sided"
	assert(type(alternative)=="string","Key alternative must be string")
	alternative=string.lower(alternative)



	
	local pvalue=nil
	local retTable={}
	
	if(alternative=="two.sided" or alternative=="notequal") then

		

	elseif(alternative=="greater") then
		

	elseif(alternative=="less") then
		
		
	else
		error("The values for the arg 'alternative': \"two.sided\" or \"notequal\", \"greater\", \"less\"", std.const.ERRORLEVEL)
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
				error("Keys: x, y, mu, alternative, conflevel.", std.const.ERRORLEVEL) 
			end

			NArgsTbl=NArgsTbl+1
		
		end

		assert(NArgsTbl>0,"Keys: x, y, mu, alternative, conflevel.")
		
		if(yvec==nil) then
			return testwilcox1(xvec, mu, alternative, conflevel)
			
		elseif(type(yvec)=="Vector") then
			return testwilcox2(xvec, yvec, mu, alternative, conflevel)
			
		end
	
	else
		error("Arg must be a Lua table with probable keys: x, y, mu, alternative, conflevel.")
	
	end
end


--std.test_wilcox=testwilcox
