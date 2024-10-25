require("deepcore/std/class")

DecolorManager = class()

function DecolorManager:new()
	if Get_Game_Mode() ~= "Space" then
		ScriptExit()
	elseif Object.Get_Owner() ~= Find_Player("Empire") then
		return
	end
		local team_Color = GlobalValue.Get("SHIPS_DECOLORED")

		if team_Color == 1 then
			-- general mesh names
			Hide_Sub_Object(Object, 1, "Origin")
			-- victory varinats
			Hide_Sub_Object(Object, 1, "central_mesh") 
			Hide_Sub_Object(Object, 1, "main_hull_mesh")
			-- corellian corvette
			Hide_Sub_Object(Object, 1, "objCylinder001")
			Hide_Sub_Object(Object, 1, "objFull")
			
			
			Hide_Sub_Object(Object, 0, "Gray")

			Hide_Sub_Object(Object, 0, "central_mesh_gray")
			Hide_Sub_Object(Object, 0, "main_hull_mesh_gray")
			
			Hide_Sub_Object(Object, 0, "objFullGray")
			Hide_Sub_Object(Object, 0, "objCylinder001Gray")
        else 
			-- general mesh names
			Hide_Sub_Object(Object, 0, "Origin")
			-- victory varinats
			Hide_Sub_Object(Object, 0, "central_mesh") 
			Hide_Sub_Object(Object, 0, "main_hull_mesh")
			-- corellian corvette
			Hide_Sub_Object(Object, 0, "objCylinder001")
			Hide_Sub_Object(Object, 0, "objFull")
			
			
			Hide_Sub_Object(Object, 1, "Gray")

			Hide_Sub_Object(Object, 1, "central_mesh_gray")
			Hide_Sub_Object(Object, 1, "main_hull_mesh_gray")
			
			Hide_Sub_Object(Object, 1, "objFullGray")
			Hide_Sub_Object(Object, 1, "objCylinder001Gray")
		end
end

return DecolorManager