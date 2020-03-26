-- Author:	Gokhan Bingol (gbingol@hotmail.com)
-- License: Subject to end-user license agreement conditions available at www.sciencesuit.org

--INPUT: 1) eig(m)
--		2)	eig(m, ComputeEigVec)
--		3) eig(m, ComputeEigVec, algorithm)


local function eig(...)
	local arg=table.pack(...)
	local nargs=#arg
	
	local algorithm="general"
	
	local ComputeEigenVectors=false
	
	assert( type(arg[1])=="Matrix","ERROR: First argument must be of type matrix.")

		
	if(nargs==2) then
		assert( type(arg[2])=="boolean","ERROR: Second argument must be of type boolean")
		
		ComputeEigenVectors=arg[2]
		
	elseif(nargs==3) then
		assert( type(arg[3])=="string","ERROR: Second argument must be of type string")
		
		algorithm=string.lower(arg[3]) 
	end


	if(algorithm=="general") then
		return SYSTEM.eig(arg[1] , ComputeEigenVectors)
	end
	 
end

std.eig=eig
