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
			Hide_Sub_Object(Object, 0, "Gray")
        end
end

return DecolorManager