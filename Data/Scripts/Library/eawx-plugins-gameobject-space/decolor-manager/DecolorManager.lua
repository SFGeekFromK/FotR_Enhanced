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
			Hide_Sub_Object(Object, 1, "Origin")
			Hide_Sub_Object(Object, 1, "central_mesh") -- victory varinats
			Hide_Sub_Object(Object, 1, "main_hull_mesh") --victory variants
			
			Hide_Sub_Object(Object, 0, "Gray")
			Hide_Sub_Object(Object, 0, "central_mesh_gray")
			Hide_Sub_Object(Object, 0, "main_hull_mesh_gray")
        end
end

return DecolorManager