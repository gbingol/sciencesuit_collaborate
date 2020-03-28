-- PROGRAMMED BY GOKHAN BINGOL (gbingol@sciencesuit.org)

-- NOTE:THIS FILE WILL BE THE FIRST ONE (AFTER INTERNAL LUA LIBRARIES ARE LOADED) TO BE EXECUTED WHEN SCIENCESUIT LOADS

package.cpath = package.cpath..";./?.dll;./?.so;../lib/?.so;../lib/vc_dll/?.dll;../lib/bcc_dll/?.dll;../lib/mingw_dll/?.dll;"

TOLERANCE=1E-5 -- planned to be removed in the following version

--Interprocess Communication Port Number, recommended (1000,60000). Used by ScienceSuit to respond to clicking a lua or ssp file from filemanager of OS.
IPCPORTNUMBER=-1 

 --Just return error message. If more diagnostic is required, such as at which line the error occured, then set it to 1.
ERRORLEVEL=0     


SYSTEM={}
SYSTEM.__name="SYSTEM"

SYSTEM.Meta_Plot={} --metatable of std.plot



std={}
std.__name="std"


std.app={}
std.app.__name="std.app"


std.gui={}
std.gui.__name="std.gui"


std.plot={}
std.plot.__name="std.plot"

setmetatable(std.plot, SYSTEM.Meta_Plot)


std.misc={}
std.misc.__name="std.misc"


--CONSTANTS
std.const={tolerance=1E-5} 
std.const.__name="std.const"

std.const.font={style_italic="italic",style_normal="normal",
				weight_bold="bold", weight_normal="normal",
				underline_single="single", underline_none="none"}


std.const.color={white="255 255 255", red="255 0 0", red_dark="139 0 0", lime="0 255 0", blue="0 0 255", yellow="255 255 0",
                 aqua="0 255 255", fuchsia="255 0 255", silver="192 192 192", gray="128 128 128", maroon="128 0 0",
                 olive="128 128 0", green="0 128 0", purple="128 0 128", teal="0 128 128", navy="0 0 128",
                 maroon="128 0 0", brown="165 42 42", crimson="220 20 60", salmon_dark="233 150 122",
                 salmon="250 128 114" , salmon_light="255 160 122", orange_red="255 69 0", orange_dark="255 140 0", orange="255 165 0",
                 chocolate="210 105 30", tan="210 180 140", brown_saddle="139 69 19", wheat="245 222 179", orchid="218 112 214",
                 indigo="75 0 130", blue_medium="0 0 205", blue_royal="65 105 225", blue_midnight="25 25 112" }



--Computer Vision Library Constants and Some Functions
std.const.cv={CV_8U=0, CV_8S=1, CV_16U=2, CV_16S=3,CV_32S=4, CV_32U=5,IMREAD_COLOR=1, IMREAD_GRAYSCALE=0, IMREAD_UNCHANGED=-1} 
std.const.cv.__name="std.const.cv"

