-- PROGRAMMED BY GOKHAN BINGOL (gbingol@sciencesuit.org)

-- NOTE:THIS FILE WILL BE THE FIRST ONE (AFTER INTERNAL LUA LIBRARIES ARE LOADED) TO BE EXECUTED WHEN SCIENCESUIT LOADS

package.cpath = package.cpath..";./?.dll;"

TOLERANCE=1E-5 -- planned to be removed in the following version


std.app={}
std.app.AllowPreSelection=true


std.gui={}

std.const={}

std.misc={}


std.Array=Array
std.Database=Database
std.Matrix=Matrix
std.Range=Range
std.Vector=Vector
std.Worksheet=Worksheet


Array=nil
Database=nil
Matrix=nil
Range=nil
Vector=nil
Worksheet=nil