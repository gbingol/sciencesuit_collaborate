local std <const> =std


local function cov(cont1, cont2, str)
	--Calculates the covariance between two containers of same size
	--If str is not provided the function will calculate SAMPLE covariance
	--If str=="p" then function will calculate POPULATION covariance

	str=str or "s"
	
	assert(type(str)=="string","3rd arg: \"s\" or \"p\"")
	str=string.lower(str)

	assert(str=="s" or str=="p","3rd arg: \"s\" or \"p\"")
	
	
	if(type(cont1)=="Array") then
		cont1=cont1:clone()
		cont1:keep_numbers()
	end

	if(type(cont2)=="Array") then
		cont2=cont2:clone()
		cont2:keep_numbers()
	end


	local sum1, len1, sum2, len2 = nil, nil, nil, nil
	
	
	if(type(cont1)=="Array" or type(cont1)=="Vector") then
		sum1=std.sum(cont1)
		len1=#cont1
	
	else
		sum1, len1=std.accumulate(cont1,0)
	end


	if(type(cont2)=="Array" or type(cont2)=="Vector") then
		sum2=std.sum(cont2)
		len2=#cont2
	
	else
		sum2, len2=std.accumulate(cont2,0)
	end
	

	assert(len1==len2,"Arg 1 and 2 should be of same size")



	local df=len1-1
	if(str=="p") then df=len1 end

	local avg1,avg2=sum1/len1,sum2/len2
	
	local total=0
	
	local k2,v2=next(cont2,nil)
	
	for k1, v1 in pairs(cont1) do
		total = total + (v1-avg1)*(v2-avg2)
		
		k2,v2 = next(cont2,k2)
	end
	

	return total/df
end




std.cov=cov




-- Author:	Gokhan Bingol (gbingol@sciencesuit.org)
-- License: Subject to end-user license agreement conditions available at www.sciencesuit.org
