-- Author:	Gokhan Bingol (gbingol@sciencesuit.org)
-- License: Subject to end-user license agreement conditions available at www.sciencesuit.org


local function sum(Container, n)
	--Finds the sum of a vector, matrix or range
	n=n or 1
	
	local total, NElem=std.accumulate( Container,0, function(x) return x^n end )

	return total
end

std.sum=sum
