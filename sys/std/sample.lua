-- Author:	Gokhan Bingol (gbingol@hotmail.com)
-- License: Subject to end-user license agreement conditions available at www.sciencesuit.org

local function SAMPLE(SampleSpace, n, replacement)
	--Used for sampling numbers from a Vector

	if(replacement==nil) then
		replacement=false
	end
	
	
	assert(type(SampleSpace)=="Vector","First argument (x) must be of type vector" ) 
	assert(math.type(n)=="integer" and n>0,"Second argument (size) must be a positive integer") 
	assert(type(replacement)=="boolean","Third argument (replace), must be type boolean") 


	local retVec=Vector.new(n)

	if(replacement==true) then
		
		local dim=#SampleSpace
		for i=1,n do
			local index=math.random(1,dim)
			retVec[i]=SampleSpace(index)
		end
		


	elseif(replacement==false) then
		assert(n<=#SampleSpace,"If replacement is false you cannot request to have more than the number of elements in the vector") 
				
		local v=SampleSpace[{}] --clone
		v:shuffle() --randomize the cloned space

		for i=1,n do
			retVec[i]=v(i)
		end
		
	end



	if(#retVec==1) then
		return retVec[1]
	else
		return retVec
	end
	
end  




local function sample(...)
	local arg=table.pack(...)

	assert(#arg>=2 or type(arg[1])=="table", "ERROR: At least 2 arguments or a single argument of type table must be supplied")
	
	if(#arg==1 and type(arg[1])=="table") then
		
		local v, n, replace=nil, nil, false
		local NTblArgs=0

		for key,value in pairs(arg[1]) do
			
			local key=string.lower(key)
			
			if(key=="x") then v=value
			elseif(key=="size") then n=value
			elseif(key=="replace") then replace=value
			
			else 
				error("ERROR: Signature: {x=, size=, replace=false}", ERRORLEVEL)
			end

			NTblArgs=NTblArgs+1

		end
		
		assert(NTblArgs>0, "ERROR: Signature: {x=, size=, replace=false}")

		return SAMPLE(v, n, replace)



	elseif (#arg==2 or #arg==3) then
		return SAMPLE(arg[1],arg[2],arg[3])
	

	else
		error("ERROR: Signature: {x=, size=, replace=false} OR (x=, size=, replace=false)", ERRORLEVEL)
	end


end




std.sample=sample
     
