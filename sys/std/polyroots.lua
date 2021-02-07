local std <const> =std



--currently just monic polynom algorithm implemented


local function POLYROOTS_MONICPOLY(vec)
	
	--vec is in the form of monic polynomial
	
	--uses eigen value approach
	--Companion is the companion matrix for a polynomial
	
	
	assert(type(vec) == "Vector", "Argument must be Vector")
	assert(std.abs(vec(1) -1 ) <std.const.tolerance, "A monic polynomial is expected.") 
	
	local dim = #vec
	
	local Companion = std.eye(dim -2, dim -2) 
	
	local Zeros=std.Vector.new(dim -2)
	
	
	Companion:insert(Zeros, 1, "col")  -- (dim-2) by (dim-1) 
	
	vec = -vec	
	vec[1] = nil
	vec:reverse()
	
	Companion:append(vec, "row") -- (dim -1) * (dim-1)
	
	
	return std.eig(Companion)
end




std.polyroots=POLYROOTS_MONICPOLY
	
	



-- Author:	Gokhan Bingol (gbingol@sciencesuit.org)
-- License: Subject to end-user license agreement conditions available at www.sciencesuit.org
	