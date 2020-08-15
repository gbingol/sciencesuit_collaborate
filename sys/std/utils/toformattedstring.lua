-- Author:	Gokhan Bingol (gbingol@sciencesuit.org)
-- License: Subject to end-user license agreement conditions available at www.sciencesuit.org


local std <const> =std

local function ToFormattedString(Entry)
	
	--Most of the time formatted output is needed
	--This is a utility function to assist in general formatting
	
	if(type(Entry)=="string") then
		return Entry
	end
	
	if(math.type(Entry)=="integer")  then
		return tostring(Entry)
	end


	-- Note that this is intentionally not the first line of guard
	assert(type(Entry)=="number", "ERROR: Entry must be of type number")

	if(Entry>-0.1 and Entry<0.1) then
		return string.format("%.5f", Entry)
		
	elseif(Entry>-1 and Entry<1) then
		return string.format("%.4f", Entry)
	
	elseif(Entry>-10 and Entry<10) then
		return string.format("%.3f", Entry)
	
	elseif(Entry>-100 and Entry<100) then
		return string.format("%.2f", Entry)
		
	elseif(Entry>-1000 and Entry<1000) then
		return string.format("%.1f", Entry)
	
	else
		return string.format("%.0f", Entry)
	end
end


std.toformattedstring=ToFormattedString
