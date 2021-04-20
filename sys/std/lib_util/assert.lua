local std <const> =std


local function ASSERT(expr, msg)

	local ErrLevel=std.const.ERRORLEVEL
	
	--[[
		if ErrLevel=0, then there is extra info attached
		if ErrLevel=1, then more diagnostics is required by the system
			therefore we return the error to the caller level
	--]]
	
	--dont throw at the current stack
	if(ErrLevel == 1) then
		ErrLevel = 2 --return to caller
	end
	
	if(expr==false) then
		error(msg, ErrLevel)
	end
end


std.util.assert=ASSERT