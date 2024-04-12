require("deepcore/std/class")
require("deepcore/crossplot/crossplot")
require("eawx-util/GalacticUtil")
require("eawx-util/ChangeOwnerUtilities")
require("PGSpawnUnits")
require("TRCommands")
StoryUtil = require("eawx-util/StoryUtil")
UnitUtil = require("eawx-util/UnitUtil")
require("UnitSwitcherLibrary")
require("eawx-util/Sort")

---@class GovernmentEmpire
GovernmentEmpire = class()

function GovernmentEmpire:new(gc, absorb, dark_empire, id)
    self.PlayerEmpire = Find_Player("Empire")
    self.PlayerPentastar = Find_Player("Pentastar")
    self.PlayerMaldrood = Find_Player("Greater_Maldrood")
    self.PlayerZsinj = Find_Player("Zsinj_Empire")
    self.PlayerEriadu = Find_Player("Eriadu_Authority")
    self.LegitimacyAbsorb = 3
    self.StartingEra = GlobalValue.Get("CURRENT_ERA")
    self.Unit_List = require("hardpoint-lists/PersistentLibrary")
    self.StartingEmpires = 0    

    self.id = id

    GlobalValue.Set("IMPERIAL_REMNANT", "EMPIRE")

    self.DarkEmpirePlanetBasedOnlyThreshold = table.getn(FindPlanet.Get_All_Planets())/2

    if absorb then 
        self.LegitimacyAbsorb = absorb
    end

    self.imperial_table = {
        ["EMPIRE"] = {
            legitimacy = 25,
            controls_planets = false,
            percentile_legitimacy = 0,
            factions_integrated = 0,
            is_integrated = false,
            next_tier = 1,
            failed_rolls = 0,
            max_unlocked = false,
            joined_groups = {},
            destruction_unlocks = {"Imperial_Stormtrooper_Squad"},
            destruction_unlock_descs = {"TEXT_GOVERNMENT_EMPIRE_INTEGRATION_REWARD_STORMTROOPER"},
            heroes_killed_since_last_roll = 0,
            integrate_value = 2
        },
        ["PENTASTAR"] = {
            legitimacy = 25,
            controls_planets = false,
            percentile_legitimacy = 0,
            factions_integrated = 0,
            is_integrated = false,
            next_tier = 1,
            failed_rolls = 0,
            max_unlocked = false,
            joined_groups = {},
            destruction_unlocks = {"PellaeonUpgrade"},
            destruction_unlock_descs = {"TEXT_GOVERNMENT_EMPIRE_INTEGRATION_REWARD_PELLAEON_REAPER"},
            heroes_killed_since_last_roll = 0,
            integrate_value = 1
        },
        ["GREATER_MALDROOD"] = {
            legitimacy = 25,
            controls_planets = false,
            percentile_legitimacy = 0,
            factions_integrated = 0,
            is_integrated = false,
            next_tier = 1,
            failed_rolls = 0,
            max_unlocked = false,
            joined_groups = {},
            destruction_unlocks = {"Crimson_Victory"},
            destruction_unlock_descs = {"TEXT_GOVERNMENT_EMPIRE_INTEGRATION_REWARD_CCVSD"},
            heroes_killed_since_last_roll = 0,
            integrate_value = 1
        },
        ["ZSINJ_EMPIRE"] = {
            legitimacy = 25,
            controls_planets = false,
            percentile_legitimacy = 0,
            factions_integrated = 0,
            is_integrated = false,
            next_tier = 1,
            failed_rolls = 0,
            max_unlocked = false,
            joined_groups = {},
            destruction_unlocks = {"Imperial_Defiler_Squad"},
            destruction_unlock_descs = {},
            zann_unlocked = false,
            heroes_killed_since_last_roll = 0,
            integrate_value = 1
        },
        ["ERIADU_AUTHORITY"] = {
            legitimacy = 25,
            controls_planets = false,
            percentile_legitimacy = 0,
            factions_integrated = 0,
            is_integrated = false,
            next_tier = 1,
            failed_rolls = 0,
            max_unlocked = false,
            joined_groups = {},
            destruction_unlocks = {"DaalaUpgrade"},
            destruction_unlock_descs = {"TEXT_GOVERNMENT_EMPIRE_INTEGRATION_REWARD_DAALA_KNIGHT_HAMMER"},
            heroes_killed_since_last_roll = 0,
            integrate_value = 1
        }
    }
	
	--SSD heroes who are leaders do not need to be on this list
	self.leader_table = {
		-- Green Empire leaders
		["PESTAGE_TEAM"] = {"SATE_PESTAGE"}, ["YSANNE_ISARD_TEAM"] = {"YSANNE_ISARD"},
		"HISSA_MOFFSHIP", "THRAWN_CHIMAERA", "FLIM_TIERCE_IRONHAND",
		-- Green Empire heroes with warlord trait
		"HARRSK_WHIRLWIND", "HARRSK_SHOCKWAVE", "KRENNEL_WARLORD", "NORYM_KIM_BLOOD_GAINS", "TETHYS_CALLOUS",
		["SHARGAEL_TEAM"] = {"SHARGAEL_AT_TE"},
		
		-- Pentastar leaders
		["JEREC_TEAM"] = {"JEREC"}, ["ARDUS_KAINE_TEAM"] = {"ARDUS_KAINE"},
		
		-- Greater Maldrood leaders
		"TREUTEN_13X", "TREUTEN_CRIMSON_SUNRISE", "KOSH_LANCET",
		
		-- Zsinj's Empire leaders
		"ZSINJ_IRON_FIST_VSD",
		-- Zsinj's Empire heroes with warlord trait
		"SCREED_DEMOLISHER", "SLAGORTH_ARC",
		
		-- Eriadu Authority leaders
		"DELVARDUS_THALASSA", "DELVARDUS_BRILLIANT",
		
		-- Legitimacy group heroes with warlord trait
		"DELURIN_GALAXY_DRAGON", "NICLARA_PULSARS_REVENGE", "PRENTIOCH_PRENTIOCH", "LANKIN_KNIGHT", "YZU_CONSTITUTION",
		["NIVERS_TEAM"] = {"NIVERS_AT_AT_WALKER"}, ["GANN_TEAM"] = {"GANN_JUGGERNAUT_A6"}, ["FOGA_BRILL_TEAM"] = {"FOGA_BRILL"},
		
		-- Legitimacy winner leaders
		["EMPEROR_PALPATINE_TEAM"] = {"EMPEROR_PALPATINE"}, ["CARNOR_JAX_TEAM"] = {"CARNOR_JAX"}, 
		"DAALA_GORGON", "PELLAEON_GRAND_CHIMAERA"
	}

	--SSD heroes need to be on *this* list whether or not they are leaders
    self.hero_ssd_table = {
        ["ISARD_LUSANKYA"] = "TEXT_GOVERNMENT_EMPIRE_SSD_LEADER_ISARD",
		["NIGHT_HAMMER"] = "TEXT_GOVERNMENT_EMPIRE_SSD_HERO_CRONUS_NIGHT_HAMMER",
        ["DELVARDUS_NIGHT_HAMMER"] = "TEXT_GOVERNMENT_EMPIRE_SSD_LEADER_DELVARDUS",
        ["DAALA_KNIGHT_HAMMER"] = "TEXT_GOVERNMENT_EMPIRE_SSD_LEADER_DAALA",
        ["PELLAEON_REAPER"] = "TEXT_GOVERNMENT_EMPIRE_SSD_LEADER_PELLAEON_REAPER",
        ["PELLAEON_MEGADOR"] = "TEXT_GOVERNMENT_EMPIRE_SSD_LEADER_PELLAEON_MEGADOR",
		["ROGRISS_DOMINION"] = "TEXT_GOVERNMENT_EMPIRE_SSD_HERO_ROGRISS_DOMINION",
        ["KAINE_REAPER"] = "TEXT_GOVERNMENT_EMPIRE_SSD_LEADER_KAINE",
		["VENGEANCE_JEREC"] = "TEXT_GOVERNMENT_EMPIRE_SSD_HERO_SYSCO_VENGEANCE",
        ["ZSINJ_IRON_FIST_EXECUTOR"] = "TEXT_GOVERNMENT_EMPIRE_SSD_LEADER_ZSINJ",
		["RAZORS_KISS"] = "TEXT_GOVERNMENT_EMPIRE_SSD_HERO_RASLAN_RAZORS_KISS",
		["DROMMEL_GUARDIAN"] = "TEXT_GOVERNMENT_EMPIRE_SSD_WARLORD_DROMMEL",
		["GRUNGER_AGGRESSOR"] = "TEXT_GOVERNMENT_EMPIRE_SSD_WARLORD_GRUNGER",
		["GRONN_ACULEUS"] = "TEXT_GOVERNMENT_EMPIRE_SSD_HERO_GRONN",
		["DANGOR_JAVELIN"] = "TEXT_GOVERNMENT_EMPIRE_SSD_HERO_DANGOR"
    }

	self.dead_leader_table = {}
	
    self.planet_values = {
		["BASTION"] = 3,
		["CARIDA"] = 5,
        ["CORUSCANT"] = 10,
		["ERIADU"] = 3,
        ["KUAT"] = 5
    }
    
	self.pending_integration_queue = {}
	
    self.imperial_player = false
    for faction_name, _ in pairs(self.imperial_table) do
        if Find_Player(faction_name).Is_Human() then
            self.imperial_player = true
        end
    end

    --Dark Empire
    self.WinnerDetermined = false
    self.DarkEmpireAvailable = true
    if dark_empire == false then
        self.DarkEmpireAvailable = dark_empire
    end
    if self.StartingEra >= 4 then
        self.DarkEmpireAvailable = false
    end
    self.DarkEmpireUnlocked = false
    self.DarkEmpireStarted = false
    self.DarkEmpireEnded = false
    self.DarkEmpireFaction = "None"
    self.DarkEmpireRequireIntegrations = 2
    self.DarkEmpirePlanetBasedOnly = false

    self.legitimacy_groups = require("eawx-mod-icw/LegitimacyRewardLibrary")

    self.HighestLegitimacy = "EMPIRE"
    self.LowestLegitimacy = "GREATER_MALDROOD"

    self.elapsed_weeks = 0
    self:first_week_setup()

    self.galactic_hero_killed_event = gc.Events.GalacticHeroKilled
    self.galactic_hero_killed_event:attach_listener(self.on_galactic_hero_killed, self)
	
    self.galactic_ssd_killed_event = gc.Events.GalacticSSDKilled
    self.galactic_ssd_killed_event:attach_listener(self.on_galactic_ssd_killed, self)

    self.planet_owner_changed_event = gc.Events.PlanetOwnerChanged
    self.planet_owner_changed_event:attach_listener(self.on_planet_owner_changed, self)

    self.production_finished_event = gc.Events.GalacticProductionFinished
    self.production_finished_event:attach_listener(self.on_construction_finished, self)
    if self.imperial_player == true then
        crossplot:subscribe("UPDATE_GOVERNMENT", self.UpdateDisplay, self)
    end
    self.Events = {}
    self.Events.FactionIntegrated = Observable()
end

function GovernmentEmpire:first_week_setup()
    --Logger:trace("entering GovernmentEmpire:first_week_setup")

    self.StartingEmpires = 0
    for faction_name, _ in pairs(self.imperial_table) do
        local added_legitimacy = EvaluatePerception("Planet_Ownership", Find_Player(faction_name))
       
        if added_legitimacy then
            if added_legitimacy > 0 then
                self.imperial_table[faction_name].controls_planets = true
                self.StartingEmpires = self.StartingEmpires + 1
            end
        end
		
        --Needs to be one under the value, since one point already comes from initial count.
        for planet_name, value in pairs(self.planet_values) do
            if TestValid(FindPlanet(planet_name)) and (FindPlanet(planet_name).Get_Owner() == Find_Player(faction_name)) then
                added_legitimacy = added_legitimacy + value - 1
            end
        end
		
        self.imperial_table[faction_name].legitimacy = self.imperial_table[faction_name].legitimacy +  added_legitimacy

        for faction, stats in pairs(self.imperial_table) do
            if faction_name ~= faction then
                UnitUtil.SetLockList(faction_name, stats.destruction_unlocks, false)
            end
        end

        if self.imperial_table[faction_name].controls_planets == false then
            self.imperial_table[faction_name].legitimacy = 0
        end
    end

    if self.StartingEmpires == 2 then
        self.DarkEmpireRequireIntegrations = 1
    elseif self.StartingEmpires <= 1 then
        self.DarkEmpirePlanetBasedOnly = true
    end

    self:calculate_percentile_legitimacy()

end

function GovernmentEmpire:Update()
    --Logger:trace("entering GovernmentEmpire:Update")

    self.elapsed_weeks = self.elapsed_weeks + 1
		
	if self.elapsed_weeks == 2 then
		for index=1,table.getn(self.legitimacy_groups) do
			for i, entry in pairs(self.legitimacy_groups[index]) do
				local swap_entry = Get_Swap_Entry(string.upper(entry.unlocks[1]))
				for j, hero in pairs(swap_entry[2]) do
					local h = Find_First_Object(hero)
					if TestValid(h) then
						table.remove(self.legitimacy_groups[index], i)
						break
					end
				end
			end
		end
		local z = Find_First_Object("URAI_FEN")
		if TestValid(z) then
			self.imperial_table["ZSINJ_EMPIRE"].zann_unlocked = true
		end
	end
    
    for _, integrated_faction in pairs(self.pending_integration_queue) do
        --Logger:trace("entering GovernmentEmpire- integrate loop")
        local player_integrated_faction = Find_Player(integrated_faction)
        local player_highest_legitimacy = Find_Player(self.HighestLegitimacy)

        Faction_Total_Replace(player_integrated_faction,player_highest_legitimacy,1)

        --Logger:trace("entering GovernmentEmpire- integrate addons")
        if self.imperial_table[integrated_faction].destruction_unlocks then  
            UnitUtil.SetLockList(integrated_faction, self.imperial_table[integrated_faction].destruction_unlocks, false)
            UnitUtil.SetLockList(self.HighestLegitimacy, self.imperial_table[integrated_faction].destruction_unlocks)
            for _, unit in pairs(self.imperial_table[integrated_faction].destruction_unlocks) do
                table.insert(self.imperial_table[self.HighestLegitimacy].destruction_unlocks, unit)
            end
            for _, desc in pairs(self.imperial_table[integrated_faction].destruction_unlock_descs) do
                table.insert(self.imperial_table[self.HighestLegitimacy].destruction_unlock_descs, desc)
            end
            self.imperial_table[integrated_faction].destruction_unlocks = {}
            self.imperial_table[integrated_faction].destruction_unlock_descs = {}
            self.imperial_table[integrated_faction].legitimacy = 0
            self.imperial_table[integrated_faction].controls_planets = false
            self.imperial_table[self.HighestLegitimacy].factions_integrated = self.imperial_table[self.HighestLegitimacy].factions_integrated + self.imperial_table[integrated_faction].integrate_value + self.imperial_table[integrated_faction].factions_integrated
		end
	end
	
	self.pending_integration_queue = {}

    for faction_name, table in pairs(self.imperial_table) do
        if self.imperial_table[faction_name].controls_planets == true and EvaluatePerception("Planet_Ownership", Find_Player(faction_name)) == 0 then
            self.imperial_table[faction_name].controls_planets = false
        end
    end

    if self.DarkEmpireAvailable == true and self.DarkEmpireUnlocked == false then
        for faction_name, stats in pairs(self.imperial_table) do
            if self.imperial_table[faction_name].factions_integrated >= self.DarkEmpireRequireIntegrations then
                if self.imperial_table[faction_name].percentile_legitimacy > 60 then
                    self:unlock_dark_empire(faction_name)
                end
            elseif self.DarkEmpirePlanetBasedOnly == true then 
                if EvaluatePerception("Planet_Ownership", Find_Player(faction_name)) > self.DarkEmpirePlanetBasedOnlyThreshold then
                    self:unlock_dark_empire(faction_name)
                end
            end
        end
    end

    if self.StartingEra >= 4 and self.WinnerDetermined == false then
        for faction_name, stats in pairs(self.imperial_table) do
            if self.imperial_table[faction_name].factions_integrated >= 2 then
                if self.imperial_table[faction_name].percentile_legitimacy > 60 then
                    self.WinnerDetermined = true
                    GlobalValue.Set("IMPERIAL_REMNANT", faction_name)
                end
            end
        end
    end
end

function GovernmentEmpire:on_construction_finished(planet, game_object_type_name)
    --Logger:trace("entering GovernmentEmpire:on_construction_finished")
    if game_object_type_name == "DUMMY_RECRUIT_GROUP_TAGGE_CSA" then 
        self:tagge_handler(planet, game_object_type_name)
    end

    if game_object_type_name == "DUMMY_REGICIDE_PALPATINE" then 
        self:enter_dark_empire(planet, game_object_type_name)
    end

end

function GovernmentEmpire:tagge_handler(planet, game_object_type_name)
    --Logger:trace("entering GovernmentEmpire:tagge_handler")

    -- In case they've unlocked it. Probably need to handle this differently since it'd be annoying to get the group and then lose it.
    for faction_name, _ in pairs(self.imperial_table) do
        UnitUtil.SetLockList(faction_name, {
            "DUMMY_RECRUIT_GROUP_TAGGE"
        }, false)
    end

    for i, entry in pairs(self.legitimacy_groups[4]) do
        if entry.text == "TEXT_GOVERNMENT_LEGITIMACY_GROUP_TAGGE" then
            table.remove(self.legitimacy_groups[4], i)
        end
    end
    local tagge_table = {{"CORPORATE_SECTOR","SHIP_MARKET","GENERIC_TAGGE_BATTLECRUISER_CSA",3}}
    
    crossplot:publish("ADJUST_MARKET_CHANCE", tagge_table)
    self.production_finished_event:detach_listener(self.tagge_handler, self)
end

function GovernmentEmpire:unlock_dark_empire(faction_name)
    --Logger:trace("entering GovernmentEmpire:unlock_dark_empire")

    self.DarkEmpireUnlocked = true
    self.WinnerDetermined = true
    if Find_Player("local") == Find_Player(faction_name) then
        StoryUtil.Multimedia("TEXT_CONQUEST_EVENT_IR_PALPATINE_CONTACT", 15, nil, "Palpatine_Reborn_Loop", 0)
        Story_Event("PALPATINE_REQUEST_STARTED")
        Find_Player(faction_name).Unlock_Tech(Find_Object_Type("Dummy_Regicide_Palpatine"))
    else 
        StoryUtil.Multimedia("TEXT_CONQUEST_EVENT_IR_PALPATINE_CONTACT_ENEMY", 15, nil, "Palpatine_Reborn_Loop", 0)
        self:enter_dark_empire_ai(faction_name)
    end
end

function GovernmentEmpire:enter_dark_empire_ai(faction_name)
    --Logger:trace("entering GovernmentEmpire:enter_dark_empire")

    self.DarkEmpireStarted = true
    self.DarkEmpireFaction = faction_name
    GlobalValue.Set("IMPERIAL_REMNANT", self.DarkEmpireFaction)

    crossplot:publish("STATE_TRANSITION", "DARK_EMPIRE_TRIGGER")
    crossplot:publish("IMPERIAL_REMNANT_DECIDED", "empty")
end

function GovernmentEmpire:enter_dark_empire(planet, game_object_type_name)
    --Logger:trace("entering GovernmentEmpire:enter_dark_empire")

    self.DarkEmpireStarted = true
    self.DarkEmpireFaction = planet:get_owner().Get_Faction_Name()
    GlobalValue.Set("IMPERIAL_REMNANT", self.DarkEmpireFaction)

    crossplot:publish("STATE_TRANSITION", "DARK_EMPIRE_TRIGGER")
    crossplot:publish("IMPERIAL_REMNANT_DECIDED", "empty")
end

function GovernmentEmpire:on_galactic_hero_killed(hero_name, owner, killer)
    --Logger:trace("entering GovernmentEmpire:on_galactic_hero_killed")
    for faction_name, _ in pairs(self.imperial_table) do
        if faction_name == owner then	
			--all heroes
			self:adjust_legitimacy(owner, -1)

			--non-SSD leaders & warlords
			for leader_key, leader_value in pairs(self.leader_table) do
				if type(leader_value) ~= "table" then
					if hero_name == leader_value then
						self:adjust_legitimacy(owner, -4) --The 1 above adds to this
					end
				elseif hero_name == leader_key then
					self:adjust_legitimacy(owner, -4) --The 1 above adds to this
					table.insert(self.dead_leader_table,hero_name)
				end
			end
			
			--SSD heroes
			for unit, _ in pairs(self.Unit_List[1]) do
				if hero_name == unit then
					self:adjust_legitimacy(owner, -4) --The 1 above adds to this
				end
			end
        end

        if faction_name == killer then
            self.imperial_table[faction_name].heroes_killed_since_last_roll = self.imperial_table[faction_name].heroes_killed_since_last_roll + 1
        end
    end	
end

function GovernmentEmpire:on_galactic_ssd_killed(hero_name, owner, killer)
    --Logger:trace("entering GovernmentEmpire:on_galactic_hero_killed")
    for faction_name, _ in pairs(self.imperial_table) do
        if faction_name == owner then	
			--non-hero SSDs
            self:adjust_legitimacy(owner, -5)		
			break
        end		
    end	
end

function GovernmentEmpire:check_leader_dead(hero_team_name)
   if not next(self.dead_leader_table) then  
        return false
    else
        for _,dead_team_name in pairs(self.dead_leader_table) do
            if hero_team_name == dead_team_name then
                return true
            end
        end
    end  
    return false	
end


function GovernmentEmpire:group_joins(faction_name)
    --Logger:trace("entering GovernmentEmpire:group_joins")
    local level = self.imperial_table[faction_name].next_tier
    if self.imperial_table[faction_name].max_unlocked == true then
        level = GameRandom.Free_Random(1, 4)
    end

        if faction_name == "ZSINJ_EMPIRE" then
            if self.imperial_table["ZSINJ_EMPIRE"].zann_unlocked == false then

                if Find_Player("ZSINJ_EMPIRE").Is_Human() then
                    StoryUtil.Multimedia("TEXT_GOVERNMENT_LEGITIMACY_GROUP_ZANN", 15, nil, "Tyber_Loop", 0) 
                end
                UnitUtil.SetLockList(faction_name, {"GENERIC_AGGRESSOR", "VENGEANCE_FRIGATE", "Dummy_Recruit_Group_Zann"})
                self.imperial_table["ZSINJ_EMPIRE"].zann_unlocked = true
                table.insert(self.imperial_table[faction_name].joined_groups, "Dummy_Recruit_Group_Zann")
                return
            end
        end
    
        while table.getn(self.legitimacy_groups[level]) == 0 do
            level = level - 1
            if level == 0 then
                return
            end 
        end
        local group_number = GameRandom.Free_Random(1, table.getn(self.legitimacy_groups[level]))
        
        UnitUtil.SetLockList(faction_name, self.legitimacy_groups[level][group_number].unlocks)

        if self.legitimacy_groups[level][group_number].text == "TEXT_GOVERNMENT_LEGITIMACY_GROUP_TAGGE" then
            UnitUtil.SetLockList("CORPORATE_SECTOR", {
                "DUMMY_RECRUIT_GROUP_TAGGE_CSA"
            }, false)    
        end

        if Find_Player(faction_name).Is_Human() then
		    if GlobalValue.Get("GOV_EMP_DISABLE_MULTIMEDIA_HOLO") == 1 then
			    StoryUtil.Multimedia(self.legitimacy_groups[level][group_number].text, 15, nil, nil, 0)
		  		GlobalValue.Set("GOV_EMP_DISABLE_MULTIMEDIA_HOLO", 0)
		    else
			    StoryUtil.Multimedia(self.legitimacy_groups[level][group_number].text, 15, nil, self.legitimacy_groups[level][group_number].movie, 0)
		    end
        end
        -- StoryUtil.ShowScreenText(faction_name, 15)
        -- self.Events.FactionIntegrated:notify {
        --     joined = Find_Player(faction_name)
        -- }
		
        table.insert(self.imperial_table[faction_name].joined_groups, self.legitimacy_groups[level][group_number].unlocks[1])
        table.remove(self.legitimacy_groups[level], group_number)
        if level == 5 then
            self.imperial_table[faction_name].max_unlocked = true
        end
        if self.imperial_table[faction_name].next_tier < 5 then
            self.imperial_table[faction_name].next_tier = self.imperial_table[faction_name].next_tier + 1
        end
end

function GovernmentEmpire:faction_has_living_leaders(faction_name)
    --Logger:trace("entering GovernmentEmpire:faction_has_living_leaders")
    local leader_alive = 0
	faction_player = Find_Player(faction_name)
    for leader_key, leader_value in pairs(self.leader_table) do
		if type(leader_value) ~= "table" then
			if Find_First_Object(leader_value) then
				if Find_First_Object(leader_value).Get_Owner() == faction_player then
					leader_alive = leader_alive + 1
				end
			end
		elseif not self:check_leader_dead(leader_key) then
			if Find_First_Object(leader_value[1]) then
				if Find_First_Object(leader_value[1]).Get_Owner() == faction_player then
					leader_alive = leader_alive + 1
				end
			end
        end
    end

    local ssd_alive = 0
    local object_list = {}
    for unit, _ in pairs(self.Unit_List[1]) do
        object_list = Find_All_Objects_Of_Type(unit, Find_Player(faction_name))
        ssd_alive = ssd_alive + table.getn(object_list)
    end

    if leader_alive == 0 and ssd_alive == 0 then
		return false
	end
	
	return true	
end

---@param planet Planet
function GovernmentEmpire:on_planet_owner_changed(planet, new_owner_name, old_owner_name)
    --Logger:trace("entering GovernmentEmpire:on_planet_owner_changed")
    if new_owner_name ~= "NEUTRAL" and old_owner_name ~= "NEUTRAL" then
		if self.imperial_table[old_owner_name] or self.imperial_table[new_owner_name] then
			local value = 1
			local name = planet:get_name()
			for important_planet, new_value in pairs(self.planet_values) do
				if name == important_planet then
					value = new_value
					break
				end
			end
			
			if self.imperial_table[old_owner_name] then
				self:adjust_legitimacy(old_owner_name, (0 - value))
			end
			
			if self.imperial_table[new_owner_name] then
				self:adjust_legitimacy(new_owner_name, value)
			end
		end
	end

    if self.imperial_table[old_owner_name] then
	    if self.imperial_table[old_owner_name].is_integrated == false then
			if self.HighestLegitimacy ~= old_owner_name then
				if self.imperial_table[self.HighestLegitimacy].controls_planets == true then
					if self.imperial_table[self.HighestLegitimacy].is_integrated == false then			
						if EvaluatePerception("Planet_Ownership", Find_Player(old_owner_name)) <= self.LegitimacyAbsorb then
							if not self:faction_has_living_leaders(old_owner_name) then
								StoryUtil.ChangeAIPlayer(old_owner_name, "None")
								if self.LegitimacyAbsorb > 0 or table.getn(self.imperial_table[old_owner_name].destruction_unlocks) > 0 then
									if GlobalValue.Get("GOV_EMP_DISABLE_MULTIMEDIA_HOLO") == 1 then
										StoryUtil.Multimedia("TEXT_GOVERNMENT_LEGITIMACY_ABSORB_SPEECH_"..tostring(old_owner_name), 15, nil, nil, 0, nil, {r = 255, g = 255, b = 100}) 
										GlobalValue.Set("GOV_EMP_DISABLE_MULTIMEDIA_HOLO", 0)
									else
										StoryUtil.Multimedia("TEXT_GOVERNMENT_LEGITIMACY_ABSORB_SPEECH_"..tostring(old_owner_name), 15, nil, "Imperial_Naval_Officer_Loop", 0, nil, {r = 255, g = 255, b = 100}) 
									end							
								end
								--Need to have a way to turn this back on when factons re-emerge in the future.
								self.imperial_table[old_owner_name].is_integrated = true
								table.insert(self.pending_integration_queue, old_owner_name)
							end
						end
					end
				end
            end
        end
    end
end


function GovernmentEmpire:adjust_legitimacy(faction_name, added_legitimacy)
    --Logger:trace("entering GovernmentEmpire:adjust_legitimacy")

    local old_legitimacy = self.imperial_table[faction_name].legitimacy
    self.imperial_table[faction_name].legitimacy = self.imperial_table[faction_name].legitimacy +  added_legitimacy
    if self.imperial_table[faction_name].legitimacy <  0 then
        self.imperial_table[faction_name].legitimacy = 0
    end

    if self.imperial_table[faction_name].legitimacy > self.imperial_table[self.HighestLegitimacy].legitimacy then
        self.HighestLegitimacy = faction_name
    end

    if self.imperial_table[faction_name].legitimacy < self.imperial_table[self.LowestLegitimacy].legitimacy then
        self.LowestLegitimacy = faction_name
    end

    self:calculate_percentile_legitimacy()

    if old_legitimacy < self.imperial_table[faction_name].legitimacy  and self.elapsed_weeks >= 2 then
        local chance = GameRandom.Free_Random(1,40) + added_legitimacy + self.imperial_table[faction_name].heroes_killed_since_last_roll
        if self.imperial_table[faction_name].next_tier == 1 then
            chance = chance + 10
        end	
        if self.imperial_table[faction_name].next_tier == 2 then
            chance = chance + 5
        end	
        if chance >= 40 or self.imperial_table[faction_name].failed_rolls >= 15 then
            self.imperial_table[faction_name].failed_rolls = 0
            self:group_joins(faction_name)
            self.imperial_table[faction_name].heroes_killed_since_last_roll = 0
            self.imperial_table[faction_name].failed_rolls = self.imperial_table[faction_name].failed_rolls - 5
            if self.imperial_table[faction_name].failed_rolls < 0 then
                self.imperial_table[faction_name].failed_rolls = 0
            end
        else
            self.imperial_table[faction_name].failed_rolls = self.imperial_table[faction_name].failed_rolls + 1
        end
    end

end

function GovernmentEmpire:calculate_percentile_legitimacy()
    --Logger:trace("entering GovernmentEmpire:calculate_percentile_legitimacy")
    local total_legitimacy = 0
    for faction, _ in pairs(self.imperial_table) do
        total_legitimacy = total_legitimacy + self.imperial_table[faction].legitimacy
    end

    if total_legitimacy <= 0 then
        total_legitimacy = 1 
    end

    for faction, _ in pairs(self.imperial_table) do
        self.imperial_table[faction].percentile_legitimacy = tonumber(Dirty_Floor((self.imperial_table[faction].legitimacy / total_legitimacy)*100 ))
    end

end

function GovernmentEmpire:UpdateDisplay()
    --Logger:trace("entering GovernmentEmpire:UpdateDisplay")
    local plot = Get_Story_Plot("Conquests\\Player_Agnostic_Plot.xml")
    local government_display_event = plot.Get_Event("Government_Display")
    if self.imperial_player == true then
        government_display_event.Clear_Dialog_Text()

        government_display_event.Set_Reward_Parameter(1, Find_Player("local").Get_Faction_Name())

		government_display_event.Add_Dialog_Text("TEXT_GOVERNMENT_EMPIRE_LEGITIMACY_HEADER")
        government_display_event.Add_Dialog_Text("TEXT_DOCUMENTATION_BODY_SEPARATOR")
        for i,faction_name in ipairs(SortKeysByElement(self.imperial_table,"legitimacy","desc")) do
            if self.imperial_table[faction_name].controls_planets == true then
                government_display_event.Add_Dialog_Text(
                    "%s".. ": "..tostring(self.imperial_table[faction_name].legitimacy).." ("..tostring(self.imperial_table[faction_name].percentile_legitimacy).."%%)",
                    CONSTANTS.ALL_FACTION_TEXTS[string.upper(faction_name)]            
                )
                if self:faction_has_living_leaders(faction_name) then
					government_display_event.Add_Dialog_Text("TEXT_NONE")
					government_display_event.Add_Dialog_Text("TEXT_GOVERNMENT_EMPIRE_LIVING_LEADERS")
					faction_player = Find_Player(faction_name)
					--SSD heroes
					for hero_ssd, hero_ssd_text in pairs(self.hero_ssd_table) do
						if Find_First_Object(hero_ssd) then
							if Find_First_Object(hero_ssd).Get_Owner() == faction_player then
								government_display_event.Add_Dialog_Text(hero_ssd_text)
							end
						end
					end
					--Non-SSD leaders & warlords
					for leader_key, leader_value in pairs(self.leader_table) do
						if type(leader_value) ~= "table" then
							if Find_First_Object(leader_value) then
								if Find_First_Object(leader_value).Get_Owner() == faction_player then
									government_display_event.Add_Dialog_Text("%s",Find_Object_Type(leader_value))
								end
							end
						elseif not self:check_leader_dead(leader_key) then
							if Find_First_Object(leader_value[1]) then
								if Find_First_Object(leader_value[1]).Get_Owner() == faction_player then
									government_display_event.Add_Dialog_Text("%s",Find_Object_Type(leader_value[1]))
								end
							end
						end
					end		
					--Generic SSDs
					for unit, _ in pairs(self.Unit_List[1]) do
						if Find_First_Object(unit) then
							if Find_First_Object(unit).Get_Owner() == faction_player then
								if not self.hero_ssd_table[unit] then
									government_display_event.Add_Dialog_Text("%s",Find_Object_Type(unit))
								end
							end
						end
					end
				end
                if self.imperial_table[faction_name].destruction_unlock_descs[1] ~= nil then
                    government_display_event.Add_Dialog_Text("TEXT_NONE")
                    government_display_event.Add_Dialog_Text("Integration Rewards:")
                    for _, desc in pairs(self.imperial_table[faction_name].destruction_unlock_descs) do
                        government_display_event.Add_Dialog_Text(desc)
                    end
                end
                if self.imperial_table[faction_name].factions_integrated ~= 0 then
                    government_display_event.Add_Dialog_Text("TEXT_NONE")
                    government_display_event.Add_Dialog_Text("Factions Integrated: " .. tostring(self.imperial_table[faction_name].factions_integrated))
                end
                if self.imperial_table[faction_name].joined_groups[1] ~= nil then
                    government_display_event.Add_Dialog_Text("TEXT_NONE")
                    government_display_event.Add_Dialog_Text("Minor Groups Integrated:")
                    for _, name in pairs(self.imperial_table[faction_name].joined_groups) do
                        government_display_event.Add_Dialog_Text("%s",Find_Object_Type(name))     
                    end
                end

                government_display_event.Add_Dialog_Text("TEXT_DOCUMENTATION_BODY_SEPARATOR")
            end
        end
        
        government_display_event.Add_Dialog_Text("TEXT_NONE")
        
        government_display_event.Add_Dialog_Text("TEXT_GOVERNMENT_EMPIRE_HEADER")
        government_display_event.Add_Dialog_Text("TEXT_DOCUMENTATION_BODY_SEPARATOR")
        government_display_event.Add_Dialog_Text("TEXT_GOVERNMENT_EMPIRE_DESCRIPTION")
        
        government_display_event.Add_Dialog_Text("TEXT_DOCUMENTATION_BODY_SEPARATOR")
        government_display_event.Add_Dialog_Text("TEXT_GOVERNMENT_EMPIRE_LEGITIMACY_MOD_HEADER")
        government_display_event.Add_Dialog_Text("TEXT_DOCUMENTATION_BODY_SEPARATOR")
        government_display_event.Add_Dialog_Text("TEXT_GOVERNMENT_EMPIRE_LEGITIMACY_BASE")
        government_display_event.Add_Dialog_Text("TEXT_GOVERNMENT_EMPIRE_LEGITIMACY_MOD_CONQUEST1")
        government_display_event.Add_Dialog_Text("TEXT_GOVERNMENT_EMPIRE_LEGITIMACY_MOD_CONQUEST2")
		government_display_event.Add_Dialog_Text("TEXT_GOVERNMENT_EMPIRE_LEGITIMACY_MOD_PLUS3")
        government_display_event.Add_Dialog_Text("TEXT_GOVERNMENT_EMPIRE_LEGITIMACY_MOD_PLUS5")
        government_display_event.Add_Dialog_Text("TEXT_GOVERNMENT_EMPIRE_LEGITIMACY_MOD_PLUS10")
        government_display_event.Add_Dialog_Text("TEXT_GOVERNMENT_EMPIRE_LEGITIMACY_MOD_DEAD_HERO")
        government_display_event.Add_Dialog_Text("TEXT_GOVERNMENT_EMPIRE_LEGITIMACY_MOD_DEAD_LEADER")
		government_display_event.Add_Dialog_Text("TEXT_GOVERNMENT_EMPIRE_LEGITIMACY_MOD_RIVAL")
        
        government_display_event.Add_Dialog_Text("TEXT_NONE")
        
        government_display_event.Add_Dialog_Text("TEXT_GOVERNMENT_EMPIRE_INTEGRATION_HEADER")
        government_display_event.Add_Dialog_Text("TEXT_DOCUMENTATION_BODY_SEPARATOR")
        government_display_event.Add_Dialog_Text("TEXT_GOVERNMENT_EMPIRE_INTEGRATION_DESCRIPTION", self.LegitimacyAbsorb)
        
        government_display_event.Add_Dialog_Text("TEXT_NONE")
        
        government_display_event.Add_Dialog_Text("TEXT_GOVERNMENT_EMPIRE_DARKEMPIRE_HEADER")
        government_display_event.Add_Dialog_Text("TEXT_DOCUMENTATION_BODY_SEPARATOR")
        government_display_event.Add_Dialog_Text("TEXT_GOVERNMENT_EMPIRE_DARKEMPIRE_DESCRIPTION")
        government_display_event.Add_Dialog_Text("TEXT_DOCUMENTATION_BODY_SEPARATOR")
        government_display_event.Add_Dialog_Text("Requirements:")
        government_display_event.Add_Dialog_Text("TEXT_DOCUMENTATION_BODY_SEPARATOR")

        if self.DarkEmpireAvailable then
            if self.DarkEmpirePlanetBasedOnly == false then
                government_display_event.Add_Dialog_Text("TEXT_GOVERNMENT_EMPIRE_DARKEMPIRE_REQUIREMENT_1")
                government_display_event.Add_Dialog_Text("TEXT_GOVERNMENT_EMPIRE_DARKEMPIRE_REQUIREMENT_2", self.DarkEmpireRequireIntegrations)
            else
                government_display_event.Add_Dialog_Text("TEXT_GOVERNMENT_EMPIRE_DARKEMPIRE_REQUIREMENT_2", self.DarkEmpireRequireIntegrations)
            end
        else
            government_display_event.Add_Dialog_Text("TEXT_GOVERNMENT_EMPIRE_DARKEMPIRE_UNAVAILABLE")
        end
            
        government_display_event.Add_Dialog_Text("TEXT_DOCUMENTATION_BODY_SEPARATOR")
        government_display_event.Add_Dialog_Text("TEXT_GOVERNMENT_EMPIRE_DARKEMPIRE_REWARD_HEADER")
        government_display_event.Add_Dialog_Text("TEXT_DOCUMENTATION_BODY_SEPARATOR")
        
		government_display_event.Add_Dialog_Text("TEXT_GOVERNMENT_EMPIRE_DARKEMPIRE_REWARD_1")
		government_display_event.Add_Dialog_Text("TEXT_GOVERNMENT_EMPIRE_DARKEMPIRE_REWARD_2")
		government_display_event.Add_Dialog_Text("TEXT_GOVERNMENT_EMPIRE_DARKEMPIRE_REWARD_3")
		government_display_event.Add_Dialog_Text("TEXT_GOVERNMENT_EMPIRE_DARKEMPIRE_REWARD_4")
		government_display_event.Add_Dialog_Text("TEXT_GOVERNMENT_EMPIRE_DARKEMPIRE_REWARD_5")
		government_display_event.Add_Dialog_Text("TEXT_GOVERNMENT_EMPIRE_DARKEMPIRE_REWARD_6")
		government_display_event.Add_Dialog_Text("TEXT_GOVERNMENT_EMPIRE_DARKEMPIRE_REWARD_7")
		government_display_event.Add_Dialog_Text("TEXT_GOVERNMENT_EMPIRE_DARKEMPIRE_REWARD_8")
		government_display_event.Add_Dialog_Text("TEXT_GOVERNMENT_EMPIRE_DARKEMPIRE_REWARD_9")
		government_display_event.Add_Dialog_Text("TEXT_GOVERNMENT_EMPIRE_DARKEMPIRE_REWARD_10")
		government_display_event.Add_Dialog_Text("TEXT_GOVERNMENT_EMPIRE_DARKEMPIRE_REWARD_11")
		
		 government_display_event.Add_Dialog_Text("TEXT_NONE")
		
        government_display_event.Add_Dialog_Text("TEXT_GOVERNMENT_EMPIRE_CRIMSON_EMPIRE_REWARD_HEADER")
        government_display_event.Add_Dialog_Text("TEXT_DOCUMENTATION_BODY_SEPARATOR")
        
		government_display_event.Add_Dialog_Text("TEXT_GOVERNMENT_EMPIRE_CRIMSON_EMPIRE_REWARD_REWARD_1")
        
        government_display_event.Add_Dialog_Text("TEXT_NONE")
		
        government_display_event.Add_Dialog_Text("TEXT_GOVERNMENT_EMPIRE_REUNIFICATION_REWARD_HEADER")
        government_display_event.Add_Dialog_Text("TEXT_DOCUMENTATION_BODY_SEPARATOR")
        
		government_display_event.Add_Dialog_Text("TEXT_GOVERNMENT_EMPIRE_REUNIFICATION_REWARD_REWARD_1")
		government_display_event.Add_Dialog_Text("TEXT_GOVERNMENT_EMPIRE_REUNIFICATION_REWARD_REWARD_2")
		
		government_display_event.Add_Dialog_Text("TEXT_NONE")
		
        government_display_event.Add_Dialog_Text("TEXT_GOVERNMENT_EMPIRE_FINAL_IMPERIAL_PUSH_REWARD_HEADER")
        government_display_event.Add_Dialog_Text("TEXT_DOCUMENTATION_BODY_SEPARATOR")
        
		government_display_event.Add_Dialog_Text("TEXT_GOVERNMENT_EMPIRE_FINAL_IMPERIAL_PUSH_REWARD_REWARD_1")
		government_display_event.Add_Dialog_Text("TEXT_GOVERNMENT_EMPIRE_FINAL_IMPERIAL_PUSH_REWARD_REWARD_2")
		government_display_event.Add_Dialog_Text("TEXT_GOVERNMENT_EMPIRE_FINAL_IMPERIAL_PUSH_REWARD_REWARD_3")
		government_display_event.Add_Dialog_Text("TEXT_GOVERNMENT_EMPIRE_FINAL_IMPERIAL_PUSH_REWARD_REWARD_4")
		government_display_event.Add_Dialog_Text("TEXT_GOVERNMENT_EMPIRE_FINAL_IMPERIAL_PUSH_REWARD_REWARD_5")
		government_display_event.Add_Dialog_Text("TEXT_GOVERNMENT_EMPIRE_FINAL_IMPERIAL_PUSH_REWARD_REWARD_6")
		
		government_display_event.Add_Dialog_Text("TEXT_NONE")

        government_display_event.Add_Dialog_Text("TEXT_DOCUMENTATION_BODY_SEPARATOR")
        government_display_event.Add_Dialog_Text("TEXT_GOVERNMENT_EMPIRE_REWARD_LIST")
        government_display_event.Add_Dialog_Text("TEXT_DOCUMENTATION_BODY_SEPARATOR")
        
        government_display_event.Add_Dialog_Text("TEXT_GOVERNMENT_EMPIRE_TIER_1")
        government_display_event.Add_Dialog_Text("TEXT_GOVERNMENT_EMPIRE_TIER_1_REWARD_1")
        government_display_event.Add_Dialog_Text("TEXT_GOVERNMENT_EMPIRE_TIER_1_REWARD_2")
        government_display_event.Add_Dialog_Text("TEXT_GOVERNMENT_EMPIRE_TIER_1_REWARD_3")
        government_display_event.Add_Dialog_Text("TEXT_GOVERNMENT_EMPIRE_TIER_1_REWARD_4")
        
        government_display_event.Add_Dialog_Text("TEXT_DOCUMENTATION_BODY_SEPARATOR")
        
        government_display_event.Add_Dialog_Text("TEXT_GOVERNMENT_EMPIRE_TIER_2")
        government_display_event.Add_Dialog_Text("TEXT_GOVERNMENT_EMPIRE_TIER_2_REWARD_1")
        government_display_event.Add_Dialog_Text("TEXT_GOVERNMENT_EMPIRE_TIER_2_REWARD_2")
        government_display_event.Add_Dialog_Text("TEXT_GOVERNMENT_EMPIRE_TIER_2_REWARD_3")
        government_display_event.Add_Dialog_Text("TEXT_GOVERNMENT_EMPIRE_TIER_2_REWARD_4")
        government_display_event.Add_Dialog_Text("TEXT_GOVERNMENT_EMPIRE_TIER_2_REWARD_5")
        government_display_event.Add_Dialog_Text("TEXT_GOVERNMENT_EMPIRE_TIER_2_REWARD_6")
		government_display_event.Add_Dialog_Text("TEXT_GOVERNMENT_EMPIRE_TIER_2_REWARD_7")
        government_display_event.Add_Dialog_Text("TEXT_GOVERNMENT_EMPIRE_TIER_2_REWARD_8")
        government_display_event.Add_Dialog_Text("TEXT_GOVERNMENT_EMPIRE_TIER_2_REWARD_9")
        government_display_event.Add_Dialog_Text("TEXT_GOVERNMENT_EMPIRE_TIER_2_REWARD_10")
        government_display_event.Add_Dialog_Text("TEXT_GOVERNMENT_EMPIRE_TIER_2_REWARD_11")
        government_display_event.Add_Dialog_Text("TEXT_GOVERNMENT_EMPIRE_TIER_2_REWARD_12")
        government_display_event.Add_Dialog_Text("TEXT_GOVERNMENT_EMPIRE_TIER_2_REWARD_13")
        government_display_event.Add_Dialog_Text("TEXT_GOVERNMENT_EMPIRE_TIER_2_REWARD_14")
        government_display_event.Add_Dialog_Text("TEXT_GOVERNMENT_EMPIRE_TIER_2_REWARD_15")
        government_display_event.Add_Dialog_Text("TEXT_GOVERNMENT_EMPIRE_TIER_2_REWARD_16")
        government_display_event.Add_Dialog_Text("TEXT_GOVERNMENT_EMPIRE_TIER_2_REWARD_17")
        government_display_event.Add_Dialog_Text("TEXT_GOVERNMENT_EMPIRE_TIER_2_REWARD_18")
        government_display_event.Add_Dialog_Text("TEXT_GOVERNMENT_EMPIRE_TIER_2_REWARD_19")
		government_display_event.Add_Dialog_Text("TEXT_GOVERNMENT_EMPIRE_TIER_2_REWARD_20")
        government_display_event.Add_Dialog_Text("TEXT_GOVERNMENT_EMPIRE_TIER_2_REWARD_21")
        government_display_event.Add_Dialog_Text("TEXT_GOVERNMENT_EMPIRE_TIER_2_REWARD_22")
        
        government_display_event.Add_Dialog_Text("TEXT_DOCUMENTATION_BODY_SEPARATOR")
        
        government_display_event.Add_Dialog_Text("TEXT_GOVERNMENT_EMPIRE_TIER_3")
        government_display_event.Add_Dialog_Text("TEXT_GOVERNMENT_EMPIRE_TIER_3_REWARD_1")
        government_display_event.Add_Dialog_Text("TEXT_GOVERNMENT_EMPIRE_TIER_3_REWARD_2")
        government_display_event.Add_Dialog_Text("TEXT_GOVERNMENT_EMPIRE_TIER_3_REWARD_3")
        government_display_event.Add_Dialog_Text("TEXT_GOVERNMENT_EMPIRE_TIER_3_REWARD_4")
        government_display_event.Add_Dialog_Text("TEXT_GOVERNMENT_EMPIRE_TIER_3_REWARD_5")
        government_display_event.Add_Dialog_Text("TEXT_GOVERNMENT_EMPIRE_TIER_3_REWARD_6")
        government_display_event.Add_Dialog_Text("TEXT_GOVERNMENT_EMPIRE_TIER_3_REWARD_7")
        government_display_event.Add_Dialog_Text("TEXT_GOVERNMENT_EMPIRE_TIER_3_REWARD_8")
        government_display_event.Add_Dialog_Text("TEXT_GOVERNMENT_EMPIRE_TIER_3_REWARD_9")
        government_display_event.Add_Dialog_Text("TEXT_GOVERNMENT_EMPIRE_TIER_3_REWARD_10")
        government_display_event.Add_Dialog_Text("TEXT_GOVERNMENT_EMPIRE_TIER_3_REWARD_11")
        government_display_event.Add_Dialog_Text("TEXT_GOVERNMENT_EMPIRE_TIER_3_REWARD_12")
        government_display_event.Add_Dialog_Text("TEXT_GOVERNMENT_EMPIRE_TIER_3_REWARD_13")
        government_display_event.Add_Dialog_Text("TEXT_GOVERNMENT_EMPIRE_TIER_3_REWARD_14")
        government_display_event.Add_Dialog_Text("TEXT_GOVERNMENT_EMPIRE_TIER_3_REWARD_15")
        government_display_event.Add_Dialog_Text("TEXT_GOVERNMENT_EMPIRE_TIER_3_REWARD_16")
        government_display_event.Add_Dialog_Text("TEXT_GOVERNMENT_EMPIRE_TIER_3_REWARD_17")
        government_display_event.Add_Dialog_Text("TEXT_GOVERNMENT_EMPIRE_TIER_3_REWARD_18")
        government_display_event.Add_Dialog_Text("TEXT_GOVERNMENT_EMPIRE_TIER_3_REWARD_19")
        government_display_event.Add_Dialog_Text("TEXT_GOVERNMENT_EMPIRE_TIER_3_REWARD_20")
        government_display_event.Add_Dialog_Text("TEXT_GOVERNMENT_EMPIRE_TIER_3_REWARD_21")
        government_display_event.Add_Dialog_Text("TEXT_GOVERNMENT_EMPIRE_TIER_3_REWARD_22")
		government_display_event.Add_Dialog_Text("TEXT_GOVERNMENT_EMPIRE_TIER_3_REWARD_23")
        government_display_event.Add_Dialog_Text("TEXT_GOVERNMENT_EMPIRE_TIER_3_REWARD_24")
        government_display_event.Add_Dialog_Text("TEXT_GOVERNMENT_EMPIRE_TIER_3_REWARD_25")
        
        government_display_event.Add_Dialog_Text("TEXT_DOCUMENTATION_BODY_SEPARATOR")
        
        government_display_event.Add_Dialog_Text("TEXT_GOVERNMENT_EMPIRE_TIER_4")
        government_display_event.Add_Dialog_Text("TEXT_GOVERNMENT_EMPIRE_TIER_4_REWARD_1")
        government_display_event.Add_Dialog_Text("TEXT_GOVERNMENT_EMPIRE_TIER_4_REWARD_2")
        government_display_event.Add_Dialog_Text("TEXT_GOVERNMENT_EMPIRE_TIER_4_REWARD_3")
        government_display_event.Add_Dialog_Text("TEXT_GOVERNMENT_EMPIRE_TIER_4_REWARD_4")
        government_display_event.Add_Dialog_Text("TEXT_GOVERNMENT_EMPIRE_TIER_4_REWARD_5")
        government_display_event.Add_Dialog_Text("TEXT_GOVERNMENT_EMPIRE_TIER_4_REWARD_6")
        government_display_event.Add_Dialog_Text("TEXT_GOVERNMENT_EMPIRE_TIER_4_REWARD_7")
        government_display_event.Add_Dialog_Text("TEXT_GOVERNMENT_EMPIRE_TIER_4_REWARD_8")
        government_display_event.Add_Dialog_Text("TEXT_GOVERNMENT_EMPIRE_TIER_4_REWARD_9")
        government_display_event.Add_Dialog_Text("TEXT_GOVERNMENT_EMPIRE_TIER_4_REWARD_10")
        government_display_event.Add_Dialog_Text("TEXT_GOVERNMENT_EMPIRE_TIER_4_REWARD_11")
        government_display_event.Add_Dialog_Text("TEXT_GOVERNMENT_EMPIRE_TIER_4_REWARD_12")
        government_display_event.Add_Dialog_Text("TEXT_GOVERNMENT_EMPIRE_TIER_4_REWARD_13")
        government_display_event.Add_Dialog_Text("TEXT_GOVERNMENT_EMPIRE_TIER_4_REWARD_14")
        government_display_event.Add_Dialog_Text("TEXT_GOVERNMENT_EMPIRE_TIER_4_REWARD_15")
        government_display_event.Add_Dialog_Text("TEXT_GOVERNMENT_EMPIRE_TIER_4_REWARD_16")
        government_display_event.Add_Dialog_Text("TEXT_GOVERNMENT_EMPIRE_TIER_4_REWARD_17")
        government_display_event.Add_Dialog_Text("TEXT_GOVERNMENT_EMPIRE_TIER_4_REWARD_18")
        government_display_event.Add_Dialog_Text("TEXT_GOVERNMENT_EMPIRE_TIER_4_REWARD_19")
		government_display_event.Add_Dialog_Text("TEXT_GOVERNMENT_EMPIRE_TIER_4_REWARD_20")
        government_display_event.Add_Dialog_Text("TEXT_GOVERNMENT_EMPIRE_TIER_4_REWARD_21")
		government_display_event.Add_Dialog_Text("TEXT_GOVERNMENT_EMPIRE_TIER_4_REWARD_22")
        
        government_display_event.Add_Dialog_Text("TEXT_DOCUMENTATION_BODY_SEPARATOR")
        
        government_display_event.Add_Dialog_Text("TEXT_GOVERNMENT_EMPIRE_TIER_5")
        government_display_event.Add_Dialog_Text("TEXT_GOVERNMENT_EMPIRE_TIER_5_REWARD_1")
        government_display_event.Add_Dialog_Text("TEXT_GOVERNMENT_EMPIRE_TIER_5_REWARD_2")
        government_display_event.Add_Dialog_Text("TEXT_GOVERNMENT_EMPIRE_TIER_5_REWARD_3")
        government_display_event.Add_Dialog_Text("TEXT_GOVERNMENT_EMPIRE_TIER_5_REWARD_4")
        government_display_event.Add_Dialog_Text("TEXT_GOVERNMENT_EMPIRE_TIER_5_REWARD_5")
        government_display_event.Add_Dialog_Text("TEXT_GOVERNMENT_EMPIRE_TIER_5_REWARD_6")
        government_display_event.Add_Dialog_Text("TEXT_GOVERNMENT_EMPIRE_TIER_5_REWARD_7")
        government_display_event.Add_Dialog_Text("TEXT_GOVERNMENT_EMPIRE_TIER_5_REWARD_8")
        government_display_event.Add_Dialog_Text("TEXT_GOVERNMENT_EMPIRE_TIER_5_REWARD_9")
        government_display_event.Add_Dialog_Text("TEXT_GOVERNMENT_EMPIRE_TIER_5_REWARD_10")
        government_display_event.Add_Dialog_Text("TEXT_GOVERNMENT_EMPIRE_TIER_5_REWARD_11")
        government_display_event.Add_Dialog_Text("TEXT_GOVERNMENT_EMPIRE_TIER_5_REWARD_12")
        government_display_event.Add_Dialog_Text("TEXT_GOVERNMENT_EMPIRE_TIER_5_REWARD_13")
        government_display_event.Add_Dialog_Text("TEXT_GOVERNMENT_EMPIRE_TIER_5_REWARD_14")
		government_display_event.Add_Dialog_Text("TEXT_GOVERNMENT_EMPIRE_TIER_5_REWARD_15")
        government_display_event.Add_Dialog_Text("TEXT_GOVERNMENT_EMPIRE_TIER_5_REWARD_16")
        government_display_event.Add_Dialog_Text("TEXT_GOVERNMENT_EMPIRE_TIER_5_REWARD_17")
        government_display_event.Add_Dialog_Text("TEXT_GOVERNMENT_EMPIRE_TIER_5_REWARD_18")
		
		government_display_event.Add_Dialog_Text("TEXT_DOCUMENTATION_BODY_SEPARATOR")
        
        government_display_event.Add_Dialog_Text("TEXT_GOVERNMENT_EMPIRE_TIER_SPECIAL")
        government_display_event.Add_Dialog_Text("TEXT_GOVERNMENT_EMPIRE_TIER_SPECIAL_REWARD_1")
        government_display_event.Add_Dialog_Text("TEXT_GOVERNMENT_EMPIRE_TIER_SPECIAL_REWARD_2")
        government_display_event.Add_Dialog_Text("TEXT_GOVERNMENT_EMPIRE_TIER_SPECIAL_REWARD_3")
        government_display_event.Add_Dialog_Text("TEXT_GOVERNMENT_EMPIRE_TIER_SPECIAL_REWARD_4")
        government_display_event.Add_Dialog_Text("TEXT_GOVERNMENT_EMPIRE_TIER_SPECIAL_REWARD_5")

        Story_Event("GOVERNMENT_DISPLAY")
    end
end

return GovernmentEmpire
