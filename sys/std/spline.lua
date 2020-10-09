-- Author:	Gokhan Bingol (gbingol@sciencesuit.org)
-- License: Subject to end-user license agreement conditions available at www.sciencesuit.org

--This has been updated in C++


local std <const> =std

local function spline(x, y,val)  
    
    --Cubic spline algorithm
    --x and y are vectors and val (single value or vector) is the value where the spline is evaluated

    --Algorithm: Kincaid and Cheney, Numerical Mathematics and Computing 6th Edition, pp:392-393
    
	assert(type(x)=="Vector" and type(y)=="Vector","First two arguments must be vectors" ) 
	  
	assert(lenX==lenY,"ERROR: Size of the vectors do not match" )

	local lenX=std.size(x)
	local lenY=std.size(y)
	local len=lenX
   
	local function spline_coeff()
		
	        local h=std.Vector.new(len-1) --x(i)-x(i-1)
	        local b=std.Vector.new(len-1)

	        for i=1,len-1 do
		        h[i]=x(i+1)-x(i)
			b[i]=1/h(i) * (y(i+1)-y(i))
	        end

	        local u=std.Vector.new(len-2)
	        local v=std.Vector.new(len-2)

	        u[1]=2*(h(1)+h(2))
	        v[1]=6*(b(2)-b(1))

	        for i=2, len-2 do
			u[i]=2*(h(i)+h(i-1))-h(i-1)^2/u(i-1)
			v[i]=6*(b(i)-b(i-1))-(h(i-1)*v(i-1)/u(i-1))
	        end
	       
	        local z=std.Vector.new(len)
	        z[1]=0
	        z[len]=0
	        
	        for i=len-1,2,-1 do
		   tempz=(v(i-1)-h(i-1)*z(i+1))/u(i-1)
		   z[i]=tempz
	        end

	        return z
	end 

	local z=spline_coeff()

	local function spline_eval(xx) --evaluates the spline at a value of xx 
		
		local i=0
		
		for k=len-1,0,-1 do
			i=k
			assert(k>0,"ERROR: Requested value is out of range" )
			
			if(std.abs(xx-x(k))<TOLERANCE) then 
				return y(k) 
			end
			
			if((xx-x(k))>0) then 
				break 
			end
	        end

	        local h=x(i+1)-x(i)
	        local B=-h/6*(z(i+1)+2*z(i))+(y(i+1)-y(i))/h
	        local tmp=z(i)/2+(xx-x(i))*(z(i+1)-z(i))/(6*h)

	        return y(i)+(xx-x(i))*(B+(xx-x(i))*tmp)
	        
	end --spline_eval

	if(type(val)=="number") then
		return spline_eval(val) 
	end
		   
	if(type(val)=="Vector") then
		dim=std.size(val)
		retVec=std.Vector.new(dim)
	        
	        for i=1,dim do
		   retVec[i]=spline_eval(val(i))
	        end
	        
	        return retVec
	end
	   
end

--std.spline=spline
