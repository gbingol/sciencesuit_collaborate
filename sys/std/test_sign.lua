

--NORMALAPPROXIMATIONSATISFIED=12 seems controversial to choose for normal approximation of binomial dist
--Larsen & Marx An Introduction to Mathematical Statistics and Its Applications recommends a sample size of 10 (aligned with general rule of np>=5, where p=0.5)
--Chakraborti & Gibbons at Nonparametric Statistical Inference, Fifth Edition pp 171 recommends at least 12
--Minitab and R seems to choose a number greater than 10. R refers to Chakraborti & Gibbons publication on its documentation
--Therefore, 12 was chosen for normal approximation of binomial distribution


local std <const> =std


local NORMALAPPROXIMATIONSATISFIED=12



local function Interpolation(x1, y1, x2, y2, val) 
	-- Given 2 data points (x1,y1) and (x2,y2) we are looking for the y-value of the point x=val 
	if(x1==x2 or math.abs(x1-x2)<1E-6) then 
		return y1 
	end 
	
	local m = (y2 - y1) / (x2 - x1)
	local n = y2 - m * x2;
	
	return m * val + n
end




local function FindCI(xvec, alternative, conflevel)
	local vec=xvec[{}] --make a clone as we do not want to modify the vector xvec
	
	vec:sort("A") --sort ascending
	
	
	
	local lower,exact, upper = 0, 0, 0
	local lower_found, upper_found = false, false
	local lower_pos, upper_pos = 0, 0
	
	local probability = 0
	
	local SampleSize = #vec
	
	
	for i=0, SampleSize do
		
		local pbinom=std.pbinom{q=i, size=SampleSize, prob=0.5}

		if(alternative=="two.sided" or alternative=="notequal") then
			probability=1-2*pbinom
			
		elseif(alternative=="greater") then
			probability=1-pbinom
			
		elseif(alternative=="less") then
			probability=pbinom
		end
		
		
		if(probability>=conflevel) then
			upper=probability
			upper_found=true
			
			upper_pos=i
			
			if(lower_found) then break end
			
		elseif(probability<conflevel) then
			lower=probability
			lower_found=true
			
			lower_pos=i
			
			if(upper_found) then break end
			
		end
				
	end --loop


	local retTable={}
		
	
	local CI_a, CI_b=vec[lower_pos+1], vec[#vec-lower_pos]
	
	retTable.lower={}
	retTable.lower={pos=lower_pos, prob=lower, CILow=math.min(CI_a, CI_b), CIHigh=math.max(CI_a, CI_b)}
	
	
	CI_a, CI_b=vec[upper_pos+1], vec[#vec-upper_pos]
	
	retTable.upper={}
	retTable.upper={pos=upper_pos, prob=upper, CILow=math.min(CI_a, CI_b), CIHigh=math.max(CI_a, CI_b)}
	
	
	return retTable
end




local function sign_test1(x_vector,md, alternative, conflevel)

	--Default values
	assert(type(x_vector)=="Vector" , "Key x must be Vector")
	
	assert(type(md)=="number","Key md must be number")
	
	
	conflevel=conflevel or 0.95
	assert(type(conflevel)=="number","Key conflevel must be number")
	assert(conflevel>=0 and conflevel<=1,"Key conflevel must be in [0,1].")



	alternative=alternative or "two.sided"
	assert(type(alternative)=="string","Key alternative must be string")
	alternative=string.lower(alternative)


	local alpha=(1-conflevel)
	
	
	--clone x_vector as its size can be modified
	local xvec=x_vector[{}]
	local NElemGreater, NElemEqual=0, 0
	local ElemsEqual, k={}, 0
	
	
	for i=1,#xvec do
		local difference = xvec[i] - md
		
		if(difference>0) then
			NElemGreater=NElemGreater+1
		
		--remove elements which are in the TOLERANCE neighbourhood of md
		elseif(math.abs(difference)<std.const.tolerance) then 
			NElemEqual=NElemEqual+1
		
			xvec[i]=nil   
			
			--once an element is deleted from xvec, the element to be deleted from kth position moves to (k-1)th
			i=i-1 
		end
	end



	local SampleSize=#xvec 
	
	local pvalue, retTable=nil, {}
	

	--computation of p-value
	--Note that when sample size>=10 normal approximation holds, otherwise we need to calculate probabilities using binomial dist
	--For more info see Larsen & Marx, An Introduction to Mathematical Statistics and Its Applications, Chapter 13
	
	if(SampleSize<NORMALAPPROXIMATIONSATISFIED) then
		
		if(alternative=="two.sided" or alternative=="notequal") then
			
			local n=math.min(NElemGreater,SampleSize-NElemGreater)
			
			--B(n, 0.5) is symmetric
			pvalue = 2*std.pbinom{q=n,size=SampleSize, prob=0.5} 
			

		elseif(alternative=="greater") then
			pvalue=1-std.pbinom{q=NElemGreater-1,size=SampleSize, prob=0.5} -- area on the right
			
		elseif(alternative=="less") then
			pvalue=std.pbinom{q=NElemGreater,size=SampleSize, prob=0.5} --area on the left
			
		end
			


	elseif(SampleSize>=NORMALAPPROXIMATIONSATISFIED) then
	
		local variance=SampleSize/4
		local zvalue=(NElemGreater-SampleSize/2)/math.sqrt( variance)
		
		
		if(alternative=="two.sided" or alternative=="notequal") then
			if(zvalue<=0) then
				--area on the left + area on the right of positive
				pvalue=std.pnorm{q=zvalue}+ (1-std.pnorm{q=-1.0*zvalue}) 
				
			elseif(zvalue>0) then
				--area on the right of positive + area on the left of negative 
				pvalue=(1-std.pnorm{q=zvalue}) +std.pnorm{q=-zvalue} 
			end

		elseif(alternative=="greater") then
			-- area on the right
			pvalue=(1-std.pnorm{q=zvalue}) 
			
		elseif(alternative=="less") then
			--area on the left
			pvalue=std.pnorm{q=zvalue} 
			
		end
			
	end




	--computation and arranging return values for confidence interval
	
	retTable=FindCI(xvec, alternative, conflevel)
	
	if(#retTable==1) then
		return pvalue, retTable
	end


	retTable.interpolated={prob=conflevel}
	
	if(alternative=="two.sided" or alternative=="notequal") then
		local x1, x2=retTable.lower.prob, retTable.upper.prob
		
		retTable.interpolated.CILow=Interpolation(x1, retTable.lower.CILow,x2 , retTable.upper.CILow, conflevel) 
		retTable.interpolated.CIHigh=Interpolation(x1, retTable.lower.CIHigh, x2, retTable.upper.CIHigh, conflevel) 
		

	elseif(alternative=="greater") then
		retTable.lower.CIHigh="inf"
		retTable.upper.CIHigh="inf"
		
		retTable.interpolated.CILow=Interpolation(retTable.lower.prob, retTable.lower.CILow, retTable.upper.prob, retTable.upper.CILow, conflevel) 
		retTable.interpolated.CIHigh="inf"
		
	elseif(alternative=="less") then
		retTable.lower.CILow="-inf"
		retTable.upper.CILow="-inf"
		
		retTable.interpolated.CILow="-inf"
		retTable.interpolated.CIHigh=Interpolation(retTable.lower.prob, retTable.lower.CIHigh, retTable.upper.prob, retTable.upper.CIHigh, conflevel) 
	else
		error("Values for arg 'alternative': \"two.sided\" or \"notequal\", \"greater\", \"less\"", std.const.ERRORLEVEL)
	end


	retTable.nequal=NElemEqual
	retTable.ngreater=NElemGreater


	return pvalue, retTable

end





local function sign_test(...)
	local args=table.pack(...)
	
	if(#args==1 and type(args[1])=="table") then
		
		local xvec, yvec, alternative, md, conflevel=nil, nil, nil, nil, nil
		local NArgsTbl=0
		
		for k,v in pairs(args[1]) do
			k=string.lower(k)
			
			if(k=="x") then xvec=v
			elseif(k=="y") then yvec=v
			elseif(k=="alternative") then alternative=v
			elseif(k=="md") then md=v
			elseif(k=="conflevel") then conflevel=v
			else 
				error("Keys: x, y, alternative, md, conflevel.", std.const.ERRORLEVEL) 
			end

			NArgsTbl=NArgsTbl+1
		
		end

		assert(NArgsTbl>0,"Keys: x, y, alternative, md, conflevel.")
		
		if(yvec==nil) then
			return sign_test1(xvec, md, alternative, conflevel)
			
		elseif(type(yvec)=="Vector" ) then
			return  sign_test1(xvec-yvec, md, alternative, conflevel)
		end
	
	else
		error("Lua table expected, keys: x, y, alternative, md, conflevel.", std.const.ERRORLEVEL)
	
	end
end




std.test_sign=sign_test



-- Author:	Gokhan Bingol (gbingol@sciencesuit.org)
-- License: Subject to end-user license agreement conditions available at www.sciencesuit.org

