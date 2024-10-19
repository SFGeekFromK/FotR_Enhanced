
--****************************************************--
--**   Fall of the Republic: Tennuutta Skirmishes   **--
--****************************************************--

require("PGStoryMode")
require("PGBase")
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

    StoryModeEvents = {
		-- Generic
        Trigger_GC_Set_Up = State_GC_Set_Up,
		Trigger_Framework_Activation = State_Framework_Activation,

		-- CIS
		CIS_Venator_Venture_Epilogue = State_CIS_Venator_Venture_Epilogue,
		CIS_Tennuutta_Skirmishes_Handooine_Scounting = State_CIS_Tennuutta_Skirmishes_Handooine_Scounting,
		Trigger_CIS_Tennuutta_Skirmishes_Test_Field = State_CIS_Tennuutta_Test_Field_Search_Phase_01,
		Trigger_CIS_Lok_Durd_Enter_Vorzyd = State_CIS_Tennuutta_Test_Field_Search_Phase_02,
		Trigger_CIS_Lok_Durd_Enter_Ringo_Vinda = State_CIS_Tennuutta_Test_Field_Search_Phase_03,
		Trigger_CIS_Lok_Durd_Enter_Maridun = State_CIS_Tennuutta_Test_Field_Search_Phase_04,
		CIS_Maridun_Marauder_Epilogue = State_CIS_Maridun_Marauder_Epilogue,
		CIS_GC_Progression_ODL_Research = State_CIS_GC_Progression_ODL_Research,

		-- Republic
		Rep_Crash_Course_Epilogue = State_Rep_Crash_Course_Epilogue,
		Trigger_Rep_Tennuutta_Jedi_Search = State_Rep_Tennuutta_Jedi_Search,
		Rep_Tennuutta_Skirmishes_Scouting_01 = State_Rep_Tennuutta_Skirmishes_Scouting_01,
		Rep_Tennuutta_Skirmishes_Scouting_02 = State_Rep_Tennuutta_Skirmishes_Scouting_02,
		Rep_Tennuutta_Skirmishes_Scouting_03 = State_Rep_Tennuutta_Skirmishes_Scouting_03,
		Trigger_Rep_Tennuutta_Jedi_Found = State_Rep_Tennuutta_Jedi_Found,
		Rep_Maridun_Marauder_Epilogue = State_Rep_Maridun_Marauder_Epilogue,
		Trigger_Rep_Tennuutta_Command_Meeting = State_Rep_Tennuutta_Command_Meeting,
	}

	p_cis = Find_Player("Rebel")
	p_republic = Find_Player("Empire")
	p_hutts = Find_Player("Hutt_Cartels")
	p_cg = Find_Player("Commerce_Guild")
	p_tu = Find_Player("Techno_Union")
	p_tf = Find_Player("Trade_Federation")

	gc_start = false
	all_planets_conquered = false

	target_planets_conquered = false

	is_intro = false

	crossplot:galactic()
	crossplot:subscribe("HISTORICAL_GC_CHOICE_OPTION", State_Historical_GC_Choice)
end

function State_GC_Set_Up(message)
    if message == OnEnter then
		if p_cis.Is_Human() then
			GlobalValue.Set("Tennuutta_CIS_GC_Version", 0) -- 1 = AU Version; 0 = Canonical Version

			if TestValid(Find_First_Object("GC_AU_Dummy")) then
				GlobalValue.Set("Tennuutta_CIS_GC_Version", 1) -- 1 = AU Version; 0 = Canonical Version
			end
		elseif p_republic.Is_Human() then
			GlobalValue.Set("Tennuutta_Rep_GC_Version", 0) -- 1 = AU Version; 0 = Canonical Version

			if TestValid(Find_First_Object("GC_AU_Dummy")) then
				GlobalValue.Set("Tennuutta_Rep_GC_Version", 1) -- 1 = AU Version; 0 = Canonical Version
			end
		end

		crossplot:publish("POPUPEVENT", "HISTORICAL_GC_CHOICE", {"STORY", "NO_INTRO", "NO_STORY"}, { },
				{ }, { },
				{ }, { },
				{ }, { },
				"HISTORICAL_GC_CHOICE_OPTION")

		-- CIS
		Find_Player("Rebel").Unlock_Tech(Find_Object_Type("Recusant_Dreadnought"))
		Find_Player("Rebel").Unlock_Tech(Find_Object_Type("Providence_Dreadnought"))
		Find_Player("Rebel").Unlock_Tech(Find_Object_Type("Separatist_Council"))

		Find_Player("Rebel").Lock_Tech(Find_Object_Type("NewRep_Senate"))
		Find_Player("Rebel").Lock_Tech(Find_Object_Type("Random_Mercenary"))

		-- Republic
		Find_Player("Empire").Unlock_Tech(Find_Object_Type("Republic_Naval_Command_Centre"))
		Find_Player("Empire").Unlock_Tech(Find_Object_Type("Republic_Sector_Capital"))
		Find_Player("Empire").Unlock_Tech(Find_Object_Type("Generic_Venator"))

		Find_Player("Empire").Lock_Tech(Find_Object_Type("Generic_Victory_Destroyer"))
		Find_Player("Empire").Lock_Tech(Find_Object_Type("Invincible_Cruiser"))
		Find_Player("Empire").Lock_Tech(Find_Object_Type("Remnant_Capital"))

		Find_Player("Empire").Lock_Tech(Find_Object_Type("Rom_Mohc_Retire"))
		Find_Player("Empire").Lock_Tech(Find_Object_Type("Yularen_Assign"))
		Find_Player("Empire").Lock_Tech(Find_Object_Type("Aayla_Assign"))
		Find_Player("Empire").Lock_Tech(Find_Object_Type("Ahsoka_Assign"))
		Find_Player("Empire").Lock_Tech(Find_Object_Type("Bly_Assign"))
		Find_Player("Empire").Lock_Tech(Find_Object_Type("Rex_Assign"))

		GlobalValue.Set("CURRENT_CLONE_PHASE", 1)
    end
end

function State_Historical_GC_Choice(choice)
	if choice == "HISTORICAL_GC_CHOICE_STORY" then
		if p_cis.Is_Human() then
			Create_Thread("State_CIS_Story_Set_Up")

			Story_Event("CIS_INTRO_START")
		end
		if p_republic.Is_Human() then
			Create_Thread("State_Rep_Story_Set_Up")

			is_intro = true
		end
	end
	if choice == "HISTORICAL_GC_CHOICE_NO_INTRO" then
		if p_cis.Is_Human() then
			Create_Thread("State_CIS_Story_Set_Up")
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
		GlobalValue.Set("CURRENT_ERA", 2)
		crossplot:publish("INITIALIZE_AI", "empty")
		crossplot:publish("VENATOR_HEROES", "empty")
		-- FotR_Enhanced
		crossplot:publish("GEEN_UNLOCK", "empty")

		--Admirals: 5 - 3 = 2
		crossplot:publish("REPUBLIC_ADMIRAL_DECREMENT", 3, 1)
		crossplot:publish("REPUBLIC_ADMIRAL_EXIT", {"Kilian","Yularen"}, 1)

		--Moffs: 0
		crossplot:publish("REPUBLIC_ADMIRAL_DECREMENT", 1, 2)

		--Jedi: 1
		crossplot:publish("REPUBLIC_ADMIRAL_DECREMENT", 2, 3)
		crossplot:publish("REPUBLIC_ADMIRAL_EXIT", {"Aayla","Ahsoka","Kit","Mace","Shaak","Yoda"}, 3)

		--Clone Officers: 2
		crossplot:publish("REPUBLIC_ADMIRAL_EXIT", {"Bly","Cody","Rex","Gree_Clone","Bacara"}, 4)
		crossplot:publish("REPUBLIC_ADMIRAL_RETURN", {"Jet"}, 4)

		--Commandos: 1
		crossplot:publish("REPUBLIC_ADMIRAL_DECREMENT", 2, 5)

		--Generals: 2 (with Rom locked in)
		crossplot:publish("REPUBLIC_ADMIRAL_DECREMENT", 1, 6)
		crossplot:publish("REPUBLIC_ADMIRAL_LOCKIN", {"Rom"}, 6)

		Clear_Fighter_Hero("AXE_BLUE_SQUADRON")
		Clear_Fighter_Hero("BROADSIDE_SHADOW_SQUADRON")
	else
		crossplot:update()
    end
end

function Story_Mode_Service()
	if gc_start then
		if p_cis.Is_Human() then
			--[[local all_planets = FindPlanet.Get_All_Planets()
			for _, planet in pairs(all_planets) do
				if planet.Get_Owner() == p_cis then
					if not all_planets_conquered then
						all_planets_conquered = true
						if (GlobalValue.Get("Tennuutta_CIS_GC_Version") == 1) then
							StoryUtil.LoadCampaign("Sandbox_AU_DurgesLance_CIS", 0)
						else
							StoryUtil.LoadCampaign("Sandbox_DurgesLance_CIS", 0)
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
						StoryUtil.LoadCampaign("Sandbox_AU_TennuuttaSkirimishes_Republic", 1)
					end
				end
			end]]
		end
	end
end

function State_Generic_Story_Set_Up()
	Find_Player("Empire").Unlock_Tech(Find_Object_Type("Republic_Naval_Command_Centre"))

	StoryUtil.SpawnAtSafePlanet("QUELL", Find_Player("Rebel"), StoryUtil.GetSafePlanetTable(), {"TF1726_Munificent"})

	gc_start = true
end

-- CIS

function State_CIS_Story_Set_Up()
	if p_cis.Is_Human() then
		Story_Event("CIS_STORY_START")

		p_roche = FindPlanet("Roche")
		p_metalorn = FindPlanet("Melalorn")
		p_centares = FindPlanet("Centares")
		p_salvara = FindPlanet("Salvara")
		p_handooine = FindPlanet("Handooine")
		p_maridun = FindPlanet("Maridun")
		p_murkhana = FindPlanet("Murkhana")

		Set_Fighter_Hero("AXE_BLUE_SQUADRON","YULAREN_RESOLUTE")
		Clear_Fighter_Hero("BROADSIDE_SHADOW_SQUADRON")

		gc_start = true

		StoryUtil.RevealPlanet("MARIDUN", false)
		StoryUtil.RevealPlanet("HANDOOINE", false)

		StoryUtil.SetPlanetRestricted("MARIDUN", 1)
		StoryUtil.SetPlanetRestricted("HANDOOINE", 1)

		Find_Player("Empire").Unlock_Tech(Find_Object_Type("Republic_Naval_Command_Centre"))

		local target_planet_list = {
			FindPlanet("Azure"),
			FindPlanet("Lianna"),
			FindPlanet("Roche"),
			FindPlanet("Handooine"),
			FindPlanet("Gavryn"),
		}

		local plot = Get_Story_Plot("Conquests\\CloneWarsTennuutta\\Story_Sandbox_Tennuutta_CIS.XML")

		event_act_1 = plot.Get_Event("CIS_Tennuutta_Skirmishes_Act_I_Dialog")
		event_act_1.Set_Dialog("DIALOG_TENNUUTTA_SKIRMISHES_CIS")
		event_act_1.Clear_Dialog_Text()
		for _,p_planet in pairs(target_planet_list) do
			if p_planet.Get_Owner() ~= p_cis then
				if p_planet.Get_Planet_Location() == FindPlanet("Handooine") then
					event_act_1.Add_Dialog_Text("TEXT_STORY_TENNUUTTA_SKIRMISHES_CIS_LOCATION_HANDOOINE", p_planet)
				else
					event_act_1.Add_Dialog_Text("TEXT_INTERVENTION_PLANET_CONQUEST_LOCATION", p_planet)
				end
			elseif p_planet.Get_Owner() == p_cis then
				event_act_1.Add_Dialog_Text("TEXT_INTERVENTION_PLANET_CONQUEST_LOCATION_COMPLETE", p_planet)
			end
		end

		local event_act_2 = plot.Get_Event("CIS_Tennuutta_Skirmishes_Act_II_Dialog")
		event_act_2.Set_Dialog("DIALOG_TENNUUTTA_SKIRMISHES_CIS")
		event_act_2.Clear_Dialog_Text()
		event_act_2.Add_Dialog_Text("TEXT_INTERVENTION_LOCATION", FindPlanet("Handooine"))

		Create_Thread("State_CIS_Tennuutta_Planet_Checker")
	end
end

function State_CIS_Tennuutta_Planet_Checker()
	local plot = Get_Story_Plot("Conquests\\CloneWarsTennuutta\\Story_Sandbox_Tennuutta_CIS.XML")

	event_act_1 = plot.Get_Event("CIS_Tennuutta_Skirmishes_Act_I_Dialog")
	event_act_1.Set_Dialog("DIALOG_TENNUUTTA_SKIRMISHES_CIS")
	event_act_1.Clear_Dialog_Text()
	local target_planet_list = {
		FindPlanet("Azure"),
		FindPlanet("Lianna"),
		FindPlanet("Roche"),
		FindPlanet("Handooine"),
		FindPlanet("Gavryn"),
	}

	for _,p_planet in pairs(target_planet_list) do
		if p_planet.Get_Owner() ~= p_cis then
			if p_planet.Get_Planet_Location() == FindPlanet("Handooine") then
				event_act_1.Add_Dialog_Text("TEXT_STORY_TENNUUTTA_SKIRMISHES_CIS_LOCATION_HANDOOINE", p_planet)
			else
				event_act_1.Add_Dialog_Text("TEXT_INTERVENTION_PLANET_CONQUEST_LOCATION", p_planet)
			end
		elseif p_planet.Get_Owner() == p_cis then
			event_act_1.Add_Dialog_Text("TEXT_INTERVENTION_PLANET_CONQUEST_LOCATION_COMPLETE", p_planet)
		end
	end
	if FindPlanet("Handooine").Get_Owner() == p_cis and FindPlanet("Lianna").Get_Owner() == p_cis and FindPlanet("Gavryn").Get_Owner() == p_cis and FindPlanet("Roche").Get_Owner() == p_cis and FindPlanet("Azure").Get_Owner() == p_cis then
		target_planets_conquered = true
	end
	Sleep(5.0)
	if not target_planets_conquered then
		Create_Thread("State_CIS_Tennuutta_Planet_Checker")
	else
		Story_Event("CIS_ACT_I_PLANETS_CONQUERED")
	end
end

function State_CIS_Venator_Venture_Epilogue(message)
	if message == OnEnter then
		if p_cis.Is_Human() then
			ChangePlanetOwnerAndRetreat(FindPlanet("Quell"), p_cis)

			local Safe_House_Planet = StoryUtil.GetSafePlanetTable()
			StoryUtil.SpawnAtSafePlanet("QUELL", Find_Player("Rebel"), Safe_House_Planet, {"TF1726_Munificent"})
		end
	end
end

function State_CIS_Tennuutta_Planet_Checker()
	local plot = Get_Story_Plot("Conquests\\CloneWarsTennuutta\\Story_Sandbox_Tennuutta_CIS.XML")

	event_act_1 = plot.Get_Event("CIS_Tennuutta_Skirmishes_Act_I_Dialog")
	event_act_1.Set_Dialog("DIALOG_TENNUUTTA_SKIRMISHES_CIS")
	event_act_1.Clear_Dialog_Text()
	local target_planet_list = {
		FindPlanet("Azure"),
		FindPlanet("Lianna"),
		FindPlanet("Roche"),
		FindPlanet("Handooine"),
		FindPlanet("Gavryn"),
	}

	for _,p_planet in pairs(target_planet_list) do
		if p_planet.Get_Owner() ~= p_cis then
			if p_planet.Get_Planet_Location() == FindPlanet("Handooine") then
				event_act_1.Add_Dialog_Text("TEXT_STORY_TENNUUTTA_SKIRMISHES_CIS_LOCATION_HANDOOINE", p_planet)
			else
				event_act_1.Add_Dialog_Text("TEXT_INTERVENTION_PLANET_CONQUEST_LOCATION", p_planet)
			end
		elseif p_planet.Get_Owner() == p_cis then
			event_act_1.Add_Dialog_Text("TEXT_INTERVENTION_PLANET_CONQUEST_LOCATION_COMPLETE", p_planet)
		end
	end
	if FindPlanet("Handooine").Get_Owner() == p_cis and FindPlanet("Lianna").Get_Owner() == p_cis and FindPlanet("Gavryn").Get_Owner() == p_cis and FindPlanet("Roche").Get_Owner() == p_cis and FindPlanet("Azure").Get_Owner() == p_cis then
		target_planets_conquered = true
	end
	Sleep(5.0)
	if not target_planets_conquered then
		Create_Thread("State_CIS_Tennuutta_Planet_Checker")
	else
		Story_Event("CIS_ACT_I_PLANETS_CONQUERED")
	end
end

function State_CIS_Tennuutta_Skirmishes_Handooine_Scounting(message)
	if message == OnEnter then
		if p_cis.Is_Human() then
			StoryUtil.SetPlanetRestricted("HANDOOINE", 0)
			Story_Event("CIS_HANDOOINE_SCOUTED")
		end
    end
end

function State_CIS_Tennuutta_Test_Field_Search_Phase_01(message)
    if message == OnEnter then
		if p_cis.Is_Human() then
			local plot = Get_Story_Plot("Conquests\\CloneWarsTennuutta\\Story_Sandbox_Tennuutta_CIS.XML")

			event_act_3 = plot.Get_Event("CIS_Tennuutta_Skirmishes_Act_III_01_Dialog")
			event_act_3.Set_Dialog("DIALOG_TENNUUTTA_SKIRMISHES_CIS")
			event_act_3.Clear_Dialog_Text()

			event_act_3.Add_Dialog_Text("TEXT_INTERVENTION_LOCATION", FindPlanet("Vorzyd"))

			local Safe_House_Planet = StoryUtil.GetSafePlanetTable()
			StoryUtil.SpawnAtSafePlanet("SALVARA", Find_Player("Rebel"), Safe_House_Planet, {"Lok_Durd_Team"})

			Story_Event("CIS_TEST_FIELD_PHASE_01")
		end
    end
end

function State_CIS_Tennuutta_Test_Field_Search_Phase_02(message)
    if message == OnEnter then
		if p_cis.Is_Human() then
			local plot = Get_Story_Plot("Conquests\\CloneWarsTennuutta\\Story_Sandbox_Tennuutta_CIS.XML")

			event_act_3 = plot.Get_Event("CIS_Tennuutta_Skirmishes_Act_III_02_Dialog")
			event_act_3.Set_Dialog("DIALOG_TENNUUTTA_SKIRMISHES_CIS")
			event_act_3.Clear_Dialog_Text()

			event_act_3.Add_Dialog_Text("TEXT_INTERVENTION_LOCATION", FindPlanet("Ringo_Vinda"))

			Story_Event("CIS_TEST_FIELD_PHASE_02")
		end
    end
end

function State_CIS_Tennuutta_Test_Field_Search_Phase_03(message)
    if message == OnEnter then
		if p_cis.Is_Human() then
			local plot = Get_Story_Plot("Conquests\\CloneWarsTennuutta\\Story_Sandbox_Tennuutta_CIS.XML")

			event_act_3 = plot.Get_Event("CIS_Tennuutta_Skirmishes_Act_III_03_Dialog")
			event_act_3.Set_Dialog("DIALOG_TENNUUTTA_SKIRMISHES_CIS")
			event_act_3.Clear_Dialog_Text()

			event_act_3.Add_Dialog_Text("TEXT_INTERVENTION_LOCATION", FindPlanet("Maridun"))

			Story_Event("CIS_TEST_FIELD_PHASE_03")
		end
    end
end

function State_CIS_Tennuutta_Test_Field_Search_Phase_04(message)
    if message == OnEnter then
		if p_cis.Is_Human() then
			Story_Event("CIS_MARIDUN_TEST_FIELD_DONE")
		end
    end
end

function State_CIS_Tennuutta_Durd_Checker()
	if not TestValid("Lok_Durd") then
		local Safe_House_Planet = StoryUtil.GetSafePlanetTable()
		StoryUtil.SpawnAtSafePlanet("SALVARA", Find_Player("Rebel"), Safe_House_Planet, {"Lok_Durd_Team"})
	end
	Sleep(5.0)
	if not test_field_found then
		Create_Thread("State_CIS_Tennuutta_Durd_Checker")
	end
end

function State_CIS_Maridun_Marauder_Epilogue(message)
    if message == OnEnter then
		if p_cis.Is_Human() then
			Story_Event("CIS_DEFOLIATOR_UNLOCK_START")

			--Find_Player("Rebel").Unlock_Tech(Find_Object_Type("Defoliator"))
			StoryUtil.SetPlanetRestricted("MARIDUN", 0)

			test_field_found = true
			Sleep(5.0)
			UnitUtil.ReplaceAtLocation("Lok_Durd", "Durd_Team")
		end
    end
end

function State_CIS_GC_Progression_ODL_Research(message)
	if message == OnEnter then
		if (GlobalValue.Get("Tennuutta_CIS_GC_Version") == 0) then
			Story_Event("ODL_GC_PROGRESSION_AU")
		else
			Story_Event("ODL_GC_PROGRESSION")
		end
	end
end

-- Republic

function State_Rep_Story_Set_Up()
	if p_republic.Is_Human() then
		p_roche = FindPlanet("Roche")
		p_metalorn = FindPlanet("Melalorn")
		p_centares = FindPlanet("Centares")
		p_salvara = FindPlanet("Salvara")
		p_handooine = FindPlanet("Handooine")
		p_maridun = FindPlanet("Maridun")
		p_murkhana = FindPlanet("Murkhana")

		Set_Fighter_Hero("AXE_BLUE_SQUADRON","YULAREN_RESOLUTE")
		Clear_Fighter_Hero("BROADSIDE_SHADOW_SQUADRON")

		gc_start = true

		Find_Player("Empire").Lock_Tech(Find_Object_Type("Republic_Naval_Command_Centre"))

		StoryUtil.RevealPlanet("MARIDUN", false)
		StoryUtil.RevealPlanet("SALVARA", false)

		StoryUtil.SetPlanetRestricted("MARIDUN", 1)

		if (GlobalValue.Get("Tennuutta_Rep_GC_Version") == 1) then
			GlobalValue.Set("CURRENT_CLONE_PHASE", 2)
			crossplot:publish("CLONE_UPGRADES", "empty")
			Find_Player("Empire").Unlock_Tech(Find_Object_Type("Clonetrooper_Phase_Two_Team"))
			Find_Player("Empire").Unlock_Tech(Find_Object_Type("Republic_BARC_Company"))
			Find_Player("Empire").Unlock_Tech(Find_Object_Type("ARC_Phase_Two_Team"))

			Find_Player("Empire").Lock_Tech(Find_Object_Type("Clonetrooper_Phase_One_Team"))
			Find_Player("Empire").Lock_Tech(Find_Object_Type("Republic_74Z_Bike_Company"))
			Find_Player("Empire").Lock_Tech(Find_Object_Type("ARC_Phase_One_Team"))
		end

		if is_intro == true then
			Story_Event("REP_INTRO_START")
		end

		Story_Event("REP_STORY_START")

		local target_planet_list = {
			FindPlanet("Salvara"),
			FindPlanet("Abhean"),
			FindPlanet("Vorzyd"),
			FindPlanet("Ringo_Vinda"),
			FindPlanet("Murkhana"),
		}

		local plot = Get_Story_Plot("Conquests\\CloneWarsTennuutta\\Story_Sandbox_Tennuutta_Republic.XML")

		event_act_1 = plot.Get_Event("Rep_Tennuutta_Skirmishes_Act_I_Dialog")
		event_act_1.Set_Dialog("DIALOG_TENNUUTTA_SKIRMISHES_REP")
		event_act_1.Clear_Dialog_Text()
		for _,p_planet in pairs(target_planet_list) do
			if p_planet.Get_Owner() ~= p_republic then
				if p_planet.Get_Planet_Location() == FindPlanet("Salvara") then
					event_act_1.Add_Dialog_Text("TEXT_STORY_TENNUUTTA_SKIRMISHES_REP_LOCATION_SALVARA", p_planet)
				else
					event_act_1.Add_Dialog_Text("TEXT_INTERVENTION_PLANET_CONQUEST_LOCATION", p_planet)
				end
			elseif p_planet.Get_Owner() == p_republic then
				event_act_1.Add_Dialog_Text("TEXT_INTERVENTION_PLANET_CONQUEST_LOCATION_COMPLETE", p_planet)
			end
		end

		local event_act_3 = plot.Get_Event("Rep_Tennuutta_Skirmishes_Act_III_Dialog")
		event_act_3.Set_Dialog("DIALOG_TENNUUTTA_SKIRMISHES_REP")
		event_act_3.Clear_Dialog_Text()
		event_act_3.Add_Dialog_Text("TEXT_INTERVENTION_LOCATION", FindPlanet("Maridun"))

		local event_act_4 = plot.Get_Event("Rep_Tennuutta_Skirmishes_Act_IV_Dialog")
		event_act_4.Set_Dialog("DIALOG_TENNUUTTA_SKIRMISHES_REP")
		event_act_4.Clear_Dialog_Text()
		event_act_4.Add_Dialog_Text("TEXT_INTERVENTION_LOCATION", FindPlanet("Handooine"))

		Create_Thread("State_Rep_Tennuutta_Planet_Checker")
	end
end

function State_Rep_Tennuutta_Planet_Checker()
	local plot = Get_Story_Plot("Conquests\\CloneWarsTennuutta\\Story_Sandbox_Tennuutta_Republic.XML")

	event_act_1 = plot.Get_Event("Rep_Tennuutta_Skirmishes_Act_I_Dialog")
	event_act_1.Set_Dialog("DIALOG_TENNUUTTA_SKIRMISHES_REP")
	event_act_1.Clear_Dialog_Text()

	local target_planet_list = {
		FindPlanet("Salvara"),
		FindPlanet("Abhean"),
		FindPlanet("Vorzyd"),
		FindPlanet("Ringo_Vinda"),
		FindPlanet("Murkhana"),
	}

	for _,p_planet in pairs(target_planet_list) do
		if p_planet.Get_Owner() ~= p_republic then
			if p_planet.Get_Planet_Location() == FindPlanet("Salvara") then
				event_act_1.Add_Dialog_Text("TEXT_STORY_TENNUUTTA_SKIRMISHES_REP_LOCATION_SALVARA", p_planet)
			else
				event_act_1.Add_Dialog_Text("TEXT_INTERVENTION_PLANET_CONQUEST_LOCATION", p_planet)
			end
		elseif p_planet.Get_Owner() == p_republic then
			event_act_1.Add_Dialog_Text("TEXT_INTERVENTION_PLANET_CONQUEST_LOCATION_COMPLETE", p_planet)
		end
	end
	if FindPlanet("Salvara").Get_Owner() == p_republic and FindPlanet("Abhean").Get_Owner() == p_republic and FindPlanet("Murkhana").Get_Owner() == p_republic and FindPlanet("Vorzyd").Get_Owner() == p_republic and FindPlanet("Ringo_Vinda").Get_Owner() == p_republic then
		target_planets_conquered = true
	end
	Sleep(5.0)
	if not target_planets_conquered then
		Create_Thread("State_Rep_Tennuutta_Planet_Checker")
	else
		Story_Event("REP_ACT_I_PLANETS_CONQUERED")
	end
end

function State_Rep_Crash_Course_Epilogue(message)
	if message == OnEnter then
		if p_republic.Is_Human() then
			ChangePlanetOwnerAndRetreat(FindPlanet("Quell"), p_cis)

			local Safe_House_Planet = StoryUtil.GetSafePlanetTable()
			StoryUtil.SpawnAtSafePlanet("QUELL", Find_Player("Rebel"), Safe_House_Planet, {"TF1726_Munificent"})
		end
	end
end

function State_Rep_Tennuutta_Jedi_Search(message)
    if message == OnEnter then
		if p_republic.Is_Human() then
			local plot = Get_Story_Plot("Conquests\\CloneWarsTennuutta\\Story_Sandbox_Tennuutta_Republic.XML")

			scout_target_01 = StoryUtil.FindTargetPlanet(p_republic, false, true, 1)

			if not scout_target_01 then
				scout_target_01 = StoryUtil.FindFriendlyPlanet(p_cis)
			end

			event_act_2 = plot.Get_Event("Rep_Tennuutta_Skirmishes_Act_II_Dialog_01")
			event_act_2.Set_Dialog("DIALOG_TENNUUTTA_SKIRMISHES_REP")
			event_act_2.Clear_Dialog_Text()

			event_act_2.Add_Dialog_Text("TEXT_INTERVENTION_LOCATION", scout_target_01)

			event_act_2_task_01 = plot.Get_Event("Rep_Tennuutta_Skirmishes_Scouting_01")
			event_act_2_task_01.Set_Event_Parameter(0, scout_target_01)

			Story_Event("REP_JEDI_SEARCH_01")
		end
    end
end

function State_Rep_Tennuutta_Skirmishes_Scouting_01(message)
    if message == OnEnter then
		if p_republic.Is_Human() then
			local plot = Get_Story_Plot("Conquests\\CloneWarsTennuutta\\Story_Sandbox_Tennuutta_Republic.XML")

			scout_target_02 = StoryUtil.FindTargetPlanet(p_republic, false, true, 1)

			if not scout_target_02 then
				scout_target_02 = StoryUtil.FindFriendlyPlanet(p_cis)
			end

			if scout_target_02 == scout_target_01 then
				scout_target_02 = StoryUtil.FindFriendlyPlanet(p_cis)
			end

			event_act_2 = plot.Get_Event("Rep_Tennuutta_Skirmishes_Act_II_Dialog_02")
			event_act_2.Set_Dialog("DIALOG_TENNUUTTA_SKIRMISHES_REP")
			event_act_2.Clear_Dialog_Text()

			event_act_2.Add_Dialog_Text("TEXT_INTERVENTION_LOCATION_COMPLETE", scout_target_01)
			event_act_2.Add_Dialog_Text("TEXT_INTERVENTION_LOCATION", scout_target_02)

			event_act_2_task_02 = plot.Get_Event("Rep_Tennuutta_Skirmishes_Scouting_02")
			event_act_2_task_02.Set_Event_Parameter(0, scout_target_02)

			Story_Event("REP_JEDI_SEARCH_02")
		end
    end
end

function State_Rep_Tennuutta_Skirmishes_Scouting_02(message)
    if message == OnEnter then
		if p_republic.Is_Human() then
			local plot = Get_Story_Plot("Conquests\\CloneWarsTennuutta\\Story_Sandbox_Tennuutta_Republic.XML")

			scout_target_03 = StoryUtil.FindTargetPlanet(p_republic, false, true, 1)

			if not scout_target_03 then
				scout_target_03 = StoryUtil.FindFriendlyPlanet(p_cis)
			end

			if scout_target_03 == scout_target_02 or scout_target_03 == scout_target_01 then
				scout_target_03 = StoryUtil.FindFriendlyPlanet(p_cis)
			end

			event_act_2 = plot.Get_Event("Rep_Tennuutta_Skirmishes_Act_II_Dialog_03")
			event_act_2.Set_Dialog("DIALOG_TENNUUTTA_SKIRMISHES_REP")
			event_act_2.Clear_Dialog_Text()

			event_act_2.Add_Dialog_Text("TEXT_INTERVENTION_LOCATION_COMPLETE", scout_target_01)
			event_act_2.Add_Dialog_Text("TEXT_INTERVENTION_LOCATION_COMPLETE", scout_target_02)
			event_act_2.Add_Dialog_Text("TEXT_INTERVENTION_LOCATION", scout_target_03)

			event_act_2_task_03 = plot.Get_Event("Rep_Tennuutta_Skirmishes_Scouting_03")
			event_act_2_task_03.Set_Event_Parameter(0, scout_target_03)

			Story_Event("REP_JEDI_SEARCH_03")
		end
    end
end

function State_Rep_Tennuutta_Skirmishes_Scouting_03(message)
    if message == OnEnter then
		if p_republic.Is_Human() then
			local plot = Get_Story_Plot("Conquests\\CloneWarsTennuutta\\Story_Sandbox_Tennuutta_Republic.XML")

			event_act_2 = plot.Get_Event("Rep_Tennuutta_Skirmishes_Act_II_Dialog_04")
			event_act_2.Set_Dialog("DIALOG_TENNUUTTA_SKIRMISHES_REP")
			event_act_2.Clear_Dialog_Text()

			event_act_2.Add_Dialog_Text("TEXT_INTERVENTION_LOCATION_COMPLETE", scout_target_01)
			event_act_2.Add_Dialog_Text("TEXT_INTERVENTION_LOCATION_COMPLETE", scout_target_02)
			event_act_2.Add_Dialog_Text("TEXT_INTERVENTION_LOCATION_COMPLETE", scout_target_03)

			Story_Event("REP_JEDI_SEARCH_04")
		end
    end
end

function State_Rep_Tennuutta_Jedi_Found(message)
	if message == OnEnter then
		if p_republic.Is_Human() then
			StoryUtil.SpawnAtSafePlanet("HANDOOINE", Find_Player("Empire"), StoryUtil.GetSafePlanetTable(), {"Yularen_Resolute"})
			-- FotR_Enhanced
			Find_Player("Empire").Unlock_Tech(Find_Object_Type("Generic_Venator_OFC"))
			--
			Story_Event("REP_JEDI_FOUND_START")
		end
	end
end

function State_Rep_Maridun_Marauder_Epilogue(message)
    if message == OnEnter then
		if p_republic.Is_Human() then
			Story_Event("REP_JEDI_FOUND_DONE")
			StoryUtil.SetPlanetRestricted("MARIDUN", 0)

			if GlobalValue.Get("CURRENT_CLONE_PHASE") == 2 then
				StoryUtil.SpawnAtSafePlanet("MARIDUN", Find_Player("Empire"), StoryUtil.GetSafePlanetTable(), {"Ahsoka_Delta_Team", "Aayla_Secura_Delta_Team", "Bly2_Team", "Rex2_Team"})
			else
				StoryUtil.SpawnAtSafePlanet("MARIDUN", Find_Player("Empire"), StoryUtil.GetSafePlanetTable(), {"Ahsoka_Delta_Team", "Aayla_Secura_Delta_Team", "Bly_Team", "Rex_Team"})
			end
		end
    end
end

function State_Rep_Tennuutta_Command_Meeting(message)
	if message == OnEnter then
		Story_Event("REP_COMMAND_MEETING_START")
		Sleep(12)
		
		Find_Player("Empire").Unlock_Tech(Find_Object_Type("Republic_Naval_Command_Centre"))
	end
end
