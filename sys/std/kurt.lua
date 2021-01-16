-- Author:	Gokhan Bingol (gbingol@sciencesuit.org)
-- License: Subject to end-user license agreement conditions available at www.sciencesuit.org

local std <const> =std


local function kurt(v) --kurtosis 
	
	local total, n=std.accumulate( v,0)
	local avg=total/n

	assert(n>=4,"Container must have at least 4 elements")

	local stdev=std.stdev(v)
	
	local s=std.accumulate(v,0, function(x) return ((x-avg)/stdev)^4 end) -- more efficient than s=std.sum((v-avg)/stdev,4)
	
	return s*n*(n+1)/((n-1)*(n-2)*(n-3)) - 3*(n-1)^2/((n-2)*(n-3))
end


std.kurt=kurt
