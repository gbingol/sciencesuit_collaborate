-- Author:	Gokhan Bingol (gbingol@sciencesuit.org)
-- License: Subject to end-user license agreement conditions available at www.sciencesuit.org

local std <const> =std


local function skew(container)  
	--calculates skewness 

	local total, n=std.accumulate(container,0)
	local avg=total/n
	
	assert(n>=3, "ERROR: At least 3 data points is required!") 
	
	local std_p=std.stdev(container,"p") 
	local skew_p=std.accumulate( container,0, function(x) return ((x-avg)/std_p)^3 end)
	
	return std.sqrt(n*(n-1))*skew_p/(n-2)
end

std.skew=skew
