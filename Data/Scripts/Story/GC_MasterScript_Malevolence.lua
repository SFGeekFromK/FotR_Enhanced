
--******************************************************--
--********  Campaign: Hunt for the Malevolence  ********--
--******************************************************--

require("PGStoryMode")
require("PGSpawnUnits")
require("eawx-util/ChangeOwnerUtilities")
StoryUtil = require("eawx-util/StoryUtil")
require("deepcore/crossplot/crossplot")
require("deepcore/std/class")
require("deepcore/std/Observable")
require("eawx-util/GalacticUtil")
require("SetFighterResearch")

UnitUtil = require("eawx-util/UnitUtil")
ModContentLoader = require("eawx-std/ModContentLoader")

function Definitions()
    DebugMessage("%s -- In Definitions", tostring(Script))

    ServiceRate = 5.0

    StoryModeEvents = {
		-- Generic
        Trigger_GC_Set_Up = State_GC_Set_Up,
		Trigger_Framework_Activation = State_Framework_Activation,

		-- CIS
		CIS_Malevolence_Hunt_Moorja_Speech = State_CIS_Malevolence_Hunt_Moorja_Speech,
		CIS_Kaliida_Nebula_Conquest = State_CIS_Kaliida_Nebula_Conquest,
		CIS_GC_Progression_Rimward_Research = State_CIS_GC_Progression_Rimward_Research,
		CIS_Cruel_AI_Activated = State_CIS_Cruel_AI_Activated,
		CIS_Cruel_AI_Deactivated = State_CIS_Cruel_AI_Deactivated,

		-- Republic
		Rep_Malevolence_Hunt_Anakin_Bormus = State_Rep_Malevolence_Hunt_Anakin_Bormus,
		Rep_Malevolence_Hunt_Y_Wing_Research = State_Rep_Malevolence_Hunt_Y_Wing_Research,
  		Rep_Malevolence_Hunt_Speech_01 = State_Rep_Kaliida_Checker,
		Rep_Malevolence_Hunt_Speech_08 = State_Rep_Post_Malevolence,
  }

	p_cis = Find_Player("Rebel")
	p_republic = Find_Player("Empire")

	gc_start = false
	all_planets_conquered = false
	act_1_active = false
	act_2_active = false
	act_3_active = false

	malevolence_mission_ii_active = false
	malevolence_destroyed = false

	crossplot:galactic()
	crossplot:subscribe("HISTORICAL_GC_CHOICE_OPTION", State_Historical_GC_Choice)
end


function State_GC_Set_Up(message)
    if message == OnEnter then
		crossplot:publish("POPUPEVENT", "HISTORICAL_GC_CHOICE", {"STORY", "NO_INTRO", "NO_STORY"}, { },
				{ }, { },
				{ }, { },
				{ }, { },
				"HISTORICAL_GC_CHOICE_OPTION")

		-- CIS
		Find_Player("Rebel").Unlock_Tech(Find_Object_Type("Separatist_Council"))

		Find_Player("Rebel").Lock_Tech(Find_Object_Type("NewRep_Senate"))
		Find_Player("Rebel").Lock_Tech(Find_Object_Type("Random_Mercenary"))

		-- Republic
		Find_Player("Empire").Unlock_Tech(Find_Object_Type("Republic_Sector_Capital"))
		Find_Player("Empire").Unlock_Tech(Find_Object_Type("Class_C_Frigate"))
		Find_Player("Empire").Unlock_Tech(Find_Object_Type("Class_C_Support"))
		--Find_Player("Empire").Unlock_Tech(Find_Object_Type("Generic_Venator"))
		Find_Player("Empire").Unlock_Tech(Find_Object_Type("Invincible_Cruiser"))
		-- FotR_Enhanced
		Find_Player("Empire").Unlock_Tech(Find_Object_Type("Generic_Venator_OFC_Campaign"))

		Find_Player("Empire").Lock_Tech(Find_Object_Type("Remnant_Capital"))
		Find_Player("Empire").Lock_Tech(Find_Object_Type("Generic_Victory_Destroyer"))
		Find_Player("Empire").Lock_Tech(Find_Object_Type("Pelta_Support"))
		Find_Player("Empire").Lock_Tech(Find_Object_Type("Pelta_Assault"))

		Find_Player("Empire").Lock_Tech(Find_Object_Type("Coburn_Retire"))
		Find_Player("Empire").Lock_Tech(Find_Object_Type("Yularen_Retire"))
		Find_Player("Empire").Lock_Tech(Find_Object_Type("Plo_Retire"))
		Find_Player("Empire").Lock_Tech(Find_Object_Type("Rex_Retire"))
		Find_Player("Empire").Lock_Tech(Find_Object_Type("Plo_Assign"))
		Find_Player("Empire").Lock_Tech(Find_Object_Type("Gree_Assign"))
		Find_Player("Empire").Lock_Tech(Find_Object_Type("Luminara_Assign"))
		Find_Player("Empire").Lock_Tech(Find_Object_Type("Tenant_Assign"))

		Set_Fighter_Research("RepublicWarpods")
    end
end

function State_Historical_GC_Choice(choice)
	if choice == "HISTORICAL_GC_CHOICE_STORY" then
		if p_cis.Is_Human() then
			Create_Thread("State_CIS_Story_Set_Up")

			GlobalValue.Set("HfM_Plo_Rescued", 1)
			GlobalValue.Set("CIS_Pelta_Kill_Count", 0)
			GlobalValue.Set("CIS_Haven_Kill_Count", 0)
			GlobalValue.Set("HfM_Malevolence_Alive", 1)

			Story_Event("CIS_INTRO_START")
		end
		if p_republic.Is_Human() then
			Create_Thread("State_Rep_Story_Set_Up")

			GlobalValue.Set("HfM_Plo_Rescued", 1)
			GlobalValue.Set("HfM_Battle_Counter", 0)
			GlobalValue.Set("HfM_Malevolence_Alive", 1)

			Story_Event("REP_INTRO_START")
		end
	end
	if choice == "HISTORICAL_GC_CHOICE_NO_INTRO" then
		if p_cis.Is_Human() then
			GlobalValue.Set("HfM_Plo_Rescued", 1)
			GlobalValue.Set("CIS_Pelta_Kill_Count", 0)
			GlobalValue.Set("CIS_Haven_Kill_Count", 0)
			GlobalValue.Set("HfM_Malevolence_Alive", 1)

			Create_Thread("State_CIS_Story_Set_Up")
		end
		if p_republic.Is_Human() then
			GlobalValue.Set("HfM_Plo_Rescued", 1)
			GlobalValue.Set("HfM_Battle_Counter", 0)
			GlobalValue.Set("HfM_Malevolence_Alive", 1)

			Create_Thread("State_Rep_Story_Set_Up")
		end
	end
	if choice == "HISTORICAL_GC_CHOICE_NO_STORY" then
		Create_Thread("State_Generic_Story_Set_Up")
	end
end

function State_Framework_Activation(message) -- FotR_Enhanced : hero decrements matched to vanilla amounts
    if message == OnEnter then
		GlobalValue.Set("CURRENT_ERA", 2)
		crossplot:publish("INITIALIZE_AI", "empty")
		crossplot:publish("VENATOR_HEROES", "empty")

		--Admirals:
		crossplot:publish("REPUBLIC_ADMIRAL_DECREMENT", 2, 1) -- 5 - (2+2) = 1 
		crossplot:publish("REPUBLIC_ADMIRAL_LOCKIN", {"Coburn","Yularen"}, 1)
		crossplot:publish("REPUBLIC_ADMIRAL_EXIT", {"Maarisa","Martz","Baraka","Grumby","Forral","Autem","Tallon","Dallin","Pellaeon","Dao"}, 1)

		--Moffs:
		crossplot:publish("REPUBLIC_ADMIRAL_DECREMENT", 2, 2)

		--Jedi:
		crossplot:publish("REPUBLIC_ADMIRAL_DECREMENT", 2, 3) -- 
		crossplot:publish("REPUBLIC_ADMIRAL_LOCKIN", {"Plo"}, 3)
		crossplot:publish("REPUBLIC_ADMIRAL_EXIT", {"Ahsoka","Luminara","Barriss","Kit","Shaak","Kota","Knol"}, 3)

		--Clone Officers:
		crossplot:publish("REPUBLIC_ADMIRAL_DECREMENT", 2, 4) -- 4 - (1+2) = 1 
		crossplot:publish("REPUBLIC_ADMIRAL_LOCKIN", {"Rex"}, 4)
		crossplot:publish("REPUBLIC_ADMIRAL_EXIT", {"Gree_Clone","Bacara","Cody"}, 4)
		crossplot:publish("REPUBLIC_ADMIRAL_RETURN", {"Jet"}, 4)

		--Commandos:
		crossplot:publish("REPUBLIC_ADMIRAL_DECREMENT", 3, 5)

		--Generals:
		crossplot:publish("REPUBLIC_ADMIRAL_DECREMENT", 3, 6)
	else
		crossplot:update()
    end
end

function State_Generic_Story_Set_Up()
	StoryUtil.SpawnAtSafePlanet("MOORJA", Find_Player("Rebel"), StoryUtil.GetSafePlanetTable(), {"Argente_Team"})

	StoryUtil.SpawnAtSafePlanet("NABOO", Find_Player("Empire"), StoryUtil.GetSafePlanetTable(), {"Rex_Team"})
	StoryUtil.SpawnAtSafePlanet("BORMUS", Find_Player("Empire"), StoryUtil.GetSafePlanetTable(), {"Plo_Koon_Delta_Team","Ask_Aak_Team"})
	StoryUtil.SpawnAtSafePlanet("KALIIDA_NEBULA", Find_Player("Empire"), StoryUtil.GetSafePlanetTable(), {"Anakin_Ahsoka_Twilight_Team"})

	Clear_Fighter_Research("RepublicWarpods")

	gc_start = true

	if p_cis.Is_Human() then
		StoryUtil.ChangeAIPlayer("TECHNO_UNION", "CISFederationAIAlly")
		StoryUtil.ChangeAIPlayer("TRADE_FEDERATION", "CISFederationAIAlly")
		StoryUtil.ChangeAIPlayer("COMMERCE_GUILD", "CISFederationAIAlly")

	elseif p_republic.Is_Human() then
		Sleep(5)

		StoryUtil.ChangeAIPlayer("TECHNO_UNION", "None")
		StoryUtil.ChangeAIPlayer("TRADE_FEDERATION", "None")
		StoryUtil.ChangeAIPlayer("COMMERCE_GUILD", "None")

		Sleep(35)

		StoryUtil.ChangeAIPlayer("TECHNO_UNION", "CISFederationAI")
		StoryUtil.ChangeAIPlayer("TRADE_FEDERATION", "CISFederationAI")
		StoryUtil.ChangeAIPlayer("COMMERCE_GUILD", "CISFederationAI")

	end
end


function Story_Mode_Service()
	if gc_start then
		if p_cis.Is_Human() then
			if set_up_done then
				if not malevolence_destroyed and (GlobalValue.Get("HfM_Malevolence_Alive") == 0) then
					if TestValid(Find_First_Object("GRIEVOUS_MALEVOLENCE_HUNT_CAMPAIGN")) then
						Find_First_Object("GRIEVOUS_MALEVOLENCE_HUNT_CAMPAIGN").Despawn()
					end
					Story_Event("CIS_RIMWARD_GC")
					malevolence_destroyed = true
				end
			end
			--[[local all_planets = FindPlanet.Get_All_Planets()
			for _, planet in pairs(all_planets) do
				if planet.Get_Owner() == p_cis then
					if not all_planets_conquered then
						all_planets_conquered = true
						if TestValid(Find_First_Object("Grievous_Malevolence_Hunt_Campaign")) then
							StoryUtil.LoadCampaign("Sandbox_AU_Rimward_CIS", 0)
						elseif not TestValid(Find_First_Object("Grievous_Malevolence_Hunt_Campaign")) then
							StoryUtil.LoadCampaign("Sandbox_Rimward_CIS", 0)
						end
					end
				end
			end]]
		elseif p_republic.Is_Human() then
			if set_up_done then
				if not malevolence_mission_ii_active and (GlobalValue.Get("HfM_Battle_Counter") == 1) then
					Story_Event("PART_II_ACTIVE")
					malevolence_mission_ii_active = true
				end
				if not malevolence_destroyed and (GlobalValue.Get("HfM_Malevolence_Alive") == 0) then
					Story_Event("REP_RIMWARD_GC")
					malevolence_destroyed = true
				end
			end
			--[[local all_planets = FindPlanet.Get_All_Planets()
			for _, planet in pairs(all_planets) do
				if planet.Get_Owner() == p_republic then
					if not all_planets_conquered then
						all_planets_conquered = true
						StoryUtil.LoadCampaign("Sandbox_AU_Rimward_Republic", 1)
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

		p_kaliida = FindPlanet("Kaliida_Nebula")
		p_moorja = FindPlanet("Moorja")

		gc_start = true

		StoryUtil.ChangeAIPlayer("TECHNO_UNION", "CISFederationAIAlly")
		StoryUtil.ChangeAIPlayer("TRADE_FEDERATION", "CISFederationAIAlly")
		StoryUtil.ChangeAIPlayer("COMMERCE_GUILD", "CISFederationAIAlly")

		local spawn_list_kaliida = {
			"Generic_Venator",
			"Generic_Venator",
			"Generic_Venator",
			"Generic_Venator",
			"Generic_Venator",
		}
		KaliidaSpawn = SpawnList(spawn_list_kaliida, FindPlanet("Kaliida_Nebula"), p_republic, false, false)

		StoryUtil.SetPlanetRestricted("KALIIDA_NEBULA", 1)
		StoryUtil.SetPlanetRestricted("MOORJA", 1)

		StoryUtil.SpawnAtSafePlanet("NABOO", Find_Player("Empire"), StoryUtil.GetSafePlanetTable(), {"Rex_Team"})
		StoryUtil.SpawnAtSafePlanet("BORMUS", Find_Player("Empire"), StoryUtil.GetSafePlanetTable(), {"Plo_Koon_Delta_Team","Ask_Aak_Team"})
		StoryUtil.SpawnAtSafePlanet("KALIIDA_NEBULA", Find_Player("Empire"), StoryUtil.GetSafePlanetTable(), {"Anakin_Ahsoka_Twilight_Team"})

		plot = Get_Story_Plot("Conquests\\CloneWarsMalevolence\\Story_Sandbox_Malevolence_CIS.XML")

		Set_Fighter_Hero("AXE_BLUE_SQUADRON","YULAREN_RESOLUTE")

		--event_act_1 = plot.Get_Event("CIS_Malevolence_Hunt_Act_I_Dialog")
		--event_act_1.Set_Dialog("DIALOG_MALEVOLENCE_HUNT_CIS")
		--event_act_1.Clear_Dialog_Text()
		--event_act_1.Add_Dialog_Text("TEXT_STORY_MALEVOLENCE_HUNT_CIS_PELTA_KILL", 0)
		--event_act_1.Add_Dialog_Text("TEXT_STORY_MALEVOLENCE_HUNT_CIS_HAVEN_KILL", 0)

		event_act_2 = plot.Get_Event("CIS_Malevolence_Hunt_Act_II_Dialog")
		event_act_2.Set_Dialog("DIALOG_MALEVOLENCE_HUNT_CIS")
		event_act_2.Clear_Dialog_Text()
		if p_kaliida.Get_Owner() ~= p_cis then
			event_act_2.Add_Dialog_Text("TEXT_INTERVENTION_PLANET_CONQUEST_LOCATION", p_kaliida)
		else
			event_act_2.Add_Dialog_Text("TEXT_INTERVENTION_PLANET_CONQUEST_LOCATION_COMPLETE", p_kaliida)
		end
		
		event_act_5 = plot.Get_Event("CIS_Malevolence_Hunt_Moorja_Dialog")
		event_act_5.Set_Dialog("DIALOG_MALEVOLENCE_HUNT_CIS")
		event_act_5.Clear_Dialog_Text()
		if p_moorja.Get_Owner() ~= p_cis then
			event_act_5.Add_Dialog_Text("TEXT_INTERVENTION_PLANET_CONQUEST_LOCATION", p_moorja)
		else
			event_act_5.Add_Dialog_Text("TEXT_INTERVENTION_PLANET_CONQUEST_LOCATION_COMPLETE", p_moorja)
		end

		Create_Thread("State_CIS_Planet_Checker")
		Create_Thread("State_CIS_Moorja_Checker")

		Sleep(5)

		StoryUtil.ChangeAIPlayer("EMPIRE", "RepublicMissionAI")
	end
end

function State_CIS_Pelta_Kill_Checker()
	plot = Get_Story_Plot("Conquests\\CloneWarsMalevolence\\Story_Sandbox_Malevolence_CIS.XML")
	event_act_1 = plot.Get_Event("CIS_Malevolence_Hunt_Act_I_Dialog")
	event_act_1.Set_Dialog("DIALOG_MALEVOLENCE_HUNT_CIS")
	event_act_1.Clear_Dialog_Text()

	pelta_kills = GlobalValue.Get("CIS_Pelta_Kill_Count")
	haven_kills = GlobalValue.Get("CIS_Haven_Kill_Count")
	if (pelta_kills < 10) and (haven_kills < 1) then
		event_act_1.Add_Dialog_Text("TEXT_STORY_MALEVOLENCE_HUNT_CIS_PELTA_KILL", pelta_kills)
		event_act_1.Add_Dialog_Text("TEXT_STORY_MALEVOLENCE_HUNT_CIS_HAVEN_KILL", haven_kills)
		Sleep(5.0)
		Create_Thread("State_CIS_Pelta_Kill_Checker")
	elseif (pelta_kills < 10) and (haven_kills >= 1) then
		event_act_1.Add_Dialog_Text("TEXT_STORY_MALEVOLENCE_HUNT_CIS_PELTA_KILL", pelta_kills)
		event_act_1.Add_Dialog_Text("TEXT_STORY_MALEVOLENCE_HUNT_CIS_HAVEN_KILL_COMPLETED", haven_kills)
		Sleep(5.0)
		Create_Thread("State_CIS_Pelta_Kill_Checker")
	elseif (pelta_kills >= 10) and (haven_kills < 1) then
		event_act_1.Add_Dialog_Text("TEXT_STORY_MALEVOLENCE_HUNT_CIS_PELTA_KILL_COMPLETED", pelta_kills)
		event_act_1.Add_Dialog_Text("TEXT_STORY_MALEVOLENCE_HUNT_CIS_HAVEN_KILL", haven_kills)
		Sleep(5.0)
		Create_Thread("State_CIS_Pelta_Kill_Checker")
	elseif (pelta_kills >= 10) and (haven_kills >= 1) then
		event_act_1.Add_Dialog_Text("TEXT_STORY_MALEVOLENCE_HUNT_CIS_PELTA_KILL_COMPLETED", pelta_kills)
		event_act_1.Add_Dialog_Text("TEXT_STORY_MALEVOLENCE_HUNT_CIS_HAVEN_KILL_COMPLETED", haven_kills)
		Story_Event("CIS_PELTA_PERSUE_COMPLETED")
	end
end

function State_CIS_Planet_Checker()
	event_act_2 = plot.Get_Event("CIS_Malevolence_Hunt_Act_II_Dialog")
	event_act_2.Set_Dialog("DIALOG_MALEVOLENCE_HUNT_CIS")
	event_act_2.Clear_Dialog_Text()
	if p_kaliida.Get_Owner() ~= p_cis then
		event_act_2.Add_Dialog_Text("TEXT_INTERVENTION_PLANET_CONQUEST_LOCATION", p_kaliida)
		Sleep(5.0)
		Create_Thread("State_CIS_Planet_Checker")
	else
		event_act_2.Add_Dialog_Text("TEXT_INTERVENTION_PLANET_CONQUEST_LOCATION_COMPLETE", p_kaliida)
		Story_Event("CIS_KALIIDA_CONQUEST")
	end
end

function State_CIS_Moorja_Checker()
	event_act_5 = plot.Get_Event("CIS_Malevolence_Hunt_Moorja_Dialog")
	event_act_5.Set_Dialog("DIALOG_MALEVOLENCE_HUNT_CIS")
	event_act_5.Clear_Dialog_Text()
	if p_moorja.Get_Owner() ~= p_cis then
		event_act_5.Add_Dialog_Text("TEXT_INTERVENTION_PLANET_CONQUEST_LOCATION", p_moorja)
		Sleep(5.0)
		Create_Thread("State_CIS_Moorja_Checker")
	else
		event_act_5.Add_Dialog_Text("TEXT_INTERVENTION_PLANET_CONQUEST_LOCATION_COMPLETE", p_moorja)
		Story_Event("CIS_MOORJA_CONQUEST")
		local Safe_House_Planet = StoryUtil.GetSafePlanetTable()
		StoryUtil.SpawnAtSafePlanet("MOORJA", Find_Player("Rebel"), Safe_House_Planet, {"Argente_Team"})
		Clear_Fighter_Research("RepublicWarpods")
	end
end

function State_CIS_Malevolence_Hunt_Moorja_Speech(message)
	if message == OnEnter then
		StoryUtil.SetPlanetRestricted("MOORJA", 0)
	end
end

function State_CIS_Kaliida_Nebula_Conquest(message)
	if message == OnEnter then
		local p_kaliida = FindPlanet("KALIIDA_NEBULA")
		if (GlobalValue.Get("HfM_Malevolence_Alive") == 1) then
			grievous_list = {"Grievous_Malevolence_Hunt_Campaign"}
			GrievousSpawn = SpawnList(grievous_list, p_kaliida, p_cis, true, false)
		end
		StoryUtil.SetPlanetRestricted("KALIIDA_NEBULA", 0)
	end
end

function State_CIS_GC_Progression_Rimward_Research(message)
	if message == OnEnter then
		if TestValid(Find_First_Object("Grievous_Malevolence_Hunt_Campaign")) then
			Story_Event("RIMWARD_GC_PROGRESSION_AU")
		elseif not TestValid(Find_First_Object("Grievous_Malevolence_Hunt_Campaign")) then
			Story_Event("RIMWARD_GC_PROGRESSION")
		end
	end
end

function State_CIS_Cruel_AI_Activated(message)
	if message == OnEnter then
		local spawn_list_kaliida = {
			"Generic_Venator",
			"Generic_Venator",
			"Generic_Venator",
			"Generic_Venator",
			"Generic_Venator",
		}
		KaliidaSpawn = SpawnList(spawn_list_kaliida, FindPlanet("Kaliida_Nebula"), p_republic, false, false)
	end
end

function State_CIS_Cruel_AI_Deactivated(message)
	if message == OnEnter then
		for i=1,5 do
			local venator = Find_First_Object("Generic_Venator")
			if TestValid(venator) then
				venator.Despawn()
			end
		end
		local spawn_list_kaliida = {
			"Generic_Venator",
			"Generic_Venator",
			"Generic_Venator",
			"Generic_Venator",
			"Generic_Venator",
		}
		KaliidaSpawn = SpawnList(spawn_list_kaliida, FindPlanet("Kaliida_Nebula"), p_republic, false, false)
	end
end

-- Republic

function State_Rep_Story_Set_Up()
	if p_republic.Is_Human() then
		Story_Event("REP_STORY_START")

		set_up_done = true

		gc_start = true

		Set_Fighter_Hero("AXE_BLUE_SQUADRON","YULAREN_RESOLUTE")

		StoryUtil.SpawnAtSafePlanet("MOORJA", Find_Player("Rebel"), StoryUtil.GetSafePlanetTable(), {"Argente_Team"})
		--StoryUtil.SpawnAtSafePlanet("MOORJA", Find_Player("Rebel"), StoryUtil.GetSafePlanetTable(), {"Doctor_Instinction"})

		StoryUtil.SpawnAtSafePlanet("NABOO", Find_Player("Empire"), StoryUtil.GetSafePlanetTable(), {"Rex_Team"})
		StoryUtil.SpawnAtSafePlanet("BORMUS", Find_Player("Empire"), StoryUtil.GetSafePlanetTable(), {"Plo_Koon_Delta_Team"})
		StoryUtil.SpawnAtSafePlanet("KALIIDA_NEBULA", Find_Player("Empire"), StoryUtil.GetSafePlanetTable(), {"Anakin_Ahsoka_Twilight_Team"})

		Sleep(5)

		StoryUtil.ChangeAIPlayer("TECHNO_UNION", "None")
		StoryUtil.ChangeAIPlayer("TRADE_FEDERATION", "None")
		StoryUtil.ChangeAIPlayer("COMMERCE_GUILD", "None")

		Sleep(35)

		StoryUtil.ChangeAIPlayer("TECHNO_UNION", "CISFederationAI")
		StoryUtil.ChangeAIPlayer("TRADE_FEDERATION", "CISFederationAI")
		StoryUtil.ChangeAIPlayer("COMMERCE_GUILD", "CISFederationAI")
	end
end

function State_Rep_Malevolence_Hunt_Anakin_Bormus(message)
	if message == OnEnter then
		Story_Event("REP_BORMUS_REACHED")
		Story_Event("REP_BORMUS_NEGOTIATIONS")
		p_republic.Unlock_Tech(Find_Object_Type("Dummy_Research_Ywing"))
	end
end

function State_Rep_Malevolence_Hunt_Y_Wing_Research(message)
	if message == OnEnter then
		Story_Event("REP_YWINGS_RESEARCHED")
		StoryUtil.SpawnAtSafePlanet("BORMUS", p_republic, StoryUtil.GetSafePlanetTable(), {"Ask_Aak_Team"})
	end
end

function State_Rep_Kaliida_Checker(message)
	if message == OnUpdate then
		local p_cis = Find_Player("Rebel")
		local p_republic = Find_Player("Empire")
		local start_planet = FindPlanet("Kaliida_Nebula")

		if p_republic.Is_Human() then
			if start_planet.Get_Owner() ~= p_republic then
				Story_Event("REP_KALIIDA_FALL")
			end
		end
	end
end

function State_Rep_Post_Malevolence(message)
	if message == OnEnter then
		StoryUtil.SpawnAtSafePlanet("NABOO", p_republic, StoryUtil.GetSafePlanetTable(), {"Padme_Amidala_Team"})
		StoryUtil.SpawnAtSafePlanet("NABOO", p_republic, StoryUtil.GetSafePlanetTable(), {"Obi_Wan_Delta_Team"})
		p_republic.Unlock_Tech(Find_Object_Type("Pelta_Assault"))
		p_republic.Unlock_Tech(Find_Object_Type("Pelta_Support"))
	end
end
