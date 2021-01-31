local std <const> =std


local function COR(v1,v2)

	--Calculates the correlation coefficient between two vectors of same size

	if(type(v1)=="Array") then
		v1=v1:clone()
		v1:keep_numbers()
	end

	if(type(v2)=="Array") then
		v2=v2:clone()
		v2:keep_numbers()
	end



	assert(#v1==#v2,"Both containers should be of same size.")
	
	

	local var1,var2=std.var(v1),std.var(v2)
	
	local std1,std2=std.sqrt(var1),std.sqrt(var2)


	return std.cov(v1,v2)/(std1*std2)

end




std.cor=COR




-- Author:	Gokhan Bingol (gbingol@sciencesuit.org)
-- License: Subject to end-user license agreement conditions available at www.sciencesuit.org
