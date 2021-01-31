-- Author:	Gokhan Bingol (gbingol@sciencesuit.org)
-- License: Subject to end-user license agreement conditions available at www.sciencesuit.org

-- Function currently used by Sort dialog


local std <const> =std


local function ColumnNumbertoLetters(num)
	-- Takes a number say 772 and finds equivalent character set, which is ACR for 772
	-- For example Z=26, AA=27, AB=28 ...

	local retStr=""
	local NCharacters=math.ceil(math.log(num)/math.log(26))

	if(NCharacters==1) then 
		local modular=num%26

		if(modular==0) then modular=26 end

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




local function LetterstoColumnNumber(letters)
	--str can be AA, BC, AAC ...

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


local function ConvertWorksheetColumnLabel(arg)
	assert(type(arg)=="string" or (math.type(arg)=="integer" and arg>0), "Arg must be a string (A, B, AA...) or a positive integer")

	if(type(arg)=="string") then 
		return LetterstoColumnNumber(arg)

	elseif(math.type(arg)=="integer") then
		return ColumnNumbertoLetters(arg)
	end

	return nil
end



std.misc.convertwscolumnlabel=ConvertWorksheetColumnLabel
