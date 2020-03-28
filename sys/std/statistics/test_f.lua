-- Author:	Gokhan Bingol (gbingol@sciencesuit.org)
-- License: Subject to end-user license agreement conditions available at www.sciencesuit.org




local function FTEST(xvec,yvec, alternative, ratio, conflevel )

	assert(type(xvec)=="Vector" and type(yvec)=="Vector", "ERROR: Keys x and y must be of type Vector")
	
	ratio=ratio or 1
	assert(type(ratio)=="number" and ratio>0,"ERROR: Key ratio must be greater than zero and of type number")
	
	conflevel=conflevel or 0.95
	assert(type(conflevel)=="number","ERROR: Key conflevel must be of type number")
	assert(conflevel>=0 and conflevel<=1,"ERROR: Key conflevel must be in the range [0,1].")

	local alpha=(1-conflevel)


	alternative=alternative or "two.sided"
	assert(type(alternative)=="string","ERROR: Key alternative must be of type string")
	alternative=string.lower(alternative)



	local df1,df2=#xvec-1, #yvec-1 --degrees of freedoms
	local var1, var2=std.var(xvec), std.var(yvec) --variances
	
	local varRatio=var1/var2
	local Fcritical=varRatio /ratio
	
	
	
	local pvalue=0.0
	local ttable={}

	if(alternative=="two.sided" or alternative=="notequal") then
	
		--F distribution is non-symmetric
		local a=std.pf{q=Fcritical, df1=df1, df2=df2}
		local b=1-std.pf{q=Fcritical, df1=df1, df2=df2}
		
		local c=std.pf{q=1/Fcritical, df1=df1, df2=df2}
		local d=1-std.pf{q=1/Fcritical, df1=df1, df2=df2}
		
		pvalue=math.min(a,b)+math.min(c,d)

	elseif(alternative=="greater") then
		pvalue=(1-std.pf{q=Fcritical, df1=df1, df2=df2}) -- area on the right

	elseif(alternative=="less") then
		pvalue=std.pf{q=Fcritical, df1=df1, df2=df2} --area on the left
		
	else
		error("ERROR: The values for the argument 'alternative': \"two.sided\" or \"notequal\", \"greater\", \"less\"", ERRORLEVEL)
	end

	
	
	if(alternative=="two.sided" or alternative=="notequal") then
		local CI1=varRatio *std.qf{p=alpha/2.0, df1=df1, df2=df2}
		local CI2=varRatio *std.qf{p=1-alpha/2.0, df1=df1, df2=df2}
		
		ttable.CI_lower=math.min(CI1,CI2)
		ttable.CI_upper=math.max(CI1,CI2)
		
	elseif(alternative=="greater") then
		ttable.CI_lower=varRatio *std.qf{p=alpha, df1=df1, df2=df2}
		
	elseif(alternative=="less") then
		ttable.CI_upper=varRatio *std.qf{p=1-alpha, df1=df1, df2=df2}
	end

	ttable.Fcritical=Fcritical
	ttable.df1=df1
	ttable.df2=df2
	
	ttable.var1=var1
	ttable.var2=var2


	return pvalue, ttable
end




local function test_f (...)
	local args=table.pack(...)
	
	if(#args==1 and type(args[1])=="table") then
		
		local xvec, yvec, alternative, ratio, conflevel=nil, nil, nil, nil, nil
		local NArgsTbl=0
		
		for k,v in pairs(args[1]) do
			k=string.lower(k)
			
			if(k=="x") then xvec=v
			elseif(k=="y") then yvec=v
			elseif(k=="alternative") then alternative=v
			elseif(k=="ratio") then ratio=v
			elseif(k=="conflevel") then conflevel=v
			else 
				error("ERROR: Unrecognized key in the table, valid keys: x, y, ratio, alternative, conflevel.", ERRORLEVEL) 
			end

			NArgsTbl=NArgsTbl+1
		
		end

		assert(NArgsTbl>0,"ERROR: Keys: x, y, ratio, alternative, conflevel.")
		
		return FTEST(xvec,yvec, alternative, ratio, conflevel )
	
	
	elseif(#args==2) then
		return FTEST(args[1],args[2])
		
		
	else
		error("Usage: {x=, y=, ratio=1, alternative=\"two.sided\", conflevel=0.95} OR (x=, y=)", ERRORLEVEL) 
	
	end
	
end


std.test_f=test_f
