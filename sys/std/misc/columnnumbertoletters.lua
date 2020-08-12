-- Author:	Gokhan Bingol (gbingol@sciencesuit.org)
-- License: Subject to end-user license agreement conditions available at www.sciencesuit.org

-- Function currently used by Sort dialog


local std <const> =std


local function ColumnNumbertoLetters(num)
	-- Takes a number say 772 and finds equivalent character set, which is ACR for 772
	-- For example Z=26, AA=27, AB=28 ...

	assert(math.type(num)=="integer" and num>0, "ERROR: The number must be a positive integer")


	local retStr=""
	local NCharacters=ceil(log(num)/log(26))

	if(NCharacters==1) then 
		local modular=num%26

		if(modular==0) then 
			modular=26 
		end

		retStr=retStr..string.char(65+modular-1) 

		return retStr
	end


	local val=num

	for i=1,NCharacters-1 do
		val=val/26
		retStr=string.char(65+floor(val)%26-1)..retStr
	end

	retStr=retStr..string.char(65+num%26-1)


	return retStr
end


SYSTEM.MISC.ColumnNumbertoLetters=ColumnNumbertoLetters