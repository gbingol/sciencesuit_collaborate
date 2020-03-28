-- Author:	Gokhan Bingol (gbingol@sciencesuit.org)
-- License: Subject to end-user license agreement conditions available at www.sciencesuit.org


local function COR(v1,v2)

	--Calculates the correlation coefficient between two vectors of same size

	
	local len1,len2=#v1,#v2

	assert(len1==len2,"ERROR: Both containers should be of same size.")

	local var1,var2=std.var(v1),std.var(v2) --variance
	local std1,std2=std.sqrt(var1),std.sqrt(var2)

	return std.cov(v1,v2)/(std1*std2)

end




std.cor=COR
