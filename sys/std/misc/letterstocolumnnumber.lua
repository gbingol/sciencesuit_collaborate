--- Author:	Gokhan Bingol (gbingol@sciencesuit.org)
-- License: Subject to end-user license agreement conditions available at www.sciencesuit.org

-- Function currently used by Sort dialog

local std <const> =std


local function LetterstoColumnNumber(letters)
	--str can be AA, BC, AAC ...
	
	assert(type(letters)=="string", "ERROR: Argument must be of type string")

	local str=letters
	string.upper(str) --convert to upper case
	
	local retNum=0

	local len=string.len(str)
	local n=0

	for i=len,1,-1 do
		local c=string.byte(str,i)
		local val=c-65+1

		retNum=retNum+26^n*val

		n=n+1
	end


	return retNum;
end

SYSTEM.MISC.LetterstoColumnNumber=LetterstoColumnNumber