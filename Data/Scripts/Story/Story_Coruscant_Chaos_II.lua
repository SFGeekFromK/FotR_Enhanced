
--*****************************************************--
--******** Outer Rim Sieges: Coruscant Chaos II ********--
--*****************************************************--

require("PGStateMachine")
require("PGStoryMode")
require("PGSpawnUnits")
require("PGMoveUnits")
require("eawx-util/StoryUtil")
require("eawx-util/MissionFunctions")

function Definitions()
	DebugMessage("%s -- In Definitions", tostring(Script))

	StoryModeEvents =
	{
		Battle_Start = Begin_Battle,
	}

	republic_defender_list = {
		"Generic_Victory_Fleet_Destroyer",
		"Generic_Victory_Fleet_Destroyer",
		"Dreadnaught_Lasers",
		"Dreadnaught_Lasers",
		"Dreadnaught_Lasers",
		"Customs_Corvette",
		"Customs_Corvette",
	}

	screed_easy_list = {
		"Screed_Arlionne",
		"Generic_Victory_Fleet_Destroyer",
		"Generic_Victory_Fleet_Destroyer",
		"Generic_Gladiator",
		"Dreadnaught_Lasers",
		"Dreadnaught_Lasers",
		"Dreadnaught_Lasers",
		"Customs_Corvette",
		"Customs_Corvette",
		"Customs_Corvette",
	}

	screed_medium_list = {
		"Screed_Arlionne",
		"Generic_Victory_Fleet_Destroyer",
		"Generic_Victory_Fleet_Destroyer",
		"Generic_Victory_Fleet_Destroyer",
		"Generic_Victory_Fleet_Destroyer",
		"Generic_Gladiator",
		"Generic_Gladiator",
		"Dreadnaught_Lasers",
		"Dreadnaught_Lasers",
		"Dreadnaught_Lasers",
		"Customs_Corvette",
		"Customs_Corvette",
		"Customs_Corvette",
		"Customs_Corvette",
	}

	screed_hard_list = {
		"Screed_Arlionne",
		"Generic_Victory_Fleet_Destroyer",
		"Generic_Victory_Fleet_Destroyer",
		"Generic_Victory_Fleet_Destroyer",
		"Generic_Victory_Fleet_Destroyer",
		"Generic_Victory_Fleet_Destroyer",
		"Generic_Gladiator",
		"Generic_Gladiator",
		"Generic_Gladiator",
		"Generic_Gladiator",
		"Dreadnaught_Lasers",
		"Dreadnaught_Lasers",
		"Customs_Corvette",
		"Customs_Corvette",
		"Customs_Corvette",
		"Customs_Corvette",
	}

	bulwark_easy_list = {
		"Bulwark_I",
	}

	bulwark_medium_list = {
		"Bulwark_I",
		"Bulwark_I",
	}

	bulwark_hard_list = {
		"Bulwark_I",
		"Bulwark_I",
		"Bulwark_I",
	}

	screed_player_list = {
		"Screed_Arlionne",
		"Customs_Corvette",
		"Customs_Corvette",
		"Customs_Corvette",
		"Customs_Corvette",
		"Generic_Gladiator",
		"Generic_Gladiator",
		"Generic_Victory_Fleet_Destroyer",
		"Generic_Victory_Fleet_Destroyer",
		"Generic_Victory_Fleet_Destroyer",
		"Generic_Victory_Fleet_Destroyer",
	}

	p_cis = Find_Player("Rebel")
	p_republic = Find_Player("Empire")
	p_invaders = Find_Player("Hostile")

	act_1_active = false

	cinematic_one = false

	cinematic_one_skipped = false

	current_cinematic_thread_id = nil

	screed_arrived = false
	avenger_fleet_arrived = false

	dodonna_dead = false
	screed_dead = false
	ningo_dead = false

	republic_victory = false
	cis_victory = false
end

function Begin_Battle(message)
	if message == OnEnter then
		attacker_marker = Find_First_Object("Attacker Entry Position")

		rep_fleet_01_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "rep-fleet-1")
		rep_fleet_02_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "rep-fleet-2")
		rep_fleet_03_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "rep-fleet-3")
		rep_fleet_04_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "rep-fleet-4")
		rep_fleet_05_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "rep-fleet-5")

		rep_defender_01_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "intro-rep-defender")

		introcam_1_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam-1")
		introcam_2_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam-2")
		introcam_3_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam-3")
		introcam_4_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam-4")
		introcam_5_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam-5")
		introcam_6_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam-6")
		introcam_7_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam-7")
		introcam_8_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam-8")
		introcam_9_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam-9")

		introcam_target_1_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam-target-1")
		introcam_target_2_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam-target-2")
		introcam_target_3_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam-target-3")

		intro_1_ningo_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "intro-1-ningo")
		intro_2_ningo_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "intro-2-ningo")

		intro_1_dodonna_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "intro-1-dodonna")
		intro_2_dodonna_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "intro-2-dodonna")

		intro_1_vsd_1_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "intro-1-vsd-1")
		intro_1_vsd_2_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "intro-1-vsd-2")

		intro_2_vsd_1_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "intro-2-vsd-1")
		intro_2_vsd_2_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "intro-2-vsd-2")

		intro_1_cc_1_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "intro-1-cc-1")
		intro_1_cc_2_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "intro-1-cc-2")

		intro_2_cc_1_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "intro-2-cc-1")
		intro_2_cc_2_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "intro-2-cc-2")

		intro_1_bw_1_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "intro-1-bw-1")
		intro_2_bw_1_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "intro-2-bw-1")

		intro_1_bw_2_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "intro-1-bw-2")
		intro_2_bw_2_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "intro-2-bw-2")

		intro_1_bw_3_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "intro-1-bw-3")
		intro_2_bw_3_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "intro-2-bw-3")

		intro_1_bw_4_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "intro-1-bw-4")
		intro_2_bw_4_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "intro-2-bw-4")

		if p_cis.Is_Human() then
			current_cinematic_thread_id = Create_Thread("Start_Cinematic_Intro_CIS")
		elseif p_republic.Is_Human() then
			current_cinematic_thread_id = Create_Thread("Start_Cinematic_Intro_Rep")
		end
	end
end


function State_Avenger_Fleet_Arrives()
	if p_cis.Is_Human() then
		if not avenger_fleet_arrived then
			avenger_fleet_arrived = true

			local entry_gamble = GameRandom.Free_Random(1, 5)
			if entry_gamble == 1 then
				rep_fleet_01_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "rep-fleet-1")
			elseif entry_gamble == 2 then
				rep_fleet_01_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "rep-fleet-2")
			elseif entry_gamble == 3 then
				rep_fleet_01_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "rep-fleet-3")
			elseif entry_gamble == 4 then
				rep_fleet_01_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "rep-fleet-4")
			elseif entry_gamble == 5 then
				rep_fleet_01_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "rep-fleet-5")
			end

			if p_republic.Get_Difficulty()== "Easy" then
				AI_Republic_Fleet = SpawnList(screed_easy_list, rep_fleet_01_marker.Get_Position(), p_republic, true, true)
				Republic_AI_Fleet = AI_Republic_Fleet[1]
				Republic_AI_Fleet.Teleport_And_Face(rep_fleet_01_marker)
				Republic_AI_Fleet.Cinematic_Hyperspace_In(150)
			elseif p_republic.Get_Difficulty()== "Hard" then
				AI_Republic_Fleet = SpawnList(screed_hard_list, rep_fleet_01_marker.Get_Position(), p_republic, true, true)
				Republic_AI_Fleet = AI_Republic_Fleet[1]
				Republic_AI_Fleet.Teleport_And_Face(rep_fleet_01_marker)
				Republic_AI_Fleet.Cinematic_Hyperspace_In(150)
			else
				AI_Republic_Fleet = SpawnList(screed_medium_list, rep_fleet_01_marker.Get_Position(), p_republic, true, true)
				Republic_AI_Fleet = AI_Republic_Fleet[1]
				Republic_AI_Fleet.Teleport_And_Face(rep_fleet_01_marker)
				Republic_AI_Fleet.Cinematic_Hyperspace_In(150)
			end
			Story_Event("SHOWDOWN_08")
		end
	elseif p_republic.Is_Human() then
		Story_Event("SHOWDOWN_09")

		local entry_gamble = GameRandom.Free_Random(1, 3)
		if entry_gamble == 1 then
			rep_fleet_01_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "rep-fleet-1")
		elseif entry_gamble == 2 then
			rep_fleet_01_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "rep-fleet-2")
		elseif entry_gamble == 3 then
			rep_fleet_01_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "rep-fleet-3")
		elseif entry_gamble == 4 then
			rep_fleet_01_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "rep-fleet-4")
		elseif entry_gamble == 5 then
			rep_fleet_01_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "rep-fleet-5")
		end

		Republic_Fleet = SpawnList(screed_player_list, rep_fleet_01_marker.Get_Position(), p_republic, true, true)
		Republic_Fleet = Republic_Fleet[1]
		Republic_Fleet.Teleport_And_Face(rep_fleet_01_marker)
		Republic_Fleet.Cinematic_Hyperspace_In(100)
	end
end


function Story_Handle_Esc()
	if p_cis.Is_Human() then
		if cinematic_one then
			if not cinematic_one_skipped then
				cinematic_one_skipped = true
				-- MessageBox("Escape Key Pressed!!!")

				if current_cinematic_thread_id ~= nil then
					Thread.Kill(current_cinematic_thread_id)
					current_cinematic_thread_id = nil
				end

				Fade_Screen_Out(0)
				Stop_All_Music()
				Stop_All_Speech()
				Remove_All_Text()
				Stop_Bink_Movie()

				StoryUtil.CinematicEnvironmentOff()

				p_republic.Make_Enemy(p_cis)
				p_cis.Make_Enemy(p_republic)

				if not TestValid(player_dodonna) then
					player_dodonna = Spawn_Unit(Find_Object_Type("DODONNA_ARDENT"), intro_1_dodonna_marker, p_republic)
					player_dodonna = Find_Nearest(intro_1_dodonna_marker, p_republic, true)
					player_dodonna.Teleport_And_Face(intro_1_dodonna_marker)	

					player_cc_1 = Spawn_Unit(Find_Object_Type("CUSTOMS_CORVETTE"), intro_1_cc_1_marker, p_republic)
					player_cc_1 = Find_Nearest(intro_1_cc_1_marker, p_republic, true)
					player_cc_1.Teleport_And_Face(intro_1_cc_1_marker)

					player_cc_2 = Spawn_Unit(Find_Object_Type("CUSTOMS_CORVETTE"), intro_1_cc_2_marker, p_republic)
					player_cc_2 = Find_Nearest(intro_1_cc_2_marker, p_republic, true)
					player_cc_2.Teleport_And_Face(intro_1_cc_2_marker)

					player_vsd_1 = Spawn_Unit(Find_Object_Type("Generic_Victory_Fleet_Destroyer"), intro_1_vsd_1_marker, p_republic)
					player_vsd_1 = Find_Nearest(intro_1_vsd_1_marker, p_republic, true)
					player_vsd_1.Teleport_And_Face(intro_1_vsd_1_marker)

					player_vsd_2 = Spawn_Unit(Find_Object_Type("Generic_Victory_Fleet_Destroyer"), intro_1_vsd_2_marker, p_republic)
					player_vsd_2 = Find_Nearest(intro_1_vsd_2_marker, p_republic, true)
					player_vsd_2.Teleport_And_Face(intro_1_vsd_2_marker)
				end

				AI_Republic_Fleet = SpawnList(republic_defender_list, rep_defender_01_marker.Get_Position(), p_republic, true, true)
				Republic_AI_Fleet = AI_Republic_Fleet[1]
				Republic_AI_Fleet.Teleport_And_Face(rep_defender_01_marker)

				Register_Timer(State_Avenger_Fleet_Arrives, 60)

				Point_Camera_At(intro_1_ningo_marker)
				Letter_Box_Out(0)
				Lock_Controls(0)
				Suspend_AI(0)
				End_Cinematic_Camera()

				StoryUtil.AIActivation()
				Story_Event("GOAL_TRIGGER_CIS_I")

				cinematic_one = false
				act_1_active = true

				Fade_Screen_In(0.5)
				Sleep(0.5)
			end
		end
	elseif p_republic.Is_Human() then
		if cinematic_one then
			if not cinematic_one_skipped then
				cinematic_one_skipped = true
				-- MessageBox("Escape Key Pressed!!!")

				if current_cinematic_thread_id ~= nil then
					Thread.Kill(current_cinematic_thread_id)
					current_cinematic_thread_id = nil
				end

				Fade_Screen_Out(0)
				Stop_All_Music()
				Stop_All_Speech()
				Remove_All_Text()
				Stop_Bink_Movie()

				StoryUtil.CinematicEnvironmentOff()

				if not TestValid(Find_First_Object("DODONNA_ARDENT")) then
					player_dodonna = Spawn_Unit(Find_Object_Type("DODONNA_ARDENT"), intro_1_dodonna_marker, p_republic)
					player_dodonna = Find_Nearest(intro_1_dodonna_marker, p_republic, true)
					player_dodonna.Teleport_And_Face(intro_1_dodonna_marker)	
					player_dodonna.Cinematic_Hyperspace_In(100)

					player_vsd_1 = Spawn_Unit(Find_Object_Type("Generic_Victory_Fleet_Destroyer"), intro_1_vsd_1_marker, p_republic)
					player_vsd_1 = Find_Nearest(intro_1_vsd_1_marker, p_republic, true)
					player_vsd_1.Teleport_And_Face(intro_1_vsd_1_marker)	
					player_vsd_1.Cinematic_Hyperspace_In(75)

					player_vsd_2 = Spawn_Unit(Find_Object_Type("Generic_Victory_Fleet_Destroyer"), intro_1_vsd_2_marker, p_republic)
					player_vsd_2 = Find_Nearest(intro_1_vsd_2_marker, p_republic, true)
					player_vsd_2.Teleport_And_Face(intro_1_vsd_2_marker)	
					player_vsd_2.Cinematic_Hyperspace_In(125)

					player_cc_1 = Spawn_Unit(Find_Object_Type("CUSTOMS_CORVETTE"), intro_1_cc_1_marker, p_republic)
					player_cc_1 = Find_Nearest(intro_1_cc_1_marker, p_republic, true)
					player_cc_1.Teleport_And_Face(intro_1_cc_1_marker)	
					player_cc_1.Cinematic_Hyperspace_In(150)

					player_cc_2 = Spawn_Unit(Find_Object_Type("CUSTOMS_CORVETTE"), intro_1_cc_2_marker, p_republic)
					player_cc_2 = Find_Nearest(intro_1_cc_2_marker, p_republic, true)
					player_cc_2.Teleport_And_Face(intro_1_cc_2_marker)	
					player_cc_2.Cinematic_Hyperspace_In(50)

					player_glad_1 = Spawn_Unit(Find_Object_Type("GENERIC_GLADIATOR"), intro_1_cc_1_marker, p_republic)
					player_glad_1 = Find_Nearest(intro_1_cc_1_marker, p_republic, true)
					player_glad_1.Teleport_And_Face(intro_1_cc_1_marker)	
					player_glad_1.Cinematic_Hyperspace_In(150)

					player_glad_2 = Spawn_Unit(Find_Object_Type("GENERIC_GLADIATOR"), intro_1_cc_2_marker, p_republic)
					player_glad_2 = Find_Nearest(intro_1_cc_2_marker, p_republic, true)
					player_glad_2.Teleport_And_Face(intro_1_cc_2_marker)	
					player_glad_2.Cinematic_Hyperspace_In(50)
				end

				if not TestValid(Find_First_Object("DUA_NINGO_UNREPENTANT")) then
					player_ningo = Spawn_Unit(Find_Object_Type("DUA_NINGO_UNREPENTANT"), intro_1_ningo_marker, p_cis)
					player_ningo = Find_Nearest(intro_1_ningo_marker, p_cis, true)
					player_ningo.Teleport_And_Face(intro_1_ningo_marker)	

					player_bw_1 = Spawn_Unit(Find_Object_Type("BULWARK_I"), intro_1_bw_1_marker, p_cis)
					player_bw_1 = Find_Nearest(intro_1_bw_1_marker, p_cis, true)
					player_bw_1.Teleport_And_Face(intro_1_bw_1_marker)	

					player_bw_2 = Spawn_Unit(Find_Object_Type("BULWARK_I"), intro_1_bw_2_marker, p_cis)
					player_bw_2 = Find_Nearest(intro_1_bw_2_marker, p_cis, true)
					player_bw_2.Teleport_And_Face(intro_1_bw_2_marker)	

					player_bw_3 = Spawn_Unit(Find_Object_Type("BULWARK_I"), intro_1_bw_3_marker, p_cis)
					player_bw_3 = Find_Nearest(intro_1_bw_3_marker, p_cis, true)
					player_bw_3.Teleport_And_Face(intro_1_bw_3_marker)	

					player_bw_4 = Spawn_Unit(Find_Object_Type("BULWARK_I"), intro_1_bw_4_marker, p_cis)
					player_bw_4 = Find_Nearest(intro_1_bw_4_marker, p_cis, true)
					player_bw_4.Teleport_And_Face(intro_1_bw_4_marker)	
				end

				if p_cis.Get_Difficulty()== "Easy" then
					AI_CIS_Fleet = SpawnList(bulwark_easy_list, attacker_marker.Get_Position(), p_cis, true, true)
					CIS_AI_Fleet = AI_CIS_Fleet[1]
					CIS_AI_Fleet.Teleport_And_Face(attacker_marker)
					CIS_AI_Fleet.Cinematic_Hyperspace_In(150)
				elseif p_cis.Get_Difficulty()== "Hard" then
					AI_CIS_Fleet = SpawnList(bulwark_hard_list, attacker_marker.Get_Position(), p_cis, true, true)
					CIS_AI_Fleet = AI_CIS_Fleet[1]
					CIS_AI_Fleet.Teleport_And_Face(attacker_marker)
					CIS_AI_Fleet.Cinematic_Hyperspace_In(150)
				else
					AI_CIS_Fleet = SpawnList(bulwark_medium_list, attacker_marker.Get_Position(), p_cis, true, true)
					CIS_AI_Fleet = AI_CIS_Fleet[1]
					CIS_AI_Fleet.Teleport_And_Face(attacker_marker)
					CIS_AI_Fleet.Cinematic_Hyperspace_In(150)
				end

				Register_Timer(State_Avenger_Fleet_Arrives, 30)

				p_republic.Make_Enemy(p_cis)
				p_cis.Make_Enemy(p_republic)

				Point_Camera_At(intro_1_dodonna_marker)
				Letter_Box_Out(0)
				Lock_Controls(0)
				Suspend_AI(0)
				End_Cinematic_Camera()

				StoryUtil.AIActivation()

				Story_Event("GOAL_TRIGGER_REP_I")

				cinematic_one = false
				act_1_active = true

				Fade_Screen_In(0.5)
				Sleep(0.5)
			end
		end
	end
end

function Story_Mode_Service()
	if p_cis.Is_Human() then
		if act_1_active then
		end
	elseif p_republic.Is_Human() then
		if act_1_active then
		end
	end
end


function Start_Cinematic_Intro_CIS()
	Start_Cinematic_Camera()
	Stop_All_Music()
	Suspend_AI(1)
	Lock_Controls(1)
	Cancel_Fast_Forward()

	Fade_On()
	Sleep(0.5)

	if not TestValid(player_ningo) then
		Ningo_Spawning = Find_First_Object("DUA_NINGO_UNREPENTANT")
		if not TestValid(Ningo_Spawning) then
			Ningo_Spawning = Spawn_From_Reinforcement_Pool(Find_Object_Type("DUA_NINGO_UNREPENTANT"), intro_1_ningo_marker, p_cis)
			if Ningo_Spawning then
				Ningo_Spawning = Ningo_Spawning[1]
			end
		end
	end
	player_ningo = Find_First_Object("DUA_NINGO_UNREPENTANT")

	cinematic_one = true

	Letter_Box_In(3)
	Fade_Screen_In(5)
	Play_Music("TPM_The_Droid_Invasion_Theme")

	Set_Cinematic_Camera_Key(introcam_1_marker, 0, 0, 0, 1, 0, 0, 0)
	Set_Cinematic_Target_Key(introcam_1_marker, 0, 0, 0, 0, introcam_target_1_marker, 1, 0)
	Transition_Cinematic_Camera_Key(introcam_2_marker, 12.5, 0, 0, 0, 1, 0, 0, 0)
	Transition_Cinematic_Target_Key(introcam_2_marker, 12.5, 0, 0, 0, 0, introcam_target_2_marker, 1, 0)
	Story_Event("CINEMATIC_CRAWL_01")
	Sleep(3.0)

	Story_Event("CINEMATIC_CRAWL_02")
	Sleep(8.0)

	player_dodonna = Spawn_Unit(Find_Object_Type("DODONNA_ARDENT"), intro_1_dodonna_marker, p_republic)
	player_dodonna = Find_Nearest(intro_1_dodonna_marker, p_republic, true)
	player_dodonna.Teleport_And_Face(intro_1_dodonna_marker)	
	player_dodonna.Cinematic_Hyperspace_In(100)

	player_cc_1 = Spawn_Unit(Find_Object_Type("CUSTOMS_CORVETTE"), intro_1_cc_1_marker, p_republic)
	player_cc_1 = Find_Nearest(intro_1_cc_1_marker, p_republic, true)
	player_cc_1.Teleport_And_Face(intro_1_cc_1_marker)	
	player_cc_1.Cinematic_Hyperspace_In(150)

	player_cc_2 = Spawn_Unit(Find_Object_Type("CUSTOMS_CORVETTE"), intro_1_cc_2_marker, p_republic)
	player_cc_2 = Find_Nearest(intro_1_cc_2_marker, p_republic, true)
	player_cc_2.Teleport_And_Face(intro_1_cc_2_marker)	
	player_cc_2.Cinematic_Hyperspace_In(50)

	player_vsd_1 = Spawn_Unit(Find_Object_Type("Generic_Victory_Fleet_Destroyer"), intro_1_vsd_1_marker, p_republic)
	player_vsd_1 = Find_Nearest(intro_1_vsd_1_marker, p_republic, true)
	player_vsd_1.Teleport_And_Face(intro_1_vsd_1_marker)	
	player_vsd_1.Cinematic_Hyperspace_In(75)

	player_vsd_2 = Spawn_Unit(Find_Object_Type("Generic_Victory_Fleet_Destroyer"), intro_1_vsd_2_marker, p_republic)
	player_vsd_2 = Find_Nearest(intro_1_vsd_2_marker, p_republic, true)
	player_vsd_2.Teleport_And_Face(intro_1_vsd_2_marker)	
	player_vsd_2.Cinematic_Hyperspace_In(125)

	Story_Event("SHOWDOWN_01")
	Story_Event("SHOWDOWN_02")
	Sleep(5.0)

	Fade_Screen_Out(2)
	Sleep(3.0)

	player_dodonna.Move_To(intro_2_dodonna_marker)
	player_cc_1.Move_To(intro_2_cc_1_marker)
	player_cc_2.Move_To(intro_2_cc_2_marker)
	player_vsd_1.Move_To(intro_2_vsd_1_marker)
	player_vsd_2.Move_To(intro_2_cc_2_marker)

	Set_Cinematic_Camera_Key(introcam_3_marker, 0, 0, 0, 1, 0, 0, 0)
	Set_Cinematic_Target_Key(introcam_3_marker, 0, 0, 0, 0, introcam_target_2_marker, 1, 0)
	Transition_Cinematic_Camera_Key(introcam_4_marker, 13, 0, 0, 0, 1, 0, 0, 0)
	Transition_Cinematic_Target_Key(introcam_4_marker, 13, 0, 0, 0, 0, player_dodonna, 1, 0)
	Sleep(3.0)

	Story_Event("SHOWDOWN_03")
	Fade_Screen_In(2)
	Sleep(9.0)

	BW_1_Spawning = Find_First_Object("BULWARK_I")
	if not TestValid(BW_1_Spawning) then
		BW_1_Spawning = Spawn_From_Reinforcement_Pool(Find_Object_Type("BULWARK_I"), intro_1_ningo_marker, p_cis)
		if BW_1_Spawning then
			BW_1_Spawning = BW_1_Spawning[1]
			player_bw_1 = Spawn_Unit(Find_Object_Type("BULWARK_I"), intro_1_bw_1_marker, p_cis)
			player_bw_1 = Find_Nearest(intro_1_bw_1_marker, p_cis, true)
			player_bw_1.Teleport_And_Face(intro_1_bw_1_marker)	
			player_bw_1.Cinematic_Hyperspace_In(150)
		end
	end

	BW_2_Spawning = Find_First_Object("BULWARK_I")
	if not TestValid(BW_2_Spawning) then
		BW_2_Spawning = Spawn_From_Reinforcement_Pool(Find_Object_Type("BULWARK_I"), intro_2_ningo_marker, p_cis)
		if BW_2_Spawning then
			BW_2_Spawning = BW_2_Spawning[1]
			player_bw_2 = Spawn_Unit(Find_Object_Type("BULWARK_I"), intro_1_bw_2_marker, p_cis)
			player_bw_2 = Find_Nearest(intro_1_bw_2_marker, p_cis, true)
			player_bw_2.Teleport_And_Face(intro_1_bw_2_marker)	
			player_bw_2.Cinematic_Hyperspace_In(150)
		end
	end

	Play_Music("Grievous_Theme")
	Transition_Cinematic_Camera_Key(introcam_4_marker, 5, 0, 0, 0, 1, 0, 0, 0)
	Transition_Cinematic_Target_Key(introcam_4_marker, 5, 0, 0, 0, 0, introcam_target_3_marker, 1, 0)
	Story_Event("SHOWDOWN_04")
	Sleep(5.5)

	Transition_Cinematic_Camera_Key(introcam_6_marker, 20, 0, 0, 0, 1, 0, 0, 0)
	Transition_Cinematic_Target_Key(introcam_6_marker, 20, 0, 0, 0, 0, player_ningo, 1, 0)
	Story_Event("SHOWDOWN_05")
	Sleep(5.5)

	Story_Event("SHOWDOWN_06")

	if TestValid(player_ningo) then
		player_ningo.Move_To(intro_2_ningo_marker)
	end
	if TestValid(player_bw_1) then
		player_bw_1.Move_To(intro_2_bw_1_marker)
	end
	if TestValid(player_bw_2) then
	player_bw_2.Move_To(intro_2_bw_2_marker)
	end
	Sleep(8.5)

	Set_Cinematic_Camera_Key(introcam_7_marker, 0, 0, 0, 1, 0, 0, 0)
	Set_Cinematic_Target_Key(introcam_7_marker, 0, 0, 0, 0, player_ningo, 1, 0)
	Transition_Cinematic_Camera_Key(introcam_8_marker, 30.0, 0, 0, 0, 1, 0, 0, 0)
	Transition_Cinematic_Target_Key(introcam_8_marker, 30.0, 0, 0, 0, 0, player_ningo, 1, 0)
	Story_Event("SHOWDOWN_07")
	Sleep(5.0)

	if not cinematic_one_skipped then
		current_cinematic_thread_id = Create_Thread("End_Cinematic_Intro_CIS")
	end
end

function End_Cinematic_Intro_CIS()
	AI_Republic_Fleet = SpawnList(republic_defender_list, rep_defender_01_marker.Get_Position(), p_republic, true, true)
	Republic_AI_Fleet = AI_Republic_Fleet[1]
	Republic_AI_Fleet.Teleport_And_Face(rep_defender_01_marker)

	Point_Camera_At(player_ningo)
	Transition_To_Tactical_Camera(3)
	Letter_Box_Out(3)
	Sleep(3.0)
	End_Cinematic_Camera()
	Lock_Controls(0)
	Suspend_AI(0)

	p_cis.Make_Enemy(p_republic)
	p_republic.Make_Enemy(p_cis)

	Story_Event("GOAL_TRIGGER_CIS_I")
	StoryUtil.AIActivation()

	cinematic_one = false
	act_1_active = true

	Register_Timer(State_Avenger_Fleet_Arrives, 60)

	StoryUtil.CinematicEnvironmentOff()
end


function Start_Cinematic_Intro_Rep()
	Start_Cinematic_Camera()
	Stop_All_Music()
	Suspend_AI(1)
	Lock_Controls(1)
	Cancel_Fast_Forward()

	Fade_On()
	Sleep(0.5)

	cinematic_one = true

	Letter_Box_In(3)
	Fade_Screen_In(5)
	Play_Music("TPM_The_Droid_Invasion_Theme")

	Set_Cinematic_Camera_Key(introcam_1_marker, 0, 0, 0, 1, 0, 0, 0)
	Set_Cinematic_Target_Key(introcam_1_marker, 0, 0, 0, 0, introcam_target_1_marker, 1, 0)
	Transition_Cinematic_Camera_Key(introcam_2_marker, 10.5, 0, 0, 0, 1, 0, 0, 0)
	Transition_Cinematic_Target_Key(introcam_2_marker, 10.5, 0, 0, 0, 0, introcam_target_2_marker, 1, 0)
	Story_Event("CINEMATIC_CRAWL_01")
	Sleep(3.0)

	Story_Event("CINEMATIC_CRAWL_02")
	Sleep(5.5)

	player_dodonna = Spawn_Unit(Find_Object_Type("DODONNA_ARDENT"), intro_1_dodonna_marker, p_republic)
	player_dodonna = Find_Nearest(intro_1_dodonna_marker, p_republic, true)
	player_dodonna.Teleport_And_Face(intro_1_dodonna_marker)	
	player_dodonna.Cinematic_Hyperspace_In(100)

	player_vsd_1 = Spawn_Unit(Find_Object_Type("Generic_Victory_Fleet_Destroyer"), intro_1_vsd_1_marker, p_republic)
	player_vsd_1 = Find_Nearest(intro_1_vsd_1_marker, p_republic, true)
	player_vsd_1.Teleport_And_Face(intro_1_vsd_1_marker)	
	player_vsd_1.Cinematic_Hyperspace_In(75)

	player_vsd_2 = Spawn_Unit(Find_Object_Type("Generic_Victory_Fleet_Destroyer"), intro_1_vsd_2_marker, p_republic)
	player_vsd_2 = Find_Nearest(intro_1_vsd_2_marker, p_republic, true)
	player_vsd_2.Teleport_And_Face(intro_1_vsd_2_marker)	
	player_vsd_2.Cinematic_Hyperspace_In(125)

	player_cc_1 = Spawn_Unit(Find_Object_Type("CUSTOMS_CORVETTE"), intro_1_cc_1_marker, p_republic)
	player_cc_1 = Find_Nearest(intro_1_cc_1_marker, p_republic, true)
	player_cc_1.Teleport_And_Face(intro_1_cc_1_marker)	
	player_cc_1.Cinematic_Hyperspace_In(150)

	player_cc_2 = Spawn_Unit(Find_Object_Type("CUSTOMS_CORVETTE"), intro_1_cc_2_marker, p_republic)
	player_cc_2 = Find_Nearest(intro_1_cc_2_marker, p_republic, true)
	player_cc_2.Teleport_And_Face(intro_1_cc_2_marker)	
	player_cc_2.Cinematic_Hyperspace_In(50)

	player_glad_1 = Spawn_Unit(Find_Object_Type("GENERIC_GLADIATOR"), intro_1_cc_1_marker, p_republic)
	player_glad_1 = Find_Nearest(intro_1_cc_1_marker, p_republic, true)
	player_glad_1.Teleport_And_Face(intro_1_cc_1_marker)	
	player_glad_1.Cinematic_Hyperspace_In(150)

	player_glad_2 = Spawn_Unit(Find_Object_Type("GENERIC_GLADIATOR"), intro_1_cc_2_marker, p_republic)
	player_glad_2 = Find_Nearest(intro_1_cc_2_marker, p_republic, true)
	player_glad_2.Teleport_And_Face(intro_1_cc_2_marker)	
	player_glad_2.Cinematic_Hyperspace_In(50)

	Sleep(2.5)

	Story_Event("SHOWDOWN_01")
	Story_Event("SHOWDOWN_02")
	Sleep(1.5)
	Fade_Screen_Out(2.0)
	Sleep(2.0)

	player_dodonna.Move_To(intro_2_dodonna_marker)
	player_cc_1.Move_To(intro_2_cc_1_marker)
	player_cc_2.Move_To(intro_2_cc_2_marker)
	player_vsd_1.Move_To(intro_2_vsd_1_marker)
	player_vsd_2.Move_To(intro_2_cc_2_marker)
	Sleep(3.5)

	Set_Cinematic_Camera_Key(introcam_3_marker, 0, 0, 0, 1, 0, 0, 0)
	Set_Cinematic_Target_Key(introcam_3_marker, 0, 0, 0, 0, introcam_target_2_marker, 1, 0)
	Transition_Cinematic_Camera_Key(introcam_4_marker, 9, 0, 0, 0, 1, 0, 0, 0)
	Transition_Cinematic_Target_Key(introcam_4_marker, 9, 0, 0, 0, 0, player_dodonna, 1, 0)
	Story_Event("SHOWDOWN_03")
	Fade_Screen_In(2)
	Sleep(9.0)

	player_ningo = Spawn_Unit(Find_Object_Type("DUA_NINGO_UNREPENTANT"), intro_1_ningo_marker, p_cis)
	player_ningo = Find_Nearest(intro_1_ningo_marker, p_cis, true)
	player_ningo.Teleport_And_Face(intro_1_ningo_marker)	
	player_ningo.Cinematic_Hyperspace_In(100)

	player_bw_1 = Spawn_Unit(Find_Object_Type("BULWARK_I"), intro_1_bw_1_marker, p_cis)
	player_bw_1 = Find_Nearest(intro_1_bw_1_marker, p_cis, true)
	player_bw_1.Teleport_And_Face(intro_1_bw_1_marker)	
	player_bw_1.Cinematic_Hyperspace_In(100)

	player_bw_2 = Spawn_Unit(Find_Object_Type("BULWARK_I"), intro_1_bw_2_marker, p_cis)
	player_bw_2 = Find_Nearest(intro_1_bw_2_marker, p_cis, true)
	player_bw_2.Teleport_And_Face(intro_1_bw_2_marker)	
	player_bw_2.Cinematic_Hyperspace_In(100)

	player_bw_3 = Spawn_Unit(Find_Object_Type("BULWARK_I"), intro_1_bw_3_marker, p_cis)
	player_bw_3 = Find_Nearest(intro_1_bw_3_marker, p_cis, true)
	player_bw_3.Teleport_And_Face(intro_1_bw_3_marker)	
	player_bw_3.Cinematic_Hyperspace_In(100)

	player_bw_4 = Spawn_Unit(Find_Object_Type("BULWARK_I"), intro_1_bw_4_marker, p_cis)
	player_bw_4 = Find_Nearest(intro_1_bw_4_marker, p_cis, true)
	player_bw_4.Teleport_And_Face(intro_1_bw_4_marker)	
	player_bw_4.Cinematic_Hyperspace_In(100)

	Transition_Cinematic_Camera_Key(introcam_4_marker, 5, 0, 0, 0, 1, 0, 0, 0)
	Transition_Cinematic_Target_Key(introcam_4_marker, 5, 0, 0, 0, 0, introcam_target_3_marker, 1, 0)
	Story_Event("SHOWDOWN_04")
	Sleep(5.5)

	Story_Event("SHOWDOWN_05")
	Sleep(5.5)

	Set_Cinematic_Camera_Key(introcam_5_marker, 0, 0, 0, 1, 0, 0, 0)
	Set_Cinematic_Target_Key(introcam_5_marker, 0, 0, 0, 0, introcam_target_3_marker, 1, 0)
	Transition_Cinematic_Camera_Key(introcam_6_marker, 20, 0, 0, 0, 1, 0, 0, 0)
	Transition_Cinematic_Target_Key(introcam_6_marker, 20, 0, 0, 0, 0, player_ningo, 1, 0)
	Story_Event("SHOWDOWN_06")

	player_ningo.Move_To(intro_2_ningo_marker)

	player_bw_1.Move_To(intro_2_bw_1_marker)
	player_bw_2.Move_To(intro_2_bw_2_marker)
	player_bw_3.Move_To(intro_2_bw_3_marker)
	player_bw_4.Move_To(intro_2_bw_4_marker)
	Sleep(8.5)

	Set_Cinematic_Camera_Key(introcam_7_marker, 0, 0, 0, 1, 0, 0, 0)
	Set_Cinematic_Target_Key(introcam_7_marker, 0, 0, 0, 0, player_ningo, 1, 0)
	Transition_Cinematic_Camera_Key(introcam_8_marker, 30.0, 0, 0, 0, 1, 0, 0, 0)
	Transition_Cinematic_Target_Key(introcam_8_marker, 30.0, 0, 0, 0, 0, player_ningo, 1, 0)
	Story_Event("SHOWDOWN_07")
	Sleep(5.0)

	if not cinematic_one_skipped then
		current_cinematic_thread_id = Create_Thread("End_Cinematic_Intro_Rep")
	end
end

function End_Cinematic_Intro_Rep()
	if p_cis.Get_Difficulty()== "Easy" then
		AI_CIS_Fleet = SpawnList(bulwark_easy_list, attacker_marker.Get_Position(), p_cis, true, true)
		CIS_AI_Fleet = AI_CIS_Fleet[1]
		CIS_AI_Fleet.Teleport_And_Face(attacker_marker)
		CIS_AI_Fleet.Cinematic_Hyperspace_In(150)
	elseif p_cis.Get_Difficulty()== "Hard" then
		AI_CIS_Fleet = SpawnList(bulwark_hard_list, attacker_marker.Get_Position(), p_cis, true, true)
		CIS_AI_Fleet = AI_CIS_Fleet[1]
		CIS_AI_Fleet.Teleport_And_Face(attacker_marker)
		CIS_AI_Fleet.Cinematic_Hyperspace_In(150)
	else
		AI_CIS_Fleet = SpawnList(bulwark_medium_list, attacker_marker.Get_Position(), p_cis, true, true)
		CIS_AI_Fleet = AI_CIS_Fleet[1]
		CIS_AI_Fleet.Teleport_And_Face(attacker_marker)
		CIS_AI_Fleet.Cinematic_Hyperspace_In(150)
	end

	Point_Camera_At(player_dodonna)
	Transition_To_Tactical_Camera(3)
	Letter_Box_Out(3)
	Sleep(3.0)
	End_Cinematic_Camera()
	Lock_Controls(0)
	Suspend_AI(0)

	Register_Timer(State_Avenger_Fleet_Arrives, 30)

	p_cis.Make_Enemy(p_republic)
	p_republic.Make_Enemy(p_cis)

	Story_Event("GOAL_TRIGGER_REP_I")
	StoryUtil.AIActivation()

	cinematic_one = false
	act_1_active = true

	StoryUtil.CinematicEnvironmentOff()
end
