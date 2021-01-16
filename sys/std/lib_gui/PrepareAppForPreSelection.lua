-- Author:	Gokhan Bingol (gbingol@sciencesuit.org)
-- License: Subject to end-user license agreement conditions available at www.sciencesuit.org


local std <const> =std
local iup <const> =iup


local function PrepareAppForPreSelection_Userdata(... )

	local args=table.pack(...)

	local nargs=#args


	local MainRange=std.activeworksheet():selection()

	
	if(nargs==1) then
		local txtInput=args[1] 

		assert(type(txtInput)=="userdata", "Entry must be userdata")
		
		txtInput.value=tostring(MainRange)
		
		return
	end
	



	if(MainRange:ncols() ~= nargs) then
		return
	end

		
	for i=1, nargs do
		
		local txtInput=args[i] 

		assert(type(txtInput)=="userdata", "Entries must be userdata")
	
		local SubRange=MainRange:col(i)
		
		if(SubRange==nil) then
			return
		end
		
		
		txtInput.value=tostring(SubRange) 
		
	end
end







local function PrepareAppForPreSelection_Table(... )

	
	local args=table.pack(...)

	local nargs=#args


	local MainRange=std.activeworksheet():selection()


	for i=1, nargs do
		
		local UserTable=args[i] 

		assert(type(UserTable) == "table", "Entries must be table")
	
		local txtInput=UserTable.txt
		
		local TL_Row=UserTable.row
		local TL_Col=UserTable.col
		
		local nrows=UserTable.nrows
		local ncols=UserTable.ncols
		
		local SubRange=MainRange:subrange({r=TL_Row, c=TL_Col}, nrows, ncols)
		
		if(SubRange==nil) then
			return
		end
		
		
		txtInput.value=tostring(SubRange) 
		
	end
end






local function PrepareAppForPreSelection(... )

	if(std.app.AllowPreSelection == false)  then
		return
	end

	
	local args=table.pack(...)

	local nargs=#args


	local MainRange=std.activeworksheet():selection()

	if(MainRange == nil) then
		return
	end
	

	if(type(args[1]) == "userdata") then
		PrepareAppForPreSelection_Userdata(table.unpack(args))
		
	elseif(type(args[1]) == "table") then
		PrepareAppForPreSelection_Table(table.unpack(args))
		
	else
		error("Args must be table or userdata")
	end


end


std.gui.PrepareAppForPreSelection=PrepareAppForPreSelection