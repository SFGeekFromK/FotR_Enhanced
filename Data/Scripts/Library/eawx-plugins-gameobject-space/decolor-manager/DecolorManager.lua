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
			Hide_Sub_Object(Object, 1, "main_hull_mesh") -- isd included
			-- corellian corvette
			Hide_Sub_Object(Object, 1, "objCylinder001")
			Hide_Sub_Object(Object, 1, "objFull")
			-- Pelta variants
			Hide_Sub_Object(Object, 1, "objpCube32")
			Hide_Sub_Object(Object, 1, "objLeft")
			Hide_Sub_Object(Object, 1, "objRight")
			--Consular Refit aka consular armed
			Hide_Sub_Object(Object, 1, "Consular_Body_Main_low")
			Hide_Sub_Object(Object, 1, "C70_Main")
			-- invincible engine
			Hide_Sub_Object(Object, 1, "Invincible_Engine")
			
			Hide_Sub_Object(Object, 0, "Gray")

			Hide_Sub_Object(Object, 0, "central_mesh_gray")
			Hide_Sub_Object(Object, 0, "main_hull_mesh_gray")
			
			Hide_Sub_Object(Object, 0, "objFullGray")
			Hide_Sub_Object(Object, 0, "objCylinder001Gray")

			Hide_Sub_Object(Object, 0, "objpCube32Gray")
			Hide_Sub_Object(Object, 0, "objLeftGray")
			Hide_Sub_Object(Object, 0, "objRightGray")

			Hide_Sub_Object(Object, 0, "Consular_Body_Main_low_Gray")
			Hide_Sub_Object(Object, 0, "C70_Main_Gray")

			Hide_Sub_Object(Object, 0, "Invincible_Engine_Gray")
        end
end

return DecolorManager