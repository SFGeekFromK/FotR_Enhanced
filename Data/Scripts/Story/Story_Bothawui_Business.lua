
--****************************************************--
--************ Rimward: Bothawui Business ************--
--****************************************************--

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
		Trigger_Trap_Active = State_Trap_Active,
	}

	p_cis = Find_Player("Rebel")
	p_republic = Find_Player("Empire")
	p_neutral = Find_Player("Neutral")
	p_hostile = Find_Player("Hostile")

	cinematic_crawl = false
	cinematic_one = false
	cinematic_two = false

	cinematic_crawl_skipped = false
	cinematic_one_skipped = false
	cinematic_two_skipped = false

	act_1_active = false

	trap_activated = false
	anakin_crashed = false
	anakin_rescued = false
	yularen_escaped = false
	grievous_escaped = false

	current_cinematic_thread_id = nil

	camera_offset = 125
	mission_started = false
end

function Begin_Battle(message)
	if message == OnEnter then
		yularen_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "yularen")
		dauntless_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "dauntless")
		pioneer_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "pioneer")

		muni1_1_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "muni-1-1")
		muni1_2_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "muni-1-2")
		muni2_1_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "muni-2-1")
		muni2_2_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "muni-2-2")
		muni3_1_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "muni-3-1")
		muni3_2_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "muni-3-2")
		muni4_1_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "muni-4-1")
		muni4_2_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "muni-4-2")
		muni5_1_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "muni-5-1")
		muni5_2_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "muni-5-2")

		grievous_move_to = Find_Hint("STORY_TRIGGER_ZONE_00", "grievousmoveto")
		muni1_move_to = Find_Hint("STORY_TRIGGER_ZONE_00", "muni1moveto")
		muni2_move_to = Find_Hint("STORY_TRIGGER_ZONE_00", "muni2moveto")
		muni3_move_to = Find_Hint("STORY_TRIGGER_ZONE_00", "muni3moveto")
		muni4_move_to = Find_Hint("STORY_TRIGGER_ZONE_00", "muni4moveto")
		muni5_move_to = Find_Hint("STORY_TRIGGER_ZONE_00", "muni5moveto")

		introcam_1_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam1")
		introcam_2_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam2")
		introcam_3_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam3")
		introcam_4_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam4")
		introcam_5_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam5")
		introcam_6_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam6")
		introcam_7_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam7")
		introcam_8_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam8")
		introcam_9_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam9")
		introcam_10_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam10")

		introcam_target_1_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcamtarget1")
		introcam_target_yularen_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcamtarget-yularen")
		introcam_target_grievous_1_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcamtarget-grievous-1")
		introcam_target_grievous_2_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcamtarget-grievous-2")

		outrocam_1_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "outrocam1")
		outrocam_2_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "outrocam2")
		outrocam_3_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "outrocam3")
		outrocam_4_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "outrocam4")
		outrocam_5_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "outrocam5")

		outro_1_twilight_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "outro-twilight-1")
		outro_2_twilight_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "outro-twilight-2")

		anakin_crash_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "anakin-crash")
		retreat_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "retreat")

		player_yularen = Find_First_Object("YULAREN_RESOLUTE")
		player_anakin = Find_First_Object("ANAKIN_DELTA")

		player_munificent_1	= Find_Hint("MUNIFICENT", "1")
		player_munificent_2 = Find_Hint("MUNIFICENT", "2")
		player_munificent_3 = Find_Hint("MUNIFICENT", "3")
		player_munificent_4 = Find_Hint("MUNIFICENT", "4")
		player_munificent_5 = Find_Hint("MUNIFICENT", "5")

		p_republic.Make_Ally(p_hostile)
		p_hostile.Make_Ally(p_republic)

		p_cis.Make_Ally(p_hostile)
		p_hostile.Make_Ally(p_cis)

		space_attes_01 = Find_All_Objects_Of_Type("REPUBLIC_AT_TE_WALKER_SPACE")
		for _,attes_space_01 in pairs(space_attes_01) do
			if TestValid(attes_space_01) then
				attes_space_01.Change_Owner(p_neutral)
			end
		end

		if p_republic.Is_Human() then
			mission_started = true
			FogOfWar.Reveal_All(p_republic)
			current_cinematic_thread_id = Create_Thread("Start_Cinematic_Crawl_Rep")
		elseif p_cis.Is_Human() then
			mission_started = true
			FogOfWar.Reveal_All(p_cis)
			current_cinematic_thread_id = Create_Thread("Start_Cinematic_Crawl_CIS")
		end
	end
end


function State_Anakin_Rescued(prox_obj, trigger_obj)
	if trigger_obj == player_twilight and cinematic_two then
		player_anakin_crash.Attach_Particle_Effect("Rescue_Effect")
		Sleep(1)
		player_anakin_crash.Despawn()
		prox_obj.Cancel_Event_Object_In_Range(State_Anakin_Rescued)
	elseif trigger_obj.Get_Owner() == p_republic and act_1_active then
		anakin_rescued = true
		Story_Event("RESCUE_04")
		player_anakin_crash.Attach_Particle_Effect("Rescue_Effect")
		Sleep(1)
		player_anakin_crash.Despawn()
		anakin_crash_marker.Highlight(false)
		prox_obj.Cancel_Event_Object_In_Range(State_Anakin_Rescued)
	end
end

function State_Trap_Active(message)
	if message == OnEnter then
		trap_activated = true

		Stop_All_Music()
		StoryUtil.CinematicEnvironmentOn()

		StoryUtil.PlayGenericSpeech("Bothawui_Business_02")
		Stop_All_Music()
		Play_Music("Silence_Theme")
		Sleep(8.0)

		space_attes_02 = Find_All_Objects_Of_Type("REPUBLIC_AT_TE_WALKER_SPACE")
		for _,attes_space_02 in pairs(space_attes_02) do
			if TestValid(attes_space_02) then
				attes_space_02.Change_Owner(p_republic)
			end
		end

		if p_cis.Is_Human() then
			player_yularen.Suspend_Locomotor(false)
			player_pioneer.Suspend_Locomotor(false)
			player_dauntless.Suspend_Locomotor(false)
		end

		StoryUtil.CinematicEnvironmentOff()
		StoryUtil.CinematicEnvironmentOff()
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

					Fade_Screen_Out(0)
					Stop_All_Music()
					Stop_All_Speech()
					Remove_All_Text()
					Stop_Bink_Movie()

					StoryUtil.CinematicEnvironmentOff()

					despawn_me_table = Find_All_Objects_With_Hint("despawn-1")
					for i,despawn_me in pairs(despawn_me_table) do
						if TestValid(despawn_me) then
							despawn_me.Despawn()
						end
					end

					hide_me_table = Find_All_Objects_Of_Type("Structure", p_republic)
					for i,hide_me in pairs(hide_me_table) do
						hide_me.Hide(false)
						Hide_Object(hide_me, 0)
					end

					player_grievous.Despawn()
					if (GlobalValue.Get("Rimward_CIS_GC_Version") == 0) then
						player_grievous = Spawn_Unit(Find_Object_Type("GRIEVOUS_MUNIFICENT"), grievous_2_marker, p_cis)
						player_grievous = Find_Nearest(grievous_2_marker, p_cis, true)
						player_grievous.Teleport_And_Face(grievous_2_marker)
						player_grievous.Cinematic_Hyperspace_In(1)
					else
						player_grievous = Spawn_Unit(Find_Object_Type("GRIEVOUS_MALEVOLENCE_HUNT_CAMPAIGN"), grievous_2_marker, p_cis)
						player_grievous = Find_Nearest(grievous_2_marker, p_cis, true)
						player_grievous.Teleport_And_Face(grievous_2_marker)
						player_grievous.Cinematic_Hyperspace_In(1)
					end

					player_munificent_1.Despawn()
					player_munificent_1 = Spawn_Unit(Find_Object_Type("Munificent"), muni1_2_marker, p_cis)
					player_munificent_1 = Find_Nearest(muni1_2_marker, p_cis, true)
					player_munificent_1.Teleport_And_Face(muni1_2_marker)
					player_munificent_1.Cinematic_Hyperspace_In(1)

					player_munificent_2.Despawn()
					player_munificent_2 = Spawn_Unit(Find_Object_Type("Munificent"), muni2_2_marker, p_cis)
					player_munificent_2 = Find_Nearest(muni2_2_marker, p_cis, true)
					player_munificent_2.Teleport_And_Face(muni2_2_marker)
					player_munificent_2.Cinematic_Hyperspace_In(1)

					player_munificent_3.Despawn()
					player_munificent_3 = Spawn_Unit(Find_Object_Type("Munificent"), muni3_2_marker, p_cis)
					player_munificent_3 = Find_Nearest(muni3_2_marker, p_cis, true)
					player_munificent_3.Teleport_And_Face(muni3_2_marker)
					player_munificent_3.Cinematic_Hyperspace_In(1)

					player_munificent_4.Despawn()
					player_munificent_4 = Spawn_Unit(Find_Object_Type("Munificent"), muni4_2_marker, p_cis)
					player_munificent_4 = Find_Nearest(muni4_2_marker, p_cis, true)
					player_munificent_4.Teleport_And_Face(muni4_2_marker)
					player_munificent_4.Cinematic_Hyperspace_In(1)

					player_munificent_5.Despawn()
					player_munificent_5 = Spawn_Unit(Find_Object_Type("Munificent"), muni5_2_marker, p_cis)
					player_munificent_5 = Find_Nearest(muni5_2_marker, p_cis, true)
					player_munificent_5.Teleport_And_Face(muni5_2_marker)
					player_munificent_5.Cinematic_Hyperspace_In(1)

					player_grievous.Move_To(grievous_move_to)
					player_munificent_1.Move_To(muni1_move_to)
					player_munificent_2.Move_To(muni2_move_to)
					player_munificent_3.Move_To(muni3_move_to)
					player_munificent_4.Move_To(muni4_move_to)
					player_munificent_5.Move_To(muni5_move_to)

					if TestValid(Find_First_Object("SOULLESS_ONE")) and TestValid(player_anakin) then
						Find_First_Object("SOULLESS_ONE").Attack_Move(player_anakin)
					end

					rep_fighters = Find_All_Objects_Of_Type(p_republic, "Fighter | Bomber")
					for _,repfighters in pairs(rep_fighters) do
						if TestValid(repfighters) then
							repfighters.Attack_Move(player_munificent_1)
						end
					end

					Letter_Box_Out(0)
					Lock_Controls(0)
					Suspend_AI(0)
					End_Cinematic_Camera()
					Point_Camera_At(player_grievous)

					player_yularen.Suspend_Locomotor(true)
					player_pioneer.Suspend_Locomotor(true)
					player_dauntless.Suspend_Locomotor(true)

					player_grievous.Make_Invulnerable(false)
					player_munificent_1.Make_Invulnerable(false)
					player_munificent_2.Make_Invulnerable(false)
					player_munificent_3.Make_Invulnerable(false)
					player_munificent_4.Make_Invulnerable(false)
					player_munificent_5.Make_Invulnerable(false)

					StoryUtil.AIActivation()

					Story_Event("GOAL_TRIGGER_CIS_I")

					cinematic_one = false
					act_1_active = true

					Fade_Screen_In(0.5)
					Sleep(0.5)
				end
			end
			if cinematic_two then
				if not cinematic_two_skipped then
					cinematic_two_skipped = true
					-- MessageBox("Escape Key Pressed!!!")

					if current_cinematic_thread_id ~= nil then
						Thread.Kill(current_cinematic_thread_id)
						current_cinematic_thread_id = nil
					end

					StoryUtil.CinematicEnvironmentOff()

					if yularen_escaped then
						GlobalValue.Set("Rimward_Bothawui_Business_Outcome", 0) -- 0 = CIS Victory, 1 = Republic Victory
						StoryUtil.DeclareVictory(p_cis, false)
					elseif grievous_escaped then
						GlobalValue.Set("Rimward_Bothawui_Business_Outcome", 1) -- 0 = CIS Victory, 1 = Republic Victory
						StoryUtil.DeclareVictory(p_republic, false)
					end
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

					Fade_Screen_Out(0)
					Stop_All_Music()
					Stop_All_Speech()
					Remove_All_Text()
					Stop_Bink_Movie()

					despawn_me_table = Find_All_Objects_With_Hint("despawn-1")
					for i,despawn_me in pairs(despawn_me_table) do
						if TestValid(despawn_me) then
							despawn_me.Despawn()
						end
					end

					hide_me_table = Find_All_Objects_Of_Type("Structure", p_republic)
					for i,hide_me in pairs(hide_me_table) do
						hide_me.Hide(false)
						Hide_Object(hide_me, 0)
					end

					player_grievous.Teleport_And_Face(grievous_2_marker)

					player_munificent_1.Despawn()
					player_munificent_1 = Spawn_Unit(Find_Object_Type("Munificent"), muni1_2_marker, p_cis)
					player_munificent_1 = Find_Nearest(muni1_2_marker, p_cis, true)
					player_munificent_1.Teleport_And_Face(muni1_2_marker)
					player_munificent_1.Cinematic_Hyperspace_In(1)

					player_munificent_2.Despawn()
					player_munificent_2 = Spawn_Unit(Find_Object_Type("Munificent"), muni2_2_marker, p_cis)
					player_munificent_2 = Find_Nearest(muni2_2_marker, p_cis, true)
					player_munificent_2.Teleport_And_Face(muni2_2_marker)
					player_munificent_2.Cinematic_Hyperspace_In(1)

					player_munificent_3.Despawn()
					player_munificent_3 = Spawn_Unit(Find_Object_Type("Munificent"), muni3_2_marker, p_cis)
					player_munificent_3 = Find_Nearest(muni3_2_marker, p_cis, true)
					player_munificent_3.Teleport_And_Face(muni3_2_marker)
					player_munificent_3.Cinematic_Hyperspace_In(1)

					player_munificent_4.Despawn()
					player_munificent_4 = Spawn_Unit(Find_Object_Type("Munificent"), muni4_2_marker, p_cis)
					player_munificent_4 = Find_Nearest(muni4_2_marker, p_cis, true)
					player_munificent_4.Teleport_And_Face(muni4_2_marker)
					player_munificent_4.Cinematic_Hyperspace_In(1)

					player_munificent_5.Despawn()
					player_munificent_5 = Spawn_Unit(Find_Object_Type("Munificent"), muni5_2_marker, p_cis)
					player_munificent_5 = Find_Nearest(muni5_2_marker, p_cis, true)
					player_munificent_5.Teleport_And_Face(muni5_2_marker)
					player_munificent_5.Cinematic_Hyperspace_In(1)

					player_grievous.Move_To(grievous_move_to)
					player_munificent_1.Move_To(muni1_move_to)
					player_munificent_2.Move_To(muni2_move_to)
					player_munificent_3.Move_To(muni3_move_to)
					player_munificent_4.Move_To(muni4_move_to)
					player_munificent_5.Move_To(muni5_move_to)

					if TestValid(Find_First_Object("SOULLESS_ONE")) and TestValid(player_anakin) then
						Find_First_Object("SOULLESS_ONE").Attack_Move(player_anakin)
					end

					rep_fighters = Find_All_Objects_Of_Type(p_republic, "Fighter | Bomber")
					for _,repfighters in pairs(rep_fighters) do
						if TestValid(repfighters) then
							repfighters.Attack_Move(player_munificent_1)
						end
					end

					StoryUtil.CinematicEnvironmentOff()

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
			if cinematic_two then
				if not cinematic_two_skipped then
					cinematic_two_skipped = true
					-- MessageBox("Escape Key Pressed!!!")

					if current_cinematic_thread_id ~= nil then
						Thread.Kill(current_cinematic_thread_id)
						current_cinematic_thread_id = nil
					end

					StoryUtil.CinematicEnvironmentOff()

					if yularen_escaped then
						GlobalValue.Set("Rimward_Bothawui_Business_Outcome", 0) -- 0 = CIS Victory, 1 = Republic Victory
						StoryUtil.DeclareVictory(p_cis, false)
					elseif grievous_escaped then
						GlobalValue.Set("Rimward_Bothawui_Business_Outcome", 1) -- 0 = CIS Victory, 1 = Republic Victory
						StoryUtil.DeclareVictory(p_republic, false)
					end
				end
			end
		end
	end 
end

function Story_Mode_Service()
	if p_cis.Is_Human() then
		if act_1_active then
			if Find_First_Object("YULAREN_RESOLUTE").Get_Hull() <= 0.1 and not yularen_escaped then
				yularen_escaped = true
				Find_First_Object("YULAREN_RESOLUTE").Make_Invulnerable(true)
				current_cinematic_thread_id = Create_Thread("Start_Cinematic_Outro_CIS")
			end
			if (GlobalValue.Get("Rimward_CIS_GC_Version") == 0) then
				if not TestValid(Find_First_Object("GRIEVOUS_MUNIFICENT")) and not TestValid(Find_First_Object("MUNIFICENT")) and not grievous_escaped then
					grievous_escaped = true
					current_cinematic_thread_id = Create_Thread("Start_Cinematic_Outro_CIS")
				end
			end
			if (GlobalValue.Get("Rimward_CIS_GC_Version") == 1) then
				if not TestValid(Find_First_Object("GRIEVOUS_MALEVOLENCE_HUNT_CAMPAIGN")) and not TestValid(Find_First_Object("MUNIFICENT")) and not grievous_escaped then
					grievous_escaped = true
					current_cinematic_thread_id = Create_Thread("Start_Cinematic_Outro_CIS")
				end
			end
		end
	elseif p_republic.Is_Human() then
		if act_1_active then
			if Find_First_Object("YULAREN_RESOLUTE").Get_Hull() <= 0.1 and not yularen_escaped then
				yularen_escaped = true
				Find_First_Object("YULAREN_RESOLUTE").Make_Invulnerable(true)
				current_cinematic_thread_id = Create_Thread("Start_Cinematic_Outro_Rep")
			end
			if not TestValid(Find_First_Object("ANAKIN_DELTA")) and not anakin_crashed then
				anakin_crashed = true
				Story_Event("CRASHED")
			end
			if not TestValid(Find_First_Object("GRIEVOUS_MUNIFICENT")) and not TestValid(Find_First_Object("MUNIFICENT")) and not grievous_escaped then
				grievous_escaped = true
				current_cinematic_thread_id = Create_Thread("Start_Cinematic_Outro_Rep")
			end
		end
	end
end


function Start_Cinematic_Crawl_Rep()
	StoryUtil.StartCinematicCamera()
	StoryUtil.CinematicEnvironmentOn()

	StoryUtil.SetCinematicCamera(introcam_1_marker, introcam_target_1_marker, true)

	cinematic_crawl = true
	StoryUtil.PlayCinematicMovieCrawl("Rimward_Campaign_Intro", "Clone_Wars_Crawl_Theme")

	if not cinematic_crawl_skipped then
		current_cinematic_thread_id = Create_Thread("Start_Cinematic_Intro_Rep")
	end
end

function Start_Cinematic_Intro_Rep()
	cinematic_crawl = false

	Find_First_Object("GRIEVOUS_MALEVOLENCE_HUNT_CAMPAIGN").Despawn()
	player_grievous = Find_First_Object("GRIEVOUS_MUNIFICENT")
	grievous_1_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "grievous-1")
	grievous_2_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "grievous-2")

	player_dauntless = Spawn_Unit(Find_Object_Type("Generic_Venator_OFC"), dauntless_marker, p_republic)
	player_dauntless = Find_Nearest(dauntless_marker, p_republic, true)
	player_dauntless.Teleport_And_Face(dauntless_marker)
	player_dauntless.Cinematic_Hyperspace_In(1)

	player_pioneer = Spawn_Unit(Find_Object_Type("Generic_Venator_OFC"), pioneer_marker, p_republic)
	player_pioneer = Find_Nearest(pioneer_marker, p_republic, true)
	player_pioneer.Teleport_And_Face(pioneer_marker)
	player_pioneer.Cinematic_Hyperspace_In(1)

	cinematic_one = true

	hide_me_table = Find_All_Objects_Of_Type("Structure", p_republic)
	for i,hide_me in pairs(hide_me_table) do
		hide_me.Hide(true)
		Hide_Object(hide_me, 1)
	end

	StoryUtil.PlayGenericSpeech("Bothawui_Business_01")
	StoryUtil.PlayGenericMusic("Silence_Theme")
	Transition_Cinematic_Camera_Key(introcam_1_marker, 14.0, 0, 0, 0, 1, 0, 0, 0)
	Transition_Cinematic_Target_Key(introcam_1_marker, 14.0, 0, 0, 0, 0, introcam_target_yularen_marker, 1, 0)
	Letter_Box_In(1.0)
	Sleep(14.0)

	Transition_Cinematic_Camera_Key(introcam_2_marker, 13.0, 0, 0, 0, 1, 0, 0, 0)
	Transition_Cinematic_Target_Key(introcam_2_marker, 13.0, 0, 0, 0, 0, introcam_target_yularen_marker, 1, 0)
	Sleep(13.0)

	Set_Cinematic_Camera_Key(introcam_3_marker, 0, 0, 0, 1, 0, 0, 0)
	Set_Cinematic_Target_Key(introcam_3_marker, 0, 0, 0, 0, introcam_target_yularen_marker, 1, 0)
	Transition_Cinematic_Camera_Key(introcam_4_marker, 15, 0, 0, 0, 1, 0, 0, 0)
	Transition_Cinematic_Target_Key(introcam_4_marker, 15, 0, 0, 0, 0, introcam_target_yularen_marker, 1, 0)
	Sleep(10.0)

	Fade_Screen_Out(3.0)
	Sleep(3.0)

	despawn_me_table = Find_All_Objects_With_Hint("despawn-1")
	for i,despawn_me in pairs(despawn_me_table) do
		despawn_me.Despawn()
	end

	Sleep(1.0)

	Story_Event("CINEMATIC_CRAWL")
	player_munificent_1.Teleport_And_Face(muni1_1_marker)
	player_munificent_1.Cinematic_Hyperspace_In(70)

	player_munificent_2.Teleport_And_Face(muni2_1_marker)
	player_munificent_2.Cinematic_Hyperspace_In(70)

	player_munificent_3.Teleport_And_Face(muni3_1_marker)
	player_munificent_3.Cinematic_Hyperspace_In(70)

	player_munificent_4.Teleport_And_Face(muni4_1_marker)
	player_munificent_4.Cinematic_Hyperspace_In(70)

	player_munificent_5.Teleport_And_Face(muni5_1_marker)
	player_munificent_5.Cinematic_Hyperspace_In(70)

	player_grievous.Despawn()

	player_grievous = Spawn_Unit(Find_Object_Type("GRIEVOUS_MUNIFICENT"), grievous_1_marker, p_cis)
	player_grievous = Find_Nearest(grievous_1_marker, p_cis, true)
	player_grievous.Teleport_And_Face(grievous_1_marker)
	player_grievous.Cinematic_Hyperspace_In(100)

	Fade_Screen_In(1.0)
	Set_Cinematic_Camera_Key(introcam_5_marker, 0, 0, 0, 1, 0, 0, 0)
	Set_Cinematic_Target_Key(introcam_5_marker, 0, 0, 0, 0, introcam_target_grievous_1_marker, 1, 0)
	Transition_Cinematic_Camera_Key(introcam_6_marker, 13, 0, 0, 0, 1, 0, 0, 0)
	Transition_Cinematic_Target_Key(introcam_6_marker, 13, 0, 0, 0, 0, introcam_target_grievous_1_marker, 1, 0)
	Sleep(12)

	Transition_Cinematic_Camera_Key(introcam_7_marker, 9, 0, 0, 0, 1, 0, 0, 0)
	Transition_Cinematic_Target_Key(introcam_7_marker, 9, 0, 0, 0, 0, introcam_target_grievous_1_marker, 1, 0)
	Sleep(7.5)

	Set_Cinematic_Camera_Key(introcam_8_marker, 0, 0, 0, 1, 0, 0, 0)
	Set_Cinematic_Target_Key(introcam_8_marker, 0, 0, 0, 0, player_grievous, 1, 0)
	Cinematic_Zoom(13.5, 5.0)
	Sleep(13.5)

	Fade_Screen_In(0.1)
	player_grievous.Teleport_And_Face(grievous_2_marker)
	player_munificent_1.Teleport_And_Face(muni1_2_marker)
	player_munificent_2.Teleport_And_Face(muni2_2_marker)
	player_munificent_3.Teleport_And_Face(muni3_2_marker)
	player_munificent_4.Teleport_And_Face(muni4_2_marker)
	player_munificent_5.Teleport_And_Face(muni5_2_marker)

	player_grievous.Move_To(grievous_move_to)
	player_munificent_1.Move_To(muni1_move_to)
	player_munificent_2.Move_To(muni2_move_to)
	player_munificent_3.Move_To(muni3_move_to)
	player_munificent_4.Move_To(muni4_move_to)
	player_munificent_5.Move_To(muni5_move_to)

	Set_Cinematic_Camera_Key(introcam_9_marker, 0, 0, 0, 1, 0, 0, 0)
	Set_Cinematic_Target_Key(introcam_9_marker, 0, 0, 0, 0, introcam_target_grievous_2_marker, 1, 0)
	Transition_Cinematic_Camera_Key(introcam_10_marker, 20, 0, 0, 0, 1, 0, 0, 0)
	Transition_Cinematic_Target_Key(introcam_10_marker, 20, 0, 0, 0, 0, introcam_target_grievous_2_marker, 1, 0)
	Sleep(17)

	rep_fighters = Find_All_Objects_Of_Type(p_republic, "Fighter | Bomber")
	for _,repfighters in pairs(rep_fighters) do
		if TestValid(repfighters) then
			repfighters.Attack_Move(player_munificent_1)
		end
	end

	hide_me_table = Find_All_Objects_Of_Type("Structure", p_republic)
	for i,hide_me in pairs(hide_me_table) do
		hide_me.Hide(false)
		Hide_Object(hide_me, 0)
	end

	Story_Event("GOAL_TRIGGER_REP_I")
	StoryUtil.AIActivation()

	if not cinematic_one_skipped then
		current_cinematic_thread_id = Create_Thread("End_Cinematic_Intro_Rep")
	end
end

function End_Cinematic_Intro_Rep()
	Point_Camera_At(player_yularen)
	Transition_To_Tactical_Camera(3)
	Letter_Box_Out(3)
	Sleep(3.0)
	End_Cinematic_Camera()
	Lock_Controls(0)
	Suspend_AI(0)

	cis_fleet = Find_All_Objects_Of_Type(p_cis)
	for _,cis_ships in pairs(cis_fleet) do
		if TestValid(cis_ships) then
			cis_ships.Attack_Move(player_pioneer)
		end
	end

	cinematic_one = false
	act_1_active = true

	if TestValid(Find_First_Object("SOULLESS_ONE")) and TestValid(player_anakin) then
		Find_First_Object("SOULLESS_ONE").Attack_Move(player_anakin)
	end

	Sleep(2.0)

	StoryUtil.CinematicEnvironmentOff()
end

function Start_Cinematic_Outro_Rep()
	act_1_active = false
	cinematic_two = true

	Fade_Screen_Out(2)
	Sleep(2.5)

	Start_Cinematic_Camera()
	Suspend_AI(1)
	Lock_Controls(1)
	Stop_All_Music()
	Cancel_Fast_Forward()

	if not anakin_crashed then
		anakin_crashed = true
		Allow_Localized_SFX(false)
		StoryUtil.CinematicEnvironmentOn()

		Story_Event("FINALE_06")
		StoryUtil.PlayGenericSpeech("Bothawui_Business_03")
		Stop_All_Music()
		Play_Music("Silence_Theme")
		Sleep(7.0)

		StoryUtil.CinematicEnvironmentOff()
	end

	if yularen_escaped and not anakin_rescued then
		Play_Music("Trade_Federation_Theme")
		Fade_Screen_In(1.5)
		Letter_Box_In(1.5)

		player_anakin_crash = Spawn_Unit(Find_Object_Type("Anakin_Delta"), anakin_crash_marker, p_republic)
		player_anakin_crash = Find_Nearest(anakin_crash_marker, p_republic, true)
		player_anakin_crash.Teleport_And_Face(anakin_crash_marker)

		if TestValid(player_yularen) then
			player_yularen.Turn_To_Face(retreat_marker)
		end
		if TestValid(player_pioneer) then
			player_pioneer.Turn_To_Face(retreat_marker)
		end
		if TestValid(player_dauntless) then
			player_dauntless.Turn_To_Face(retreat_marker)
		end

		Set_Cinematic_Camera_Key(outrocam_1_marker, 0, 0, 0, 1, 0, 0, 0)
		Set_Cinematic_Target_Key(outrocam_1_marker, 0, 0, 0, 0, player_yularen, 1, 0)
		Transition_Cinematic_Camera_Key(outrocam_2_marker, 25.0, 0, 0, 0, 1, 0, 0, 0)
		Transition_Cinematic_Target_Key(outrocam_2_marker, 25.0, 0, 0, 0, 0, player_yularen, 1, 0)
		Story_Event("FINALE_01_ALT_01")
		Sleep(8.5)

		Story_Event("FINALE_02_ALT_01")
		Sleep(8.5)

		Story_Event("FINALE_03_ALT_01")
		Sleep(1.5)

		if TestValid(player_yularen) then
			player_yularen.Hyperspace_Away(false)
		end
		if TestValid(player_pioneer) then
			player_pioneer.Hyperspace_Away(false)
		end
		if TestValid(player_dauntless) then
			player_dauntless.Hyperspace_Away(false)
		end
		Sleep(2.0)

		Fade_Screen_Out(1.0)
		Sleep(1.5)

		player_twilight = Spawn_Unit(Find_Object_Type("Twilight_Mission"), outro_1_twilight_marker, p_republic)
		player_twilight = Find_Nearest(outro_1_twilight_marker, p_republic, true)
		player_twilight.Teleport_And_Face(outro_1_twilight_marker)
		player_twilight.Cinematic_Hyperspace_In(50)
		player_twilight.Override_Max_Speed(15)
		player_twilight.Move_To(outro_2_twilight_marker)

		--Register_Prox(player_anakin_crash, State_Anakin_Rescued, 100, p_republic)

		Fade_Screen_In(1.0)

		Set_Cinematic_Camera_Key(outrocam_3_marker, 0, 0, 0, 1, 0, 0, 0)
		Set_Cinematic_Target_Key(outrocam_3_marker, 0, 0, 0, 0, player_twilight, 1, 0)
		Transition_Cinematic_Camera_Key(outrocam_4_marker, 15.0, 0, 0, 0, 1, 0, 0, 0)
		Transition_Cinematic_Target_Key(outrocam_4_marker, 15.0, 0, 0, 0, 0, player_twilight, 1, 0)
		Sleep(2.0)

		player_twilight.Move_To(outro_2_twilight_marker)
		Story_Event("FINALE_04")
		Sleep(5.0)

		Fade_Screen_Out(1.0)
		Sleep(2)

		StoryUtil.CinematicEnvironmentOff()
		GlobalValue.Set("Rimward_Bothawui_Business_Outcome", 0) -- 0 = CIS Victory, 1 = Republic Victory
		StoryUtil.DeclareVictory(p_cis, false)
	elseif yularen_escaped and anakin_rescued then
		Play_Music("Trade_Federation_Theme")
		Fade_Screen_In(0.5)
		Letter_Box_In(0.5)

		if TestValid(player_yularen) then
			player_yularen.Turn_To_Face(retreat_marker)
		end
		if TestValid(player_pioneer) then
			player_pioneer.Turn_To_Face(retreat_marker)
		end
		if TestValid(player_dauntless) then
			player_dauntless.Turn_To_Face(retreat_marker)
		end

		Set_Cinematic_Camera_Key(outrocam_1_marker, 0, 0, 0, 1, 0, 0, 0)
		Set_Cinematic_Target_Key(outrocam_1_marker, 0, 0, 0, 0, player_yularen, 1, 0)
		Transition_Cinematic_Camera_Key(outrocam_2_marker, 25.0, 0, 0, 0, 1, 0, 0, 0)
		Transition_Cinematic_Target_Key(outrocam_2_marker, 25.0, 0, 0, 0, 0, player_yularen, 1, 0)
		Story_Event("FINALE_01_ALT_03")
		Sleep(7.0)

		if TestValid(player_yularen) then
			player_yularen.Hyperspace_Away(false)
		end
		if TestValid(player_pioneer) then
			player_pioneer.Hyperspace_Away(false)
		end
		if TestValid(player_dauntless) then
			player_dauntless.Hyperspace_Away(false)
		end
		Sleep(2.0)

		Fade_Screen_Out(1.0)
		Sleep(2.0)
		StoryUtil.CinematicEnvironmentOff()
		GlobalValue.Set("Rimward_Bothawui_Business_Outcome", 0) -- 0 = CIS Victory, 1 = Republic Victory
		StoryUtil.DeclareVictory(p_cis, false)
	elseif grievous_escaped and not anakin_rescued then
		Play_Music("Trade_Federation_Theme")
		Fade_Screen_In(1.5)
		Letter_Box_In(1.5)

		player_anakin_crash = Spawn_Unit(Find_Object_Type("Anakin_Delta"), anakin_crash_marker, p_republic)
		player_anakin_crash = Find_Nearest(anakin_crash_marker, p_republic, true)
		player_anakin_crash.Teleport_And_Face(anakin_crash_marker)

		Set_Cinematic_Camera_Key(outrocam_1_marker, 0, 0, 0, 1, 0, 0, 0)
		Set_Cinematic_Target_Key(outrocam_1_marker, 0, 0, 0, 0, player_yularen, 1, 0)
		Transition_Cinematic_Camera_Key(outrocam_2_marker, 25.0, 0, 0, 0, 1, 0, 0, 0)
		Transition_Cinematic_Target_Key(outrocam_2_marker, 25.0, 0, 0, 0, 0, player_yularen, 1, 0)
		Story_Event("FINALE_01_ALT_02")
		Sleep(9.5)

		Story_Event("FINALE_02_ALT_02")
		Sleep(8.5)

		Story_Event("FINALE_03_ALT_02")
		Sleep(3.5)

		Fade_Screen_Out(1.0)
		Sleep(1.5)

		player_twilight = Spawn_Unit(Find_Object_Type("Twilight_Mission"), outro_1_twilight_marker, p_republic)
		player_twilight = Find_Nearest(outro_1_twilight_marker, p_republic, true)
		player_twilight.Teleport_And_Face(outro_1_twilight_marker)
		player_twilight.Cinematic_Hyperspace_In(50)
		player_twilight.Override_Max_Speed(15)
		player_twilight.Move_To(outro_2_twilight_marker)

		--Register_Prox(player_anakin_crash, State_Anakin_Rescued, 100, p_republic)

		Fade_Screen_In(1.0)

		Set_Cinematic_Camera_Key(outrocam_3_marker, 0, 0, 0, 1, 0, 0, 0)
		Set_Cinematic_Target_Key(outrocam_3_marker, 0, 0, 0, 0, player_twilight, 1, 0)
		Transition_Cinematic_Camera_Key(outrocam_4_marker, 15.0, 0, 0, 0, 1, 0, 0, 0)
		Transition_Cinematic_Target_Key(outrocam_4_marker, 15.0, 0, 0, 0, 0, player_twilight, 1, 0)
		Sleep(2.0)

		player_twilight.Move_To(outro_2_twilight_marker)
		Story_Event("FINALE_04")
		Sleep(5.0)

		Fade_Screen_Out(1.0)
		Sleep(2)

		StoryUtil.CinematicEnvironmentOff()
		GlobalValue.Set("Rimward_Bothawui_Business_Outcome", 1) -- 0 = CIS Victory, 1 = Republic Victory
		StoryUtil.DeclareVictory(p_republic, false)
	elseif grievous_escaped and anakin_rescued then
		Play_Music("Trade_Federation_Theme")
		Letter_Box_In(0.5)
		Fade_Screen_In(0.5)

		Set_Cinematic_Camera_Key(outrocam_1_marker, 0, 0, 0, 1, 0, 0, 0)
		Set_Cinematic_Target_Key(outrocam_1_marker, 0, 0, 0, 0, player_yularen, 1, 0)
		Transition_Cinematic_Camera_Key(outrocam_2_marker, 25.0, 0, 0, 0, 1, 0, 0, 0)
		Transition_Cinematic_Target_Key(outrocam_2_marker, 25.0, 0, 0, 0, 0, player_yularen, 1, 0)
		Story_Event("FINALE_01_ALT_04")
		Sleep(9.5)

		Fade_Screen_Out(2.0)
		Sleep(2.5)
		StoryUtil.CinematicEnvironmentOff()
		GlobalValue.Set("Rimward_Bothawui_Business_Outcome", 1) -- 0 = CIS Victory, 1 = Republic Victory
		StoryUtil.DeclareVictory(p_republic, false)
	end
end


function Start_Cinematic_Crawl_CIS()
	StoryUtil.StartCinematicCamera()
	StoryUtil.CinematicEnvironmentOn()

	StoryUtil.SetCinematicCamera(introcam_1_marker, introcam_target_1_marker, true)

	cinematic_crawl = true
	if (GlobalValue.Get("Rimward_CIS_GC_Version") == 0) then
		StoryUtil.PlayCinematicMovieCrawl("Rimward_Campaign_Intro", "Clone_Wars_Crawl_Theme")
	else
		StoryUtil.PlayCinematicMovieCrawl("Rimward_Campaign_AU_Intro", "Clone_Wars_Crawl_Theme")
	end

	if not cinematic_crawl_skipped then
		current_cinematic_thread_id = Create_Thread("Start_Cinematic_Intro_CIS")
	end
end

function Start_Cinematic_Intro_CIS()
	cinematic_crawl = false
	if (GlobalValue.Get("Rimward_CIS_GC_Version") == 0) then
		Find_First_Object("GRIEVOUS_MALEVOLENCE_HUNT_CAMPAIGN").Despawn()
		player_grievous = Find_First_Object("GRIEVOUS_MUNIFICENT")
		grievous_1_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "grievous-1")
		grievous_2_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "grievous-2")
	else
		Find_First_Object("GRIEVOUS_MUNIFICENT").Despawn()
		player_grievous = Find_First_Object("GRIEVOUS_MALEVOLENCE_HUNT_CAMPAIGN")
		grievous_1_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "grievous-1-au")
		grievous_2_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "grievous-2-au")
	end

	player_dauntless = Spawn_Unit(Find_Object_Type("Generic_Venator_OFC"), dauntless_marker, p_republic)
	player_dauntless = Find_Nearest(dauntless_marker, p_republic, true)
	player_dauntless.Teleport_And_Face(dauntless_marker)
	player_dauntless.Cinematic_Hyperspace_In(1)

	player_pioneer = Spawn_Unit(Find_Object_Type("Generic_Venator_OFC"), pioneer_marker, p_republic)
	player_pioneer = Find_Nearest(pioneer_marker, p_republic, true)
	player_pioneer.Teleport_And_Face(pioneer_marker)
	player_pioneer.Cinematic_Hyperspace_In(1)

	cinematic_one = true

	hide_me_table = Find_All_Objects_Of_Type("Structure", p_republic)
	for i,hide_me in pairs(hide_me_table) do
		hide_me.Hide(true)
		Hide_Object(hide_me, 1)
	end

	StoryUtil.PlayGenericSpeech("Bothawui_Business_01")
	StoryUtil.PlayGenericMusic("Silence_Theme")
	Transition_Cinematic_Camera_Key(introcam_1_marker, 14.0, 0, 0, 0, 1, 0, 0, 0)
	Transition_Cinematic_Target_Key(introcam_1_marker, 14.0, 0, 0, 0, 0, introcam_target_yularen_marker, 1, 0)
	Letter_Box_In(1.0)
	Sleep(14.0)

	Transition_Cinematic_Camera_Key(introcam_2_marker, 13.0, 0, 0, 0, 1, 0, 0, 0)
	Transition_Cinematic_Target_Key(introcam_2_marker, 13.0, 0, 0, 0, 0, introcam_target_yularen_marker, 1, 0)
	Sleep(13.0)

	Set_Cinematic_Camera_Key(introcam_3_marker, 0, 0, 0, 1, 0, 0, 0)
	Set_Cinematic_Target_Key(introcam_3_marker, 0, 0, 0, 0, introcam_target_yularen_marker, 1, 0)
	Transition_Cinematic_Camera_Key(introcam_4_marker, 15, 0, 0, 0, 1, 0, 0, 0)
	Transition_Cinematic_Target_Key(introcam_4_marker, 15, 0, 0, 0, 0, introcam_target_yularen_marker, 1, 0)
	Sleep(10.0)

	Fade_Screen_Out(3.0)
	Sleep(3.0)

	despawn_me_table = Find_All_Objects_With_Hint("despawn-1")
	for i,despawn_me in pairs(despawn_me_table) do
		despawn_me.Despawn()
	end

	Sleep(1.0)

	Story_Event("CINEMATIC_CRAWL")
	player_munificent_1.Teleport_And_Face(muni1_1_marker)
	player_munificent_1.Cinematic_Hyperspace_In(70)

	player_munificent_2.Teleport_And_Face(muni2_1_marker)
	player_munificent_2.Cinematic_Hyperspace_In(70)

	player_munificent_3.Teleport_And_Face(muni3_1_marker)
	player_munificent_3.Cinematic_Hyperspace_In(70)

	player_munificent_4.Teleport_And_Face(muni4_1_marker)
	player_munificent_4.Cinematic_Hyperspace_In(70)

	player_munificent_5.Teleport_And_Face(muni5_1_marker)
	player_munificent_5.Cinematic_Hyperspace_In(70)

	player_grievous.Teleport_And_Face(grievous_1_marker)
	player_grievous.Cinematic_Hyperspace_In(100)

	player_grievous.Make_Invulnerable(true)
	player_munificent_1.Make_Invulnerable(true)
	player_munificent_2.Make_Invulnerable(true)
	player_munificent_3.Make_Invulnerable(true)
	player_munificent_4.Make_Invulnerable(true)
	player_munificent_5.Make_Invulnerable(true)

	Fade_Screen_In(1.0)
	Set_Cinematic_Camera_Key(introcam_5_marker, 0, 0, 0, 1, 0, 0, 0)
	Set_Cinematic_Target_Key(introcam_5_marker, 0, 0, 0, 0, introcam_target_grievous_1_marker, 1, 0)
	Transition_Cinematic_Camera_Key(introcam_6_marker, 13, 0, 0, 0, 1, 0, 0, 0)
	Transition_Cinematic_Target_Key(introcam_6_marker, 13, 0, 0, 0, 0, introcam_target_grievous_1_marker, 1, 0)
	Sleep(12)

	Transition_Cinematic_Camera_Key(introcam_7_marker, 9, 0, 0, 0, 1, 0, 0, 0)
	Transition_Cinematic_Target_Key(introcam_7_marker, 9, 0, 0, 0, 0, introcam_target_grievous_1_marker, 1, 0)
	Sleep(7.5)

	Set_Cinematic_Camera_Key(introcam_8_marker, 0, 0, 0, 1, 0, 0, 0)
	Set_Cinematic_Target_Key(introcam_8_marker, 0, 0, 0, 0, player_grievous, 1, 0)
	Cinematic_Zoom(13.5, 5.0)	
	Sleep(13.5)

	Fade_Screen_In(0.1)
	player_grievous.Teleport_And_Face(grievous_2_marker)
	player_munificent_1.Teleport_And_Face(muni1_2_marker)
	player_munificent_2.Teleport_And_Face(muni2_2_marker)
	player_munificent_3.Teleport_And_Face(muni3_2_marker)
	player_munificent_4.Teleport_And_Face(muni4_2_marker)
	player_munificent_5.Teleport_And_Face(muni5_2_marker)

	player_grievous.Move_To(grievous_move_to)
	player_munificent_1.Move_To(muni1_move_to)
	player_munificent_2.Move_To(muni2_move_to)
	player_munificent_3.Move_To(muni3_move_to)
	player_munificent_4.Move_To(muni4_move_to)
	player_munificent_5.Move_To(muni5_move_to)

	Set_Cinematic_Camera_Key(introcam_9_marker, 0, 0, 0, 1, 0, 0, 0)
	Set_Cinematic_Target_Key(introcam_9_marker, 0, 0, 0, 0, introcam_target_grievous_2_marker, 1, 0)
	Transition_Cinematic_Camera_Key(introcam_10_marker, 20, 0, 0, 0, 1, 0, 0, 0)
	Transition_Cinematic_Target_Key(introcam_10_marker, 20, 0, 0, 0, 0, introcam_target_grievous_2_marker, 1, 0)
	Sleep(17)

	rep_fighters = Find_All_Objects_Of_Type(p_republic, "Fighter | Bomber")
	for _,repfighters in pairs(rep_fighters) do
		if TestValid(repfighters) then
			repfighters.Attack_Move(player_munificent_1)
		end
	end

	hide_me_table = Find_All_Objects_Of_Type("Structure", p_republic)
	for i,hide_me in pairs(hide_me_table) do
		hide_me.Hide(false)
		Hide_Object(hide_me, 0)
	end

	player_yularen.Suspend_Locomotor(true)
	player_pioneer.Suspend_Locomotor(true)
	player_dauntless.Suspend_Locomotor(true)

	player_grievous.Make_Invulnerable(false)
	player_munificent_1.Make_Invulnerable(false)
	player_munificent_2.Make_Invulnerable(false)
	player_munificent_3.Make_Invulnerable(false)
	player_munificent_4.Make_Invulnerable(false)
	player_munificent_5.Make_Invulnerable(false)

	Story_Event("GOAL_TRIGGER_CIS_I")
	StoryUtil.AIActivation()

	if not cinematic_one_skipped then
		current_cinematic_thread_id = Create_Thread("End_Cinematic_Intro_CIS")
	end
end

function End_Cinematic_Intro_CIS()
	Point_Camera_At(player_grievous)
	Transition_To_Tactical_Camera(3)
	Letter_Box_Out(3)
	Sleep(3.0)
	End_Cinematic_Camera()
	Lock_Controls(0)
	Suspend_AI(0)

	cis_fleet = Find_All_Objects_Of_Type(p_cis)
	for _,cis_ships in pairs(cis_fleet) do
		if TestValid(cis_ships) then
			cis_ships.Attack_Move(player_pioneer)
		end
	end

	cinematic_one = false
	act_1_active = true

	if TestValid(Find_First_Object("SOULLESS_ONE")) and TestValid(player_anakin) then
		Find_First_Object("SOULLESS_ONE").Attack_Move(player_anakin)
	end

	Sleep(2.0)

	StoryUtil.CinematicEnvironmentOff()
end

function Start_Cinematic_Outro_CIS()
	act_1_active = false
	cinematic_two = true

	Fade_Screen_Out(2)
	Sleep(2.5)

	Start_Cinematic_Camera()
	Suspend_AI(1)
	Lock_Controls(1)
	Stop_All_Music()
	Cancel_Fast_Forward()

	if not anakin_crashed then
		anakin_crashed = true
		StoryUtil.CinematicEnvironmentOn()

		Story_Event("FINALE_06")
		StoryUtil.PlayGenericSpeech("Bothawui_Business_03")
		Stop_All_Music()
		Play_Music("Silence_Theme")
		Sleep(8.0)

		StoryUtil.CinematicEnvironmentOff()
	end

	if yularen_escaped and not anakin_rescued then
		Play_Music("Trade_Federation_Theme")
		Fade_Screen_In(1.5)
		Letter_Box_In(1.5)

		player_anakin_crash = Spawn_Unit(Find_Object_Type("Anakin_Delta"), anakin_crash_marker, p_republic)
		player_anakin_crash = Find_Nearest(anakin_crash_marker, p_republic, true)
		player_anakin_crash.Teleport_And_Face(anakin_crash_marker)

		if TestValid(player_yularen) then
			player_yularen.Turn_To_Face(retreat_marker)
		end
		if TestValid(player_pioneer) then
			player_pioneer.Turn_To_Face(retreat_marker)
		end
		if TestValid(player_dauntless) then
			player_dauntless.Turn_To_Face(retreat_marker)
		end

		Set_Cinematic_Camera_Key(outrocam_1_marker, 0, 0, 0, 1, 0, 0, 0)
		Set_Cinematic_Target_Key(outrocam_1_marker, 0, 0, 0, 0, player_yularen, 1, 0)
		Transition_Cinematic_Camera_Key(outrocam_2_marker, 25.0, 0, 0, 0, 1, 0, 0, 0)
		Transition_Cinematic_Target_Key(outrocam_2_marker, 25.0, 0, 0, 0, 0, player_yularen, 1, 0)
		Story_Event("FINALE_01_ALT_01")
		Sleep(8.5)

		Story_Event("FINALE_02_ALT_01")
		Sleep(8.5)

		Story_Event("FINALE_03_ALT_01")
		Sleep(1.5)

		if TestValid(player_yularen) then
			player_yularen.Hyperspace_Away(false)
		end
		if TestValid(player_pioneer) then
			player_pioneer.Hyperspace_Away(false)
		end
		if TestValid(player_dauntless) then
			player_dauntless.Hyperspace_Away(false)
		end
		Sleep(2.0)

		Fade_Screen_Out(1.0)
		Sleep(1.5)

		player_twilight = Spawn_Unit(Find_Object_Type("Twilight_Mission"), outro_1_twilight_marker, p_republic)
		player_twilight = Find_Nearest(outro_1_twilight_marker, p_republic, true)
		player_twilight.Teleport_And_Face(outro_1_twilight_marker)
		player_twilight.Cinematic_Hyperspace_In(50)
		player_twilight.Override_Max_Speed(15)
		player_twilight.Move_To(outro_2_twilight_marker)

		--Register_Prox(player_anakin_crash, State_Anakin_Rescued, 100, p_republic)

		Fade_Screen_In(1.0)

		Set_Cinematic_Camera_Key(outrocam_3_marker, 0, 0, 0, 1, 0, 0, 0)
		Set_Cinematic_Target_Key(outrocam_3_marker, 0, 0, 0, 0, player_twilight, 1, 0)
		Transition_Cinematic_Camera_Key(outrocam_4_marker, 15.0, 0, 0, 0, 1, 0, 0, 0)
		Transition_Cinematic_Target_Key(outrocam_4_marker, 15.0, 0, 0, 0, 0, player_twilight, 1, 0)
		Sleep(2.0)

		Story_Event("FINALE_04")
		Sleep(5.0)

		Fade_Screen_Out(1.0)
		Sleep(2)

		StoryUtil.CinematicEnvironmentOff()
		GlobalValue.Set("Rimward_Bothawui_Business_Outcome", 0) -- 0 = CIS Victory, 1 = Republic Victory
		StoryUtil.DeclareVictory(p_cis, false)
	elseif yularen_escaped and anakin_rescued then
		Play_Music("Trade_Federation_Theme")
		Fade_Screen_In(0.5)
		Letter_Box_In(0.5)

		if TestValid(player_yularen) then
			player_yularen.Turn_To_Face(retreat_marker)
		end
		if TestValid(player_pioneer) then
			player_pioneer.Turn_To_Face(retreat_marker)
		end
		if TestValid(player_dauntless) then
			player_dauntless.Turn_To_Face(retreat_marker)
		end

		Set_Cinematic_Camera_Key(outrocam_1_marker, 0, 0, 0, 1, 0, 0, 0)
		Set_Cinematic_Target_Key(outrocam_1_marker, 0, 0, 0, 0, player_yularen, 1, 0)
		Transition_Cinematic_Camera_Key(outrocam_2_marker, 25.0, 0, 0, 0, 1, 0, 0, 0)
		Transition_Cinematic_Target_Key(outrocam_2_marker, 25.0, 0, 0, 0, 0, player_yularen, 1, 0)
		Story_Event("FINALE_01_ALT_03")
		Sleep(7.0)

		if TestValid(player_yularen) then
			player_yularen.Hyperspace_Away(false)
		end
		if TestValid(player_pioneer) then
			player_pioneer.Hyperspace_Away(false)
		end
		if TestValid(player_dauntless) then
			player_dauntless.Hyperspace_Away(false)
		end
		Sleep(2.0)

		Fade_Screen_Out(1.0)
		Sleep(2.0)
		StoryUtil.CinematicEnvironmentOff()
		GlobalValue.Set("Rimward_Bothawui_Business_Outcome", 0) -- 0 = CIS Victory, 1 = Republic Victory
		StoryUtil.DeclareVictory(p_cis, false)
	elseif grievous_escaped and not anakin_rescued then
		Play_Music("Trade_Federation_Theme")
		Fade_Screen_In(1.5)
		Letter_Box_In(1.5)

		player_anakin_crash = Spawn_Unit(Find_Object_Type("Anakin_Delta"), anakin_crash_marker, p_republic)
		player_anakin_crash = Find_Nearest(anakin_crash_marker, p_republic, true)
		player_anakin_crash.Teleport_And_Face(anakin_crash_marker)

		Set_Cinematic_Camera_Key(outrocam_1_marker, 0, 0, 0, 1, 0, 0, 0)
		Set_Cinematic_Target_Key(outrocam_1_marker, 0, 0, 0, 0, player_yularen, 1, 0)
		Transition_Cinematic_Camera_Key(outrocam_2_marker, 25.0, 0, 0, 0, 1, 0, 0, 0)
		Transition_Cinematic_Target_Key(outrocam_2_marker, 25.0, 0, 0, 0, 0, player_yularen, 1, 0)
		Story_Event("FINALE_01_ALT_02")
		Sleep(9.5)

		Story_Event("FINALE_02_ALT_02")
		Sleep(8.5)

		Story_Event("FINALE_03_ALT_02")
		Sleep(3.5)

		Fade_Screen_Out(1.0)
		Sleep(1.5)

		player_twilight = Spawn_Unit(Find_Object_Type("Twilight_Mission"), outro_1_twilight_marker, p_republic)
		player_twilight = Find_Nearest(outro_1_twilight_marker, p_republic, true)
		player_twilight.Teleport_And_Face(outro_1_twilight_marker)
		player_twilight.Cinematic_Hyperspace_In(50)
		player_twilight.Override_Max_Speed(15)

		Fade_Screen_In(1.0)

		Set_Cinematic_Camera_Key(outrocam_3_marker, 0, 0, 0, 1, 0, 0, 0)
		Set_Cinematic_Target_Key(outrocam_3_marker, 0, 0, 0, 0, player_twilight, 1, 0)
		Transition_Cinematic_Camera_Key(outrocam_4_marker, 15.0, 0, 0, 0, 1, 0, 0, 0)
		Transition_Cinematic_Target_Key(outrocam_4_marker, 15.0, 0, 0, 0, 0, player_twilight, 1, 0)
		Sleep(2.0)

		Story_Event("FINALE_04")
		Sleep(5.0)

		Fade_Screen_Out(1.0)
		Sleep(2)

		StoryUtil.CinematicEnvironmentOff()
		GlobalValue.Set("Rimward_Bothawui_Business_Outcome", 1) -- 0 = CIS Victory, 1 = Republic Victory
		StoryUtil.DeclareVictory(p_republic, false)
	elseif grievous_escaped and anakin_rescued then
		Play_Music("Trade_Federation_Theme")
		Letter_Box_In(0.5)
		Fade_Screen_In(0.5)

		Set_Cinematic_Camera_Key(outrocam_1_marker, 0, 0, 0, 1, 0, 0, 0)
		Set_Cinematic_Target_Key(outrocam_1_marker, 0, 0, 0, 0, player_yularen, 1, 0)
		Transition_Cinematic_Camera_Key(outrocam_2_marker, 25.0, 0, 0, 0, 1, 0, 0, 0)
		Transition_Cinematic_Target_Key(outrocam_2_marker, 25.0, 0, 0, 0, 0, player_yularen, 1, 0)
		Story_Event("FINALE_01_ALT_04")
		Sleep(9.5)

		Fade_Screen_Out(2.0)
		Sleep(2.5)
		StoryUtil.CinematicEnvironmentOff()
		GlobalValue.Set("Rimward_Bothawui_Business_Outcome", 1) -- 0 = CIS Victory, 1 = Republic Victory
		StoryUtil.DeclareVictory(p_republic, false)
	end
end
