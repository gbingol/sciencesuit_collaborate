-- Author:	Gokhan Bingol (gbingol@sciencesuit.org)
-- License: Subject to end-user license agreement conditions available at www.sciencesuit.org

local function meshgrid( x, y)
	-- Places two row vectors on a grid on the xy-plane.
	-- The length of the grid in the x-axis is defined by the column number of the CRowVector x
	-- The length of the grid in the y-axis is determined by the column number of the CRowVector y
	-- x = [1   2   3]; y=[4 5 6 7]

	-- meshgrid (x,y)
	-- X =                 Y =
	--  1   2   3               4   4   4
	--  1   2   3               5   5   5
	--  1   2   3               6   6   6
	--  1   2   3               7   7   7

	assert(type(x)=="Vector" and type(y)=="Vector","ERROR: Arguments must be of type Vector") 

	local row, col=#y, #x
	local X, Y=Matrix.new(row, col) , Matrix.new(row, col)

	for i=1,row do
		for j=1, col do
			X[i][j]=x(j)
			Y[i][j]=y(i)
		end
	end

	return X, Y

end

std.meshgrid=meshgrid
