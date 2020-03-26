-- Author:	Gokhan Bingol (gbingol@hotmail.com)
-- License: Subject to end-user license agreement conditions available at www.sciencesuit.org


local function cov(cont1,cont2,str)
	--Calculates the covariance between two containers of same size
	--If str is not provided the function will calculate SAMPLE covariance
	--If str=="p" then function will calculate POPULATION covariance

	str=str or "s"
	
	assert(type(str)=="string","ERROR: Third argument must be of type string, 's' or 'p'")
	str=string.lower(str)

	assert(str=="s" or str=="p","ERROR: Third argument can be either \"s\" or \"p\"")
	
	local sum1, len1=std.accumulate(cont1,0)
	local sum2, len2=std.accumulate(cont2,0)

	assert(len1==len2,"ERROR: Argument 1 and 2 should be of same size")

	local df=len1-1
	if(str=="p") then df=len1 end

	local avg1,avg2=sum1/len1,sum2/len2
	
	local total=0
	
	local k2,v2=next(cont2,nil)
	for k1,v1 in pairs(cont1) do
		total=total+(v1-avg1)*(v2-avg2)
		k2,v2=next(cont2,k2)
	end
	

	return total/df
end


std.cov=cov
