require("PGStateMachine")
require("PGSpawnUnits")
UnitUtil = require("eawx-util/UnitUtil")


function Definitions()
    DebugMessage("%s -- In Definitions", tostring(Script))

    Define_State("State_Init", State_Init);
end


function State_Init(message)
    if message == OnEnter then	
		if Get_Game_Mode() ~= "Galactic" then
			ScriptExit()
		end
		local phase_one={"Clonetrooper_Phase_One_Team", "ARC_Phase_One_Team", "Republic_74Z_Bike_Company", "Clone_Jumptrooper_Phase_One_Company"}
        local phase_two={"Clonetrooper_Phase_Two_Team", "ARC_Phase_Two_Team", "Republic_BARC_Company", "Clone_Jumptrooper_Phase_Two_Company"}
        for i, unit_type in pairs(phase_one) do
            local despawn_list = Find_All_Objects_Of_Type(unit_type)
            for  _, target in pairs(despawn_list) do
                UnitUtil.ReplaceAtLocation(target, phase_two[i])
            end
        end
		
		ScriptExit()
	end
end
