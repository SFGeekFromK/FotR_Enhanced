--*****************************************************--
--******** Outer Rim Sieges: Blockade Bypass **********--
--*****************************************************--

require("PGStateMachine")
require("PGStoryMode")
require("PGSpawnUnits")
require("PGMoveUnits")
require("eawx-util/StoryUtil")
require("eawx-util/MissionFunctions")

function Definitions()
    DebugMessage("%s -- In Definitions", tostring(Script))

    StoryModeEvents = {

    }
end

function Begin_Battle(message)
    if message == OnEnter then
        
    end
end