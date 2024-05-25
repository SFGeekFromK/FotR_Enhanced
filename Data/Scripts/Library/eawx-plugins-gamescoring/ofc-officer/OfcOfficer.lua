require("PGBase")
require("PGSpawnUnits")
require("deepcore/std/class")
require("deepcore/crossplot/crossplot")
Officer_Table = require("OfcOfficerList")
StoryUtil = require("eawx-util/StoryUtil")
UnitUtil = require("eawx-util/UnitUtil")

---@class OfcOfficer
OfcOfficer = class()

function OfcOfficer:new()
    StoryUtil.ShowScreenText("OFC Officer Updating", 10)
    self.player_name = "Empire"
    self.player = Find_Player("Empire")
    self.is_tactical = false
    self.position = nil
    self.spawn_buff = false
    self.active_buff = nil

    crossplot:subscribe("GAME_MODE_STARTING", self.mode_start, self)
    crossplot:subscribe("GAME_MODE_ENDING", self.battle_end, self)

end

function OfcOfficer:update()
    if self.is_tactical then
        if self.position == nil then
            self.position = Find_First_Object("Attacker Entry Position").Get_Position()
        end
        if self.position and self.spawn_buff == true then
            self.active_buff = Create_Generic_Object("OFC_OFFICER_BUFF", self.position, self.player)
        end
        if not TestValid(self.active_buff) then
            self.active_buff = nil
        end
    end
end

function OfcOfficer:mode_start(mode)

    if mode == "Space" then 
        StoryUtil.ShowScreenText("Is Space Tactical", 10)
        self.is_tactical = true
        


    else
        self.is_tactical = false
        self.position = nil 
        self.spawn_buff = nil 
    end
end

function OfcOfficer:battle_end(mode)

    if mode == "Space" then 
        self.is_tactical = false
        self.position = nil
    end
  
end

return OfcOfficer