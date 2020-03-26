local scatter={}
local meta={}

setmetatable(scatter, meta)

function meta:__call(x,y,name)
	name=name or ""
	return SYSTEM.plot_scatter(x,y,0,name)
end




function scatter.line(x,y,Name, HasMarker)

	Name=Name or ""
	assert(type(Name)=="string", "Third argument must be of type string")
	
	assert(type(HasMarker)=="boolean" or HasMarker==nil,"If provided third argument must be of type boolean indicating whether there is marker or not")
	
	if(HasMarker==nil) then
		HasMarker=false
	else
		HasMarker=true
	end
	
	if(HasMarker) then
		return SYSTEM.plot_scatter(x,y,2, Name)
	else
		return SYSTEM.plot_scatter(x,y, 1, Name)
	end
	
end



function scatter.smooth(x,y, Name, HasMarker)

	Name=Name or ""
	assert(type(Name)=="string", "Third argument must be of type string")
	
	assert(type(HasMarker)=="boolean" or HasMarker==nil,"If provided third argument must be of type boolean indicating whether there is marker or not")
	
	if(HasMarker==nil) then
		HasMarker=false
	else
		HasMarker=true
	end
	
	if(HasMarker) then
		return SYSTEM.plot_scatter(x,y,4, Name)
	else
		return SYSTEM.plot_scatter(x,y, 3, Name)
	end
	
end
	
	
std.scatter=scatter


function SYSTEM.Meta_Plot:__call(x,y,Name)
	return std.scatter(x,y, Name)
end
