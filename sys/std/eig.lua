local std <const> =std

local function eig(...)

	--INPUT: 1) eig(m)
	--		2)	eig(m, ComputeEigVec)
	--		3) eig(m, ComputeEigVec, algorithm)
	
	
	local arg=table.pack(...)
	local nargs=#arg
	
	local algorithm="general"
	
	local ComputeEigenVectors=false
	
	assert( type(arg[1])=="Matrix","First arg must be matrix.")

		
	if(nargs==2) then
		assert( type(arg[2])=="boolean","Second arg must be boolean")
		
		ComputeEigenVectors=arg[2]
		
	elseif(nargs==3) then
		assert( type(arg[3])=="string","Second arg must be string")
		
		algorithm=string.lower(arg[3]) 
	end


	if(algorithm=="general") then
		return SYSTEM.eig(arg[1] , ComputeEigenVectors)
	end
	 
end



std.eig=eig


-- Author:	Gokhan Bingol (gbingol@sciencesuit.org)
-- License: Subject to end-user license agreement conditions available at www.sciencesuit.org
