require("eawx-util/StoryUtil")
require("eawx-util/UnitUtil")
require("PGStoryMode")
require("PGSpawnUnits")
require("SetFighterResearch")

return {
    on_enter = function(self, state_context)
        --Logger:trace("entering fotr-progressive-era-five:on_enter")

        GlobalValue.Set("CURRENT_ERA", 5)

        self.HoldoutEvent = false

        self.Active_Planets = StoryUtil.GetSafePlanetTable()
        self.entry_time = GetCurrentTime()
        self.StaticFleets = false
        self.MandaloreFired = false
        self.AI_Active = true


        if self.entry_time <= 5 then
            if Find_Player("local") == Find_Player("Empire") then
                StoryUtil.Multimedia("TEXT_STORY_INTRO_PROGRESSIVE_REPUBLIC_PALPATINE_ERA_4", 15, nil, "PalpatineFotR_Loop", 0)
            elseif Find_Player("local") == Find_Player("Rebel") then

                StoryUtil.Multimedia("TEXT_STORY_INTRO_PROGRESSIVE_CIS_DOOKU_ERA_4", 15, nil, "Dooku_Loop", 0)
            end

			Set_Fighter_Hero("ODD_BALL_ARC170_SQUAD_SEVEN_SQUADRON", "YULAREN_INTEGRITY")

            self.StaticFleets = true
            self.AI_Active = false
            self.Starting_Spawns = require("eawx-mod-fotr/spawn-sets/EraFiveStartSet")
            for faction, herolist in pairs(self.Starting_Spawns) do
                for planet, spawnlist in pairs(herolist) do
                    StoryUtil.SpawnAtSafePlanet(planet, Find_Player(faction), self.Active_Planets, spawnlist)  
                end
            end

			Find_Player("Rebel").Lock_Tech(Find_Object_Type("Grievous_Team_Malevolence_Recusant"))
			Find_Player("Rebel").Lock_Tech(Find_Object_Type("Grievous_Team_Malevolence_Providence"))

		else
			-- self.Starting_Spawns = require("eawx-mod-fotr/spawn-sets/EraFiveProgressSet")
            -- for faction, herolist in pairs(self.Starting_Spawns) do
            --     for planet, spawnlist in pairs(herolist) do
            --         StoryUtil.SpawnAtSafePlanet(planet, Find_Player(faction), self.Active_Planets, spawnlist)  
            --     end
            -- end
			
			crossplot:publish("ERA_FIVE_TRANSITION", "empty")
        end
    end,
    on_update = function(self, state_context)
        local current = GetCurrentTime() - self.entry_time
        local player = nil
        local p_human = Find_Player("local")
        if (current >=10) and (self.AI_Active == false) then
            self.AI_Active = true
            crossplot:publish("INITIALIZE_AI", "empty")
        end
        if (current >=20) and (self.StaticFleets == true) then
            self.StaticFleets = false
            local static_spawns = require("eawx-mod-fotr/spawn-sets/EraTwoStaticFleetSet")

            for metafaction, factions in pairs(static_spawns) do
                if p_human ~= Find_Player(metafaction) then
                    for faction, unitlist in pairs(factions) do
                        player = Find_Player(faction)
                        for planet, spawnlist in pairs(unitlist) do
                            if self.Active_Planets[planet] then
                                StoryUtil.SpawnAtSafePlanet(planet, player, self.Active_Planets, spawnlist, false)  
                            end
                        end
                    end
                end
            end

            crossplot:publish("VENATOR_RESEARCH_FINISHED", "empty")
            crossplot:publish("PHASE_TWO_RESEARCH_FINISHED", "empty")
            crossplot:publish("BULWARK_RESEARCH_FINISHED", "empty")
            crossplot:publish("VICTORY_RESEARCH_FINISHED", "empty")
            -- FotR_Enhanced
            crossplot:publish("GEEN_UNLOCK", "empty")
        end

        if self.Active_Planets["MANDALORE"] and self.MandaloreFired == false then
			if FindPlanet("Mandalore").Get_Owner() == Find_Player("REBEL") and (current >= 40) then
				crossplot:publish("CIS_MANDALORE_SUPPORT_START", "empty")
                self.MandaloreFired = true
			end
		end

    end,
    on_exit = function(self, state_context)
    end
}
