-- Author:	Gokhan Bingol (gbingol@sciencesuit.org)
-- License: Subject to end-user license agreement conditions available at www.sciencesuit.org

local function mean(Container, n)
	--Finds the mean value of an iteratable and addable container
	n=n or 1
	
	local sum, nelem=std.accumulate(Container, 0, function(x) return x^n end)

	return sum/nelem
	
end

std.aver=mean
std.mean=mean
