require( "iuplua" )


local std <const> =std
local iup <const> =iup


local function makeicon(fullpath)
	assert(type(fullpath)=="string", "ERROR: Argument must be of type string")

	pixelvals, width, height=SYSTEM.makeicon(fullpath)

	return iup.imagergb{width = width, height = height, pixels=pixelvals}
end



std.gui.makeicon=makeicon



-- Author:	Gokhan Bingol (gbingol@sciencesuit.org)
-- License: Subject to end-user license agreement conditions available at www.sciencesuit.org