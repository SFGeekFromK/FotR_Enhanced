require("deepcore/std/class")
require("deepcore/crossplot/crossplot")
require("eawx-util/GalacticUtil")
require("eawx-util/UnitUtil")

---@class DevastatorHandler
DevastatorHandler = class()

---@param galactic_display DisplayComponentContainer
function DevastatorHandler:new(galactic_display, gc)
    ---@private
    ---@type NewsFeedDisplayComponent
    self.initialized = false
    self.news_feed = galactic_display:get_component("news_feed")
    self.WinningEmpire = Find_Player("Empire")
    self.HumanPlayer = Find_Player("local")
    self.ReplaceChance = 5
    self.CurrentDevastator = nil
    self.CurrentLifecycle = false
    self.SecondChanceUsed = false
    self.StageMultiplier = 100

    if GetCurrentTime() < 5 and GlobalValue.Get("REGIME_INDEX") == 4 then
        self.CurrentLifecycle = true
    end

    self.DevastatorTable = {
        {"KLEV_FRIGATE_DEVASTATOR", "KLEV_CAPITAL_DEVASTATOR", "KLEV_BATTLECRUISER_DEVASTATOR"},
        {"WORLD_DEVASTATOR_FRIGATE", "WORLD_DEVASTATOR_CAPITAL", "WORLD_DEVASTATOR_BATTLECRUISER"}
    }

    for _, devastator_table in pairs(self.DevastatorTable) do
        for _, devastator in pairs(devastator_table) do
            GlobalValue.Set(devastator, 0)
        end
    end

    if Find_Player("EMPIRE").Is_Human() or Find_Player("PENTASTAR").Is_Human() or Find_Player("ERIADU_AUTHORITY").Is_Human() or Find_Player("ZSINJ_EMPIRE").Is_Human() or Find_Player("GREATER_MALDROOD").Is_Human() then
        gc.Events.TacticalBattleEnded:attach_listener(self.on_battle_end, self)
    end

    crossplot:subscribe("IMPERIAL_REMNANT_DECIDED", self.DetermineRemnant, self)
end

function DevastatorHandler:DetermineRemnant()
    --Logger:trace("entering DevastatorHandler:DetermineRemnant")
    self.WinningEmpire = Find_Player(GlobalValue.Get("IMPERIAL_REMNANT"))
end

function DevastatorHandler:update()
    if self.initialized == false then
        self.initialized = true
        return
    end

    --Logger:trace("entering DevastatorHandler:update")
    local previous_lifecycle = self.CurrentLifecycle
    self.CurrentLifecycle = false

    if self.HumanPlayer ~= self.WinningEmpire then
        local chance = 100
        if self.WinningEmpire.Get_Difficulty() == "Easy" then
            chance = 200
        elseif self.WinningEmpire.Get_Difficulty() == "Hard" then
            chance = 50
        end

        if GlobalValue.Get("CRUEL_ON") == 1 then
            chance = chance / 2
        end

        local previous_devastator = self.CurrentDevastator
        for _, devastator_table in pairs(self.DevastatorTable) do
            for i, devastator in pairs(devastator_table) do
                if i < 3 then
                    if TestValid(Find_First_Object(devastator)) then
                        self.CurrentDevastator = devastator
                        self.CurrentLifecycle = true
                        if self.CurrentDevastator == previous_devastator then
                            local roll = GameRandom.Free_Random(1, chance)

                            if roll <= self.ReplaceChance then
                                self.ReplaceChance = 5
                                UnitUtil.ReplaceAtLocation(devastator, devastator_table[i+1])
                                GlobalValue.Set(devastator, 0)

                                if i+1 == 3 then
                                    UnitUtil.SpawnAtObjectLocation(devastator_table[i+1], "WORLD_DEVASTATOR_FRIGATE")
                                end
                                break
                            else
                                self.ReplaceChance = self.ReplaceChance + 5
                            end
                        end
                    end
                end
            end
        end
    end

    if TestValid(Find_First_Object("Umak_Leth")) == false then
        return
    end

    if self.HumanPlayer == self.WinningEmpire and self.SecondChanceUsed == false then
        for _, devastator_table in pairs(self.DevastatorTable) do
            for i, devastator in pairs(devastator_table) do
                if i < 3 then
                    if TestValid(Find_First_Object(devastator)) then
                        self.CurrentLifecycle = true
                        break
                    end
                end
            end
        end
    end

    if self.CurrentLifecycle == true or self.SecondChanceUsed == true then
        self.WinningEmpire.Lock_Tech(Find_Object_Type("World_Devastator_Frigate"))
    end

    if self.CurrentLifecycle == false and previous_lifecycle == true and self.SecondChanceUsed == false then
        self.WinningEmpire.Unlock_Tech(Find_Object_Type("World_Devastator_Frigate"))
        self.SecondChanceUsed = true

        if self.HumanPlayer == self.WinningEmpire then
            self.news_feed:post {
                headline = "TEXT_WORLD_DEVASTATOR_LIFECYCLE",
                color = {r = 244, g = 244, b = 0}
            }
        end
    end
end

function DevastatorHandler:on_battle_end()
    --Logger:trace("entering DevastatorHandler:on_battle_end")
    for _, devastator_table in pairs(self.DevastatorTable) do
        for i, devastator in pairs(devastator_table) do
            if i < 3 then
                local current_materials = GlobalValue.Get(devastator)
                local target_materials = i * self.StageMultiplier
                local net_materials = current_materials - target_materials
                
                if net_materials >= 0 then
                    local devastatorObject = Find_First_Object(devastator)
    
                    if not TestValid(devastatorObject) then
                        GlobalValue.Set(devastator, 0)
                        break
                    end
    
                    local devastatorOwner = devastatorObject.Get_Owner()
    
                    local devastatorLocation = devastatorObject.Get_Planet_Location()
                    if not devastatorLocation then
                        devastatorLocation = StoryUtil.FindFriendlyPlanet(devastatorOwner, true)
                    end
                    if not devastatorLocation then
                        break
                    end

                    devastatorObject.Despawn()
                    SpawnList({devastator_table[i+1]}, devastatorLocation, devastatorOwner, true, false)
                    GlobalValue.Set(devastator, 0)

                    local max_carryover = (3 - i) * self.StageMultiplier / 2

                    if net_materials > max_carryover then
                        net_materials = max_carryover
                    end

                    local devastatorNews = "TEXT_WORLD_DEVASTATOR_GROWTH_BATTLECRUISER"

                    if i == 1 then
                        devastatorNews = "TEXT_WORLD_DEVASTATOR_GROWTH_DESTROYER"
                        GlobalValue.Set(devastator_table[i+1], net_materials)
                    else
                        SpawnList({"WORLD_DEVASTATOR_FRIGATE"}, devastatorLocation, devastatorOwner, true, false)
                        GlobalValue.Set("WORLD_DEVASTATOR_FRIGATE", net_materials)    
                    end
    
                    self.news_feed:post {
                        headline = devastatorNews,
                        var = devastatorLocation,
                        color = {r = 244, g = 244, b = 0}
                    }
                    break
                end
            end
        end
    end
end
