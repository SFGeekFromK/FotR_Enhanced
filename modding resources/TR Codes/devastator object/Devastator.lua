require("PGCommands")
require("TRCommands")
require("eawx-util/StoryUtil")
require("deepcore/std/class")
require("deepcore/crossplot/crossplot")

---@class Devastator
Devastator = class()

function Devastator:new()
    if Find_Player("local") == Object.Get_Owner() then
        self.enabled = true
    else
        self.enabled = false
        return
    end

    self.DevastatorID = Object.Get_Type().Get_Name()
    self.target_reached = false

    crossplot:subscribe("TACTICAL_UNIT_DESTROYED", self.object_detroyed, self)

    local StageMultiplier = 100

    self.target_materials = StageMultiplier
    if self.DevastatorID == "KLEV_CAPITAL_DEVASTATOR" or self.DevastatorID == "WORLD_DEVASTATOR_CAPITAL" then
        self.target_materials = self.target_materials * 2
    end

    StoryUtil.ShowScreenText("World Devastator online. Current materials: "..GlobalValue.Get(self.DevastatorID).." of "..self.target_materials.." to grow.", 10)
end

function Devastator:object_detroyed(object_name, object_power, object_is_hero)
    if self.enabled ~= true then
        return
    end

    local current_materials = GlobalValue.Get(self.DevastatorID)

    local clampmax = 50
    if object_is_hero then
        object_power = object_power * 2
        clampmax = 60
    end

    local added_materials = Clamp(tonumber(Dirty_Floor((object_power + 150) / 300)),1,clampmax)

    current_materials = current_materials + added_materials

    GlobalValue.Set(self.DevastatorID, current_materials)

    Object.Attach_Particle_Effect("World_Devastator_Particle")

    StoryUtil.ShowScreenText("Materials +" .. tostring(added_materials) .. " (Total: " .. tostring(current_materials)..")", 10)

    if current_materials >= self.target_materials and self.target_reached ~= true then
        StoryUtil.ShowScreenText("Materials target reached. The World Devastator will grow after this battle, if it survives.", 20)
        self.target_reached = true
    end
end

return Devastator
