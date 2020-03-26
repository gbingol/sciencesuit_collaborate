-- Author:	Gokhan Bingol (gbingol@hotmail.com)
-- License: Subject to end-user license agreement conditions available at www.sciencesuit.org

-- Function currently used by Sort dialog

local function LetterstoColumnNumber(letters)
	--str can be AA, BC, AAC ...
	if(type(letters)~="string") then error("ERROR: Argument must be of type string" , ERRORLEVEL) end
	str=letters
	string.upper(str) --convert to upper case
	retNum=0
	len=string.len(str)
	n=0
	for i=len,1,-1 do
		c=string.byte(str,i)
		val=c-65+1;
		retNum=retNum+26^n*val
		n=n+1
	end

	return retNum;
end

SYSTEM.MISC.LetterstoColumnNumber=LetterstoColumnNumber