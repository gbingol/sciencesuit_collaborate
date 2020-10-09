-- Author:	Gokhan Bingol (gbingol@sciencesuit.org)
-- License: Subject to end-user license agreement conditions available at www.sciencesuit.org

local std <const> =std


local function ttest1(xvec, alternative, mu, conflevel)

	--Default values
	assert(type(xvec)=="Vector" , "ERROR: Key x must be of type Vector")
	
	assert(type(mu)=="number","ERROR: Key mu must be of type number")
	
	conflevel=conflevel or 0.95
	assert(type(conflevel)=="number","ERROR: Key conflevel must be of type number")
	assert(conflevel>=0 and conflevel<=1,"ERROR: Key conflevel must be in the range [0,1].")

	alternative=alternative or "two.sided"
	assert(type(alternative)=="string","ERROR: Key alternative must be of type string")
	alternative=string.lower(alternative)



	local dim=std.size(xvec) 
	local df=dim-1 --degrees of freedom
	local xaver=std.mean(xvec)
	local stdev=std.stdev(xvec) -- sample's standard deviation
	local SE=stdev/std.sqrt(dim) ----Standard Error of Mean

	local alpha=(1-conflevel)
	

	local tcritical=(xaver-mu)/SE
	local pvalue=nil
	local retTable={}
	
	if(alternative=="two.sided" or alternative=="notequal") then

		if(tcritical<=0) then
			pvalue=std.pt{q=tcritical, df=df}+ (1-std.pt{q=math.abs(tcritical), df=df}) --area on the left of tcrit + area on the right of positive
			
		elseif(tcritical>0) then
			pvalue=(1-std.pt{q=tcritical, df=df}) +std.pt{q=-tcritical, df=df} --area on the right of positive tcritical + area on the left of negative tcritical
		end
		
		retTable.CI_upper=xaver-std.qt{df=df, p=alpha/2.0}*SE
		retTable.CI_lower=xaver+std.qt{df=df, p=alpha/2.0}*SE

	elseif(alternative=="greater") then
		pvalue=(1-std.pt{q=tcritical, df=df}) -- area on the right
		
		retTable.CI_lower=xaver+std.qt{df=df, p=alpha}*SE

	elseif(alternative=="less") then
		pvalue=std.pt{q=tcritical, df=df} --area on the left
		
		retTable.CI_upper=xaver-std.qt{df=df, p=alpha}*SE
		
	else
		error("ERROR: The values for the argument 'alternative': \"two.sided\" or \"notequal\", \"greater\", \"less\"", std.const.ERRORLEVEL)
	end


	retTable.SE=SE
	retTable.N=dim
	retTable.stdev=stdev
	retTable.mean=xaver
	retTable.tcritical=tcritical


	return pvalue, retTable

end





local function ttest2(xvec,yvec, varequal, alternative, mu, conflevel )
	-- x,y: vectors to be compared assuming equal means

	assert(type(xvec)=="Vector" and type(yvec)=="Vector", "ERROR: Keys x and y must be of type Vector")
	
	mu=mu or 0
	assert(type(mu)=="number","ERROR: Key mu must be of type number")
	
	conflevel=conflevel or 0.95
	assert(type(conflevel)=="number","ERROR: Key conflevel must be of type number")
	assert(conflevel>=0 and conflevel<=1,"ERROR: Key conflevel must be in the range [0,1].")

	alternative=alternative or "two.sided"
	assert(type(alternative)=="string","ERROR: Key alternative must be of type string")
	alternative=string.lower(alternative)

	if(varequal==nil) then
		varequal=true
	else
		assert(type(varequal)=="boolean", "ERROR: Key varequal must be of type boolean")
	end


	local n1,n2=#xvec, #yvec
	local xaver, yaver=std.mean(xvec), std.mean(yvec)
	local s1, s2=std.stdev(xvec), std.stdev(yvec)

	local pvalue=0.0
	local ttable={}
	local df=nil
	local tcritical=nil
	
	local alpha=(1-conflevel)


	if(not varequal) then --unequal variances
		local df_num=(s1^2/n1+s2^2/n2)^2
		local df_denom=1/(n1-1)*(s1^2/n1)^2+1/(n2-1)*(s2^2/n2)^2

		df=math.floor(df_num/df_denom)

		tcritical=((xaver-yaver)-mu)/std.sqrt(s1^2/n1+s2^2/n2)


	elseif(varequal) then
		df=n1+n2-2
		local sp_num=(n1-1)*s1^2+(n2-1)*s2^2
		local sp=math.sqrt(sp_num/df)		--pooled variance

		tcritical=((xaver-yaver)-mu)/(sp*std.sqrt(1/n1+1/n2))

		ttable.sp=sp

	end


	if(alternative=="two.sided" or alternative=="notequal") then

		if(tcritical<=0) then
			pvalue=std.pt{q=tcritical, df=df}+ (1-std.pt{q=math.abs(tcritical), df=df}) --area on the left of tcrit + area on the right of positive
			
		elseif(tcritical>0) then
			pvalue=(1-std.pt{q=tcritical, df=df}) +std.pt{q=-tcritical, df=df} --area on the right of positive tcritical + area on the left of negative tcritical
		end

	elseif(alternative=="greater") then
		pvalue=(1-std.pt{q=tcritical, df=df}) -- area on the right

	elseif(alternative=="less") then
		pvalue=std.pt{q=tcritical, df=df} --area on the left
		
	else
		error("ERROR: The values for the argument 'alternative': \"two.sided\" or \"notequal\", \"greater\", \"less\"", std.const.ERRORLEVEL)
	end

	
	local SE=nil

	if(varequal) then
		local sp=ttable.sp
		SE=sp*math.sqrt(1/n1+1/n2)

	elseif(not varequal) then
		SE=math.sqrt(s1^2/n1+s2^2/n2)
	end
	
	
	local CI1, CI2=nil, nil

	if(alternative=="two.sided" or alternative=="notequal") then
		local quantile=std.qt{p=alpha/2.0, df=df}
		CI1=(xaver-yaver)-quantile*SE
		CI2=(xaver-yaver)+quantile*SE
		ttable.CI_lower=math.min(CI1,CI2)
		ttable.CI_upper=math.max(CI1,CI2)
		
	elseif(alternative=="greater") then
		local quantile=std.qt{p=1-alpha, df=df}
		ttable.CI_lower=(xaver-yaver)-quantile*SE
		
	elseif(alternative=="less") then
		local quantile=std.qt{p=alpha, df=df}
		ttable.CI_upper=(xaver-yaver)-quantile*SE
	end

	ttable.tcritical=tcritical
	ttable.n1=n1
	ttable.n2=n2
	ttable.df=df
	ttable.xaver=xaver
	ttable.yaver=yaver
	ttable.s1=s1
	ttable.s2=s2


	return pvalue, ttable
end




local function ttest_paired(xvec,yvec, alternative, mu, conflevel)

	assert(type(xvec)=="Vector" and type(yvec)=="Vector", "ERROR: Keys x and y must be of type Vector")
	assert(#xvec==#yvec,"x and y vectors must have the same length")
	
	mu=mu or 0
	assert(type(mu)=="number","ERROR: Key mu must be of type number")
	
	conflevel=conflevel or 0.95
	assert(type(conflevel)=="number","ERROR: Key conflevel must be of type number")
	assert(conflevel>=0 and conflevel<=1,"ERROR: Key conflevel must be in the range [0,1].")

	alternative=alternative or "two.sided"
	assert(type(alternative)=="string","ERROR: Key alternative must be of type string")
	alternative=string.lower(alternative)


	local n1,n2=#xvec, #yvec
	local xaver, yaver=std.mean(xvec), std.mean(yvec)
	local s1, s2=std.stdev(xvec), std.stdev(yvec)

	
	local ttable={}
	
	ttable.n1=n1
	ttable.n2=n2

	ttable.xaver=xaver
	ttable.yaver=yaver
	
	ttable.s1=s1
	ttable.s2=s2

	local pval, tblDifference=ttest1(xvec-yvec, alternative, mu, conflevel)
	
	--merge the tables
	for k,v in pairs(tblDifference) do
		ttable[k]=v
	end
	
	return pval, ttable
end




local function ttest(...)
	local args=table.pack(...)
	
	if(#args==1 and type(args[1])=="table") then
		
		local xvec, yvec, varequal, alternative, mu, conflevel, paired=nil, nil, nil, nil, nil, nil, nil
		local NArgsTbl=0
		
		for k,v in pairs(args[1]) do
			k=string.lower(k)
			
			if(k=="x") then xvec=v
			elseif(k=="y") then yvec=v
			elseif(k=="varequal") then varequal=v
			elseif(k=="alternative") then alternative=v
			elseif(k=="mu") then mu=v
			elseif(k=="conflevel") then conflevel=v
			elseif(k=="paired") then paired=v
			else 
				error("ERROR: Unrecognized key in the table, valid keys: x, y, varequal, alternative, mu, conflevel, paired.", std.const.ERRORLEVEL) 
			end

			NArgsTbl=NArgsTbl+1
		
		end

		assert(NArgsTbl>0,"ERROR: Keys: x, y, varequal, alternative, mu, conflevel, paired.")
		
		if(yvec==nil) then
			return ttest1(xvec, alternative, mu, conflevel)
			
		elseif(type(yvec)=="Vector" and (paired==nil or paired==false)) then
			return ttest2(xvec, yvec, varequal, alternative, mu, conflevel)
			
		elseif(type(yvec)=="Vector" and paired==true) then
			return ttest_paired(xvec, yvec, alternative, mu, conflevel)
		end
	
	else
		error("ERROR: Argument must be a Lua table with probable keys: x, y, varequal, alternative, mu, conflevel, paired.")
	
	end
end


std.test_t=ttest
