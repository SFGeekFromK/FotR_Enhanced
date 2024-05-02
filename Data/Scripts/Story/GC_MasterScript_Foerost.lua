
--****************************************************--
--****   Fall of the Republic: Foerost Campaign   ****--
--****************************************************--

require("PGStoryMode")
require("PGSpawnUnits")
require("eawx-util/ChangeOwnerUtilities")
StoryUtil = require("eawx-util/StoryUtil")
require("deepcore/crossplot/crossplot")

function Definitions()
    DebugMessage("%s -- In Definitions", tostring(Script))

    ServiceRate = 5.0

    StoryModeEvents = {
		-- Generic
        Trigger_GC_Set_Up = State_GC_Set_Up,
		Trigger_Framework_Activation = State_Framework_Activation,

		-- CIS
		CIS_VSD_Destroyed = State_CIS_Target_Rendili,
		CIS_Venator_Venting_Tactical_Epilogue = State_CIS_Venator_Venting_Tactical_Epilogue,
		CIS_GC_Progression_ORS_Research = State_CIS_GC_Progression_ORS_Research,

		-- Republic
		Rep_Anaxes_Annexation_Tactical_Epilogue = State_Rep_Anaxes_Annexation_Tactical_Epilogue,
		Trigger_Rep_Gladiator_Unleashed = State_Rep_Gladiator_Unleashed,
		Rep_Foerost_Gladiator_Researched = State_Rep_Foerost_Gladiator_Researched,
	}

	p_cis = Find_Player("Rebel")
	p_republic = Find_Player("Empire")

	bulwark_fleet_list = {
		"Dua_Ningo_Unrepentant",
		"Bulwark_I",
		"Bulwark_I",
		"Bulwark_I",
		"Bulwark_I",
		"Bulwark_I",
		"Hardcell",
		"Hardcell",
		"Hardcell",
		"Hardcell",
		"Hardcell",
		"Hardcell",
	}

	clysm_fleet_list = {
		"Calli_Trilm_Bulwark",
		"Bulwark_I",
		"Bulwark_I",
		"Bulwark_I",
		"Bulwark_I",
		"Bulwark_I",
		"Bulwark_I",
		"Bulwark_I",
		"Auxilia",
		"Auxilia",
		"Auxilia",
		"Captor",
		"Captor",
		"Captor",
		"Marauder_Cruiser",
		"Marauder_Cruiser",
		"Marauder_Cruiser",
		"Marauder_Cruiser",
		"Marauder_Cruiser",
		"Hardcell",
		"Hardcell",
		"Hardcell",
		"Hardcell",
		"Hardcell",
		"Hardcell",
		"Hardcell_Tender",
		"Hardcell_Tender",
		"Hardcell_Tender",
		"Hardcell_Tender",
		"Hardcell_Tender",
	}

	potential_targets = {}

	bulwark_fleet_unit_list = nil
	clysm_fleet_unit_list = nil
	
	rampage_move_delay = 45

	gc_start = false
	all_planets_conquered = false
	act_1_active = false
	act_2_active = false
	act_3_active = false

	ningo_alive = false
	screed_alive = false
	dodonna_alive = false
	target_planets_conquered = false
	rendili_conquered = false
	carida_conquered = false
	carida_clysm_start = false

	anaxes_complete = false

	crossplot:galactic()
	crossplot:subscribe("HISTORICAL_GC_CHOICE_OPTION", State_Historical_GC_Choice)
end


function State_GC_Set_Up(message)
    if message == OnEnter then
		if p_cis.Is_Human() then
			GlobalValue.Set("Foerost_CIS_GC_Version", 0) -- 1 = AU Version; 0 = Canonical Version

			if TestValid(Find_First_Object("GC_AU_Dummy")) then
				GlobalValue.Set("Foerost_CIS_GC_Version", 1) -- 1 = AU Version; 0 = Canonical Version
			end
		elseif p_republic.Is_Human() then
			GlobalValue.Set("Foerost_Rep_GC_Version", 0) -- 1 = AU Version; 0 = Canonical Version

			if TestValid(Find_First_Object("GC_AU_Dummy")) then
				GlobalValue.Set("Foerost_Rep_GC_Version", 1) -- 1 = AU Version; 0 = Canonical Version
			end
		end

		crossplot:publish("POPUPEVENT", "HISTORICAL_GC_CHOICE", {"STORY", "NO_INTRO", "NO_STORY"}, { },
				{ }, { },
				{ }, { },
				{ }, { },
				"HISTORICAL_GC_CHOICE_OPTION")

		-- CIS
		Find_Player("Rebel").Unlock_Tech(Find_Object_Type("Bulwark_I"))
		Find_Player("Rebel").Unlock_Tech(Find_Object_Type("Separatist_Council"))

		Find_Player("Rebel").Lock_Tech(Find_Object_Type("NewRep_Senate"))
		Find_Player("Rebel").Lock_Tech(Find_Object_Type("Random_Mercenary"))

		-- Republic
		Find_Player("Empire").Unlock_Tech(Find_Object_Type("Republic_Sector_Capital"))
		Find_Player("Empire").Unlock_Tech(Find_Object_Type("Invincible_Cruiser"))
		Find_Player("Empire").Unlock_Tech(Find_Object_Type("Generic_Venator"))
		Find_Player("Empire").Unlock_Tech(Find_Object_Type("Generic_Victory_Fleet_Destroyer"))
		Find_Player("Empire").Unlock_Tech(Find_Object_Type("Customs_Corvette"))
		Find_Player("Empire").Unlock_Tech(Find_Object_Type("LAC"))

		Find_Player("Empire").Lock_Tech(Find_Object_Type("Remnant_Capital"))
		Find_Player("Empire").Lock_Tech(Find_Object_Type("Charger_C70"))
		Find_Player("Empire").Lock_Tech(Find_Object_Type("Invincible_Cruiser"))
		Find_Player("Empire").Lock_Tech(Find_Object_Type("Corellian_Corvette"))

		Find_Player("Empire").Lock_Tech(Find_Object_Type("Screed_Retire"))
		Find_Player("Empire").Lock_Tech(Find_Object_Type("Dodonna_Retire"))
		Find_Player("Empire").Lock_Tech(Find_Object_Type("Trachta_Retire"))
    end
end

function State_Historical_GC_Choice(choice)
	if choice == "HISTORICAL_GC_CHOICE_STORY" then
		if p_cis.Is_Human() then
			Create_Thread("State_CIS_Story_Set_Up")
			GlobalValue.Set("Foerost_CIS_Renown_Conquered", 0) -- 1 = AU Version; 0 = Canonical Version

			Story_Event("CIS_INTRO_START")
		end
		if p_republic.Is_Human() then
			Create_Thread("State_Rep_Story_Set_Up")

			Story_Event("REP_INTRO_START")
		end
	end
	if choice == "HISTORICAL_GC_CHOICE_NO_INTRO" then
		if p_cis.Is_Human() then
			Create_Thread("State_CIS_Story_Set_Up")
			GlobalValue.Set("Foerost_CIS_Renown_Conquered", 0) -- 1 = AU Version; 0 = Canonical Version
		end
		if p_republic.Is_Human() then
			Create_Thread("State_Rep_Story_Set_Up")
		end
	end
	if choice == "HISTORICAL_GC_CHOICE_NO_STORY" then
		Create_Thread("State_Generic_Story_Set_Up")
	end
end

function State_Framework_Activation(message)
    if message == OnEnter then
		GlobalValue.Set("CURRENT_ERA", 3)
		crossplot:publish("INITIALIZE_AI", "empty")
		crossplot:publish("VENATOR_HEROES", "empty")
		crossplot:publish("VICTORY_HEROES", "empty")
		crossplot:publish("CLONE_UPGRADES", "empty")
		-- FotR_Enhanced
		crossplot:publish("GEEN_UNLOCK", "empty")

		--Admirals: 5 - 2 - 3 = 0
		crossplot:publish("REPUBLIC_ADMIRAL_DECREMENT", 3, 1)
		crossplot:publish("REPUBLIC_ADMIRAL_LOCKIN", {"Screed", "Dodonna"}, 1)

		--Moffs: 2 - 1 - 1
		crossplot:publish("REPUBLIC_ADMIRAL_DECREMENT", 1, 2)
		crossplot:publish("REPUBLIC_ADMIRAL_LOCKIN", {"Trachta"}, 2)

		--Jedi: 5 - 4 = 1 
		crossplot:publish("REPUBLIC_ADMIRAL_DECREMENT", 4, 3)
		crossplot:publish("REPUBLIC_ADMIRAL_EXIT", {"Halcyon","Ahsoka","Barriss","Knol","Shaak","Mace"}, 3)

		--Clone Officers: 5 - 3 = 2
		crossplot:publish("REPUBLIC_ADMIRAL_DECREMENT", 3, 4)
		crossplot:publish("REPUBLIC_ADMIRAL_EXIT", {"Bly","Cody","Rex","Gree_Clone"}, 4)

		--Commandos: 3 - 2 = 1 
		crossplot:publish("REPUBLIC_ADMIRAL_DECREMENT", 2, 5)

		--Generals: 2 - 1 = 1
		crossplot:publish("REPUBLIC_ADMIRAL_DECREMENT", 1, 6)
		else
		crossplot:update()
    end
end

function State_Generic_Story_Set_Up()
	StoryUtil.SpawnAtSafePlanet("EMPRESS_TETA", Find_Player("Rebel"), StoryUtil.GetSafePlanetTable(), {"Dua_Ningo_Unrepentant","Bulwark_I","Bulwark_I"})

	p_republic.Unlock_Tech(Find_Object_Type("Generic_Gladiator"))

	gc_start = true
end


function Story_Mode_Service()
	if gc_start then
		if p_cis.Is_Human() then
			--[[local all_planets = FindPlanet.Get_All_Planets()
			for _, planet in pairs(all_planets) do
				if planet.Get_Owner() == p_cis then
					if not all_planets_conquered then
						all_planets_conquered = true
						if TestValid(Find_First_Object("Dua_Ningo_Unrepentant")) then
							StoryUtil.LoadCampaign("Sandbox_AU_3_OuterRimSieges_CIS", 0)
						else
							StoryUtil.LoadCampaign("Sandbox_OuterRimSieges_CIS", 0)
						end
					end
				end
			end]]
		elseif p_republic.Is_Human() then
			--[[local all_planets = FindPlanet.Get_All_Planets()
			for _, planet in pairs(all_planets) do
				if planet.Get_Owner() == p_republic then
					if not all_planets_conquered then
						all_planets_conquered = true
						StoryUtil.LoadCampaign("Sandbox_AU_1_OuterRimSieges_Republic", 1)
					end
				end
			end]]
		end
	end
end

-- CIS

function State_CIS_Story_Set_Up()
	if p_cis.Is_Human() then
		Story_Event("CIS_STORY_START")

		gc_start = true

		StoryUtil.RevealPlanet("ANAXES", false)
		StoryUtil.RevealPlanet("RENDILI", false)

		StoryUtil.SetPlanetRestricted("ANAXES", 1)

		lockdown_list = {"Invincible_Cruiser", "Invincible_Cruiser", "Invincible_Cruiser"}
		LockdownSpawn = SpawnList(lockdown_list, FindPlanet("Alsakan"), p_republic, false, false)

		lockdown_list = {"Dua_Ningo_Unrepentant"}
		LockdownSpawn = SpawnList(lockdown_list, FindPlanet("Empress_Teta"), p_cis, true, false)

		p_republic.Unlock_Tech(Find_Object_Type("Generic_Gladiator"))

		target_planet_list = {
			FindPlanet("Alsakan"),
			FindPlanet("Basilisk"),
			FindPlanet("Ixtlar"),
			}

		plot = Get_Story_Plot("Conquests\\CloneWarsFoerost\\Story_Sandbox_Foerost_CIS.XML")

		event_act_1 = plot.Get_Event("CIS_Foerost_Campaign_Act_I_Dialog")
		event_act_1.Set_Dialog("DIALOG_FOEROST_CAMPAIGN_CIS")
		event_act_1.Clear_Dialog_Text()
		for _,p_planet in pairs(target_planet_list) do
			if p_planet.Get_Owner() ~= p_cis then
				event_act_1.Add_Dialog_Text("TEXT_INTERVENTION_PLANET_CONQUEST_LOCATION", p_planet)
			else
				event_act_1.Add_Dialog_Text("TEXT_INTERVENTION_PLANET_CONQUEST_LOCATION_COMPLETE", p_planet)
			end
		end

		event_act_2 = plot.Get_Event("CIS_Foerost_Campaign_Act_II_Dialog")
		event_act_2.Set_Dialog("DIALOG_FOEROST_CAMPAIGN_CIS")
		event_act_2.Clear_Dialog_Text()
		if FindPlanet("Rendili").Get_Owner() ~= p_cis then
			event_act_2.Add_Dialog_Text("TEXT_INTERVENTION_PLANET_CONQUEST_LOCATION", FindPlanet("Rendili"))
		else
			event_act_2.Add_Dialog_Text("TEXT_INTERVENTION_PLANET_CONQUEST_LOCATION_COMPLETE", FindPlanet("Rendili"))
			rendili_conquered = true
		end

		event_act_3 = plot.Get_Event("CIS_Foerost_Campaign_Act_III_Dialog")
		event_act_3.Set_Dialog("DIALOG_FOEROST_CAMPAIGN_CIS")
		event_act_3.Clear_Dialog_Text()
		if FindPlanet("Anaxes").Get_Owner() ~= p_cis then
			event_act_3.Add_Dialog_Text("TEXT_STORY_FOEROST_CAMPIGN_CIS_LOCATION_ANAXES", FindPlanet("Anaxes"))
		else
			event_act_3.Add_Dialog_Text("TEXT_INTERVENTION_PLANET_CONQUEST_LOCATION_COMPLETE", FindPlanet("Anaxes"))
		end

		Create_Thread("State_CIS_Act_I_Planet_Checker")
		Create_Thread("State_CIS_Act_II_Planet_Checker")
	end
end

function State_CIS_Act_I_Planet_Checker()
	event_act_1 = plot.Get_Event("CIS_Foerost_Campaign_Act_I_Dialog")
	event_act_1.Set_Dialog("DIALOG_FOEROST_CAMPAIGN_CIS")
	event_act_1.Clear_Dialog_Text()
	for _,p_planet in pairs(target_planet_list) do
		if p_planet.Get_Owner() ~= p_cis then
			event_act_1.Add_Dialog_Text("TEXT_INTERVENTION_PLANET_CONQUEST_LOCATION", p_planet)
		else
			event_act_1.Add_Dialog_Text("TEXT_INTERVENTION_PLANET_CONQUEST_LOCATION_COMPLETE", p_planet)
		end
	end
	if FindPlanet("Alsakan").Get_Owner() == p_cis and FindPlanet("Basilisk").Get_Owner() == p_cis and FindPlanet("Ixtlar").Get_Owner() == p_cis then
		target_planets_conquered = true
		Story_Event("CIS_TARGET_PLANETS_CONQUERED")
	end
	Sleep(5.0)
	if not target_planets_conquered then
		Create_Thread("State_CIS_Act_I_Planet_Checker")
	end
end

function State_CIS_Act_II_Planet_Checker()
	event_act_2 = plot.Get_Event("CIS_Foerost_Campaign_Act_II_Dialog")
	event_act_2.Set_Dialog("DIALOG_FOEROST_CAMPAIGN_CIS")
	event_act_2.Clear_Dialog_Text()
	if FindPlanet("Rendili").Get_Owner() ~= p_cis then
		event_act_2.Add_Dialog_Text("TEXT_INTERVENTION_PLANET_CONQUEST_LOCATION", FindPlanet("Rendili"))
	else
		event_act_2.Add_Dialog_Text("TEXT_INTERVENTION_PLANET_CONQUEST_LOCATION_COMPLETE", FindPlanet("Rendili"))
		rendili_conquered = true
		Story_Event("CIS_RENDILI_CONQUERED")
		local rendili_reward_list = {"AutO_Providence", "Protodeka_Company"}
		RendiliRewardSpawn = SpawnList(rendili_reward_list, FindPlanet("Rendili"), p_cis, true, false)
	end
	Sleep(5.0)
	if not rendili_conquered then
		Create_Thread("State_CIS_Act_II_Planet_Checker")
	end
end

function State_CIS_Target_Rendili(message)
    if message == OnEnter then
		if p_cis.Is_Human() then
			if FindPlanet("Rendili").Get_Owner() == p_republic then
				Story_Event("CIS_TARGET_RENDILI")
			else
				StoryUtil.SetPlanetRestricted("RENDILI", 0)
			end
		end
    end
end

function State_CIS_Venator_Venting_Tactical_Epilogue(message)
    if message == OnEnter then
		if p_cis.Is_Human() then
			StoryUtil.SetPlanetRestricted("RENDILI", 0)
			if (GlobalValue.Get("Foerost_CIS_Renown_Conquered") == 1) then
				event_act_5 = plot.Get_Event("CIS_Foerost_Campaign_Act_V_Dialog")
				event_act_5.Set_Dialog("DIALOG_FOEROST_CAMPAIGN_CIS")
				event_act_5.Clear_Dialog_Text()
				if FindPlanet("Carida").Get_Owner() ~= p_cis then
						if not carida_clysm_start then 
							Story_Event("CIS_CARIDA_CLYSM_START")
							carida_clysm_start = true
						end
					event_act_5.Add_Dialog_Text("TEXT_INTERVENTION_PLANET_CONQUEST_LOCATION", FindPlanet("Carida"))
				else
					event_act_5.Add_Dialog_Text("TEXT_INTERVENTION_PLANET_CONQUEST_LOCATION_COMPLETE", FindPlanet("Carida"))
					carida_conquered = true
					Story_Event("CIS_CARIDA_CONQUEST")
					local Safe_House_Planet = StoryUtil.GetSafePlanetTable()
					StoryUtil.SpawnAtSafePlanet("CARIDA", Find_Player("Rebel"), Safe_House_Planet, {"Calli_Trilm_Bulwark"})
				end
			end
			if not carida_conquered then
				Create_Thread("State_CIS_Carida_Checker")
			end
		end
    end
end

function State_CIS_Carida_Checker()
	if (GlobalValue.Get("Foerost_CIS_Renown_Conquered") == 1) then
		event_act_5 = plot.Get_Event("CIS_Foerost_Campaign_Act_V_Dialog")
		event_act_5.Set_Dialog("DIALOG_FOEROST_CAMPAIGN_CIS")
		event_act_5.Clear_Dialog_Text()
		if FindPlanet("Carida").Get_Owner() ~= p_cis then
				if not carida_clysm_start then 
					Story_Event("CIS_CARIDA_CLYSM_START")
					carida_clysm_start = true
				end
			event_act_5.Add_Dialog_Text("TEXT_INTERVENTION_PLANET_CONQUEST_LOCATION", FindPlanet("Carida"))
		else
			event_act_5.Add_Dialog_Text("TEXT_INTERVENTION_PLANET_CONQUEST_LOCATION_COMPLETE", FindPlanet("Carida"))
			carida_conquered = true
			Story_Event("CIS_CARIDA_CONQUEST")
			local Safe_House_Planet = StoryUtil.GetSafePlanetTable()
			StoryUtil.SpawnAtSafePlanet("CARIDA", Find_Player("Rebel"), Safe_House_Planet, {"Calli_Trilm_Bulwark"})
		end
	end
	Sleep(5.0)
	if not carida_conquered then
		Create_Thread("State_CIS_Carida_Checker")
	end
end

function State_CIS_GC_Progression_ORS_Research(message)
	if message == OnEnter then
		if TestValid(Find_First_Object("Dua_Ningo_Unrepentant")) then
			Story_Event("CIS_ORS_GC_PROGRESSION_AU")
		else
			Story_Event("CIS_ORS_GC_PROGRESSION")
		end
	end
end

-- Republic

function State_Rep_Story_Set_Up()
	if p_republic.Is_Human() then
		Story_Event("REP_STORY_START")

		p_bulwark = "Bulwark_I"
		p_ningo = "Dua_Ningo_Unrepentant"

		gc_start = true

		StoryUtil.RevealPlanet("FOEROST", false)
		StoryUtil.RevealPlanet("KAIKIELIUS", false)

		target_planet_list = {
			FindPlanet("Foerost"),
			FindPlanet("Kaikielius"),
			FindPlanet("Empress_Teta"),
			FindPlanet("Vulpter"),
		}

		plot = Get_Story_Plot("Conquests\\CloneWarsFoerost\\Story_Sandbox_Foerost_Republic.XML")

		event_act_2 = plot.Get_Event("Rep_Foerost_Campaign_Act_II_Dialog")
		event_act_2.Set_Dialog("DIALOG_FOEROST_CAMPAIGN_REP")
		event_act_2.Clear_Dialog_Text()
		for _,p_planet in pairs(target_planet_list) do
			if p_planet.Get_Owner() ~= p_republic then
				event_act_2.Add_Dialog_Text("TEXT_INTERVENTION_PLANET_CONQUEST_LOCATION", p_planet)
			elseif p_planet.Get_Owner() == p_republic then
				event_act_2.Add_Dialog_Text("TEXT_INTERVENTION_PLANET_CONQUEST_LOCATION_COMPLETE", p_planet)
			end
		end

		Create_Thread("State_Rep_Planet_Checker")
		Create_Thread("State_Rep_Bulwarks_Unleashed")
		Create_Thread("State_Rep_Anaxes_Anexation_Checker")
	end
end

function State_Rep_Planet_Checker()
	event_act_2 = plot.Get_Event("Rep_Foerost_Campaign_Act_II_Dialog")
	event_act_2.Set_Dialog("DIALOG_FOEROST_CAMPAIGN_REP")
	event_act_2.Clear_Dialog_Text()
	for _,p_planet in pairs(target_planet_list) do
		if p_planet.Get_Owner() ~= p_republic then
			event_act_2.Add_Dialog_Text("TEXT_INTERVENTION_PLANET_CONQUEST_LOCATION", p_planet)
		elseif p_planet.Get_Owner() == p_republic then
			event_act_2.Add_Dialog_Text("TEXT_INTERVENTION_PLANET_CONQUEST_LOCATION_COMPLETE", p_planet)
		end
	end
	if FindPlanet("Foerost").Get_Owner() == p_republic and FindPlanet("Kaikielius").Get_Owner() == p_republic and FindPlanet("Empress_Teta").Get_Owner() == p_republic and FindPlanet("Vulpter").Get_Owner() == p_republic then
		target_planets_conquered = true
	end
	Sleep(5.0)
	if not target_planets_conquered then
		Create_Thread("State_Rep_Planet_Checker")
	else
		Story_Event("REP_TARGET_PLANETS_CONQUERED")
	end
end

function State_Rep_Bulwarks_Unleashed()
	bulwark_fleet_unit_list = SpawnList(bulwark_fleet_list, FindPlanet("Empress_Teta"), p_cis, false, false)
	player_bulwark_fleet = Assemble_Fleet(bulwark_fleet_unit_list)
	Register_Timer(State_Rep_Bulwark_Rampage, 80)
end

function State_Rep_Bulwark_Rampage()
	if TestValid(player_bulwark_fleet) then
		potential_targets = FindPlanet.Get_All_Planets()
		target_planet = nil
		attack_gambtit = nil
		local attack_gambtit = GameRandom.Free_Random(1, 4)
		if attack_gambtit == 1 then
			while not target_planet do
				local length = table.getn(potential_targets)
				if length > 0 then
					local index = GameRandom(1, table.getn(potential_targets))
					local potential_target = potential_targets[index]

					if potential_target.Get_Owner() == p_republic then
						if EvaluatePerception("Is_Neglected_By_My_Opponent_Space", p_cis, potential_target) then
							target_planet = potential_target
						end
					end
					table.remove(potential_targets, index)
				else 
					break
				end
			end
		elseif attack_gambtit >= 2 then
			while not target_planet do
				local length = table.getn(potential_targets)
				if length > 0 then
					local index = GameRandom(1, table.getn(potential_targets))
					local potential_target = potential_targets[index]

					if potential_target.Get_Owner() == p_cis then
						target_planet = potential_target
					end
					table.remove(potential_targets, index)
				else 
					break
				end
			end
		end
		current_planet = player_bulwark_fleet.Get_Parent_Object()
		if not current_planet then
			Sleep(5)
		else
			local to_grow_or_not = GameRandom.Free_Random(1, 3)
			if current_planet.Get_Owner() == p_cis then
				growing_list = {"Bulwark_I", "Bulwark_I", "Marauder_Cruiser", "Marauder_Cruiser", "Hardcell", "Hardcell", "Hardcell"}
				to_grow_or_not = 1
			end
			if to_grow_or_not == 1 then
				growing_list = {"Bulwark_I", "Munificent", "Munificent", "Munificent", "Munificent", "Hardcell", "Hardcell", "Hardcell_Tender"}
				to_grow_or_not = 1
			elseif to_grow_or_not == 2 then
				growing_list = {"Bulwark_I", "Bulwark_I", "Bulwark_I", "Hardcell", "Hardcell",  "Hardcell_Tender", "Hardcell_Tender"}
				to_grow_or_not = 1
			elseif to_grow_or_not == 3 then
				growing_list = {"Bulwark_I", "Bulwark_I", "Bulwark_I", "Bulwark_I", "Marauder_Cruiser", "Marauder_Cruiser", "Hardcell",  "Hardcell"}
				to_grow_or_not = 1
			end
				local bulwark_fleet_followers = SpawnList(growing_list, current_planet, p_cis, true, false)
			bulwark_fleet_path = Find_Path(p_cis, current_planet, target_planet)
			if bulwark_fleet_path then
				bulwark_commander = Find_First_Object("Dua_Ningo_Unrepentant")
				if TestValid(bulwark_commander) then
					player_bulwark_fleet = bulwark_commander.Get_Parent_Object()
					BlockOnCommand(player_bulwark_fleet.Move_To(target_planet))
					bulwark_commander = Find_First_Object("Dua_Ningo_Unrepentant")
					bulwark_commander.Set_Check_Contested_Space(true)
				end
			end
		end
		if ningo_alive then
			Register_Timer(State_Rep_Bulwark_Rampage, GameRandom.Free_Random(30, 60))
		end
	end
end

function State_Rep_Anaxes_Anexation_Checker()
	plot = Get_Story_Plot("Conquests\\CloneWarsFoerost\\Story_Sandbox_Foerost_Republic.XML")

	event_act_3 = plot.Get_Event("Rep_Foerost_Campaign_Act_III_Dialog")
	event_act_3.Set_Dialog("DIALOG_FOEROST_CAMPAIGN_REP")
	event_act_3.Clear_Dialog_Text()

	if TestValid(Find_First_Object("Screed_Arlionne")) and TestValid(Find_First_Object("Dodonna_Ardent")) then
		event_act_3.Add_Dialog_Text("TEXT_STORY_FOEROST_CAMPAIGN_REP_ACT_III_OBJECTIVE_01")
		event_act_3.Add_Dialog_Text("TEXT_NONE")
		event_act_3.Add_Dialog_Text("TEXT_INTERVENTION_LOCATION", FindPlanet("Anaxes"))

		event_act_3_01_task = plot.Get_Event("Rep_Trigger_Anaxes_Annexation")
		event_act_3_01_task.Set_Event_Parameter(2, Find_Object_Type("Dodonna_Ardent"))
	elseif not TestValid(Find_First_Object("Screed_Arlionne")) and TestValid(Find_First_Object("Dodonna_Ardent")) then
		event_act_3.Add_Dialog_Text("TEXT_STORY_FOEROST_CAMPAIGN_REP_ACT_III_OBJECTIVE_02")
		event_act_3.Add_Dialog_Text("TEXT_NONE")
		event_act_3.Add_Dialog_Text("TEXT_INTERVENTION_LOCATION", FindPlanet("Anaxes"))

		event_act_3_01_task = plot.Get_Event("Rep_Trigger_Anaxes_Annexation")
		event_act_3_01_task.Set_Event_Parameter(2, Find_Object_Type("Dodonna_Ardent"))
	elseif TestValid(Find_First_Object("Screed_Arlionne")) and not TestValid(Find_First_Object("Dodonna_Ardent")) then
		event_act_3.Add_Dialog_Text("TEXT_STORY_FOEROST_CAMPAIGN_REP_ACT_III_OBJECTIVE_03")
		event_act_3.Add_Dialog_Text("TEXT_NONE")
		event_act_3.Add_Dialog_Text("TEXT_INTERVENTION_LOCATION", FindPlanet("Anaxes"))

		event_act_3_01_task = plot.Get_Event("Rep_Trigger_Anaxes_Annexation")
		event_act_3_01_task.Set_Event_Parameter(2, Find_Object_Type("Screed_Arlionne"))
	elseif not TestValid(Find_First_Object("Screed_Arlionne")) and not TestValid(Find_First_Object("Dodonna_Ardent")) then
		event_act_3.Add_Dialog_Text("TEXT_STORY_FOEROST_CAMPAIGN_REP_ACT_III_OBJECTIVE_04")
		event_act_3.Add_Dialog_Text("TEXT_NONE")
		event_act_3.Add_Dialog_Text("TEXT_INTERVENTION_LOCATION", FindPlanet("Anaxes"))

		event_act_3_01_task = plot.Get_Event("Rep_Trigger_Anaxes_Annexation")
		event_act_3_01_task.Set_Event_Parameter(2, Find_Object_Type("Generic_Victory_Fleet_Destroyer"))
	end
	if not anaxes_complete then
		Sleep(5.0)
		Create_Thread("State_Rep_Anaxes_Anexation_Checker")
	end
end

function State_Rep_Anaxes_Annexation_Tactical_Epilogue(message)
	if message == OnEnter then
		if p_republic.Is_Human() then
			anaxes_complete = true
		end
    end
end

function State_Rep_Gladiator_Unleashed(message)
	if message == OnEnter then
		if p_republic.Is_Human() then
			Story_Event("REP_GLADIATOR_UNLEASHED")
			p_republic.Unlock_Tech(Find_Object_Type("Dummy_Research_Gladiator"))
		end
    end
end

function State_Rep_Foerost_Gladiator_Researched(message)
	if message == OnEnter then
		if p_republic.Is_Human() then
			p_republic.Unlock_Tech(Find_Object_Type("Generic_Gladiator"))
		end
    end
end
