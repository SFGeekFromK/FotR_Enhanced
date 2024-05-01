
--*****************************************************--
--********  Campaign: Operation Durge's Lance  ********--
--*****************************************************--

require("PGStoryMode")
require("PGSpawnUnits")
require("eawx-util/ChangeOwnerUtilities")
StoryUtil = require("eawx-util/StoryUtil")
require("deepcore/crossplot/crossplot")
require("eawx-plugins/influence-service/InfluenceService")

function Definitions()
    DebugMessage("%s -- In Definitions", tostring(Script))

    ServiceRate = 5.0

    StoryModeEvents = {
		-- Generic
        Trigger_GC_Set_Up = State_GC_Set_Up,
		Trigger_Framework_Activation = State_Framework_Activation,

		-- CIS
		CIS_Duro_Defence_Tactical_Epilogue = State_CIS_Duro_Defence_Tactical_Epilogue,
		CIS_Jyvus_Joyride_Tactical_Failed = State_CIS_Keggle_Checker,
		CIS_Duro_Drama_Tactical_Epilogue = State_CIS_Duro_Drama_Tactical_Epilogue,
		CIS_Duro_Bombing_Checker = State_CIS_Duro_Bombing_Checker,
		CIS_Mad_Clone_Checker = State_CIS_Mad_Clone_Checker,
		CIS_Kuat_Lockdown = State_CIS_Kuat_Lockdown,
		CIS_Kuat_Conquest = State_CIS_Kuat_Conquest,
		CIS_GC_Progression_Research = State_CIS_GC_Progression_Research,

		-- Republic
    }

	p_cis = Find_Player("Rebel")
	p_republic = Find_Player("Empire")

	gc_start = false
	all_planets_conquered = false
	act_1_active = false
	act_2_active = false
	act_3_active = false

	duro_bombed = false
	duro_chain_complete = false
	resurection_amount = 0

	grievous_dead = false

	target_planets_conquered = false
	savety_check = 0

	GlobalValue.Set("CURRENT_CLONE_PHASE", 1)

	crossplot:galactic()
	crossplot:subscribe("HISTORICAL_GC_CHOICE_OPTION", State_Historical_GC_Choice)
end


function State_GC_Set_Up(message)
    if message == OnEnter then
		if p_cis.Is_Human() then
			GlobalValue.Set("ODL_CIS_GC_Version", 0) -- 1 = AU Version; 0 = Canonical Version

			if TestValid(Find_First_Object("GC_AU_Dummy")) then
				GlobalValue.Set("ODL_CIS_GC_Version", 1) -- 1 = AU Version; 0 = Canonical Version
			end
		elseif p_republic.Is_Human() then
			GlobalValue.Set("ODL_Rep_GC_Version", 0) -- 1 = AU Version; 0 = Canonical Version

			if TestValid(Find_First_Object("GC_AU_Dummy")) then
				GlobalValue.Set("ODL_Rep_GC_Version", 1) -- 1 = AU Version; 0 = Canonical Version
			end
			if TestValid(Find_First_Object("GC_AU_2_Dummy")) then
				GlobalValue.Set("CURRENT_CLONE_PHASE", 2)
			end
		end

		crossplot:publish("POPUPEVENT", "HISTORICAL_GC_CHOICE", {"STORY", "NO_INTRO", "NO_STORY"}, { },
				{ }, { },
				{ }, { },
				{ }, { },
				"HISTORICAL_GC_CHOICE_OPTION")

		-- CIS
		Find_Player("Rebel").Unlock_Tech(Find_Object_Type("Separatist_Council"))

		Find_Player("Rebel").Lock_Tech(Find_Object_Type("NewRep_Senate"))
		Find_Player("Rebel").Lock_Tech(Find_Object_Type("Grievous_Team_Malevolence_Recusant"))
		Find_Player("Rebel").Lock_Tech(Find_Object_Type("Grievous_Team_Malevolence_Providence"))
		Find_Player("Rebel").Lock_Tech(Find_Object_Type("Random_Mercenary"))

		-- Republic
		Find_Player("Empire").Unlock_Tech(Find_Object_Type("Republic_Sector_Capital"))
		Find_Player("Empire").Unlock_Tech(Find_Object_Type("Generic_Victory_Destroyer"))
		Find_Player("Empire").Unlock_Tech(Find_Object_Type("Generic_Venator"))
		Find_Player("Empire").Unlock_Tech(Find_Object_Type("LAC"))
		Find_Player("Empire").Unlock_Tech(Find_Object_Type("Citadel_Cruiser_Squadron"))

		Find_Player("Empire").Lock_Tech(Find_Object_Type("Remnant_Capital"))
		Find_Player("Empire").Lock_Tech(Find_Object_Type("Charger_C70"))

		Find_Player("Empire").Lock_Tech(Find_Object_Type("Mace_Retire"))

	end
end

function State_Historical_GC_Choice(choice)
	if choice == "HISTORICAL_GC_CHOICE_STORY" then
		if p_cis.Is_Human() then
			Create_Thread("State_CIS_Story_Set_Up")

			GlobalValue.Set("ODL_CIS_Shipyard_Struggle_Outcome", 0) -- 0 = CIS Victory; 1 = Republic Victory
			GlobalValue.Set("ODL_CIS_Jyvus_Joyride_Outcome", 1) -- 0 = CIS Victory; 1 = Republic Victory
			GlobalValue.Set("ODL_CIS_Grievous_Respawn", 0)

			Story_Event("CIS_INTRO_START")
		end
		if p_republic.Is_Human() then
			Create_Thread("State_Rep_Story_Set_Up")

			Story_Event("REP_INTRO_START")
		end
	end
	if choice == "HISTORICAL_GC_CHOICE_NO_INTRO" then
		if p_cis.Is_Human() then
			GlobalValue.Set("ODL_CIS_Shipyard_Struggle_Outcome", 0) -- 0 = CIS Victory; 1 = Republic Victory
			GlobalValue.Set("ODL_CIS_Jyvus_Joyride_Outcome", 1) -- 0 = CIS Victory; 1 = Republic Victory
			GlobalValue.Set("ODL_CIS_Grievous_Respawn", 0)

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
		GlobalValue.Set("CURRENT_ERA", 3)
		crossplot:publish("INITIALIZE_AI", "empty")
		crossplot:publish("VENATOR_HEROES", "empty")
		crossplot:publish("VICTORY_HEROES", "empty")
		-- FotR_Enhanced
		crossplot:publish("GEEN_UNLOCK", "empty")

		--Admirals: 5 - 3 = 2 -- FotR_Enhanced : block and needa unavailable
		crossplot:publish("REPUBLIC_ADMIRAL_DECREMENT", 3, 1)
		crossplot:publish("REPUBLIC_ADMIRAL_EXIT", {"Yularen","Coburn","Kilian","Screed","Dodonna","Wieler","Dao","Tenant","Block","Needa",}, 1)

		--Moffs: 2 - 1 = 1
		crossplot:publish("REPUBLIC_ADMIRAL_LOCKIN", {"Grant"}, 2)

		--Jedi: 5 - 1 - 1 = 3
		crossplot:publish("REPUBLIC_ADMIRAL_DECREMENT", 1, 3)
		crossplot:publish("REPUBLIC_ADMIRAL_LOCKIN", {"Mace"}, 3)
		crossplot:publish("REPUBLIC_ADMIRAL_EXIT", {"Aayla","Barriss","Kit","Shaak","Ahsoka","Knol","Halcyon"}, 3)

		--Clone Officers: 4 - 3 = 1 (if phaes 2 then 2)
		crossplot:publish("REPUBLIC_ADMIRAL_DECREMENT", 3, 4)
		crossplot:publish("REPUBLIC_ADMIRAL_EXIT", {"Rex","Bly","Cody","Wolffe","Gree_Clone"}, 4)

		--Commandos: 3 - 1 = 2
		crossplot:publish("REPUBLIC_ADMIRAL_DECREMENT", 1, 5)

		--Generals: 3 - 1 - 1 = 1
		crossplot:publish("REPUBLIC_ADMIRAL_LOCKIN", {"Gentis"}, 6)
		crossplot:publish("REPUBLIC_ADMIRAL_DECREMENT", 1, 6)
	else
		crossplot:update()
    end
end

function State_Generic_Story_Set_Up()
	StoryUtil.SpawnAtSafePlanet("YAGDHUL", Find_Player("Rebel"), StoryUtil.GetSafePlanetTable(), {"Grievous_Team"})
	gc_start = true
end


function Story_Mode_Service()
	if gc_start then
		if p_cis.Is_Human() then
			if (GlobalValue.Get("ODL_CIS_Grievous_Respawn") == 1) then
				local Grievous_Spawns = {"Grievous_Team"}
				StoryUtil.SpawnAtSafePlanet("YAGDHUL", p_cis, StoryUtil.GetSafePlanetTable(), Grievous_Spawns)
				GlobalValue.Set("ODL_CIS_Grievous_Respawn", 0)
			end
			--[[local all_planets = FindPlanet.Get_All_Planets()
			for _, planet in pairs(all_planets) do
				if planet.Get_Owner() == p_cis then
					if not all_planets_conquered then
						all_planets_conquered = true
						if TestValid(Find_First_Object("Grievous_Soulless_One_Ground")) or TestValid(Find_First_Object("Soulless_One")) or TestValid(Find_First_Object("Grievous_Team_Soulless_One")) then
							if FindPlanet("Kuat").Get_Owner() == p_cis then
								StoryUtil.LoadCampaign("Sandbox_AU_2_OuterRimSieges_CIS", 0)
							end
							if FindPlanet("Kuat").Get_Owner() ~= p_cis then
								StoryUtil.LoadCampaign("Sandbox_OuterRimSieges_CIS", 0)
							end

							savety_check = 0
							grievous_dead = false
						elseif TestValid(Find_First_Object("General_Grievous")) or TestValid(Find_First_Object("Invisible_Hand")) or TestValid(Find_First_Object("Grievous_Team")) then
							if FindPlanet("Kuat").Get_Owner() == p_cis then
								StoryUtil.LoadCampaign("Sandbox_AU_2_OuterRimSieges_CIS", 0)
							end
							if FindPlanet("Kuat").Get_Owner() ~= p_cis then
								StoryUtil.LoadCampaign("Sandbox_OuterRimSieges_CIS", 0)
							end

							savety_check = 0
							grievous_dead = false
						elseif TestValid(Find_First_Object("Grievous_Recusant_Ground")) or TestValid(Find_First_Object("Grievous_Recusant")) or TestValid(Find_First_Object("Grievous_Team_Recusant")) then
							if FindPlanet("Kuat").Get_Owner() == p_cis then
								StoryUtil.LoadCampaign("Sandbox_AU_2_OuterRimSieges_CIS", 0)
							end
							if FindPlanet("Kuat").Get_Owner() ~= p_cis then
								StoryUtil.LoadCampaign("Sandbox_OuterRimSieges_CIS", 0)
							end

							savety_check = 0
							grievous_dead = false
						elseif TestValid(Find_First_Object("Grievous_Munificent_Ground")) or TestValid(Find_First_Object("Grievous_Munificent")) or TestValid(Find_First_Object("Grievous_Team_Munificent")) then
							if FindPlanet("Kuat").Get_Owner() == p_cis then
								StoryUtil.LoadCampaign("Sandbox_AU_2_OuterRimSieges_CIS", 0)
							end
							if FindPlanet("Kuat").Get_Owner() ~= p_cis then
								StoryUtil.LoadCampaign("Sandbox_OuterRimSieges_CIS", 0)
							end

							savety_check = 0
							grievous_dead = false
						elseif TestValid(Find_First_Object("Grievous_Malevolence_Ground")) or TestValid(Find_First_Object("Grievous_Malevolence")) or TestValid(Find_First_Object("Grievous_Team_Malevolence")) then
							StoryUtil.LoadCampaign("Sandbox_AU_1_OuterRimSieges_CIS", 0)

							savety_check = 0
							grievous_dead = false
						else
							grievous_dead = true
							StoryUtil.LoadCampaign("Sandbox_Foerost_CIS", 0)
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
						StoryUtil.LoadCampaign("Sandbox_Foerost_Republic", 1)
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

		StoryUtil.SetPlanetRestricted("DURO", 1)
		StoryUtil.SetPlanetRestricted("KUAT", 1)

		target_planet_list = {
			--FindPlanet("Corellia"),
			--FindPlanet("Kuat"),
			FindPlanet("Duro"),
			FindPlanet("Humbarine"),
			FindPlanet("Kaikielius"),
			FindPlanet("Byss"),
		}

		if (GlobalValue.Get("ODL_CIS_GC_Version") == 0) then
			StoryUtil.SpawnAtSafePlanet("YAGDHUL", Find_Player("Rebel"), StoryUtil.GetSafePlanetTable(), {"Grievous_Team"})
		elseif (GlobalValue.Get("ODL_CIS_GC_Version") == 1) then
			StoryUtil.SpawnAtSafePlanet("YAGDHUL", Find_Player("Rebel"), StoryUtil.GetSafePlanetTable(), {"Grievous_Team_Malevolence"})
		end

		plot = Get_Story_Plot("Conquests\\CloneWarsDurgesLance\\Story_Sandbox_DurgesLance_CIS.XML")

		event_act_1 = plot.Get_Event("CIS_Durges_Lance_Act_I_Dialog")
		event_act_1.Set_Dialog("DIALOG_DURGES_LANCE_CIS")
		event_act_1.Clear_Dialog_Text()
		for _,p_planet in pairs(target_planet_list) do
			if p_planet.Get_Owner() ~= p_cis then
				if p_planet.Get_Planet_Location() == FindPlanet("Duro") then
					event_act_1.Add_Dialog_Text("TEXT_STORY_DURGES_LANCE_CIS_LOCATION_DURO", p_planet)
				elseif p_planet.Get_Planet_Location() == FindPlanet("Kuat") then
					event_act_1.Add_Dialog_Text("TEXT_STORY_DURGES_LANCE_CIS_LOCATION_KUAT", p_planet)
				elseif p_planet.Get_Planet_Location() == FindPlanet("Humbarine") then
					event_act_1.Add_Dialog_Text("TEXT_STORY_DURGES_LANCE_CIS_LOCATION_HUMBARINE", p_planet)
				else
					event_act_1.Add_Dialog_Text("TEXT_INTERVENTION_PLANET_CONQUEST_LOCATION", p_planet)
				end
			else
				event_act_1.Add_Dialog_Text("TEXT_INTERVENTION_PLANET_CONQUEST_LOCATION_COMPLETE", p_planet)
			end
		end

		event_act_2 = plot.Get_Event("CIS_Durges_Lance_Act_II_Dialog")
		event_act_2.Set_Dialog("DIALOG_DURGES_LANCE_CIS")
		event_act_2.Clear_Dialog_Text()
		event_act_2.Add_Dialog_Text("TEXT_STORY_DURGES_LANCE_CIS_LOCATION_KUAT", FindPlanet("Kuat"))

		event_act_3 = plot.Get_Event("CIS_Durges_Lance_Act_III_Dialog")
		event_act_3.Set_Dialog("DIALOG_DURGES_LANCE_CIS")
		event_act_3.Clear_Dialog_Text()
		event_act_3.Add_Dialog_Text("TEXT_INTERVENTION_PLANET_CONQUEST_LOCATION", FindPlanet("YagDhul"))

		if TestValid(Find_First_Object("Grievous_Soulless_One_Ground")) or TestValid(Find_First_Object("Soulless_One")) or TestValid(Find_First_Object("Grievous_Team_Soulless_One")) then
			event_act_2_01_task = plot.Get_Event("CIS_Grievous_Entry_Duro")
			event_act_2_01_task.Set_Event_Parameter(2, Find_Object_Type("Grievous_Team_Soulless_One"))

			--event_act_2_02_task = plot.Get_Event("CIS_Grievous_Invading_Duro")
			--event_act_2_02_task.Set_Event_Parameter(2, Find_Object_Type("Grievous_Team_Soulless_One"))

			event_act_2_03_task = plot.Get_Event("CIS_Grievous_Entry_Kuat")
			event_act_2_03_task.Set_Event_Parameter(2, Find_Object_Type("Grievous_Team_Soulless_One"))

			event_act_2_04_task = plot.Get_Event("CIS_Grievous_Entry_HoloNet")
			event_act_2_04_task.Set_Event_Parameter(2, Find_Object_Type("Grievous_Team_Soulless_One"))

			event_act_2_05_task = plot.Get_Event("CIS_Shipyard_Struggle_Tactical")
			event_act_2_05_task.Set_Event_Parameter(2, Find_Object_Type("Grievous_Team_Soulless_One"))

			savety_check = 0
		elseif TestValid(Find_First_Object("General_Grievous")) or TestValid(Find_First_Object("Invisible_Hand")) or TestValid(Find_First_Object("Grievous_Team")) then
			event_act_2_01_task = plot.Get_Event("CIS_Grievous_Entry_Duro")
			event_act_2_01_task.Set_Event_Parameter(2, Find_Object_Type("Grievous_Team"))

			--event_act_2_02_task = plot.Get_Event("CIS_Grievous_Invading_Duro")
			--event_act_2_02_task.Set_Event_Parameter(2, Find_Object_Type("Grievous_Team"))

			event_act_2_03_task = plot.Get_Event("CIS_Grievous_Entry_Kuat")
			event_act_2_03_task.Set_Event_Parameter(2, Find_Object_Type("Grievous_Team"))

			event_act_2_04_task = plot.Get_Event("CIS_Grievous_Entry_HoloNet")
			event_act_2_04_task.Set_Event_Parameter(2, Find_Object_Type("Grievous_Team"))

			event_act_2_05_task = plot.Get_Event("CIS_Shipyard_Struggle_Tactical")
			event_act_2_05_task.Set_Event_Parameter(2, Find_Object_Type("Grievous_Team"))

			savety_check = 0
		elseif TestValid(Find_First_Object("Grievous_Recusant_Ground")) or TestValid(Find_First_Object("Grievous_Recusant")) or TestValid(Find_First_Object("Grievous_Team_Recusant")) then
			event_act_2_01_task = plot.Get_Event("CIS_Grievous_Entry_Duro")
			event_act_2_01_task.Set_Event_Parameter(2, Find_Object_Type("Grievous_Team_Recusant"))

			--event_act_2_02_task = plot.Get_Event("CIS_Grievous_Invading_Duro")
			--event_act_2_02_task.Set_Event_Parameter(2, Find_Object_Type("Grievous_Team_Recusant"))

			event_act_2_03_task = plot.Get_Event("CIS_Grievous_Entry_Kuat")
			event_act_2_03_task.Set_Event_Parameter(2, Find_Object_Type("Grievous_Team_Recusant"))

			event_act_2_04_task = plot.Get_Event("CIS_Grievous_Entry_HoloNet")
			event_act_2_04_task.Set_Event_Parameter(2, Find_Object_Type("Grievous_Team_Recusant"))

			event_act_2_05_task = plot.Get_Event("CIS_Shipyard_Struggle_Tactical")
			event_act_2_05_task.Set_Event_Parameter(2, Find_Object_Type("Grievous_Team_Recusant"))

			savety_check = 0
		elseif TestValid(Find_First_Object("Grievous_Munificent_Ground")) or TestValid(Find_First_Object("Grievous_Munificent")) or TestValid(Find_First_Object("Grievous_Team_Munificent")) then
			event_act_2_01_task = plot.Get_Event("CIS_Grievous_Entry_Duro")
			event_act_2_01_task.Set_Event_Parameter(2, Find_Object_Type("Grievous_Team_Munificent"))

			--event_act_2_02_task = plot.Get_Event("CIS_Grievous_Invading_Duro")
			--event_act_2_02_task.Set_Event_Parameter(2, Find_Object_Type("Grievous_Team_Munificent"))

			event_act_2_03_task = plot.Get_Event("CIS_Grievous_Entry_Kuat")
			event_act_2_03_task.Set_Event_Parameter(2, Find_Object_Type("Grievous_Team_Munificent"))

			event_act_2_04_task = plot.Get_Event("CIS_Grievous_Entry_HoloNet")
			event_act_2_04_task.Set_Event_Parameter(2, Find_Object_Type("Grievous_Team_Munificent"))

			event_act_2_05_task = plot.Get_Event("CIS_Shipyard_Struggle_Tactical")
			event_act_2_05_task.Set_Event_Parameter(2, Find_Object_Type("Grievous_Team_Munificent"))

			savety_check = 0
		elseif TestValid(Find_First_Object("Grievous_Malevolence_Ground")) or TestValid(Find_First_Object("Grievous_Malevolence")) or TestValid(Find_First_Object("Grievous_Team_Malevolence")) then
			event_act_2_01_task = plot.Get_Event("CIS_Grievous_Entry_Duro")
			event_act_2_01_task.Set_Event_Parameter(2, Find_Object_Type("Grievous_Team_Malevolence"))

			--event_act_2_02_task = plot.Get_Event("CIS_Grievous_Invading_Duro")
			--event_act_2_02_task.Set_Event_Parameter(2, Find_Object_Type("Grievous_Team_Malevolence"))

			event_act_2_03_task = plot.Get_Event("CIS_Grievous_Entry_Kuat")
			event_act_2_03_task.Set_Event_Parameter(2, Find_Object_Type("Grievous_Team_Malevolence"))

			event_act_2_04_task = plot.Get_Event("CIS_Grievous_Entry_HoloNet")
			event_act_2_04_task.Set_Event_Parameter(2, Find_Object_Type("Grievous_Team_Malevolence"))

			event_act_2_05_task = plot.Get_Event("CIS_Shipyard_Struggle_Tactical")
			event_act_2_05_task.Set_Event_Parameter(2, Find_Object_Type("Grievous_Team_Malevolence"))

			savety_check = 0
		else
			savety_check = savety_check + 1
		end

		local holo_centre_gamble = 2
		if holo_centre_gamble == 1 then
			event_act_4_01_task = plot.Get_Event("CIS_Grievous_Entry_HoloNet")
			event_act_4_01_task.Set_Event_Parameter(0, FindPlanet("Byss"))

			event_act_4_02_task = plot.Get_Event("CIS_Holo_Hunt_Tactical")
			event_act_4_02_task.Set_Reward_Parameter(0, FindPlanet("Byss"))

			event_act_4_03_task = plot.Get_Event("CIS_Holo_Hunt_Tactical_Completed")
			event_act_4_03_task.Set_Event_Parameter(3, FindPlanet("Byss"))
			StoryUtil.SetPlanetRestricted("BYSS", 1)
		elseif holo_centre_gamble == 2 then
			event_act_4_01_task = plot.Get_Event("CIS_Grievous_Entry_HoloNet")
			event_act_4_01_task.Set_Event_Parameter(0, FindPlanet("Humbarine"))

			event_act_4_02_task = plot.Get_Event("CIS_Holo_Hunt_Tactical")
			event_act_4_02_task.Set_Reward_Parameter(0, FindPlanet("Humbarine"))

			event_act_4_03_task = plot.Get_Event("CIS_Holo_Hunt_Tactical_Completed")
			event_act_4_03_task.Set_Event_Parameter(3, FindPlanet("Humbarine"))
			StoryUtil.SetPlanetRestricted("HUMBARINE", 1)
		elseif holo_centre_gamble == 3 then
			event_act_4_01_task = plot.Get_Event("CIS_Grievous_Entry_HoloNet")
			event_act_4_01_task.Set_Event_Parameter(0, FindPlanet("Kaikielius"))

			event_act_4_02_task = plot.Get_Event("CIS_Holo_Hunt_Tactical")
			event_act_4_02_task.Set_Reward_Parameter(0, FindPlanet("Kaikielius"))

			event_act_4_03_task = plot.Get_Event("CIS_Holo_Hunt_Tactical_Completed")
			event_act_4_03_task.Set_Event_Parameter(3, FindPlanet("Kaikielius"))
			StoryUtil.SetPlanetRestricted("KAIKIELIUS", 1)
		end

		Create_Thread("State_CIS_Planet_Checker")
		Create_Thread("State_CIS_Grievous_Checker")
	end
end

function State_CIS_Planet_Checker()
	plot = Get_Story_Plot("Conquests\\CloneWarsDurgesLance\\Story_Sandbox_DurgesLance_CIS.XML")
	event_act_1 = plot.Get_Event("CIS_Durges_Lance_Act_I_Dialog")
	event_act_1.Set_Dialog("DIALOG_DURGES_LANCE_CIS")
	event_act_1.Clear_Dialog_Text()
	for _,p_planet in pairs(target_planet_list) do
		if p_planet.Get_Owner() ~= p_cis then
			if p_planet.Get_Planet_Location() == FindPlanet("Duro") then
				event_act_1.Add_Dialog_Text("TEXT_STORY_DURGES_LANCE_CIS_LOCATION_DURO", p_planet)
			elseif p_planet.Get_Planet_Location() == FindPlanet("Kuat") then
				event_act_1.Add_Dialog_Text("TEXT_STORY_DURGES_LANCE_CIS_LOCATION_KUAT", p_planet)
			elseif p_planet.Get_Planet_Location() == FindPlanet("Humbarine") then
				event_act_1.Add_Dialog_Text("TEXT_STORY_DURGES_LANCE_CIS_LOCATION_HUMBARINE", p_planet)
			else
				event_act_1.Add_Dialog_Text("TEXT_INTERVENTION_PLANET_CONQUEST_LOCATION", p_planet)
			end
		elseif p_planet.Get_Owner() == p_cis then
			event_act_1.Add_Dialog_Text("TEXT_INTERVENTION_PLANET_CONQUEST_LOCATION_COMPLETE", p_planet)
		end
	end
	if FindPlanet("Duro").Get_Owner() == p_cis and FindPlanet("Humbarine").Get_Owner() == p_cis and FindPlanet("Kaikielius").Get_Owner() == p_cis and FindPlanet("Byss").Get_Owner() == p_cis then
		Story_Event("CIS_PLANETS_CONQUERED")
		target_planets_conquered = true
	end
	Sleep(5.0)
	if not target_planets_conquered then
		Create_Thread("State_CIS_Planet_Checker")
	end
end

function State_CIS_Grievous_Checker()
	plot = Get_Story_Plot("Conquests\\CloneWarsDurgesLance\\Story_Sandbox_DurgesLance_CIS.XML")

	if TestValid(Find_First_Object("Grievous_Soulless_One_Ground")) or TestValid(Find_First_Object("Soulless_One")) or TestValid(Find_First_Object("Grievous_Team_Soulless_One")) then
		event_act_2_01_task = plot.Get_Event("CIS_Grievous_Entry_Duro")
		event_act_2_01_task.Set_Event_Parameter(2, Find_Object_Type("Grievous_Team_Soulless_One"))

		--event_act_2_02_task = plot.Get_Event("CIS_Grievous_Invading_Duro")
		--event_act_2_02_task.Set_Event_Parameter(2, Find_Object_Type("Grievous_Team_Soulless_One"))

		event_act_2_03_task = plot.Get_Event("CIS_Grievous_Entry_Kuat")
		event_act_2_03_task.Set_Event_Parameter(2, Find_Object_Type("Grievous_Team_Soulless_One"))

		event_act_2_04_task = plot.Get_Event("CIS_Grievous_Entry_HoloNet")
		event_act_2_04_task.Set_Event_Parameter(2, Find_Object_Type("Grievous_Team_Soulless_One"))

		event_act_2_05_task = plot.Get_Event("CIS_Shipyard_Struggle_Tactical")
		event_act_2_05_task.Set_Event_Parameter(2, Find_Object_Type("Grievous_Team_Soulless_One"))

		savety_check = 0
		grievous_dead = false
	elseif TestValid(Find_First_Object("General_Grievous")) or TestValid(Find_First_Object("Invisible_Hand")) or TestValid(Find_First_Object("Grievous_Team")) then
		event_act_2_01_task = plot.Get_Event("CIS_Grievous_Entry_Duro")
		event_act_2_01_task.Set_Event_Parameter(2, Find_Object_Type("Grievous_Team"))

		--event_act_2_02_task = plot.Get_Event("CIS_Grievous_Invading_Duro")
		--event_act_2_02_task.Set_Event_Parameter(2, Find_Object_Type("Grievous_Team"))

		event_act_2_03_task = plot.Get_Event("CIS_Grievous_Entry_Kuat")
		event_act_2_03_task.Set_Event_Parameter(2, Find_Object_Type("Grievous_Team"))

		event_act_2_04_task = plot.Get_Event("CIS_Grievous_Entry_HoloNet")
		event_act_2_04_task.Set_Event_Parameter(2, Find_Object_Type("Grievous_Team"))

		event_act_2_05_task = plot.Get_Event("CIS_Shipyard_Struggle_Tactical")
		event_act_2_05_task.Set_Event_Parameter(2, Find_Object_Type("Grievous_Team"))

		savety_check = 0
		grievous_dead = false
	elseif TestValid(Find_First_Object("Grievous_Recusant_Ground")) or TestValid(Find_First_Object("Grievous_Recusant")) or TestValid(Find_First_Object("Grievous_Team_Recusant")) then
		event_act_2_01_task = plot.Get_Event("CIS_Grievous_Entry_Duro")
		event_act_2_01_task.Set_Event_Parameter(2, Find_Object_Type("Grievous_Team_Recusant"))

		--event_act_2_02_task = plot.Get_Event("CIS_Grievous_Invading_Duro")
		--event_act_2_02_task.Set_Event_Parameter(2, Find_Object_Type("Grievous_Team_Recusant"))

		event_act_2_03_task = plot.Get_Event("CIS_Grievous_Entry_Kuat")
		event_act_2_03_task.Set_Event_Parameter(2, Find_Object_Type("Grievous_Team_Recusant"))

		event_act_2_04_task = plot.Get_Event("CIS_Grievous_Entry_HoloNet")
		event_act_2_04_task.Set_Event_Parameter(2, Find_Object_Type("Grievous_Team_Recusant"))

		event_act_2_05_task = plot.Get_Event("CIS_Shipyard_Struggle_Tactical")
		event_act_2_05_task.Set_Event_Parameter(2, Find_Object_Type("Grievous_Team_Recusant"))

		savety_check = 0
		grievous_dead = false
	elseif TestValid(Find_First_Object("Grievous_Munificent_Ground")) or TestValid(Find_First_Object("Grievous_Munificent")) or TestValid(Find_First_Object("Grievous_Team_Munificent")) then
		event_act_2_01_task = plot.Get_Event("CIS_Grievous_Entry_Duro")
		event_act_2_01_task.Set_Event_Parameter(2, Find_Object_Type("Grievous_Team_Munificent"))

		--event_act_2_02_task = plot.Get_Event("CIS_Grievous_Invading_Duro")
		--event_act_2_02_task.Set_Event_Parameter(2, Find_Object_Type("Grievous_Team_Munificent"))

		event_act_2_03_task = plot.Get_Event("CIS_Grievous_Entry_Kuat")
		event_act_2_03_task.Set_Event_Parameter(2, Find_Object_Type("Grievous_Team_Munificent"))

		event_act_2_04_task = plot.Get_Event("CIS_Grievous_Entry_HoloNet")
		event_act_2_04_task.Set_Event_Parameter(2, Find_Object_Type("Grievous_Team_Munificent"))

		event_act_2_05_task = plot.Get_Event("CIS_Shipyard_Struggle_Tactical")
		event_act_2_05_task.Set_Event_Parameter(2, Find_Object_Type("Grievous_Team_Munificent"))

		savety_check = 0
		grievous_dead = false
	elseif TestValid(Find_First_Object("Grievous_Malevolence_Ground")) or TestValid(Find_First_Object("Grievous_Malevolence")) or TestValid(Find_First_Object("Grievous_Team_Malevolence")) then
		event_act_2_01_task = plot.Get_Event("CIS_Grievous_Entry_Duro")
		event_act_2_01_task.Set_Event_Parameter(2, Find_Object_Type("Grievous_Team_Malevolence"))

		--event_act_2_02_task = plot.Get_Event("CIS_Grievous_Invading_Duro")
		--event_act_2_02_task.Set_Event_Parameter(2, Find_Object_Type("Grievous_Team_Malevolence"))

		event_act_2_03_task = plot.Get_Event("CIS_Grievous_Entry_Kuat")
		event_act_2_03_task.Set_Event_Parameter(2, Find_Object_Type("Grievous_Team_Malevolence"))

		event_act_2_04_task = plot.Get_Event("CIS_Grievous_Entry_HoloNet")
		event_act_2_04_task.Set_Event_Parameter(2, Find_Object_Type("Grievous_Team_Malevolence"))

		event_act_2_05_task = plot.Get_Event("CIS_Shipyard_Struggle_Tactical")
		event_act_2_05_task.Set_Event_Parameter(2, Find_Object_Type("Grievous_Team_Malevolence"))

		savety_check = 0
		grievous_dead = false
	else
		savety_check = savety_check + 1
	end
	Sleep(2.5)
	if savety_check > 2 then
		Story_Event("CIS_GRIEVOUS_DEAD")
		grievous_dead = true
	else
		Create_Thread("State_CIS_Grievous_Checker")
	end
end

function State_CIS_Duro_Defence_Tactical_Epilogue(message)
    if message == OnEnter then
		if p_cis.Is_Human() then
			plot = Get_Story_Plot("Conquests\\CloneWarsDurgesLance\\Story_Sandbox_DurgesLance_CIS.XML")

			Sleep(3.0)

			if TestValid(Find_First_Object("Grievous_Soulless_One_Ground")) or TestValid(Find_First_Object("Soulless_One")) or TestValid(Find_First_Object("Grievous_Team_Soulless_One")) then
				event_act_2_01_task = plot.Get_Event("CIS_Grievous_Entry_Duro")
				event_act_2_01_task.Set_Event_Parameter(2, Find_Object_Type("Grievous_Team_Soulless_One"))

				--event_act_2_02_task = plot.Get_Event("CIS_Grievous_Invading_Duro")
				--event_act_2_02_task.Set_Event_Parameter(2, Find_Object_Type("Grievous_Team_Soulless_One"))

				event_act_2_03_task = plot.Get_Event("CIS_Grievous_Entry_Kuat")
				event_act_2_03_task.Set_Event_Parameter(2, Find_Object_Type("Grievous_Team_Soulless_One"))

				event_act_2_04_task = plot.Get_Event("CIS_Grievous_Entry_HoloNet")
				event_act_2_04_task.Set_Event_Parameter(2, Find_Object_Type("Grievous_Team_Soulless_One"))

				event_act_2_05_task = plot.Get_Event("CIS_Shipyard_Struggle_Tactical")
				event_act_2_05_task.Set_Event_Parameter(2, Find_Object_Type("Grievous_Team_Soulless_One"))

				savety_check = 0
			elseif TestValid(Find_First_Object("General_Grievous")) or TestValid(Find_First_Object("Invisible_Hand")) or TestValid(Find_First_Object("Grievous_Team")) then
				event_act_2_01_task = plot.Get_Event("CIS_Grievous_Entry_Duro")
				event_act_2_01_task.Set_Event_Parameter(2, Find_Object_Type("Grievous_Team"))

				--event_act_2_02_task = plot.Get_Event("CIS_Grievous_Invading_Duro")
				--event_act_2_02_task.Set_Event_Parameter(2, Find_Object_Type("Grievous_Team"))

				event_act_2_03_task = plot.Get_Event("CIS_Grievous_Entry_Kuat")
				event_act_2_03_task.Set_Event_Parameter(2, Find_Object_Type("Grievous_Team"))

				event_act_2_04_task = plot.Get_Event("CIS_Grievous_Entry_HoloNet")
				event_act_2_04_task.Set_Event_Parameter(2, Find_Object_Type("Grievous_Team"))

				event_act_2_05_task = plot.Get_Event("CIS_Shipyard_Struggle_Tactical")
				event_act_2_05_task.Set_Event_Parameter(2, Find_Object_Type("Grievous_Team"))

				savety_check = 0
			elseif TestValid(Find_First_Object("Grievous_Recusant_Ground")) or TestValid(Find_First_Object("Grievous_Recusant")) or TestValid(Find_First_Object("Grievous_Team_Recusant")) then
				event_act_2_01_task = plot.Get_Event("CIS_Grievous_Entry_Duro")
				event_act_2_01_task.Set_Event_Parameter(2, Find_Object_Type("Grievous_Team_Recusant"))

				--event_act_2_02_task = plot.Get_Event("CIS_Grievous_Invading_Duro")
				--event_act_2_02_task.Set_Event_Parameter(2, Find_Object_Type("Grievous_Team_Recusant"))

				event_act_2_03_task = plot.Get_Event("CIS_Grievous_Entry_Kuat")
				event_act_2_03_task.Set_Event_Parameter(2, Find_Object_Type("Grievous_Team_Recusant"))

				event_act_2_04_task = plot.Get_Event("CIS_Grievous_Entry_HoloNet")
				event_act_2_04_task.Set_Event_Parameter(2, Find_Object_Type("Grievous_Team_Recusant"))

				event_act_2_05_task = plot.Get_Event("CIS_Shipyard_Struggle_Tactical")
				event_act_2_05_task.Set_Event_Parameter(2, Find_Object_Type("Grievous_Team_Recusant"))

				savety_check = 0
			elseif TestValid(Find_First_Object("Grievous_Munificent_Ground")) or TestValid(Find_First_Object("Grievous_Munificent")) or TestValid(Find_First_Object("Grievous_Team_Munificent")) then
				event_act_2_01_task = plot.Get_Event("CIS_Grievous_Entry_Duro")
				event_act_2_01_task.Set_Event_Parameter(2, Find_Object_Type("Grievous_Team_Munificent"))

				--event_act_2_02_task = plot.Get_Event("CIS_Grievous_Invading_Duro")
				--event_act_2_02_task.Set_Event_Parameter(2, Find_Object_Type("Grievous_Team_Munificent"))

				event_act_2_03_task = plot.Get_Event("CIS_Grievous_Entry_Kuat")
				event_act_2_03_task.Set_Event_Parameter(2, Find_Object_Type("Grievous_Team_Munificent"))

				event_act_2_04_task = plot.Get_Event("CIS_Grievous_Entry_HoloNet")
				event_act_2_04_task.Set_Event_Parameter(2, Find_Object_Type("Grievous_Team_Munificent"))

				event_act_2_05_task = plot.Get_Event("CIS_Shipyard_Struggle_Tactical")
				event_act_2_05_task.Set_Event_Parameter(2, Find_Object_Type("Grievous_Team_Munificent"))

				savety_check = 0
			elseif TestValid(Find_First_Object("Grievous_Malevolence_Ground")) or TestValid(Find_First_Object("Grievous_Malevolence")) or TestValid(Find_First_Object("Grievous_Team_Malevolence")) then
				event_act_2_01_task = plot.Get_Event("CIS_Grievous_Entry_Duro")
				event_act_2_01_task.Set_Event_Parameter(2, Find_Object_Type("Grievous_Team_Malevolence"))

				--event_act_2_02_task = plot.Get_Event("CIS_Grievous_Invading_Duro")
				--event_act_2_02_task.Set_Event_Parameter(2, Find_Object_Type("Grievous_Team_Malevolence"))

				event_act_2_03_task = plot.Get_Event("CIS_Grievous_Entry_Kuat")
				event_act_2_03_task.Set_Event_Parameter(2, Find_Object_Type("Grievous_Team_Malevolence"))

				event_act_2_04_task = plot.Get_Event("CIS_Grievous_Entry_HoloNet")
				event_act_2_04_task.Set_Event_Parameter(2, Find_Object_Type("Grievous_Team_Malevolence"))

				event_act_2_05_task = plot.Get_Event("CIS_Shipyard_Struggle_Tactical")
				event_act_2_05_task.Set_Event_Parameter(2, Find_Object_Type("Grievous_Team_Malevolence"))

				savety_check = 0
			else
				savety_check = savety_check + 1
			end
		end
	end
end

function State_CIS_Keggle_Checker(message)
    if message == OnEnter then
		if p_cis.Is_Human() then
			if (GlobalValue.Get("ODL_CIS_Jyvus_Joyride_Outcome") == 1) then
				Story_Event("CIS_DURO_DRAMA")
			end
		end
    end
end

function State_CIS_Duro_Drama_Tactical_Epilogue(message)
    if message == OnEnter then
		if p_cis.Is_Human() then
			plot = Get_Story_Plot("Conquests\\CloneWarsDurgesLance\\Story_Sandbox_DurgesLance_CIS.XML")

			Sleep(3.0)

			FindPlanet("Duro").Change_Owner(p_cis)

			if TestValid(Find_First_Object("Grievous_Soulless_One_Ground")) or TestValid(Find_First_Object("Soulless_One")) or TestValid(Find_First_Object("Grievous_Team_Soulless_One")) then
				event_act_2_01_task = plot.Get_Event("CIS_Grievous_Entry_Duro")
				event_act_2_01_task.Set_Event_Parameter(2, Find_Object_Type("Grievous_Team_Soulless_One"))

				--event_act_2_02_task = plot.Get_Event("CIS_Grievous_Invading_Duro")
				--event_act_2_02_task.Set_Event_Parameter(2, Find_Object_Type("Grievous_Team_Soulless_One"))

				event_act_2_03_task = plot.Get_Event("CIS_Grievous_Entry_Kuat")
				event_act_2_03_task.Set_Event_Parameter(2, Find_Object_Type("Grievous_Team_Soulless_One"))

				event_act_2_04_task = plot.Get_Event("CIS_Grievous_Entry_HoloNet")
				event_act_2_04_task.Set_Event_Parameter(2, Find_Object_Type("Grievous_Team_Soulless_One"))

				event_act_2_05_task = plot.Get_Event("CIS_Shipyard_Struggle_Tactical")
				event_act_2_05_task.Set_Event_Parameter(2, Find_Object_Type("Grievous_Team_Soulless_One"))

				savety_check = 0
			elseif TestValid(Find_First_Object("General_Grievous")) or TestValid(Find_First_Object("Invisible_Hand")) or TestValid(Find_First_Object("Grievous_Team")) then
				event_act_2_01_task = plot.Get_Event("CIS_Grievous_Entry_Duro")
				event_act_2_01_task.Set_Event_Parameter(2, Find_Object_Type("Grievous_Team"))

				--event_act_2_02_task = plot.Get_Event("CIS_Grievous_Invading_Duro")
				--event_act_2_02_task.Set_Event_Parameter(2, Find_Object_Type("Grievous_Team"))

				event_act_2_03_task = plot.Get_Event("CIS_Grievous_Entry_Kuat")
				event_act_2_03_task.Set_Event_Parameter(2, Find_Object_Type("Grievous_Team"))

				event_act_2_04_task = plot.Get_Event("CIS_Grievous_Entry_HoloNet")
				event_act_2_04_task.Set_Event_Parameter(2, Find_Object_Type("Grievous_Team"))

				event_act_2_05_task = plot.Get_Event("CIS_Shipyard_Struggle_Tactical")
				event_act_2_05_task.Set_Event_Parameter(2, Find_Object_Type("Grievous_Team"))

				savety_check = 0
			elseif TestValid(Find_First_Object("Grievous_Recusant_Ground")) or TestValid(Find_First_Object("Grievous_Recusant")) or TestValid(Find_First_Object("Grievous_Team_Recusant")) then
				event_act_2_01_task = plot.Get_Event("CIS_Grievous_Entry_Duro")
				event_act_2_01_task.Set_Event_Parameter(2, Find_Object_Type("Grievous_Team_Recusant"))

				--event_act_2_02_task = plot.Get_Event("CIS_Grievous_Invading_Duro")
				--event_act_2_02_task.Set_Event_Parameter(2, Find_Object_Type("Grievous_Team_Recusant"))

				event_act_2_03_task = plot.Get_Event("CIS_Grievous_Entry_Kuat")
				event_act_2_03_task.Set_Event_Parameter(2, Find_Object_Type("Grievous_Team_Recusant"))

				event_act_2_04_task = plot.Get_Event("CIS_Grievous_Entry_HoloNet")
				event_act_2_04_task.Set_Event_Parameter(2, Find_Object_Type("Grievous_Team_Recusant"))

				event_act_2_05_task = plot.Get_Event("CIS_Shipyard_Struggle_Tactical")
				event_act_2_05_task.Set_Event_Parameter(2, Find_Object_Type("Grievous_Team_Recusant"))

				savety_check = 0
			elseif TestValid(Find_First_Object("Grievous_Munificent_Ground")) or TestValid(Find_First_Object("Grievous_Munificent")) or TestValid(Find_First_Object("Grievous_Team_Munificent")) then
				event_act_2_01_task = plot.Get_Event("CIS_Grievous_Entry_Duro")
				event_act_2_01_task.Set_Event_Parameter(2, Find_Object_Type("Grievous_Team_Munificent"))

				--event_act_2_02_task = plot.Get_Event("CIS_Grievous_Invading_Duro")
				--event_act_2_02_task.Set_Event_Parameter(2, Find_Object_Type("Grievous_Team_Munificent"))

				event_act_2_03_task = plot.Get_Event("CIS_Grievous_Entry_Kuat")
				event_act_2_03_task.Set_Event_Parameter(2, Find_Object_Type("Grievous_Team_Munificent"))

				event_act_2_04_task = plot.Get_Event("CIS_Grievous_Entry_HoloNet")
				event_act_2_04_task.Set_Event_Parameter(2, Find_Object_Type("Grievous_Team_Munificent"))

				event_act_2_05_task = plot.Get_Event("CIS_Shipyard_Struggle_Tactical")
				event_act_2_05_task.Set_Event_Parameter(2, Find_Object_Type("Grievous_Team_Munificent"))

				savety_check = 0
			elseif TestValid(Find_First_Object("Grievous_Malevolence_Ground")) or TestValid(Find_First_Object("Grievous_Malevolence")) or TestValid(Find_First_Object("Grievous_Team_Malevolence")) then
				event_act_2_01_task = plot.Get_Event("CIS_Grievous_Entry_Duro")
				event_act_2_01_task.Set_Event_Parameter(2, Find_Object_Type("Grievous_Team_Malevolence"))

				--event_act_2_02_task = plot.Get_Event("CIS_Grievous_Invading_Duro")
				--event_act_2_02_task.Set_Event_Parameter(2, Find_Object_Type("Grievous_Team_Malevolence"))

				event_act_2_03_task = plot.Get_Event("CIS_Grievous_Entry_Kuat")
				event_act_2_03_task.Set_Event_Parameter(2, Find_Object_Type("Grievous_Team_Malevolence"))

				event_act_2_04_task = plot.Get_Event("CIS_Grievous_Entry_HoloNet")
				event_act_2_04_task.Set_Event_Parameter(2, Find_Object_Type("Grievous_Team_Malevolence"))

				event_act_2_05_task = plot.Get_Event("CIS_Shipyard_Struggle_Tactical")
				event_act_2_05_task.Set_Event_Parameter(2, Find_Object_Type("Grievous_Team_Malevolence"))

				savety_check = 0
			else
				savety_check = savety_check + 1
			end
		end
    end
end

function State_CIS_Duro_Bombing_Checker(message)
    if message == OnEnter then
		if p_cis.Is_Human() then
			if (GlobalValue.Get("ODL_CIS_Jyvus_Joyride_Outcome") == 0) then
				Story_Event("CIS_NEW_ALLY")
				keggle_list = {"Hoolidan_Keggle_Team"}
				KeggleSpawn = SpawnList(keggle_list, FindPlanet("Duro"), p_cis, true, false)
			end
			duro_chain_complete = true
			StoryUtil.SetPlanetRestricted("DURO", 0)
			plot = Get_Story_Plot("Conquests\\CloneWarsDurgesLance\\Story_Sandbox_DurgesLance_CIS.XML")

			Sleep(3.0)

			if TestValid(Find_First_Object("Grievous_Soulless_One_Ground")) or TestValid(Find_First_Object("Soulless_One")) or TestValid(Find_First_Object("Grievous_Team_Soulless_One")) then
				event_act_2_01_task = plot.Get_Event("CIS_Grievous_Entry_Duro")
				event_act_2_01_task.Set_Event_Parameter(2, Find_Object_Type("Grievous_Team_Soulless_One"))

				--event_act_2_02_task = plot.Get_Event("CIS_Grievous_Invading_Duro")
				--event_act_2_02_task.Set_Event_Parameter(2, Find_Object_Type("Grievous_Team_Soulless_One"))

				event_act_2_03_task = plot.Get_Event("CIS_Grievous_Entry_Kuat")
				event_act_2_03_task.Set_Event_Parameter(2, Find_Object_Type("Grievous_Team_Soulless_One"))

				event_act_2_04_task = plot.Get_Event("CIS_Grievous_Entry_HoloNet")
				event_act_2_04_task.Set_Event_Parameter(2, Find_Object_Type("Grievous_Team_Soulless_One"))

				event_act_2_05_task = plot.Get_Event("CIS_Shipyard_Struggle_Tactical")
				event_act_2_05_task.Set_Event_Parameter(2, Find_Object_Type("Grievous_Team_Soulless_One"))

				savety_check = 0
			elseif TestValid(Find_First_Object("General_Grievous")) or TestValid(Find_First_Object("Invisible_Hand")) or TestValid(Find_First_Object("Grievous_Team")) then
				event_act_2_01_task = plot.Get_Event("CIS_Grievous_Entry_Duro")
				event_act_2_01_task.Set_Event_Parameter(2, Find_Object_Type("Grievous_Team"))

				--event_act_2_02_task = plot.Get_Event("CIS_Grievous_Invading_Duro")
				--event_act_2_02_task.Set_Event_Parameter(2, Find_Object_Type("Grievous_Team"))

				event_act_2_03_task = plot.Get_Event("CIS_Grievous_Entry_Kuat")
				event_act_2_03_task.Set_Event_Parameter(2, Find_Object_Type("Grievous_Team"))

				event_act_2_04_task = plot.Get_Event("CIS_Grievous_Entry_HoloNet")
				event_act_2_04_task.Set_Event_Parameter(2, Find_Object_Type("Grievous_Team"))

				event_act_2_05_task = plot.Get_Event("CIS_Shipyard_Struggle_Tactical")
				event_act_2_05_task.Set_Event_Parameter(2, Find_Object_Type("Grievous_Team"))

				savety_check = 0
			elseif TestValid(Find_First_Object("Grievous_Recusant_Ground")) or TestValid(Find_First_Object("Grievous_Recusant")) or TestValid(Find_First_Object("Grievous_Team_Recusant")) then
				event_act_2_01_task = plot.Get_Event("CIS_Grievous_Entry_Duro")
				event_act_2_01_task.Set_Event_Parameter(2, Find_Object_Type("Grievous_Team_Recusant"))

				--event_act_2_02_task = plot.Get_Event("CIS_Grievous_Invading_Duro")
				--event_act_2_02_task.Set_Event_Parameter(2, Find_Object_Type("Grievous_Team_Recusant"))

				event_act_2_03_task = plot.Get_Event("CIS_Grievous_Entry_Kuat")
				event_act_2_03_task.Set_Event_Parameter(2, Find_Object_Type("Grievous_Team_Recusant"))

				event_act_2_04_task = plot.Get_Event("CIS_Grievous_Entry_HoloNet")
				event_act_2_04_task.Set_Event_Parameter(2, Find_Object_Type("Grievous_Team_Recusant"))

				event_act_2_05_task = plot.Get_Event("CIS_Shipyard_Struggle_Tactical")
				event_act_2_05_task.Set_Event_Parameter(2, Find_Object_Type("Grievous_Team_Recusant"))

				savety_check = 0
			elseif TestValid(Find_First_Object("Grievous_Munificent_Ground")) or TestValid(Find_First_Object("Grievous_Munificent")) or TestValid(Find_First_Object("Grievous_Team_Munificent")) then
				event_act_2_01_task = plot.Get_Event("CIS_Grievous_Entry_Duro")
				event_act_2_01_task.Set_Event_Parameter(2, Find_Object_Type("Grievous_Team_Munificent"))

				--event_act_2_02_task = plot.Get_Event("CIS_Grievous_Invading_Duro")
				--event_act_2_02_task.Set_Event_Parameter(2, Find_Object_Type("Grievous_Team_Munificent"))

				event_act_2_03_task = plot.Get_Event("CIS_Grievous_Entry_Kuat")
				event_act_2_03_task.Set_Event_Parameter(2, Find_Object_Type("Grievous_Team_Munificent"))

				event_act_2_04_task = plot.Get_Event("CIS_Grievous_Entry_HoloNet")
				event_act_2_04_task.Set_Event_Parameter(2, Find_Object_Type("Grievous_Team_Munificent"))

				event_act_2_05_task = plot.Get_Event("CIS_Shipyard_Struggle_Tactical")
				event_act_2_05_task.Set_Event_Parameter(2, Find_Object_Type("Grievous_Team_Munificent"))

				savety_check = 0
			elseif TestValid(Find_First_Object("Grievous_Malevolence_Ground")) or TestValid(Find_First_Object("Grievous_Malevolence")) or TestValid(Find_First_Object("Grievous_Team_Malevolence")) then
				event_act_2_01_task = plot.Get_Event("CIS_Grievous_Entry_Duro")
				event_act_2_01_task.Set_Event_Parameter(2, Find_Object_Type("Grievous_Team_Malevolence"))

				--event_act_2_02_task = plot.Get_Event("CIS_Grievous_Invading_Duro")
				--event_act_2_02_task.Set_Event_Parameter(2, Find_Object_Type("Grievous_Team_Malevolence"))

				event_act_2_03_task = plot.Get_Event("CIS_Grievous_Entry_Kuat")
				event_act_2_03_task.Set_Event_Parameter(2, Find_Object_Type("Grievous_Team_Malevolence"))

				event_act_2_04_task = plot.Get_Event("CIS_Grievous_Entry_HoloNet")
				event_act_2_04_task.Set_Event_Parameter(2, Find_Object_Type("Grievous_Team_Malevolence"))

				event_act_2_05_task = plot.Get_Event("CIS_Shipyard_Struggle_Tactical")
				event_act_2_05_task.Set_Event_Parameter(2, Find_Object_Type("Grievous_Team_Malevolence"))

				savety_check = 0
			else
				if (GlobalValue.Get("ODL_CIS_GC_Version") == 0) then
					local Safe_House_Planet = StoryUtil.GetSafePlanetTable()
					StoryUtil.SpawnAtSafePlanet("DURO", Find_Player("Rebel"), Safe_House_Planet, {"Grievous_Team"})
				elseif (GlobalValue.Get("ODL_CIS_GC_Version") == 1) then
					local Safe_House_Planet = StoryUtil.GetSafePlanetTable()
					StoryUtil.SpawnAtSafePlanet("DURO", Find_Player("Rebel"), Safe_House_Planet, {"Grievous_Team_Malevolence"})
				end
				savety_check = savety_check + 1
			end
		end
    end
end

function State_CIS_Mad_Clone_Checker(message)
    if message == OnEnter then
		if p_cis.Is_Human() then
			Story_Event("CIS_MAD_CLONE")
			mad_clone_list = {"Mad_Clone_Munificent"}
			FindPlanet("Kaikielius").Change_Owner(p_cis)
			MaddySpawn = SpawnList(mad_clone_list, FindPlanet("Kaikielius"), p_cis, true, false)
			plot = Get_Story_Plot("Conquests\\CloneWarsDurgesLance\\Story_Sandbox_DurgesLance_CIS.XML")

			Sleep(3.0)

			if TestValid(Find_First_Object("Grievous_Soulless_One_Ground")) or TestValid(Find_First_Object("Soulless_One")) or TestValid(Find_First_Object("Grievous_Team_Soulless_One")) then
				event_act_2_01_task = plot.Get_Event("CIS_Grievous_Entry_Duro")
				event_act_2_01_task.Set_Event_Parameter(2, Find_Object_Type("Grievous_Team_Soulless_One"))

				--event_act_2_02_task = plot.Get_Event("CIS_Grievous_Invading_Duro")
				--event_act_2_02_task.Set_Event_Parameter(2, Find_Object_Type("Grievous_Team_Soulless_One"))

				event_act_2_03_task = plot.Get_Event("CIS_Grievous_Entry_Kuat")
				event_act_2_03_task.Set_Event_Parameter(2, Find_Object_Type("Grievous_Team_Soulless_One"))

				event_act_2_04_task = plot.Get_Event("CIS_Grievous_Entry_HoloNet")
				event_act_2_04_task.Set_Event_Parameter(2, Find_Object_Type("Grievous_Team_Soulless_One"))

				event_act_2_05_task = plot.Get_Event("CIS_Shipyard_Struggle_Tactical")
				event_act_2_05_task.Set_Event_Parameter(2, Find_Object_Type("Grievous_Team_Soulless_One"))

				savety_check = 0
			elseif TestValid(Find_First_Object("General_Grievous")) or TestValid(Find_First_Object("Invisible_Hand")) or TestValid(Find_First_Object("Grievous_Team")) then
				event_act_2_01_task = plot.Get_Event("CIS_Grievous_Entry_Duro")
				event_act_2_01_task.Set_Event_Parameter(2, Find_Object_Type("Grievous_Team"))

				--event_act_2_02_task = plot.Get_Event("CIS_Grievous_Invading_Duro")
				--event_act_2_02_task.Set_Event_Parameter(2, Find_Object_Type("Grievous_Team"))

				event_act_2_03_task = plot.Get_Event("CIS_Grievous_Entry_Kuat")
				event_act_2_03_task.Set_Event_Parameter(2, Find_Object_Type("Grievous_Team"))

				event_act_2_04_task = plot.Get_Event("CIS_Grievous_Entry_HoloNet")
				event_act_2_04_task.Set_Event_Parameter(2, Find_Object_Type("Grievous_Team"))

				event_act_2_05_task = plot.Get_Event("CIS_Shipyard_Struggle_Tactical")
				event_act_2_05_task.Set_Event_Parameter(2, Find_Object_Type("Grievous_Team"))

				savety_check = 0
			elseif TestValid(Find_First_Object("Grievous_Recusant_Ground")) or TestValid(Find_First_Object("Grievous_Recusant")) or TestValid(Find_First_Object("Grievous_Team_Recusant")) then
				event_act_2_01_task = plot.Get_Event("CIS_Grievous_Entry_Duro")
				event_act_2_01_task.Set_Event_Parameter(2, Find_Object_Type("Grievous_Team_Recusant"))

				--event_act_2_02_task = plot.Get_Event("CIS_Grievous_Invading_Duro")
				--event_act_2_02_task.Set_Event_Parameter(2, Find_Object_Type("Grievous_Team_Recusant"))

				event_act_2_03_task = plot.Get_Event("CIS_Grievous_Entry_Kuat")
				event_act_2_03_task.Set_Event_Parameter(2, Find_Object_Type("Grievous_Team_Recusant"))

				event_act_2_04_task = plot.Get_Event("CIS_Grievous_Entry_HoloNet")
				event_act_2_04_task.Set_Event_Parameter(2, Find_Object_Type("Grievous_Team_Recusant"))

				event_act_2_05_task = plot.Get_Event("CIS_Shipyard_Struggle_Tactical")
				event_act_2_05_task.Set_Event_Parameter(2, Find_Object_Type("Grievous_Team_Recusant"))

				savety_check = 0
			elseif TestValid(Find_First_Object("Grievous_Munificent_Ground")) or TestValid(Find_First_Object("Grievous_Munificent")) or TestValid(Find_First_Object("Grievous_Team_Munificent")) then
				event_act_2_01_task = plot.Get_Event("CIS_Grievous_Entry_Duro")
				event_act_2_01_task.Set_Event_Parameter(2, Find_Object_Type("Grievous_Team_Munificent"))

				--event_act_2_02_task = plot.Get_Event("CIS_Grievous_Invading_Duro")
				--event_act_2_02_task.Set_Event_Parameter(2, Find_Object_Type("Grievous_Team_Munificent"))

				event_act_2_03_task = plot.Get_Event("CIS_Grievous_Entry_Kuat")
				event_act_2_03_task.Set_Event_Parameter(2, Find_Object_Type("Grievous_Team_Munificent"))

				event_act_2_04_task = plot.Get_Event("CIS_Grievous_Entry_HoloNet")
				event_act_2_04_task.Set_Event_Parameter(2, Find_Object_Type("Grievous_Team_Munificent"))

				event_act_2_05_task = plot.Get_Event("CIS_Shipyard_Struggle_Tactical")
				event_act_2_05_task.Set_Event_Parameter(2, Find_Object_Type("Grievous_Team_Munificent"))

				savety_check = 0
			elseif TestValid(Find_First_Object("Grievous_Malevolence_Ground")) or TestValid(Find_First_Object("Grievous_Malevolence")) or TestValid(Find_First_Object("Grievous_Team_Malevolence")) then
				event_act_2_01_task = plot.Get_Event("CIS_Grievous_Entry_Duro")
				event_act_2_01_task.Set_Event_Parameter(2, Find_Object_Type("Grievous_Team_Malevolence"))

				--event_act_2_02_task = plot.Get_Event("CIS_Grievous_Invading_Duro")
				--event_act_2_02_task.Set_Event_Parameter(2, Find_Object_Type("Grievous_Team_Malevolence"))

				event_act_2_03_task = plot.Get_Event("CIS_Grievous_Entry_Kuat")
				event_act_2_03_task.Set_Event_Parameter(2, Find_Object_Type("Grievous_Team_Malevolence"))

				event_act_2_04_task = plot.Get_Event("CIS_Grievous_Entry_HoloNet")
				event_act_2_04_task.Set_Event_Parameter(2, Find_Object_Type("Grievous_Team_Malevolence"))

				event_act_2_05_task = plot.Get_Event("CIS_Shipyard_Struggle_Tactical")
				event_act_2_05_task.Set_Event_Parameter(2, Find_Object_Type("Grievous_Team_Malevolence"))

				savety_check = 0
			else
				if (GlobalValue.Get("ODL_CIS_GC_Version") == 0) then
					local Safe_House_Planet = StoryUtil.GetSafePlanetTable()
					StoryUtil.SpawnAtSafePlanet("DURO", Find_Player("Rebel"), Safe_House_Planet, {"Grievous_Team"})
				elseif (GlobalValue.Get("ODL_CIS_GC_Version") == 1) then
					local Safe_House_Planet = StoryUtil.GetSafePlanetTable()
					StoryUtil.SpawnAtSafePlanet("DURO", Find_Player("Rebel"), Safe_House_Planet, {"Grievous_Team_Malevolence"})
				end
				savety_check = savety_check + 1
			end
		end
    end
end

function State_CIS_Kuat_Lockdown(message)
    if message == OnEnter then
		if p_cis.Is_Human() then
			StoryUtil.SetPlanetRestricted("KUAT", 1)
			kuat_lockdown_list = {
				"Generic_Star_Destroyer",
				"Generic_Tector",
				"Arquitens",
				"Arquitens",
				"Arquitens",
				"Arquitens",
				"Corellian_Corvette",
				"Corellian_Corvette",
				"Corellian_Corvette",
				"Corellian_Corvette",
				"Corellian_Corvette",
			}
			Kuat_LockdownSpawn = SpawnList(kuat_lockdown_list, FindPlanet("Kuat"), p_republic, true, true)
		end
    end
end

function State_CIS_Kuat_Conquest(message)
    if message == OnEnter then
		if p_cis.Is_Human() then
			kuat_reward_list = {"Storm_Fleet_Destroyer", "Storm_Fleet_Destroyer", "Storm_Fleet_Destroyer"}
			Kuat_LockdownSpawn = SpawnList(kuat_reward_list, FindPlanet("Kuat"), p_cis, true, true)
		end
    end
end

function State_CIS_GC_Progression_Research(message)
	if message == OnEnter then
		if TestValid(Find_First_Object("Grievous_Soulless_One_Ground")) or TestValid(Find_First_Object("Soulless_One")) or TestValid(Find_First_Object("Grievous_Team_Soulless_One")) then
			if FindPlanet("Kuat").Get_Owner() == p_cis then
				Story_Event("CIS_ORS_GC_PROGRESSION_ALT_02")
			end
			if FindPlanet("Kuat").Get_Owner() ~= p_cis then
				Story_Event("CIS_ORS_GC_PROGRESSION")
			end

			savety_check = 0
			grievous_dead = false
		elseif TestValid(Find_First_Object("General_Grievous")) or TestValid(Find_First_Object("Invisible_Hand")) or TestValid(Find_First_Object("Grievous_Team")) then
			if FindPlanet("Kuat").Get_Owner() == p_cis then
				Story_Event("CIS_ORS_GC_PROGRESSION_ALT_02")
			end
			if FindPlanet("Kuat").Get_Owner() ~= p_cis then
				Story_Event("CIS_ORS_GC_PROGRESSION")
			end

			savety_check = 0
			grievous_dead = false
		elseif TestValid(Find_First_Object("Grievous_Recusant_Ground")) or TestValid(Find_First_Object("Grievous_Recusant")) or TestValid(Find_First_Object("Grievous_Team_Recusant")) then
			if FindPlanet("Kuat").Get_Owner() == p_cis then
				Story_Event("CIS_ORS_GC_PROGRESSION_ALT_02")
			end
			if FindPlanet("Kuat").Get_Owner() ~= p_cis then
				Story_Event("CIS_ORS_GC_PROGRESSION")
			end

			savety_check = 0
			grievous_dead = false
		elseif TestValid(Find_First_Object("Grievous_Munificent_Ground")) or TestValid(Find_First_Object("Grievous_Munificent")) or TestValid(Find_First_Object("Grievous_Team_Munificent")) then
			if FindPlanet("Kuat").Get_Owner() == p_cis then
				Story_Event("CIS_ORS_GC_PROGRESSION_ALT_02")
			end
			if FindPlanet("Kuat").Get_Owner() ~= p_cis then
				Story_Event("CIS_ORS_GC_PROGRESSION")
			end

			savety_check = 0
			grievous_dead = false
		elseif TestValid(Find_First_Object("Grievous_Malevolence_Ground")) or TestValid(Find_First_Object("Grievous_Malevolence")) or TestValid(Find_First_Object("Grievous_Team_Malevolence")) then
			Story_Event("CIS_ORS_GC_PROGRESSION_ALT_01")

			savety_check = 0
			grievous_dead = false
		else
			grievous_dead = true
			Story_Event("CIS_FOEROST_GC_PROGRESSION")
		end
	end
end

-- Republic

function State_Rep_Story_Set_Up()
	if p_republic.Is_Human() then
		Story_Event("REP_STORY_START")

		gc_start = true

		target_planet_list = {
			FindPlanet("Fondor"),
			FindPlanet("YagDhul"),
			FindPlanet("Thyferra"),
			FindPlanet("Empress_Teta"),
			FindPlanet("Deko_Neimoidia"),
		}

		StoryUtil.SpawnAtSafePlanet("YAGDHUL", Find_Player("Rebel"), StoryUtil.GetSafePlanetTable(), {"Grievous_Team"})

		if (GlobalValue.Get("ODL_Rep_GC_Version") == 1) then
			StoryUtil.SpawnAtSafePlanet("CHARDAAN", Find_Player("Empire"), StoryUtil.GetSafePlanetTable(), {"Orn_Free_Taa_Team"})
		end

		if (GlobalValue.Get("CURRENT_CLONE_PHASE") == 2) then
			crossplot:publish("CLONE_UPGRADES", "empty")
			Find_Player("Empire").Unlock_Tech(Find_Object_Type("Clonetrooper_Phase_Two_Team"))
			Find_Player("Empire").Unlock_Tech(Find_Object_Type("Republic_BARC_Company"))
			Find_Player("Empire").Unlock_Tech(Find_Object_Type("ARC_Phase_Two_Team"))

			Find_Player("Empire").Lock_Tech(Find_Object_Type("Clonetrooper_Phase_One_Team"))
			Find_Player("Empire").Lock_Tech(Find_Object_Type("Republic_74Z_Bike_Company"))
			Find_Player("Empire").Lock_Tech(Find_Object_Type("ARC_Phase_One_Team"))
		end

		plot = Get_Story_Plot("Conquests\\CloneWarsDurgesLance\\Story_Sandbox_DurgesLance_Republic.XML")

		event_act_1 = plot.Get_Event("Rep_Durges_Lance_Act_I_Dialog")
		event_act_1.Set_Dialog("DIALOG_DURGES_LANCE_REP")
		event_act_1.Clear_Dialog_Text()
		for _,p_planet in pairs(target_planet_list) do
			if p_planet.Get_Owner() ~= p_republic then
				event_act_1.Add_Dialog_Text("TEXT_INTERVENTION_PLANET_CONQUEST_LOCATION", p_planet)
			elseif p_planet.Get_Owner() == p_republic then
				event_act_1.Add_Dialog_Text("TEXT_INTERVENTION_PLANET_CONQUEST_LOCATION_COMPLETE", p_planet)
			end
		end
		Create_Thread("State_Rep_Planet_Checker")

		event_act_2 = plot.Get_Event("Rep_Durges_Lance_Act_II_Dialog")
		event_act_2.Set_Dialog("DIALOG_DURGES_LANCE_REP")
		event_act_2.Clear_Dialog_Text()
		event_act_2.Add_Dialog_Text("TEXT_TOOLTIP_COMMAND_INVISIBLE_HAND")
		Create_Thread("State_Rep_Grievous_Log_Checker")
	end
end

function State_Rep_Planet_Checker()
	event_act_1 = plot.Get_Event("Rep_Durges_Lance_Act_I_Dialog")
	event_act_1.Set_Dialog("DIALOG_DURGES_LANCE_REP")
	event_act_1.Clear_Dialog_Text()
	for _,p_planet in pairs(target_planet_list) do
		if p_planet.Get_Owner() ~= p_republic then
			event_act_1.Add_Dialog_Text("TEXT_INTERVENTION_PLANET_CONQUEST_LOCATION", p_planet)
		elseif p_planet.Get_Owner() == p_republic then
			event_act_1.Add_Dialog_Text("TEXT_INTERVENTION_PLANET_CONQUEST_LOCATION_COMPLETE", p_planet)
		end
	end
	if FindPlanet("Fondor").Get_Owner() == p_republic and FindPlanet("YagDhul").Get_Owner() == p_republic and FindPlanet("Thyferra").Get_Owner() == p_republic and FindPlanet("Empress_Teta").Get_Owner() == p_republic and FindPlanet("Deko_Neimoidia").Get_Owner() == p_republic then
		target_planets_conquered = true
	end
	Sleep(5.0)
	if not target_planets_conquered then
		Create_Thread("State_Rep_Planet_Checker")
	else
		Story_Event("REP_TARGET_PLANETS_CONQUERED")
	end
end

function State_Rep_Grievous_Log_Checker()
	event_act_2 = plot.Get_Event("Rep_Durges_Lance_Act_II_Dialog")
	event_act_2.Set_Dialog("DIALOG_DURGES_LANCE_REP")
	event_act_2.Clear_Dialog_Text()
	if TestValid(Find_First_Object("General_Grievous")) or TestValid(Find_First_Object("Invisible_Hand")) or TestValid(Find_First_Object("Grievous_Team")) then
		event_act_2.Add_Dialog_Text("TEXT_TOOLTIP_COMMAND_INVISIBLE_HAND")

		savety_check = 0
	elseif TestValid(Find_First_Object("Grievous_Recusant_Ground")) or TestValid(Find_First_Object("Grievous_Recusant")) or TestValid(Find_First_Object("Grievous_Team_Recusant")) then
		event_act_2.Add_Dialog_Text("TEXT_TOOLTIP_COMMAND_RENITOR")

		savety_check = 0
	elseif TestValid(Find_First_Object("Grievous_Munificent_Ground")) or TestValid(Find_First_Object("Grievous_Munificent")) or TestValid(Find_First_Object("Grievous_Team_Munificent")) then
		event_act_2.Add_Dialog_Text("TEXT_TOOLTIP_COMMAND_MUNIFICENT")

		savety_check = 0
	else
		savety_check = savety_check + 1
	end
	Sleep(2.5)
	if savety_check > 2 then
		event_act_2.Add_Dialog_Text("TEXT_TOOLTIP_NONE")
		Story_Event("REP_GRIEVOUS_DEAD")
		grievous_dead = true
	else
		Create_Thread("State_Rep_Grievous_Log_Checker")
	end

end
