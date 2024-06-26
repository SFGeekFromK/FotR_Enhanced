
--*****************************************************--
--****** Outer Rim Sieges: Coruscant Chaos_I *******--
--*****************************************************--

require("PGStateMachine")
require("PGStoryMode")
require("PGSpawnUnits")
require("PGMoveUnits")
require("PGCommands")
require("TRCommands")
require("eawx-util/StoryUtil")
require("eawx-util/MissionFunctions")
require("deepcore/std/class")

function Definitions()
	DebugMessage("%s -- In Definitions", tostring(Script))

	StoryModeEvents =
	{
		Battle_Start = Begin_Battle,
	}

	p_cis = Find_Player("Rebel")
	p_republic = Find_Player("Empire")
	p_hostile = Find_Player("Hostile")
	p_neutral = Find_Player("Neutral")
	p_pdf = Find_Player("Sector_Forces")

	camera_offset = 125
	mission_started = false

	cinematic_crawl = false
	cinematic_one = false
	cinematic_two = false
	cinematic_three = false
	cinematic_four = false

	cinematic_crawl_skipped = false
	cinematic_one_skipped = false
	cinematic_two_skipped = false
	cinematic_three_skipped = false
	cinematic_four_skipped = false

	current_cinematic_thread_id = nil

	notice_range = 600

	convoy_list = {
		"SUPER_TRANSPORT_VI",
		"SUPER_TRANSPORT_VII",
		"SUPER_TRANSPORT_XI",
		"CLASS_C_SUPPORT",
		"CLASS_C_SUPPORT",
		"PELTA_SUPPORT",
		"GALLEON",
		"LAC",
		"LAC",
		"GOZANTI_CRUISER",
		"GOZANTI_CRUISER",
		"GOZANTI_CRUISER",
		"GOZANTI_CRUISER",
		"GOZANTI_CRUISER",
	}

	cis_fleet_list = {
		"LUPUS_MISSILE_FRIGATE",
		"LUCREHULK_CORE_DESTROYER",
		"MUNIFICENT",
		"MUNIFICENT",
		"RECUSANT",
		"RECUSANT",
		"RECUSANT_DREADNOUGHT",
		"MUNIFEX",
		"MUNIFEX",
		"AUXILIARY_LUCREHULK_CONTROL",
	}

end

function Begin_Battle(message)
	if message == OnEnter then
		introcam_1_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam-1")
		introcam_2_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam-2")
		introcam_3_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam-3")
		introcam_4_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam-4")
		introcam_5_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam-5")
		introcam_6_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam-6")
		introcam_7_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam-7")
		introcam_8_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam-8")
		introcam_9_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam-9")
		introcam_10_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam-10")
		introcam_11_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam-11")
		introcam_12_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam-12")
		introcam_13_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam-13")
		introcam_14_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam-14")
		introcam_15_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam-15")
		introcam_16_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam-16")
		introcam_17_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam-17")
		introcam_18_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam-18")
		introcam_19_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam-19")
		introcam_20_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam-20")
		introcam_21_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam-21")

		introcam_target_1_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam-target-1")
		introcam_target_2_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam-target-2")
		introcam_target_3_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam-target-3")
		introcam_target_4_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam-target-4")

		intro_dhc_1_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "intro-dhc-1")
		intro_dhc_2_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "intro-dhc-2")

		intro_grievous_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "intro-grievous")
		intro_cis_fleet_1_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "intro-cis-fleet-1")
		intro_cis_fleet_2_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "intro-cis-fleet-2")
		intro_cis_fleet_3_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "intro-cis-fleet-3")
		intro_cis_fleet_4_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "intro-cis-fleet-4")
		intro_cis_fleet_5_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "intro-cis-fleet-5")
		intro_cis_fleet_6_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "intro-cis-fleet-6")
		intro_cis_fleet_7_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "intro-cis-fleet-7")

		player_munificent	= Find_First_Object("MUNIFICENT")
		player_recusant = Find_First_Object("RECUSANT")
		player_recusant_d = Find_First_Object("RECUSANT_DREADNOUGHT")
		player_providence_d = Find_First_Object("PROVIDENCE_DREADNOUGHT")
		player_lucrehulk = Find_First_Object("GENERIC_LUCREHULK_CONTROL")
		player_core_d = Find_First_Object("LUCREHULK_CORE_DESTROYER")
		player_supplier = Find_First_Object("SUPPLY_SHIP")

		player_dhc = Find_First_Object("DREADNAUGHT_CARRIER")
		player_dhc.Change_Owner(p_republic)

		p_republic.Make_Ally(p_cis)
		p_cis.Make_Ally(p_republic)

		cis_list = Find_All_Objects_Of_Type(p_cis)
		for j,cis_stuff in pairs(cis_list) do
			if TestValid(cis_stuff) then
				Hide_Object(cis_stuff, 1)
			end
		end

		if p_cis.Is_Human() then
			mission_started = true
			current_cinematic_thread_id = Create_Thread("Start_Cinematic_Crawl_CIS")
		elseif p_republic.Is_Human() then
			mission_started = true
			current_cinematic_thread_id = Create_Thread("Start_Cinematic_Crawl_Rep")
		end
	end
end


function Story_Handle_Esc()
	if mission_started then
		if p_cis.Is_Human() then
			if cinematic_crawl then
				if not cinematic_crawl_skipped then
					cinematic_crawl_skipped = true
					-- MessageBox("Escape Key Pressed!!!")

					if current_cinematic_thread_id ~= nil then
						Thread.Kill(current_cinematic_thread_id)
						current_cinematic_thread_id = nil
					end

					Stop_All_Music()
					Stop_All_Speech()
					Remove_All_Text()
					Stop_Bink_Movie()

					cinematic_crawl = false
					current_cinematic_thread_id = Create_Thread("Start_Cinematic_Intro_CIS")
				end
			end
			if cinematic_one then
				if not cinematic_one_skipped then
					cinematic_one_skipped = true
					-- MessageBox("Escape Key Pressed!!!")
					if current_cinematic_thread_id ~= nil then
						Thread.Kill(current_cinematic_thread_id)
						current_cinematic_thread_id = nil
					end

					StoryUtil.CinematicEnvironmentOff()
					StoryUtil.AIActivation()
					StoryUtil.DeclareVictory(p_cis, false)
				end
			end
		elseif p_republic.Is_Human() then
			if cinematic_crawl then
				if not cinematic_crawl_skipped then
					cinematic_crawl_skipped = true
					-- MessageBox("Escape Key Pressed!!!")

					if current_cinematic_thread_id ~= nil then
						Thread.Kill(current_cinematic_thread_id)
						current_cinematic_thread_id = nil
					end

					Stop_All_Music()
					Stop_All_Speech()
					Remove_All_Text()
					Stop_Bink_Movie()

					cinematic_crawl = false
					current_cinematic_thread_id = Create_Thread("Start_Cinematic_Intro_Rep")
				end
			end
			if cinematic_one then
				if not cinematic_one_skipped then
					cinematic_one_skipped = true
					-- MessageBox("Escape Key Pressed!!!")
					if current_cinematic_thread_id ~= nil then
						Thread.Kill(current_cinematic_thread_id)
						current_cinematic_thread_id = nil
					end

					StoryUtil.CinematicEnvironmentOff()
					StoryUtil.AIActivation()
					StoryUtil.DeclareVictory(p_republic, false)
				end
			end
		end
	end
end

function Story_Mode_Service()
	if p_cis.Is_Human() then
	elseif p_republic.Is_Human() then
	end
end


function Start_Cinematic_Crawl_CIS()
	StoryUtil.StartCinematicCamera()
	StoryUtil.CinematicEnvironmentOn()

	StoryUtil.SetCinematicCamera(introcam_1_marker, introcam_target_1_marker, true)

	cinematic_crawl = true
	StoryUtil.PlayCinematicMovieCrawl("Durges_Lance_Campaign_Intro", "Clone_Wars_Crawl_Theme")

	if not cinematic_crawl_skipped then
		current_cinematic_thread_id = Create_Thread("Start_Cinematic_Intro_CIS")
	end
end

function Start_Cinematic_Intro_CIS()
	cinematic_crawl = false

	if (GlobalValue.Get("ODL_CIS_GC_Version") == 0) then
		Find_First_Object("GRIEVOUS_MALEVOLENCE_HUNT_CAMPAIGN").Despawn()
		player_grievous = Find_First_Object("INVISIBLE_HAND")
	else
		Find_First_Object("INVISIBLE_HAND").Despawn()
		player_grievous = Find_First_Object("GRIEVOUS_MALEVOLENCE_HUNT_CAMPAIGN")
	end

	cinematic_one = true

	Transition_Cinematic_Camera_Key(introcam_2_marker, 8.0, 0, 0, 0, 1, 0, 0, 0)
	Transition_Cinematic_Target_Key(introcam_2_marker, 8.0, 0, 0, 0, 0, introcam_target_2_marker, 1, 0)

	Letter_Box_In(1.0)
	Play_Music("ESB_The_Ice_Planet_Hoth")
	Sleep(1.5)

	Story_Event("CINEMATIC_INTRO_01")

	player_dhc.Teleport_And_Face(intro_dhc_1_marker)
	player_dhc.Cinematic_Hyperspace_In(65)
	Sleep(3.0)

	Story_Event("CINEMATIC_INTRO_02")
	Sleep(7.5)

	Fade_Screen_In(0.01)
	Story_Event("RENDEZVOUS_01")

	Set_Cinematic_Camera_Key(introcam_4_marker, 0, 0, 0, 1, 0, 0, 0)
	Set_Cinematic_Target_Key(introcam_4_marker, 0, 0, 0, 0, player_dhc, 1, 0)
	Transition_Cinematic_Camera_Key(introcam_5_marker, 14.0, 0, 0, 0, 1, 0, 0, 0)
	Transition_Cinematic_Target_Key(introcam_5_marker, 14.0, 0, 0, 0, 0, player_dhc, 1, 0)
	Sleep(3.0)

	player_dhc.Move_To(intro_dhc_2_marker)
	Sleep(6.5)

	player_dhc.Move_To(intro_dhc_2_marker)
	Set_Cinematic_Camera_Key(introcam_6_marker, 0, 0, 0, 1, 0, 0, 0)
	Set_Cinematic_Target_Key(introcam_6_marker, 0, 0, 0, 0, introcam_target_3_marker, 1, 0)
	Transition_Cinematic_Camera_Key(introcam_7_marker, 10.0, 0, 0, 0, 1, 0, 0, 0)
	Transition_Cinematic_Target_Key(introcam_7_marker, 10.0, 0, 0, 0, 0, introcam_target_3_marker, 1, 0)
	Story_Event("RENDEZVOUS_02")
	Sleep(8.5)

	player_dhc.Move_To(intro_dhc_2_marker)
	Set_Cinematic_Camera_Key(introcam_8_marker, 0, 0, 0, 1, 0, 0, 0)
	Set_Cinematic_Target_Key(introcam_8_marker, 0, 0, 0, 0, player_dhc, 1, 0)
	Transition_Cinematic_Camera_Key(introcam_9_marker, 19.0, 0, 0, 0, 1, 0, 0, 0)
	Transition_Cinematic_Target_Key(introcam_9_marker, 19.0, 0, 0, 0, 0, player_dhc, 1, 0)
	Story_Event("RENDEZVOUS_03")
	Sleep(6.0)

	Story_Event("RENDEZVOUS_04")
	Sleep(9.5)

	Set_Cinematic_Camera_Key(introcam_11_marker, 0, 0, 0, 1, 0, 0, 0)
	Set_Cinematic_Target_Key(introcam_11_marker, 0, 0, 0, 0, introcam_target_3_marker, 1, 0)
	Transition_Cinematic_Camera_Key(introcam_13_marker, 19.0, 0, 0, 0, 1, 0, 0, 0)
	Transition_Cinematic_Target_Key(introcam_13_marker, 19.0, 0, 0, 0, 0, introcam_target_3_marker, 1, 0)
	Story_Event("RENDEZVOUS_05")
	Sleep(3.5)

	Story_Event("RENDEZVOUS_06")
	Sleep(10.4)

	Play_Music("Luminara_Theme")
	Set_Cinematic_Camera_Key(introcam_13_marker, 0, 0, 0, 1, 0, 0, 0)
	Set_Cinematic_Target_Key(introcam_13_marker, 0, 0, 0, 0, player_dhc, 1, 0)
	Transition_Cinematic_Camera_Key(introcam_12_marker, 8.5, 0, 0, 0, 1, 0, 0, 0)
	Transition_Cinematic_Target_Key(introcam_12_marker, 8.5, 0, 0, 0, 0, player_dhc, 1, 0)
	Story_Event("RENDEZVOUS_07")
	Sleep(8.5)

	Set_Cinematic_Camera_Key(introcam_14_marker, 0, 0, 0, 1, 0, 0, 0)
	Set_Cinematic_Target_Key(introcam_14_marker, 0, 0, 0, 0, introcam_target_3_marker, 1, 0)
	Transition_Cinematic_Camera_Key(introcam_15_marker, 8.0, 0, 0, 0, 1, 0, 0, 0)
	Transition_Cinematic_Target_Key(introcam_15_marker, 8.0, 0, 0, 0, 0, introcam_target_3_marker, 1, 0)
	Story_Event("RENDEZVOUS_08")
	Sleep(5.5)

	cis_list = Find_All_Objects_Of_Type(p_cis)
	for j,cis_stuff in pairs(cis_list) do
		if TestValid(cis_stuff) then
			Hide_Object(cis_stuff, 0)
		end
	end

	p_republic.Make_Enemy(p_cis)
	p_cis.Make_Enemy(p_republic)

	Set_Cinematic_Camera_Key(introcam_16_marker, 0, 0, 0, 1, 0, 0, 0)
	Set_Cinematic_Target_Key(introcam_16_marker, 0, 0, 0, 0, introcam_target_3_marker, 1, 0)
	Transition_Cinematic_Camera_Key(introcam_17_marker, 8.5, 0, 0, 0, 1, 0, 0, 0)
	Transition_Cinematic_Target_Key(introcam_17_marker, 8.5, 0, 0, 0, 0, introcam_target_4_marker, 1, 0)
	Story_Event("RENDEZVOUS_09")
	Sleep(4.0)

	player_grievous.Teleport_And_Face(intro_grievous_marker)
	player_grievous.Cinematic_Hyperspace_In(50)

	player_munificent.Teleport_And_Face(intro_cis_fleet_1_marker)
	player_munificent.Cinematic_Hyperspace_In(100)

	player_recusant.Teleport_And_Face(intro_cis_fleet_2_marker)
	player_recusant.Cinematic_Hyperspace_In(50)

	player_recusant_d.Teleport_And_Face(intro_cis_fleet_3_marker)
	player_recusant_d.Cinematic_Hyperspace_In(100)

	player_providence_d.Teleport_And_Face(intro_cis_fleet_4_marker)
	player_providence_d.Cinematic_Hyperspace_In(150)

	player_lucrehulk.Teleport_And_Face(intro_cis_fleet_5_marker)
	player_lucrehulk.Cinematic_Hyperspace_In(100)

	player_core_d.Teleport_And_Face(intro_cis_fleet_6_marker)
	player_core_d.Cinematic_Hyperspace_In(150)

	player_supplier.Teleport_And_Face(intro_cis_fleet_7_marker)
	player_supplier.Cinematic_Hyperspace_In(100)

	Play_Music("Grievous_Theme")
	Sleep(4.5)

	Set_Cinematic_Camera_Key(introcam_18_marker, 0, 0, 0, 1, 0, 0, 0)
	Set_Cinematic_Target_Key(introcam_18_marker, 0, 0, 0, 0, introcam_target_4_marker, 1, 0)
	Transition_Cinematic_Camera_Key(introcam_19_marker, 17, 0, 0, 0, 1, 0, 0, 0)
	Transition_Cinematic_Target_Key(introcam_19_marker, 17, 0, 0, 0, 0, introcam_target_4_marker, 1, 0)
	Story_Event("RENDEZVOUS_10")
	Sleep(9.0)

	Story_Event("RENDEZVOUS_11")
	Sleep(7.8)

	Set_Cinematic_Camera_Key(introcam_20_marker, 0, 0, 0, 1, 0, 0, 0)
	Set_Cinematic_Target_Key(introcam_20_marker, 0, 0, 0, 0, player_grievous, 1, 0)
	Transition_Cinematic_Camera_Key(introcam_21_marker, 23.0, 0, 0, 0, 1, 0, 0, 0)
	Transition_Cinematic_Target_Key(introcam_21_marker, 23.0, 0, 0, 0, 0, player_grievous, 1, 0)
	Story_Event("RENDEZVOUS_12")
	Sleep(4.0)

	Story_Event("RENDEZVOUS_13")
	Sleep(7.5)

	Fade_Screen_Out(8.0)

	StoryUtil.CinematicEnvironmentOff()
	StoryUtil.AIActivation()
	StoryUtil.DeclareVictory(p_cis, false)
end


function Start_Cinematic_Crawl_Rep()
	StoryUtil.StartCinematicCamera()
	StoryUtil.CinematicEnvironmentOn()

	StoryUtil.SetCinematicCamera(introcam_1_marker, introcam_target_1_marker, true)

	cinematic_crawl = true
	StoryUtil.PlayCinematicMovieCrawl("Durges_Lance_Campaign_Intro", "Clone_Wars_Crawl_Theme")

	if not cinematic_crawl_skipped then
		current_cinematic_thread_id = Create_Thread("Start_Cinematic_Intro_Rep")
	end
end

function Start_Cinematic_Intro_Rep()
	cinematic_crawl = false

	Find_First_Object("GRIEVOUS_MALEVOLENCE_HUNT_CAMPAIGN").Despawn()
	player_grievous = Find_First_Object("INVISIBLE_HAND")

	cinematic_one = true

	Transition_Cinematic_Camera_Key(introcam_2_marker, 8.0, 0, 0, 0, 1, 0, 0, 0)
	Transition_Cinematic_Target_Key(introcam_2_marker, 8.0, 0, 0, 0, 0, introcam_target_2_marker, 1, 0)

	Letter_Box_In(1.0)
	Play_Music("ESB_The_Ice_Planet_Hoth")
	Sleep(1.5)

	Story_Event("CINEMATIC_INTRO_01")

	player_dhc.Teleport_And_Face(intro_dhc_1_marker)
	player_dhc.Cinematic_Hyperspace_In(65)
	Sleep(3.0)

	Story_Event("CINEMATIC_INTRO_02")
	Sleep(7.5)

	Fade_Screen_In(0.01)
	Story_Event("RENDEZVOUS_01")

	Set_Cinematic_Camera_Key(introcam_4_marker, 0, 0, 0, 1, 0, 0, 0)
	Set_Cinematic_Target_Key(introcam_4_marker, 0, 0, 0, 0, player_dhc, 1, 0)
	Transition_Cinematic_Camera_Key(introcam_5_marker, 14.0, 0, 0, 0, 1, 0, 0, 0)
	Transition_Cinematic_Target_Key(introcam_5_marker, 14.0, 0, 0, 0, 0, player_dhc, 1, 0)
	Sleep(3.0)

	player_dhc.Move_To(intro_dhc_2_marker)
	Sleep(6.5)

	player_dhc.Move_To(intro_dhc_2_marker)
	Set_Cinematic_Camera_Key(introcam_6_marker, 0, 0, 0, 1, 0, 0, 0)
	Set_Cinematic_Target_Key(introcam_6_marker, 0, 0, 0, 0, introcam_target_3_marker, 1, 0)
	Transition_Cinematic_Camera_Key(introcam_7_marker, 10.0, 0, 0, 0, 1, 0, 0, 0)
	Transition_Cinematic_Target_Key(introcam_7_marker, 10.0, 0, 0, 0, 0, introcam_target_3_marker, 1, 0)
	Story_Event("RENDEZVOUS_02")
	Sleep(8.5)

	player_dhc.Move_To(intro_dhc_2_marker)
	Set_Cinematic_Camera_Key(introcam_8_marker, 0, 0, 0, 1, 0, 0, 0)
	Set_Cinematic_Target_Key(introcam_8_marker, 0, 0, 0, 0, player_dhc, 1, 0)
	Transition_Cinematic_Camera_Key(introcam_9_marker, 19.0, 0, 0, 0, 1, 0, 0, 0)
	Transition_Cinematic_Target_Key(introcam_9_marker, 19.0, 0, 0, 0, 0, player_dhc, 1, 0)
	Story_Event("RENDEZVOUS_03")
	Sleep(6.0)

	Story_Event("RENDEZVOUS_04")
	Sleep(9.5)

	Set_Cinematic_Camera_Key(introcam_11_marker, 0, 0, 0, 1, 0, 0, 0)
	Set_Cinematic_Target_Key(introcam_11_marker, 0, 0, 0, 0, introcam_target_3_marker, 1, 0)
	Transition_Cinematic_Camera_Key(introcam_13_marker, 19.0, 0, 0, 0, 1, 0, 0, 0)
	Transition_Cinematic_Target_Key(introcam_13_marker, 19.0, 0, 0, 0, 0, introcam_target_3_marker, 1, 0)
	Story_Event("RENDEZVOUS_05")
	Sleep(3.5)

	Story_Event("RENDEZVOUS_06")
	Sleep(10.4)

	Play_Music("Luminara_Theme")
	Set_Cinematic_Camera_Key(introcam_13_marker, 0, 0, 0, 1, 0, 0, 0)
	Set_Cinematic_Target_Key(introcam_13_marker, 0, 0, 0, 0, player_dhc, 1, 0)
	Transition_Cinematic_Camera_Key(introcam_12_marker, 8.5, 0, 0, 0, 1, 0, 0, 0)
	Transition_Cinematic_Target_Key(introcam_12_marker, 8.5, 0, 0, 0, 0, player_dhc, 1, 0)
	Story_Event("RENDEZVOUS_07")
	Sleep(8.5)

	Set_Cinematic_Camera_Key(introcam_14_marker, 0, 0, 0, 1, 0, 0, 0)
	Set_Cinematic_Target_Key(introcam_14_marker, 0, 0, 0, 0, introcam_target_3_marker, 1, 0)
	Transition_Cinematic_Camera_Key(introcam_15_marker, 8.0, 0, 0, 0, 1, 0, 0, 0)
	Transition_Cinematic_Target_Key(introcam_15_marker, 8.0, 0, 0, 0, 0, introcam_target_3_marker, 1, 0)
	Story_Event("RENDEZVOUS_08")
	Sleep(5.5)

	cis_list = Find_All_Objects_Of_Type(p_cis)
	for j,cis_stuff in pairs(cis_list) do
		if TestValid(cis_stuff) then
			Hide_Object(cis_stuff, 0)
		end
	end

	p_republic.Make_Enemy(p_cis)
	p_cis.Make_Enemy(p_republic)

	Set_Cinematic_Camera_Key(introcam_16_marker, 0, 0, 0, 1, 0, 0, 0)
	Set_Cinematic_Target_Key(introcam_16_marker, 0, 0, 0, 0, introcam_target_3_marker, 1, 0)
	Transition_Cinematic_Camera_Key(introcam_17_marker, 8.5, 0, 0, 0, 1, 0, 0, 0)
	Transition_Cinematic_Target_Key(introcam_17_marker, 8.5, 0, 0, 0, 0, introcam_target_4_marker, 1, 0)
	Story_Event("RENDEZVOUS_09")
	Sleep(4.0)

	player_grievous.Teleport_And_Face(intro_grievous_marker)
	player_grievous.Cinematic_Hyperspace_In(50)

	player_munificent.Teleport_And_Face(intro_cis_fleet_1_marker)
	player_munificent.Cinematic_Hyperspace_In(100)

	player_recusant.Teleport_And_Face(intro_cis_fleet_2_marker)
	player_recusant.Cinematic_Hyperspace_In(50)

	player_recusant_d.Teleport_And_Face(intro_cis_fleet_3_marker)
	player_recusant_d.Cinematic_Hyperspace_In(100)

	player_providence_d.Teleport_And_Face(intro_cis_fleet_4_marker)
	player_providence_d.Cinematic_Hyperspace_In(150)

	player_lucrehulk.Teleport_And_Face(intro_cis_fleet_5_marker)
	player_lucrehulk.Cinematic_Hyperspace_In(100)

	player_core_d.Teleport_And_Face(intro_cis_fleet_6_marker)
	player_core_d.Cinematic_Hyperspace_In(150)

	player_supplier.Teleport_And_Face(intro_cis_fleet_7_marker)
	player_supplier.Cinematic_Hyperspace_In(100)

	Play_Music("Grievous_Theme")
	Sleep(4.5)

	Set_Cinematic_Camera_Key(introcam_18_marker, 0, 0, 0, 1, 0, 0, 0)
	Set_Cinematic_Target_Key(introcam_18_marker, 0, 0, 0, 0, introcam_target_4_marker, 1, 0)
	Transition_Cinematic_Camera_Key(introcam_19_marker, 17, 0, 0, 0, 1, 0, 0, 0)
	Transition_Cinematic_Target_Key(introcam_19_marker, 17, 0, 0, 0, 0, introcam_target_4_marker, 1, 0)
	Story_Event("RENDEZVOUS_10")
	Sleep(9.0)

	Story_Event("RENDEZVOUS_11")
	Sleep(7.8)

	Set_Cinematic_Camera_Key(introcam_20_marker, 0, 0, 0, 1, 0, 0, 0)
	Set_Cinematic_Target_Key(introcam_20_marker, 0, 0, 0, 0, player_grievous, 1, 0)
	Transition_Cinematic_Camera_Key(introcam_21_marker, 23.0, 0, 0, 0, 1, 0, 0, 0)
	Transition_Cinematic_Target_Key(introcam_21_marker, 23.0, 0, 0, 0, 0, player_grievous, 1, 0)
	Story_Event("RENDEZVOUS_12")
	Sleep(4.0)

	Story_Event("RENDEZVOUS_13")
	Sleep(7.5)

	Fade_Screen_Out(8.0)

	StoryUtil.CinematicEnvironmentOff()
	StoryUtil.AIActivation()
	StoryUtil.DeclareVictory(p_republic, false)
end