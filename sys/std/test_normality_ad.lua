-- Author:	Gokhan Bingol (gbingol@sciencesuit.org)
-- License: Subject to end-user license agreement conditions available at www.sciencesuit.org

local std <const> =std


local function AndersonDarling(vec)
	
	assert(type(vec)=="Vector", "Argument must be of type Vector")
	
	local v=vec[{}] --clone
	
	local N=#vec

	assert(N>2,"Argument must have at least 3 entries")
	
	local mean=std.mean(v)
	local stdev=std.stdev(v)
	
	v:sort("A")
	
	local f_x=std.pnorm{q=v,mean=mean, sd=stdev}
	
	local f_x_1=1-f_x
	f_x_1:sort("A")
	
	local S=std.Vector.new(N)
	local probability=std.Vector.new(N)
	
	for i=1, #vec do
		S[i]=(2*i-1)*(std.ln(f_x[i])+std.ln(f_x_1[i]))
		
		probability[i]=(i-0.3)/(N+0.4)
	end
	
	
	local z=std.qnorm{p=probability}
	
	local AD=-N-std.sum(S)/N
	
	local AD_star=AD*(1+0.75/N+2.25/N^2)
	
	local p={0,0,0,0}
	
	
	if(AD_star<13 and AD_star>=0.6) then
		p[1]=std.exp(1.2937-5.709*AD_star+0.0186*AD_star^2)
	end

	if(AD_star<0.6 and AD_star>=0.34) then
		p[2]=std.exp(0.9177-4.279*AD_star-1.38*AD_star^2)
	end

	if(AD_star<0.34 and AD_star>=0.2) then
		p[3]=1-std.exp(-8.318+42.796*AD_star-59.938*AD_star^2)
	end

	if(AD_star<0.2) then
		p[4]=1-std.exp(-13.436+101.14*AD_star-223.73*AD_star^2)
	end

	return std.max(p), AD
	
	
end



std.test_norm_ad=AndersonDarling