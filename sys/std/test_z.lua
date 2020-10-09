-- Author:	Gokhan Bingol (gbingol@sciencesuit.org)
-- License: Subject to end-user license agreement conditions available at www.sciencesuit.org

local std <const> =std


local function ztest1(xvec, sd, mu, alternative, conflevel)

	--Default values
	assert(type(xvec)=="Vector" , "ERROR: Key x must be of type Vector.")
	
	assert(type(sd)=="number" and sd>0,"ERROR: Key sd must be of type number greater than 0.")
	
	assert(type(mu)=="number","ERROR: Key mu must be of type number.")
	
	conflevel=conflevel or 0.95
	assert(type(conflevel)=="number","ERROR: Key conflevel must be of type number.")
	assert(conflevel>=0 and conflevel<=1,"ERROR: Key conflevel must be in the range [0,1].")


	alternative=alternative or "two.sided"
	assert(type(alternative)=="string","ERROR: Key alternative must be of type string.")
	alternative=string.lower(alternative)
	
	

	local dim=std.size(xvec) 
	local xaver=std.mean(xvec)
	local SE=sd/std.sqrt(dim) ----Standard Error of Mean
	
	local stdev=std.stdev(xvec) -- sample's standard deviation

	local alpha=(1-conflevel)
	

	local zcritical=(xaver-mu)/SE
	local pvalue=nil
	local retTable={}
	
	if(alternative=="two.sided" or alternative=="notequal") then

		if(zcritical<=0) then
			pvalue=std.pnorm{q=zcritical}+ (1-std.pnorm{q=math.abs(zcritical)}) --area on the left of zcrit + area on the right of positive
			
		elseif(zcritical>0) then
			pvalue=(1-std.pnorm{q=zcritical}) +std.pnorm{q=-zcritical} --area on the right of positive zcriticial + area on the left of negative zcriticial
		end
		
		retTable.CI_upper=xaver-std.qnorm{p=alpha/2.0}*SE
		retTable.CI_lower=xaver+std.qnorm{p=alpha/2.0}*SE

	elseif(alternative=="greater") then
		pvalue=(1-std.pnorm{q=zcritical}) -- area on the right
		
		retTable.CI_lower=xaver+std.qnorm{p=alpha}*SE

	elseif(alternative=="less") then
		pvalue=std.pnorm{q=zcritical} --area on the left
		
		retTable.CI_upper=xaver-std.qnorm{p=alpha}*SE
		
	else
		error("ERROR: The values for the argument 'alternative': \"two.sided\" or \"notequal\", \"greater\", \"less\"", std.const.ERRORLEVEL)
	end


	retTable.SE=SE
	retTable.N=dim
	retTable.stdev=stdev
	retTable.mean=xaver
	retTable.zcritical=zcritical


	return pvalue, retTable

end







local function ztest(...)
	local args=table.pack(...)
	
	if(#args==1 and type(args[1])=="table") then
		
		local xvec, alternative, mu, sd, conflevel=nil, nil, nil, nil,nil
		local NArgsTbl=0
		
		for k,v in pairs(args[1]) do
			k=string.lower(k)
			
			if(k=="x") then xvec=v
			elseif(k=="alternative") then alternative=v
			elseif(k=="mu") then mu=v
			elseif(k=="sd") then sd=v
			elseif(k=="conflevel") then conflevel=v
			else 
				error("ERROR: Unrecognized key in the table, valid keys: x, alternative, mu, sd, conflevel.", std.const.ERRORLEVEL) 
			end

			NArgsTbl=NArgsTbl+1
		
		end

		assert(NArgsTbl>0,"ERROR: Keys: x, alternative, mu, sd, conflevel.")
		
		return ztest1(xvec, sd, mu, alternative, conflevel)
		
	else
	
		error("ERROR: Argument must be a Lua table with keys: x, alternative, mu, sd, conflevel.")

	end
			
		
end


std.test_z=ztest
