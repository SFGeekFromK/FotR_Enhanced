
--****************************************************--
--****   Fall of the Republic: Outer Rim Sieges   ****--
--****************************************************--

require("PGStoryMode")
require("PGSpawnUnits")
require("eawx-util/ChangeOwnerUtilities")
require("deepcore/std/class")
StoryUtil = require("eawx-util/StoryUtil")
UnitUtil = require("eawx-util/UnitUtil")
require("deepcore/crossplot/crossplot")

function Definitions()
    DebugMessage("%s -- In Definitions", tostring(Script))

    StoryModeEvents = {
		-- Generic
        Trigger_GC_Set_Up = State_GC_Set_Up,
		Trigger_Framework_Activation = State_Framework_Activation,

		-- CIS
		CIS_Cato_Castle_Clash_Epilogue = State_CIS_Cato_Castle_Clash_Epilogue,
		Trigger_CIS_Outer_Rim_Sieges_Act_III = State_CIS_Gunray_Grievous_Meeting,
		Trigger_CIS_Outer_Rim_Sieges_Act_IV = State_CIS_Tythe_Trap,
		Trigger_CIS_Outer_Rim_Sieges_Act_V = State_CIS_Crushing_Coruscant,
		CIS_Outer_Rim_Sieges_Speech_15 = State_CIS_New_Order,
		--CIS_GC_Progression = State_CIS_GC_Progression,

		-- Republic
		Rep_Outer_Rim_Sieges_Speech_03 = State_Rep_Mechno_Moving_Start,
 		Trigger_Rep_Outer_Rim_Sieges_Act_III = State_Rep_Charros_Chair_Start,
 		Trigger_Rep_Outer_Rim_Sieges_Act_IV = State_Rep_Tythe_Terror_Start,
		Rep_Outer_Rim_Sieges_Act_IV_Completed = State_Rep_Coruscant_Chaos_Start,
		Trigger_Rep_Outer_Rim_Sieges_Act_VIII = State_Rep_Outer_Rim_Sieges_Act_VIII,
   }

	p_cis = Find_Player("Rebel")
	p_republic = Find_Player("Empire")

	gc_start = false
	all_planets_conquered = false

	target_planets_conquered = false
	triad_conquered = false
	charros_chair_complete = false
	tythe_terror_complete = false
	mechno_moved = false
	meeting_done = false

	crossplot:galactic()
	crossplot:subscribe("HISTORICAL_GC_CHOICE_OPTION", State_Historical_GC_Choice)
end


function State_GC_Set_Up(message)
    if message == OnEnter then
		if p_cis.Is_Human() then
			GlobalValue.Set("ORS_CIS_GC_Version", 0) -- 3 = Ningo Alive; 2 = CIS Kuat; 1 = CIS Kuat and Maly; 0 = Canonical Version

			if TestValid(Find_First_Object("GC_AU_Dummy")) then
				GlobalValue.Set("ORS_CIS_GC_Version", 1) -- 3 = Ningo Alive; 2 = CIS Kuat; 1 = CIS Kuat and Maly; 0 = Canonical Version
			elseif TestValid(Find_First_Object("GC_AU_2_Dummy")) then
				GlobalValue.Set("ORS_CIS_GC_Version", 2) -- 3 = Ningo Alive; 2 = CIS Kuat; 1 = CIS Kuat and Maly; 0 = Canonical Version
			elseif TestValid(Find_First_Object("GC_AU_3_Dummy")) then
				GlobalValue.Set("ORS_CIS_GC_Version", 3) -- 3 = Ningo Alive; 2 = CIS Kuat; 1 = CIS Kuat and Maly; 0 = Canonical Version
			end
		elseif p_republic.Is_Human() then
			GlobalValue.Set("ORS_Rep_GC_Version", 0) -- 1 = AU Version; 0 = Canonical Version

			if TestValid(Find_First_Object("GC_AU_Dummy")) then
				GlobalValue.Set("ORS_Rep_GC_Version", 1) -- 1 = AU Version; 0 = Canonical Version
			end
		end

		crossplot:publish("POPUPEVENT", "HISTORICAL_GC_CHOICE", {"STORY", "NO_INTRO", "NO_STORY"}, { },
				{ }, { },
				{ }, { },
				{ }, { },
				"HISTORICAL_GC_CHOICE_OPTION")

		-- CIS
		Find_Player("Rebel").Unlock_Tech(Find_Object_Type("Bulwark_I"))
		Find_Player("Rebel").Unlock_Tech(Find_Object_Type("Bulwark_II"))

		Find_Player("Rebel").Lock_Tech(Find_Object_Type("Random_Mercenary"))
		Find_Player("Rebel").Lock_Tech(Find_Object_Type("Grievous_Team_Malevolence_Providence"))
		Find_Player("Rebel").Lock_Tech(Find_Object_Type("Grievous_Team_Malevolence_Recusant"))

		-- Republic
		Find_Player("Empire").Unlock_Tech(Find_Object_Type("Generic_Venator"))
		-- FotR_Enhanced
		Find_Player("Empire").Unlock_Tech(Find_Object_Type("Generic_Venator_OFC"))
		Find_Player("Empire").Unlock_Tech(Find_Object_Type("Generic_Victory_Fleet_Destroyer"))
		Find_Player("Empire").Unlock_Tech(Find_Object_Type("Generic_Victory_Destroyer_Two"))

		Find_Player("Empire").Lock_Tech(Find_Object_Type("Remnant_Capital"))
		Find_Player("Empire").Lock_Tech(Find_Object_Type("Invincible_Cruiser"))
		Find_Player("Empire").Lock_Tech(Find_Object_Type("Corellian_Corvette"))
	end
end

function State_Historical_GC_Choice(choice)
	if choice == "HISTORICAL_GC_CHOICE_STORY" then
		if p_cis.Is_Human() then
			Create_Thread("State_CIS_Story_Set_Up")

			GlobalValue.Set("CIS_Cato_Castle_Clashed", 0) -- 1 = AU Version; 0 = Canonical Version
			GlobalValue.Set("CIS_Belderone_Broken", 0) -- 1 = AU Version; 0 = Canonical Version

			Story_Event("CIS_INTRO_START")
		end
		if p_republic.Is_Human() then
			Create_Thread("State_Rep_Story_Set_Up")

			Story_Event("REP_INTRO_START")
		end
	end
	if choice == "HISTORICAL_GC_CHOICE_NO_INTRO" then
		if p_cis.Is_Human() then
			GlobalValue.Set("CIS_Cato_Castle_Clashed", 0) -- 1 = AU Version; 0 = Canonical Version
			GlobalValue.Set("CIS_Belderone_Broken", 0) -- 1 = AU Version; 0 = Canonical Version

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
		GlobalValue.Set("CURRENT_ERA", 5)
		crossplot:publish("INITIALIZE_AI", "empty")
		crossplot:publish("VENATOR_HEROES", "empty")
		crossplot:publish("VICTORY_HEROES", "empty")
		-- FotR_Enhanced
		crossplot:publish("GEEN_UNLOCK", "empty")
		
		--Admirals: 5 - 1 = 4
		crossplot:publish("REPUBLIC_ADMIRAL_DECREMENT", 1, 1)

		--Moffs: 2 - 0 = 0
		crossplot:publish("REPUBLIC_ADMIRAL_DECREMENT", 0, 2)

		--Jedi: 5 - 1 = 4 
		crossplot:publish("REPUBLIC_ADMIRAL_DECREMENT", 1, 3)
		crossplot:publish("REPUBLIC_ADMIRAL_EXIT", {"Halcyon","Ahsoka","Knol"}, 3)

		--Clone Officers: 5 - 1
		crossplot:publish("REPUBLIC_ADMIRAL_DECREMENT", 1, 4)
		crossplot:publish("REPUBLIC_ADMIRAL_EXIT", {"Rex"}, 4)

		--Commandos: 3 - 1 = 2
		crossplot:publish("REPUBLIC_ADMIRAL_DECREMENT", 1, 5)

		--Generals:
		crossplot:publish("REPUBLIC_ADMIRAL_DECREMENT", 0, 6)
	else
		crossplot:update()
    end
end

function State_Generic_Story_Set_Up()
	StoryUtil.SpawnAtSafePlanet("MURKHANA", Find_Player("Rebel"), StoryUtil.GetSafePlanetTable(), {"Grievous_Team"})

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
						StoryUtil.DeclareVictory(p_cis.Get_Faction_Name(), true)
					end
				end
			end]]
		elseif p_republic.Is_Human() then
			--[[local all_planets = FindPlanet.Get_All_Planets()
			for _, planet in pairs(all_planets) do
				if planet.Get_Owner() == p_republic then
					if not all_planets_conquered then
						all_planets_conquered = true
						StoryUtil.DeclareVictory(p_republic.Get_Faction_Name(), true)
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

		StoryUtil.RevealPlanet("CORUSCANT", false)
		StoryUtil.RevealPlanet("BELDERONE", false)

		StoryUtil.SetPlanetRestricted("BELDERONE", 1)
		--StoryUtil.SetPlanetRestricted("TYTHE", 1)

		target_planet_list = {
			FindPlanet("Kashyyyk"),
			FindPlanet("Eriadu"),
			FindPlanet("Anaxes"),
			FindPlanet("Alderaan"),
			FindPlanet("Kuat"),
			FindPlanet("Corellia"),
		}

		if (GlobalValue.Get("ORS_CIS_GC_Version") == 0) then
			local Safe_House_Planet = StoryUtil.GetSafePlanetTable()
			StoryUtil.SpawnAtSafePlanet("MURKHANA", Find_Player("Rebel"), Safe_House_Planet, {"Grievous_Team"})

		elseif (GlobalValue.Get("ORS_CIS_GC_Version") == 1) then
			local Safe_House_Planet = StoryUtil.GetSafePlanetTable()
			StoryUtil.SpawnAtSafePlanet("MURKHANA", Find_Player("Rebel"), Safe_House_Planet, {"Grievous_Team_Malevolence"})

			p_cis.Unlock_Tech(Find_Object_Type("Storm_Fleet_Destroyer"))

		elseif (GlobalValue.Get("ORS_CIS_GC_Version") == 2) then
			local Safe_House_Planet = StoryUtil.GetSafePlanetTable()
			StoryUtil.SpawnAtSafePlanet("MURKHANA", Find_Player("Rebel"), Safe_House_Planet, {"Grievous_Team"})

			p_cis.Unlock_Tech(Find_Object_Type("Storm_Fleet_Destroyer"))

		elseif (GlobalValue.Get("ORS_CIS_GC_Version") == 3) then
			local Safe_House_Planet = StoryUtil.GetSafePlanetTable()
			StoryUtil.SpawnAtSafePlanet("MURKHANA", Find_Player("Rebel"), Safe_House_Planet, {"Grievous_Team"})

			local Safe_House_Planet = StoryUtil.GetSafePlanetTable()
			StoryUtil.SpawnAtSafePlanet("ANAXES", Find_Player("Rebel"), Safe_House_Planet, {"Dua_Ningo_Unrepentant"})
		end

		p_republic.Unlock_Tech(Find_Object_Type("Generic_Gladiator"))
		
		local plot = Get_Story_Plot("Conquests\\CloneWarsOuterRimSieges\\Story_Sandbox_OuterRimSieges_CIS.XML")
		local event_act_1 = plot.Get_Event("CIS_Outer_Rim_Sieges_Act_I_Dialog")
		event_act_1.Set_Dialog("DIALOG_OUTER_RIM_SIEGES_CIS")
		event_act_1.Clear_Dialog_Text()
		for _,p_planet in pairs(target_planet_list) do
			if p_planet.Get_Owner() ~= p_cis then
				event_act_1.Add_Dialog_Text("TEXT_INTERVENTION_PLANET_CONQUEST_LOCATION", p_planet)
			else
				event_act_1.Add_Dialog_Text("TEXT_INTERVENTION_PLANET_CONQUEST_LOCATION_COMPLETE", p_planet)
			end
		end

		local event_act_2 = plot.Get_Event("CIS_Outer_Rim_Sieges_Act_II_Dialog")
		event_act_2.Set_Dialog("DIALOG_OUTER_RIM_SIEGES_CIS")
		event_act_2.Clear_Dialog_Text()
		event_act_2.Add_Dialog_Text("TEXT_STORY_OUTER_RIM_SIEGES_CIS_LOCATION_BELDERONE", FindPlanet("Belderone"))

		local event_act_5 = plot.Get_Event("CIS_Outer_Rim_Sieges_Act_V_Dialog")
		event_act_5.Set_Dialog("DIALOG_OUTER_RIM_SIEGES_CIS")
		event_act_5.Clear_Dialog_Text()
		event_act_5.Add_Dialog_Text("TEXT_STORY_OUTER_RIM_SIEGES_CIS_LOCATION_CORUSCANT", FindPlanet("Coruscant"))

		if TestValid(Find_First_Object("Grievous_Soulless_One_Ground")) or TestValid(Find_First_Object("Soulless_One")) or TestValid(Find_First_Object("Grievous_Team_Soulless_One")) then
			local event_act_2_task = plot.Get_Event("CIS_Grievous_Entry_Belderone")
			event_act_2_task.Set_Event_Parameter(2, Find_Object_Type("Grievous_Team_Soulless_One"))

			local event_act_5_task = plot.Get_Event("CIS_Grievous_Entry_Coruscant")
			event_act_5_task.Set_Event_Parameter(2, Find_Object_Type("Grievous_Team_Soulless_One"))

			savety_check = 0
		elseif TestValid(Find_First_Object("General_Grievous")) or TestValid(Find_First_Object("Invisible_Hand")) or TestValid(Find_First_Object("Grievous_Team")) then
			local event_act_2_task = plot.Get_Event("CIS_Grievous_Entry_Belderone")
			event_act_2_task.Set_Event_Parameter(2, Find_Object_Type("Grievous_Team"))

			local event_act_5_task = plot.Get_Event("CIS_Grievous_Entry_Coruscant")
			event_act_5_task.Set_Event_Parameter(2, Find_Object_Type("Grievous_Team"))

			savety_check = 0
		elseif TestValid(Find_First_Object("Grievous_Recusant_Ground")) or TestValid(Find_First_Object("Grievous_Recusant")) or TestValid(Find_First_Object("Grievous_Team_Recusant")) then
			local event_act_2_task = plot.Get_Event("CIS_Grievous_Entry_Belderone")
			event_act_2_task.Set_Event_Parameter(2, Find_Object_Type("Grievous_Team_Recusant"))

			local event_act_5_task = plot.Get_Event("CIS_Grievous_Entry_Coruscant")
			event_act_5_task.Set_Event_Parameter(2, Find_Object_Type("Grievous_Team_Recusant"))

			savety_check = 0
		elseif TestValid(Find_First_Object("Grievous_Munificent_Ground")) or TestValid(Find_First_Object("Grievous_Munificent")) or TestValid(Find_First_Object("Grievous_Team_Munificent")) then
			local event_act_2_task = plot.Get_Event("CIS_Grievous_Entry_Belderone")
			event_act_2_task.Set_Event_Parameter(2, Find_Object_Type("Grievous_Team_Munificent"))

			local event_act_5_task = plot.Get_Event("CIS_Grievous_Entry_Coruscant")
			event_act_5_task.Set_Event_Parameter(2, Find_Object_Type("Grievous_Team_Munificent"))

			savety_check = 0
		elseif TestValid(Find_First_Object("Grievous_Malevolence_Ground")) or TestValid(Find_First_Object("Grievous_Malevolence")) or TestValid(Find_First_Object("Grievous_Team_Malevolence")) then
			local event_act_5_task = plot.Get_Event("CIS_Grievous_Entry_Belderone")
			event_act_5_task.Set_Event_Parameter(2, Find_Object_Type("Grievous_Team_Malevolence"))

			local event_act_5_task = plot.Get_Event("CIS_Grievous_Entry_Coruscant")
			event_act_5_task.Set_Event_Parameter(2, Find_Object_Type("Grievous_Team_Malevolence"))

			savety_check = 0
		else
			savety_check = savety_check + 1
		end
		Create_Thread("State_CIS_Grievous_Checker")
		Create_Thread("State_CIS_Planet_Checker")
	end
end

function State_CIS_Planet_Checker()
	local plot = Get_Story_Plot("Conquests\\CloneWarsOuterRimSieges\\Story_Sandbox_OuterRimSieges_CIS.XML")
	local event_act_1 = plot.Get_Event("CIS_Outer_Rim_Sieges_Act_I_Dialog")
	event_act_1.Set_Dialog("DIALOG_OUTER_RIM_SIEGES_CIS")
	event_act_1.Clear_Dialog_Text()
	for _,p_planet in pairs(target_planet_list) do
		if p_planet.Get_Owner() ~= p_cis then
			if p_planet.Get_Planet_Location() == FindPlanet("Belderone") then
				event_act_1.Add_Dialog_Text("TEXT_STORY_OUTER_RIM_SIEGES_CIS_LOCATION_BELDERONE", p_planet)
			else
				event_act_1.Add_Dialog_Text("TEXT_INTERVENTION_PLANET_CONQUEST_LOCATION", p_planet)
			end
		else
			event_act_1.Add_Dialog_Text("TEXT_INTERVENTION_PLANET_CONQUEST_LOCATION_COMPLETE", p_planet)
		end
	end
	if FindPlanet("Belderone").Get_Owner() == p_cis then
		Story_Event("CIS_TYTHE_TRAP_START")
	end
	if FindPlanet("Corellia").Get_Owner() == p_cis and FindPlanet("Alderaan").Get_Owner() == p_cis and FindPlanet("Anaxes").Get_Owner() == p_cis and FindPlanet("Kuat").Get_Owner() == p_cis and FindPlanet("Kashyyyk").Get_Owner() == p_cis and FindPlanet("Eriadu").Get_Owner() == p_cis then
		target_planets_conquered = true
	end
	Sleep(5.0)
	if not target_planets_conquered then
		Create_Thread("State_CIS_Planet_Checker")
	elseif target_planets_conquered then
		Story_Event("CIS_ACT_I_PLANETS_CONQUERED")
	end
end

function State_CIS_Grievous_Checker() -- sets hero entry parameter in conquest story missionsby checking if grievous is alive
	local plot = Get_Story_Plot("Conquests\\CloneWarsOuterRimSieges\\Story_Sandbox_OuterRimSieges_CIS.XML")

	if TestValid(Find_First_Object("Grievous_Soulless_One_Ground")) or TestValid(Find_First_Object("Soulless_One")) or TestValid(Find_First_Object("Grievous_Team_Soulless_One")) then
		local event_act_2_task = plot.Get_Event("CIS_Grievous_Entry_Belderone")
		event_act_2_task.Set_Event_Parameter(2, Find_Object_Type("Grievous_Team_Soulless_One"))

		local event_act_5_task = plot.Get_Event("CIS_Grievous_Entry_Coruscant")
		event_act_5_task.Set_Event_Parameter(2, Find_Object_Type("Grievous_Team_Soulless_One"))

		savety_check = 0
	elseif TestValid(Find_First_Object("General_Grievous")) or TestValid(Find_First_Object("Invisible_Hand")) or TestValid(Find_First_Object("Grievous_Team")) then
		local event_act_2_task = plot.Get_Event("CIS_Grievous_Entry_Belderone")
		event_act_2_task.Set_Event_Parameter(2, Find_Object_Type("Grievous_Team"))

		local event_act_5_task = plot.Get_Event("CIS_Grievous_Entry_Coruscant")
		event_act_5_task.Set_Event_Parameter(2, Find_Object_Type("Grievous_Team"))

		savety_check = 0
	elseif TestValid(Find_First_Object("Grievous_Recusant_Ground")) or TestValid(Find_First_Object("Grievous_Recusant")) or TestValid(Find_First_Object("Grievous_Team_Recusant")) then
		local event_act_2_task = plot.Get_Event("CIS_Grievous_Entry_Belderone")
		event_act_2_task.Set_Event_Parameter(2, Find_Object_Type("Grievous_Team_Recusant"))

		local event_act_5_task = plot.Get_Event("CIS_Grievous_Entry_Coruscant")
		event_act_5_task.Set_Event_Parameter(2, Find_Object_Type("Grievous_Team_Recusant"))

		savety_check = 0
	elseif TestValid(Find_First_Object("Grievous_Munificent_Ground")) or TestValid(Find_First_Object("Grievous_Munificent")) or TestValid(Find_First_Object("Grievous_Team_Munificent")) then
		local event_act_2_task = plot.Get_Event("CIS_Grievous_Entry_Belderone")
		event_act_2_task.Set_Event_Parameter(2, Find_Object_Type("Grievous_Team_Munificent"))

		local event_act_5_task = plot.Get_Event("CIS_Grievous_Entry_Coruscant")
		event_act_5_task.Set_Event_Parameter(2, Find_Object_Type("Grievous_Team_Munificent"))

		savety_check = 0
	elseif TestValid(Find_First_Object("Grievous_Malevolence_Ground")) or TestValid(Find_First_Object("Grievous_Malevolence")) or TestValid(Find_First_Object("Grievous_Team_Malevolence")) then
		local event_act_5_task = plot.Get_Event("CIS_Grievous_Entry_Belderone")
		event_act_5_task.Set_Event_Parameter(2, Find_Object_Type("Grievous_Team_Malevolence"))

		local event_act_5_task = plot.Get_Event("CIS_Grievous_Entry_Coruscant")
		event_act_5_task.Set_Event_Parameter(2, Find_Object_Type("Grievous_Team_Malevolence"))

		savety_check = 0
	else
		savety_check = savety_check + 1
	end
	Sleep(2.5)
	if savety_check > 2 then
		Story_Event("CIS_GRIEVOUS_DEAD") -- disables all grievous requiring events ; changes it to geneirc conquer mission.
	else
		Create_Thread("State_CIS_Grievous_Checker")
	end
end

function State_CIS_Cato_Castle_Clash_Epilogue(message)
    if message == OnEnter then
		if (GlobalValue.Get("CIS_Cato_Castle_Clashed") == 0) then
			UnitUtil.DespawnList({"Sentepth_Findos_Team"})
			ChangePlanetOwnerAndRetreat(FindPlanet("Cato_Neimoidia"), p_republic)
			local CatoSpawn = {"Clonetrooper_Phase_Two_Team", "Clonetrooper_Phase_Two_Team", "Republic_A6_Juggernaut_Company", "Republic_A6_Juggernaut_Company", "Republic_AT_TE_Walker_Company", "Republic_AT_TE_Walker_Company"}
			StoryUtil.SpawnAtSafePlanet("CATO_NEIMOIDIA", p_republic, StoryUtil.GetSafePlanetTable(), CatoSpawn)
		end
	end
end

function State_CIS_Gunray_Grievous_Meeting(message)
    if message == OnEnter then
		if TestValid(Find_First_Object("General_Grievous")) and TestValid(Find_First_Object("Gunray")) then
			Story_Event("CIS_ACT_III_START")		
			if Find_First_Object("General_Grievous").Get_Planet_Location() == Find_First_Object("Gunray").Get_Planet_Location() then
				Story_Event("CIS_GRIEVOUS_GUNRAY_MEETING_START")	
			else
				Create_Thread("State_CIS_Gunray_Grievous_Meeting_Checker")
			end
		elseif TestValid(Find_First_Object("Grievous_Recusant_Ground")) and TestValid(Find_First_Object("Gunray")) then
			Story_Event("CIS_ACT_III_START")		
			if Find_First_Object("Grievous_Recusant_Ground").Get_Planet_Location() == Find_First_Object("Gunray").Get_Planet_Location() then
				Story_Event("CIS_GRIEVOUS_GUNRAY_MEETING_START")	
			else
				Create_Thread("State_CIS_Gunray_Grievous_Meeting_Checker")
			end
		elseif TestValid(Find_First_Object("Grievous_Munificent_Ground")) and TestValid(Find_First_Object("Gunray")) then
			Story_Event("CIS_ACT_III_START")		
			if Find_First_Object("Grievous_Munificent_Ground").Get_Planet_Location() == Find_First_Object("Gunray").Get_Planet_Location() then
				Story_Event("CIS_GRIEVOUS_GUNRAY_MEETING_START")	
			else
				Create_Thread("State_CIS_Gunray_Grievous_Meeting_Checker")
			end
		elseif TestValid(Find_First_Object("Grievous_Malevolence_Ground")) and TestValid(Find_First_Object("Gunray")) then
			Story_Event("CIS_ACT_III_START")		
			if Find_First_Object("Grievous_Malevolence_Ground").Get_Planet_Location() == Find_First_Object("Gunray").Get_Planet_Location() then
				Story_Event("CIS_GRIEVOUS_GUNRAY_MEETING_START")	
			else
				Create_Thread("State_CIS_Gunray_Grievous_Meeting_Checker")
			end
		end
		meeting_done = false
    end
end

function State_CIS_Gunray_Grievous_Meeting_Checker()
	if TestValid(Find_First_Object("General_Grievous")) and TestValid(Find_First_Object("Gunray")) then
		if Find_First_Object("General_Grievous").Get_Planet_Location() == Find_First_Object("Gunray").Get_Planet_Location() then
			Story_Event("CIS_GRIEVOUS_GUNRAY_MEETING_START")
			meeting_done = true
		end
		savety_check_meeting = 0
	elseif TestValid(Find_First_Object("Grievous_Recusant_Ground")) and TestValid(Find_First_Object("Gunray")) then
		if Find_First_Object("Grievous_Recusant_Ground").Get_Planet_Location() == Find_First_Object("Gunray").Get_Planet_Location() then
			Story_Event("CIS_GRIEVOUS_GUNRAY_MEETING_START")
			meeting_done = true
		end
		savety_check_meeting = 0
	elseif TestValid(Find_First_Object("Grievous_Munificent_Ground")) and TestValid(Find_First_Object("Gunray")) then
		if Find_First_Object("Grievous_Munificent_Ground").Get_Planet_Location() == Find_First_Object("Gunray").Get_Planet_Location() then
			Story_Event("CIS_GRIEVOUS_GUNRAY_MEETING_START")
			meeting_done = true
		end
		savety_check_meeting = 0
	elseif TestValid(Find_First_Object("Grievous_Malevolence_Ground")) and TestValid(Find_First_Object("Gunray")) then
		if Find_First_Object("Grievous_Malevolence_Ground").Get_Planet_Location() == Find_First_Object("Gunray").Get_Planet_Location() then
			Story_Event("CIS_GRIEVOUS_GUNRAY_MEETING_START")
			meeting_done = true
		end
		savety_check_meeting = 0
	end
	Sleep(2.5)
	if not meeting_done then
		if savety_check_meeting > 3 then
			Story_Event("CIS_MEETING_FAILED")
		else
			savety_check_meeting = savety_check_meeting + 1
			Create_Thread("State_CIS_Gunray_Grievous_Meeting_Checker")
		end
	end
end

function State_CIS_Tythe_Trap(message)
    if message == OnEnter then
		Story_Event("CIS_ACT_IV_START")
		Create_Thread("State_CIS_Tythe_Trap_Checker")
		tythe_done = false
	end
end

function State_CIS_Tythe_Trap_Checker()
	plot = Get_Story_Plot("Conquests\\CloneWarsOuterRimSieges\\Story_Sandbox_OuterRimSieges_CIS.XML")

	event_act_4 = plot.Get_Event("CIS_Outer_Rim_Sieges_Act_IV_Dialog")
	event_act_4.Set_Dialog("DIALOG_OUTER_RIM_SIEGES_CIS")
	event_act_4.Clear_Dialog_Text()

	if TestValid(Find_First_Object("Dooku")) then
		event_act_4.Add_Dialog_Text("TEXT_STORY_OUTER_RIM_SIEGES_CIS_ACT_IV_OBJECTIVE_01")
		event_act_4.Add_Dialog_Text("TEXT_NONE")
		event_act_4.Add_Dialog_Text("TEXT_INTERVENTION_LOCATION", FindPlanet("Tythe"))

		if Find_First_Object("Dooku").Get_Planet_Location() == FindPlanet("Tythe") then
			Story_Event("CIS_TYTHE_TRAP_COMPLETE")	
			tythe_done = true
		end
	elseif not TestValid(Find_First_Object("Dooku")) then
		event_act_4.Add_Dialog_Text("TEXT_STORY_OUTER_RIM_SIEGES_CIS_ACT_IV_OBJECTIVE_02")
		event_act_4.Add_Dialog_Text("TEXT_NONE")
		event_act_4.Add_Dialog_Text("TEXT_INTERVENTION_LOCATION", FindPlanet("Tythe"))

		if FindPlanet("Tythe").Get_Owner() == Find_Player("Rebel") then
			Story_Event("CIS_TYTHE_TRAP_COMPLETE")	
			tythe_done = true
		end
	end
	Sleep(2.5)
	if not tythe_done then
		Create_Thread("State_CIS_Tythe_Trap_Checker")
	end
end

function State_CIS_Crushing_Coruscant(message)
    if message == OnEnter then
		Story_Event("CIS_ACT_V_START")
	end
end

function State_CIS_New_Order(message)
    if message == OnEnter then
		UnitUtil.DespawnList({"Gunray", "Dooku", "Wat_Tambor", "Passel_Argente", "Shu_Mai_Castell", "Anakin2", "Emperor_Palpatine"})
		Sleep(1.0)
		UnitUtil.DespawnList({"Gunray", "Dooku", "Wat_Tambor", "Passel_Argente", "Shu_Mai_Castell", "Anakin2"})
		Sleep(1.0)
		UnitUtil.DespawnList({"Gunray", "Dooku", "Wat_Tambor", "Passel_Argente", "Shu_Mai_Castell", "Anakin2"})
		Sleep(1.0)
		UnitUtil.DespawnList({"Gunray", "Dooku", "Wat_Tambor", "Passel_Argente", "Shu_Mai_Castell", "Anakin2"})

		local Palpatine_Spawns = {"Emperor_Palpatine_Team", "Vader_Team"}
		StoryUtil.SpawnAtSafePlanet("CORUSCANT", p_cis, StoryUtil.GetSafePlanetTable(), Palpatine_Spawns)  
	end
end

function State_CIS_GC_Progression(message)
    if message == OnEnter then
		StoryUtil.DeclareVictory(p_cis.Get_Faction_Name(), true)
		for _, planet in pairs(FindPlanet.Get_All_Planets()) do
			planet.Change_Owner(p_cis)
		end
	end
end

-- Republic

function State_Rep_Story_Set_Up()
	if p_republic.Is_Human() then
		Story_Event("Rep_STORY_START")

		gc_start = true

		StoryUtil.RevealPlanet("CORUSCANT", false)
		StoryUtil.RevealPlanet("TYTHE", false)
		StoryUtil.RevealPlanet("Saleucami", false)
		StoryUtil.RevealPlanet("Mygeeto", false)

		StoryUtil.SetPlanetRestricted("Saleucami", false)
		StoryUtil.SetPlanetRestricted("Mygeeto", false)
		
		if (GlobalValue.Get("ORS_Rep_GC_Version") == 1) then
			p_republic.Unlock_Tech(Find_Object_Type("Generic_Gladiator"))
		end

		StoryUtil.SpawnAtSafePlanet("MURKHANA", Find_Player("Rebel"), StoryUtil.GetSafePlanetTable(), {"Grievous_Team"})

		triad_of_evil_list = {
			FindPlanet("Saleucami"),
			FindPlanet("Felucia"),
			FindPlanet("Mygeeto"),
		}

		target_planet_list = {
			FindPlanet("Serenno"),
			FindPlanet("Siskeen"),
			FindPlanet("Murkhana"),
			FindPlanet("Praesitlyn"),
			FindPlanet("YagDhul"),
			FindPlanet("Kashyyyk"),
		}

		local plot = Get_Story_Plot("Conquests\\CloneWarsOuterRimSieges\\Story_Sandbox_OuterRimSieges_Republic.XML")
		local event_act_1 = plot.Get_Event("Rep_Outer_Rim_Sieges_Act_I_Dialog")
		event_act_1.Set_Dialog("DIALOG_OUTER_RIM_SIEGES_REP")
		event_act_1.Clear_Dialog_Text()
		for _,p_planet in pairs(triad_of_evil_list) do
			if p_planet.Get_Owner() ~= p_republic then
				if p_planet.Get_Planet_Location() == FindPlanet("Saleucami") then
					if TestValid(Find_First_Object("Aayla_Secura2")) or TestValid(Find_First_Object("Aayla_Secura_Eta_Team")) then
						event_act_1.Add_Dialog_Text("TEXT_STORY_ORS_REP_LOCATION_SALEUCAMI", p_planet)
					else
						event_act_1.Add_Dialog_Text("TEXT_INTERVENTION_PLANET_CONQUEST_LOCATION", p_planet)
					end
				else
					event_act_1.Add_Dialog_Text("TEXT_INTERVENTION_PLANET_CONQUEST_LOCATION", p_planet)
				end
			else
				event_act_1.Add_Dialog_Text("TEXT_INTERVENTION_PLANET_CONQUEST_LOCATION_COMPLETE", p_planet)
			end
		end

		event_act_2 = plot.Get_Event("Rep_Outer_Rim_Sieges_Act_II_Dialog")
		event_act_2.Set_Dialog("DIALOG_OUTER_RIM_SIEGES_REP")
		event_act_2.Clear_Dialog_Text()
		event_act_2.Add_Dialog_Text("TEXT_STORY_OUTER_RIM_SIEGES_REP_ACT_II_OBJECTIVE")
		event_act_2.Add_Dialog_Text("TEXT_NONE")
		event_act_2.Add_Dialog_Text("TEXT_INTERVENTION_LOCATION", FindPlanet("Coruscant"))

		event_act_5 = plot.Get_Event("Rep_Outer_Rim_Sieges_Act_V_Dialog")
		event_act_5.Set_Dialog("DIALOG_OUTER_RIM_SIEGES_REP")
		event_act_5.Clear_Dialog_Text()
		event_act_5.Add_Dialog_Text("TEXT_STORY_OUTER_RIM_SIEGES_REP_ACT_V_OBJECTIVE")
		event_act_5.Add_Dialog_Text("TEXT_NONE")
		event_act_5.Add_Dialog_Text("TEXT_INTERVENTION_LOCATION", FindPlanet("Coruscant"))

		Create_Thread("State_Rep_Planet_Checker_01")
		Create_Thread("State_Rep_Planet_Checker_02")
	end
end

function State_Rep_Planet_Checker_01() -- triad of evil checker
	local plot = Get_Story_Plot("Conquests\\CloneWarsOuterRimSieges\\Story_Sandbox_OuterRimSieges_Republic.XML")
	local event_act_1 = plot.Get_Event("Rep_Outer_Rim_Sieges_Act_I_Dialog")
	event_act_1.Set_Dialog("DIALOG_OUTER_RIM_SIEGES_REP")
	event_act_1.Clear_Dialog_Text()
	for _,p_planet in pairs(triad_of_evil_list) do
		if p_planet.Get_Owner() ~= p_republic then
			if p_planet.Get_Planet_Location() == FindPlanet("Saleucami") then
				if (TestValid(Find_First_Object("Aayla_Secura2")) or TestValid(Find_First_Object("Aayla_Secura_Eta_Team"))) and TestValid(Find_First_Object("Autem_Venator")) then
					-- aayla and autem both present
					event_act_3.Add_Dialog_Text("TEXT_STORY_OUTER_RIM_SIEGES_REP_ACT_III_OBJECTIVE_01")
					event_act_3.Add_Dialog_Text("TEXT_NONE")
					event_act_3.Add_Dialog_Text("TEXT_INTERVENTION_LOCATION", FindPlanet("Charros"))

				event_act_3_01_task = plot.Get_Event("Rep_Outer_Rim_Sieges_Jedi_Charros_01")
				event_act_3_01_task.Set_Event_Parameter(0, Find_Object_Type("Anakin_Eta_Team"))

				event_act_3_02_task = plot.Get_Event("Rep_Outer_Rim_Sieges_Jedi_Charros_02")
				event_act_3_02_task.Set_Event_Parameter(0, Find_Object_Type("Obi_Wan_Eta_Team"))
				elseif (TestValid(Find_First_Object("Aayla_Secura2")) or TestValid(Find_First_Object("Aayla_Secura_Eta_Team"))) and not TestValid(Find_First_Object("Autem_Venator")) then
					-- only aayla	
					event_act_1.Add_Dialog_Text("TEXT_STORY_ORS_REP_LOCATION_SALEUCAMI", p_planet)
				elseif not (TestValid(Find_First_Object("Aayla_Secura2")) or TestValid(Find_First_Object("Aayla_Secura_Eta_Team"))) and TestValid(Find_First_Object("Autem_Venator")) then
					-- only autem
					event_act_1.Add_Dialog_Text("TEXT_STORY_ORS_REP_LOCATION_SALEUCAMI", p_planet)
				else
					event_act_1.Add_Dialog_Text("TEXT_INTERVENTION_PLANET_CONQUEST_LOCATION", p_planet)
				end
			else
				event_act_1.Add_Dialog_Text("TEXT_INTERVENTION_PLANET_CONQUEST_LOCATION", p_planet)
			end
		else
			event_act_1.Add_Dialog_Text("TEXT_INTERVENTION_PLANET_CONQUEST_LOCATION_COMPLETE", p_planet)
		end
	end
	if FindPlanet("Saleucami").Get_Owner() == p_republic and FindPlanet("Felucia").Get_Owner() == p_republic and FindPlanet("Mygeeto").Get_Owner() == p_republic then
		triad_conquered = true
	end
	Sleep(5.0)
	if not triad_conquered then
		Create_Thread("State_Rep_Planet_Checker_01")
	elseif triad_conquered then
		Story_Event("REP_ACT_I_PLANETS_CONQUERED")
	end
end

function State_Rep_Planet_Checker_02() -- target planet checker
	plot = Get_Story_Plot("Conquests\\CloneWarsOuterRimSieges\\Story_Sandbox_OuterRimSieges_Republic.XML")
	event_act_6 = plot.Get_Event("Rep_Outer_Rim_Sieges_Act_VI_Dialog")
	event_act_6.Set_Dialog("DIALOG_OUTER_RIM_SIEGES_REP")
	event_act_6.Clear_Dialog_Text()
	for _,p_planet in pairs(target_planet_list) do
		if p_planet.Get_Owner() ~= p_republic then
			event_act_6.Add_Dialog_Text("TEXT_INTERVENTION_PLANET_CONQUEST_LOCATION", p_planet)
		else
			event_act_6.Add_Dialog_Text("TEXT_INTERVENTION_PLANET_CONQUEST_LOCATION_COMPLETE", p_planet)
		end
	end
	if FindPlanet("Serenno").Get_Owner() == p_republic and FindPlanet("Siskeen").Get_Owner() == p_republic and FindPlanet("YagDhul").Get_Owner() == p_republic and FindPlanet("Murkhana").Get_Owner() == p_republic and FindPlanet("Praesitlyn").Get_Owner() == p_republic then
		target_planets_conquered = true
	end
	Sleep(5.0)
	if not target_planets_conquered then
		Create_Thread("State_Rep_Planet_Checker_02")
	elseif target_planets_conquered then
		Story_Event("REP_ACT_VI_PLANETS_CONQUERED")
	end
end

function State_Rep_Mechno_Moving_Start(message)
    if message == OnEnter then
		Safe_House_Planet = StoryUtil.GetSafePlanetTable()
		StoryUtil.SpawnAtSafePlanet("CATO_NEIMOIDIA", Find_Player("Empire"), Safe_House_Planet, {"Mechno_Chair_Team"})
		Create_Thread("State_Rep_Mechno_Moving_Checker")
	end
end

function State_Rep_Mechno_Moving_Checker()
	if Find_First_Object("Mechno_Chair").Get_Planet_Location() == FindPlanet("Coruscant") then
		Story_Event("REP_MECHNO_MOVED")
		if TestValid(Find_First_Object("Mechno_Chair")) then
			Find_First_Object("Mechno_Chair").Despawn()
		end
		mechno_moved = true
	end
	Sleep(5.0)
	if not mechno_moved then
		Create_Thread("State_Rep_Mechno_Moving_Checker")
	end
end

function State_Rep_Charros_Chair_Start(message)
    if message == OnEnter then
		Story_Event("REP_ACT_III_START")
		Create_Thread("State_Rep_Charros_Chair_Checker")
	end
end

function State_Rep_Charros_Chair_Checker()
	plot = Get_Story_Plot("Conquests\\CloneWarsOuterRimSieges\\Story_Sandbox_OuterRimSieges_Republic.XML")

	event_act_3 = plot.Get_Event("Rep_Outer_Rim_Sieges_Act_III_Dialog")
	event_act_3.Set_Dialog("DIALOG_OUTER_RIM_SIEGES_REP")
	event_act_3.Clear_Dialog_Text()

	if TestValid(Find_First_Object("Anakin2")) and TestValid(Find_First_Object("Obi_Wan2")) then
		event_act_3.Add_Dialog_Text("TEXT_STORY_OUTER_RIM_SIEGES_REP_ACT_III_OBJECTIVE_01")
		event_act_3.Add_Dialog_Text("TEXT_NONE")
		event_act_3.Add_Dialog_Text("TEXT_INTERVENTION_LOCATION", FindPlanet("Charros"))

		event_act_3_01_task = plot.Get_Event("Rep_Outer_Rim_Sieges_Jedi_Charros_01")
		event_act_3_01_task.Set_Event_Parameter(0, Find_Object_Type("Anakin_Eta_Team"))

		event_act_3_02_task = plot.Get_Event("Rep_Outer_Rim_Sieges_Jedi_Charros_02")
		event_act_3_02_task.Set_Event_Parameter(0, Find_Object_Type("Obi_Wan_Eta_Team"))
	elseif not TestValid(Find_First_Object("Anakin2")) and TestValid(Find_First_Object("Obi_Wan2")) then
		event_act_3.Add_Dialog_Text("TEXT_STORY_OUTER_RIM_SIEGES_REP_ACT_III_OBJECTIVE_02")
		event_act_3.Add_Dialog_Text("TEXT_NONE")
		event_act_3.Add_Dialog_Text("TEXT_INTERVENTION_LOCATION", FindPlanet("Charros"))

		event_act_3_01_task = plot.Get_Event("Rep_Outer_Rim_Sieges_Jedi_Charros_01")
		event_act_3_01_task.Set_Event_Parameter(0, Find_Object_Type("Obi_Wan_Eta_Team"))

		event_act_3_02_task = plot.Get_Event("Rep_Outer_Rim_Sieges_Jedi_Charros_02")
		event_act_3_02_task.Set_Event_Parameter(0, Find_Object_Type("Obi_Wan_Eta_Team"))
	elseif TestValid(Find_First_Object("Anakin2")) and not TestValid(Find_First_Object("Obi_Wan2")) then
		event_act_3.Add_Dialog_Text("TEXT_STORY_OUTER_RIM_SIEGES_REP_ACT_III_OBJECTIVE_03")
		event_act_3.Add_Dialog_Text("TEXT_NONE")
		event_act_3.Add_Dialog_Text("TEXT_INTERVENTION_LOCATION", FindPlanet("Charros"))

		event_act_3_01_task = plot.Get_Event("Rep_Outer_Rim_Sieges_Jedi_Charros_01")
		event_act_3_01_task.Set_Event_Parameter(0, Find_Object_Type("Anakin_Eta_Team"))

		event_act_3_02_task = plot.Get_Event("Rep_Outer_Rim_Sieges_Jedi_Charros_02")
		event_act_3_02_task.Set_Event_Parameter(0, Find_Object_Type("Anakin_Eta_Team"))
	elseif not TestValid(Find_First_Object("Anakin2")) and not TestValid(Find_First_Object("Obi_Wan2")) then
		event_act_3.Add_Dialog_Text("TEXT_STORY_OUTER_RIM_SIEGES_REP_ACT_III_OBJECTIVE_04")
		event_act_3.Add_Dialog_Text("TEXT_NONE")
		event_act_3.Add_Dialog_Text("TEXT_INTERVENTION_LOCATION", FindPlanet("Charros"))

		event_act_3_01_task = plot.Get_Event("Rep_Outer_Rim_Sieges_Jedi_Charros_01")
		event_act_3_01_task.Set_Event_Parameter(0, Find_Object_Type("Republic_Jedi_Squad"))

		event_act_3_02_task = plot.Get_Event("Rep_Outer_Rim_Sieges_Jedi_Charros_02")
		event_act_3_02_task.Set_Event_Parameter(0, Find_Object_Type("Republic_Jedi_Squad"))
	end
	if not charros_chair_complete then
		Sleep(5.0)
		Create_Thread("State_Rep_Charros_Chair_Checker")
	end
end

function State_Rep_Tythe_Terror_Start(message)
    if message == OnEnter then
		charros_chair_complete = true
		Story_Event("REP_ACT_IV_START")
		ChangePlanetOwnerAndRetreat(FindPlanet("Tythe"), p_cis)
		local spawn_list_tythe = {
			"CIS_MTT_Company",
			"AAT_Company",
			"B1_Droid_Squad",
			"B1_Droid_Squad",
			"Persuader_Company",
			"Hailfire_Company",
			"Hailfire_Company",
			"R_Ground_Barracks",
			"R_Ground_Barracks",
			"R_Ground_Barracks",
		}
		TytheSpawn = SpawnList(spawn_list_tythe, FindPlanet("Tythe"), p_cis, false, false)
		Sleep(5.0)
		Create_Thread("State_Rep_Tythe_Terror_Checker")
	end
end

function State_Rep_Tythe_Terror_Checker()
	local plot = Get_Story_Plot("Conquests\\CloneWarsOuterRimSieges\\Story_Sandbox_OuterRimSieges_Republic.XML")

	event_act_4 = plot.Get_Event("Rep_Outer_Rim_Sieges_Act_IV_Dialog")
	event_act_4.Set_Dialog("DIALOG_OUTER_RIM_SIEGES_REP")
	event_act_4.Clear_Dialog_Text()

	if TestValid(Find_First_Object("Anakin2")) and TestValid(Find_First_Object("Obi_Wan2")) then
		event_act_4.Add_Dialog_Text("TEXT_STORY_OUTER_RIM_SIEGES_REP_ACT_III_OBJECTIVE_01")
		event_act_4.Add_Dialog_Text("TEXT_NONE")
		event_act_4.Add_Dialog_Text("TEXT_INTERVENTION_LOCATION", FindPlanet("Tythe"))

		event_act_4_01_task = plot.Get_Event("Rep_Outer_Rim_Sieges_Jedi_Tythe_01")
		event_act_4_01_task.Set_Event_Parameter(0, Find_Object_Type("Anakin_Eta_Team"))

		event_act_4_02_task = plot.Get_Event("Rep_Outer_Rim_Sieges_Jedi_Tythe_02")
		event_act_4_02_task.Set_Event_Parameter(0, Find_Object_Type("Obi_Wan_Eta_Team"))
	elseif not TestValid(Find_First_Object("Anakin2")) and TestValid(Find_First_Object("Obi_Wan2")) then
		event_act_4.Add_Dialog_Text("TEXT_STORY_OUTER_RIM_SIEGES_REP_ACT_III_OBJECTIVE_02")
		event_act_4.Add_Dialog_Text("TEXT_NONE")
		event_act_4.Add_Dialog_Text("TEXT_INTERVENTION_LOCATION", FindPlanet("Tythe"))

		event_act_4_01_task = plot.Get_Event("Rep_Outer_Rim_Sieges_Jedi_Tythe_01")
		event_act_4_01_task.Set_Event_Parameter(0, Find_Object_Type("Obi_Wan_Eta_Team"))

		event_act_4_02_task = plot.Get_Event("Rep_Outer_Rim_Sieges_Jedi_Tythe_02")
		event_act_4_02_task.Set_Event_Parameter(0, Find_Object_Type("Obi_Wan_Eta_Team"))
	elseif TestValid(Find_First_Object("Anakin2")) and not TestValid(Find_First_Object("Obi_Wan2")) then
		event_act_4.Add_Dialog_Text("TEXT_STORY_OUTER_RIM_SIEGES_REP_ACT_III_OBJECTIVE_03")
		event_act_4.Add_Dialog_Text("TEXT_NONE")
		event_act_4.Add_Dialog_Text("TEXT_INTERVENTION_LOCATION", FindPlanet("Tythe"))

		event_act_4_01_task = plot.Get_Event("Rep_Outer_Rim_Sieges_Jedi_Tythe_01")
		event_act_4_01_task.Set_Event_Parameter(0, Find_Object_Type("Anakin_Eta_Team"))

		event_act_4_02_task = plot.Get_Event("Rep_Outer_Rim_Sieges_Jedi_Tythe_02")
		event_act_4_02_task.Set_Event_Parameter(0, Find_Object_Type("Anakin_Eta_Team"))
	elseif not TestValid(Find_First_Object("Anakin2")) and not TestValid(Find_First_Object("Obi_Wan2")) then
		event_act_4.Add_Dialog_Text("TEXT_STORY_OUTER_RIM_SIEGES_REP_ACT_III_OBJECTIVE_04")
		event_act_4.Add_Dialog_Text("TEXT_NONE")
		event_act_4.Add_Dialog_Text("TEXT_INTERVENTION_LOCATION", FindPlanet("Tythe"))

		event_act_4_01_task = plot.Get_Event("Rep_Outer_Rim_Sieges_Jedi_Tythe_01")
		event_act_4_01_task.Set_Event_Parameter(0, Find_Object_Type("Republic_Jedi_Squad"))

		event_act_4_02_task = plot.Get_Event("Rep_Outer_Rim_Sieges_Jedi_Tythe_02")
		event_act_4_02_task.Set_Event_Parameter(0, Find_Object_Type("Republic_Jedi_Squad"))
	end
	if not tythe_terror_complete then
		Sleep(5.0)
		Create_Thread("State_Rep_Tythe_Terror_Checker")
	end
end

function State_Rep_Coruscant_Chaos_Start(message)
    if message == OnEnter then
		tythe_terror_complete = true
		local spawn_list_coruscant = {
			"Battleship_Lucrehulk",
			"Providence_Dreadnought",
			"Providence_Dreadnought",
			"Generic_Providence",
			"Generic_Providence",
			"Generic_Providence",
			"Munificent",
			"Munificent",
			"Munificent",
			"Munificent",
			"Munificent",
			"Recusant_Dreadnought",
			"Recusant",
			"Recusant",
			"Recusant",
			"Auxilia",
			"Auxilia",
			"Auxilia",
			"Munifex",
			"Munifex",
			"Munifex",
			"Munifex",
			"C9979_Carrier",
			"C9979_Carrier",
			"C9979_Carrier",
			"C9979_Carrier",
			"C9979_Carrier",
		}
		CoruscantSpawn = SpawnList(spawn_list_coruscant, FindPlanet("Coruscant"), Find_Player("Hostile"), false, false)
	end
end

function State_Rep_Outer_Rim_Sieges_Act_VIII(message)
    if message == OnEnter then
		Story_Event("START_REPUBLIC_FUTURE")
	end
end
