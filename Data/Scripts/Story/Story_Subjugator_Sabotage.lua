
--*****************************************************--
--*** Hunt for the Malevolence: Subjugator Sabotage ***--
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
		Trigger_Hyperdrive_Reached = State_Hyperdrive_Sabotage,
		Republic_Heroes_Death = State_Republic_Heroes_Death,
		Trigger_Refill_01 = State_Refill_01,
		Trigger_Refill_02 = State_Refill_02,
		Trigger_Refill_03 = State_Refill_03,
	}

	p_cis = Find_Player("Rebel")
	p_republic = Find_Player("Empire")
	p_invaders = Find_Player("Hostile")
	p_neutral = Find_Player("Neutral")

	oom_security_squad_list =
	{
		"OOM_SECURITY_SQUAD"
	}
	b1_marine_squad_list =
	{
		"B1_DROID_MARINE_SQUAD_DEPLOYED"
	}
	b2_squad_list =
	{
		"B2_DROID_DEPLOYED"
	}
	bx_squad_list =
	{
		"BX_COMMANDO_TEAM_DEPLOYED"
	}
	dwarf_spider_squad_list =
	{
		"DWARF_SPIDER_DROID_SQUAD"
	}

	current_cinematic_thread_id = nil

	act_1_active = false
	act_2_active = false
	act_3_active = false
	act_4_active = false

	cinematic_one = false
	cinematic_two = false
	cinematic_three = false
	cinematic_four = false
	cinematic_five = false

	cinematic_one_skipped = false
	cinematic_two_skipped = false
	cinematic_three_skipped = false
	cinematic_four_skipped = false
	cinematic_five_skipped = false

	padme_reached = false
	elevator_entry_reached = false
	bridge_reached = false
	bridge_exit_reached = false
	hyperdrive_reached = false
	escape_reached = false

	anakin_reached_elevator_entry = false
	padme_reached_elevator_entry = false

	anakin_reached_bridge = false
	padme_reached_bridge = false

	anakin_reached_bridge_exit = false
	padme_reached_bridge_exit = false

	anakin_reached_escape = false
	obiwan_reached_escape = false
	padme_reached_escape = false

	camera_offset = 125
	intro_skipped = false
	mission_started = false

end

function Begin_Battle(message)
	if message == OnEnter then

		GlobalValue.Set("Allow_AI_Controlled_Fog_Reveal", 0)

		intro_1_anakin_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "intro1anakin")
		intro_2_anakin_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "intro2anakin")
		intro_3_anakin_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "intro3anakin")
		intro_4_anakin_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "intro4anakin")

		intro_1_obiwan_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "intro1obiwan")
		intro_2_obiwan_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "intro2obiwan")
		intro_3_obiwan_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "intro3obiwan")
		intro_4_obiwan_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "intro4obiwan")

		intro_1_padme_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "intro1padme")
		intro_2_padme_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "intro2padme")


		midtro_1_anakin_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "midtro1anakin")
		midtro_2_anakin_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "midtro2anakin")

		midtro_1_obiwan_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "midtro1obiwan")
		midtro_2_obiwan_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "midtro2obiwan")
		midtro_3_obiwan_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "midtro3obiwan")

		midtro_1_padme_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "midtro1padme")
		midtro_2_padme_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "midtro2padme")


		outro_1_anakin_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "outro1anakin")
		outro_1_obiwan_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "outro1obiwan")
		outro_1_padme_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "outro1padme")


		intro_1_b1_1_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "intro1b11")
		intro_1_b1_2_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "intro1b12")
		intro_2_b1_1_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "intro1b11")
		intro_2_b1_2_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "intro1b12")


		outro_1_pilot_1_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "outro1pilot1")
		outro_1_pilot_2_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "outro1pilot2")
		outro_1_pilot_3_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "outro1pilot3")

		midtro_1_grievous_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "midtro1grievous")
		midtro_1_magna_1_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "midtro1magna1")
		midtro_1_magna_2_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "midtro1magna2")

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
		introcam_11_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam11")
		introcam_12_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam12")
		introcam_13_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam13")
		introcam_14_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam14")
		introcam_15_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam15")
		introcam_16_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam16")
		introcam_17_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam17")
		introcam_18_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "introcam18")

		midtrocam_1_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "midtrocam1")
		midtrocam_2_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "midtrocam2")
		midtrocam_3_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "midtrocam3")
		midtrocam_4_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "midtrocam4")
		midtrocam_5_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "midtrocam5")
		midtrocam_6_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "midtrocam6")
		midtrocam_7_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "midtrocam7")
		midtrocam_8_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "midtrocam8")
		midtrocam_9_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "midtrocam9")
		midtrocam_10_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "midtrocam10")

		outrocam_1_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "outrocam1")
		outrocam_2_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "outrocam2")
		outrocam_3_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "outrocam3")
		outrocam_4_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "outrocam4")


		patrol_spawner_1_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "patrol-spawner-1")
		patrol_spawner_2_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "patrol-spawner-2")
		patrol_spawner_3_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "patrol-spawner-3")
		patrol_spawner_4_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "patrol-spawner-4")

		patrol_despawn_1_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "patrol-despawn-1")
		patrol_despawn_2_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "patrol-despawn-2")
		patrol_despawn_3_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "patrol-despawn-3")
		patrol_despawn_4_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "patrol-despawn-4")

		patrol_loop_1_1_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "patrol-loop-1-1")
		patrol_loop_1_2_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "patrol-loop-1-2")
		patrol_loop_1_3_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "patrol-loop-1-3")
		patrol_loop_1_4_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "patrol-loop-1-4")
		patrol_loop_1_5_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "patrol-loop-1-5")

		patrol_loop_2_1_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "patrol-loop-2-1")
		patrol_loop_2_2_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "patrol-loop-2-2")
		patrol_loop_2_3_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "patrol-loop-2-3")
		patrol_loop_2_4_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "patrol-loop-2-4")
		patrol_loop_2_5_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "patrol-loop-2-5")

		patrol_loop_3_1_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "patrol-loop-3-1")
		patrol_loop_3_2_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "patrol-loop-3-2")
		patrol_loop_3_3_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "patrol-loop-3-3")
		patrol_loop_3_4_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "patrol-loop-3-4")
		patrol_loop_3_5_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "patrol-loop-3-5")

		patrol_loop_4_1_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "patrol-loop-4-1")
		patrol_loop_4_2_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "patrol-loop-4-2")
		patrol_loop_4_3_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "patrol-loop-4-3")
		patrol_loop_4_4_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "patrol-loop-4-4")
		patrol_loop_4_5_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "patrol-loop-4-5")


		player_cinematic_door = Find_Hint("CIS_DOOR_HUGE_ANIMATED", "cinedoor")

		bridge_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "bridge")
		hyperdrive_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "hyperdrive")
		escape_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "escape")
		twilight_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "twilight")

		elevator_entry_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "elevatorentry")
		elevator_exit_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "elevatorexit")

		bridge_entry_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "bridgeentry")
		bridge_exit_marker = Find_Hint("STORY_TRIGGER_ZONE_00", "bridgeexit")


		Register_Prox(patrol_despawn_1_marker, State_Patrol_Despawn_1, 100, p_cis)
		Register_Prox(patrol_despawn_2_marker, State_Patrol_Despawn_2, 100, p_cis)
		Register_Prox(patrol_despawn_3_marker, State_Patrol_Despawn_3, 100, p_cis)
		Register_Prox(patrol_despawn_4_marker, State_Patrol_Despawn_4, 100, p_cis)

		Register_Prox(patrol_loop_1_1_marker, State_Patrol_Loop_1_1, 100, p_cis)
		Register_Prox(patrol_loop_1_2_marker, State_Patrol_Loop_1_2, 100, p_cis)
		Register_Prox(patrol_loop_1_3_marker, State_Patrol_Loop_1_3, 100, p_cis)
		Register_Prox(patrol_loop_1_4_marker, State_Patrol_Loop_1_4, 100, p_cis)
		Register_Prox(patrol_loop_1_5_marker, State_Patrol_Loop_1_5, 100, p_cis)

		Register_Prox(patrol_loop_2_1_marker, State_Patrol_Loop_2_1, 100, p_cis)
		Register_Prox(patrol_loop_2_2_marker, State_Patrol_Loop_2_2, 100, p_cis)
		Register_Prox(patrol_loop_2_3_marker, State_Patrol_Loop_2_3, 100, p_cis)
		Register_Prox(patrol_loop_2_4_marker, State_Patrol_Loop_2_4, 100, p_cis)
		Register_Prox(patrol_loop_2_5_marker, State_Patrol_Loop_2_5, 100, p_cis)

		Register_Prox(patrol_loop_3_1_marker, State_Patrol_Loop_3_1, 100, p_cis)
		Register_Prox(patrol_loop_3_2_marker, State_Patrol_Loop_3_2, 100, p_cis)
		Register_Prox(patrol_loop_3_3_marker, State_Patrol_Loop_3_3, 100, p_cis)
		Register_Prox(patrol_loop_3_4_marker, State_Patrol_Loop_3_4, 100, p_cis)
		Register_Prox(patrol_loop_3_5_marker, State_Patrol_Loop_3_5, 100, p_cis)

		Register_Prox(patrol_loop_4_1_marker, State_Patrol_Loop_4_1, 100, p_cis)
		Register_Prox(patrol_loop_4_2_marker, State_Patrol_Loop_4_2, 100, p_cis)
		Register_Prox(patrol_loop_4_3_marker, State_Patrol_Loop_4_3, 100, p_cis)
		Register_Prox(patrol_loop_4_4_marker, State_Patrol_Loop_4_4, 100, p_cis)
		Register_Prox(patrol_loop_4_5_marker, State_Patrol_Loop_4_5, 100, p_cis)


		guard_table = Find_All_Objects_With_Hint("guards")
		for i,unit in pairs(guard_table) do
			unit.Guard_Target(unit.Get_Position())
		end

		p_republic.Make_Ally(p_invaders)
		p_invaders.Make_Ally(p_republic)

		p_cis.Make_Ally(p_invaders)
		p_invaders.Make_Ally(p_cis)

		p_cis.Disable_Bombing_Run(false)
		p_republic.Disable_Bombing_Run(false)

		p_cis.Disable_Orbital_Bombardment(true)
		p_republic.Disable_Orbital_Bombardment(true)

		if p_cis.Is_Human() then
			mission_started = true
			current_cinematic_thread_id = Create_Thread("Start_Cinematic_Intro_CIS")
		elseif p_republic.Is_Human() then
			mission_started = true
			current_cinematic_thread_id = Create_Thread("Start_Cinematic_Intro_Rep")
		end
	end
end


function State_Republic_Heroes_Death(message)
	if message == OnEnter then
		if p_republic.Is_Human() then
			StoryUtil.DeclareVictory(p_cis, false)
		end
	end
end


function State_Refill_01(message)
	if message == OnEnter then
		local refill_gamble = GameRandom(1, 6)
		if refill_gamble <= 3 then
			new_squad = SpawnList(b1_marine_squad_list, patrol_spawner_1_marker, p_cis, true, true)
		elseif refill_gamble == 4 then
			new_squad = SpawnList(b2_squad_list, patrol_spawner_1_marker, p_cis, true, true)
		elseif refill_gamble == 5 then
			new_squad = SpawnList(bx_squad_list, patrol_spawner_1_marker, p_cis, true, true)
		elseif refill_gamble == 6 then
			new_squad = SpawnList(dwarf_spider_squad_list, patrol_spawner_1_marker, p_cis, true, true)
		end
		for i,unit in pairs(new_squad) do
			if TestValid(unit) then
				unit.Attack_Move(patrol_loop_1_1_marker)
			end
		end
	end
end

function State_Refill_02(message)
	if message == OnEnter then
		local refill_gamble = GameRandom(1, 6)
		if refill_gamble <= 3 then
			new_squad = SpawnList(b1_marine_squad_list, patrol_spawner_2_marker, p_cis, true, true)
		elseif refill_gamble == 4 then
			new_squad = SpawnList(b2_squad_list, patrol_spawner_2_marker, p_cis, true, true)
		elseif refill_gamble == 5 then
			new_squad = SpawnList(bx_squad_list, patrol_spawner_2_marker, p_cis, true, true)
		elseif refill_gamble == 6 then
			new_squad = SpawnList(dwarf_spider_squad_list, patrol_spawner_2_marker, p_cis, true, true)
		end
		for i,unit in pairs(new_squad) do
			if TestValid(unit) then
				unit.Attack_Move(patrol_loop_2_1_marker)
			end
		end
	end
end

function State_Refill_03(message)
	if message == OnEnter then
		local refill_gamble = GameRandom(1, 6)
		if refill_gamble <= 3 then
			new_squad = SpawnList(b1_marine_squad_list, patrol_spawner_3_marker, p_cis, true, true)
		elseif refill_gamble == 4 then
			new_squad = SpawnList(b2_squad_list, patrol_spawner_3_marker, p_cis, true, true)
		elseif refill_gamble == 5 then
			new_squad = SpawnList(bx_squad_list, patrol_spawner_3_marker, p_cis, true, true)
		elseif refill_gamble == 6 then
			new_squad = SpawnList(dwarf_spider_squad_list, patrol_spawner_3_marker, p_cis, true, true)
		end
		for i,unit in pairs(new_squad) do
			if TestValid(unit) then
				unit.Attack_Move(patrol_loop_3_1_marker)
			end
		end
	end
end

function State_Refill_04(message)
	if message == OnEnter then
		local refill_gamble = GameRandom(1, 6)
		if refill_gamble <= 3 then
			new_squad = SpawnList(b1_marine_squad_list, patrol_spawner_4_marker, p_cis, true, true)
		elseif refill_gamble == 4 then
			new_squad = SpawnList(b2_squad_list, patrol_spawner_4_marker, p_cis, true, true)
		elseif refill_gamble == 5 then
			new_squad = SpawnList(bx_squad_list, patrol_spawner_4_marker, p_cis, true, true)
		elseif refill_gamble == 6 then
			new_squad = SpawnList(dwarf_spider_squad_list, patrol_spawner_4_marker, p_cis, true, true)
		end
		for i,unit in pairs(new_squad) do
			if TestValid(unit) then
				unit.Attack_Move(patrol_loop_4_1_marker)
			end
		end
	end
end


function State_Patrol_Despawn_1(prox_obj, trigger_obj)
	if TestValid(trigger_obj) then
		if trigger_obj.Get_Type() == Find_Object_Type("OOM_SECURITY_SQUAD") 
		or trigger_obj.Get_Type() == Find_Object_Type("B1_DROID_MARINE_SQUAD_DEPLOYED")
		or trigger_obj.Get_Type() == Find_Object_Type("B2_DROID_DEPLOYED")
		or trigger_obj.Get_Type() == Find_Object_Type("BX_COMMANDO_TEAM_DEPLOYED")
		or trigger_obj.Get_Type() == Find_Object_Type("DWARF_SPIDER_DROID_SQUAD") then
			local droid_team = trigger_obj.Get_Parent_Object()
			if TestValid(droid_team) then
				if not droid_team.Has_Active_Orders() then
					droid_team.Despawn()
					Story_Event("REFILL_01")
				end
			end
		end
	end
end

function State_Patrol_Despawn_2(prox_obj, trigger_obj)
	if TestValid(trigger_obj) then
		if trigger_obj.Get_Type() == Find_Object_Type("OOM_SECURITY_SQUAD") 
		or trigger_obj.Get_Type() == Find_Object_Type("B1_DROID_MARINE_SQUAD_DEPLOYED")
		or trigger_obj.Get_Type() == Find_Object_Type("B2_DROID_DEPLOYED")
		or trigger_obj.Get_Type() == Find_Object_Type("BX_COMMANDO_TEAM_DEPLOYED")
		or trigger_obj.Get_Type() == Find_Object_Type("DWARF_SPIDER_DROID_SQUAD") then
			local droid_team = trigger_obj.Get_Parent_Object()
			if TestValid(droid_team) then
				if not droid_team.Has_Active_Orders() then
					droid_team.Despawn()
					Story_Event("REFILL_02")
				end
			end
		end
	end
end

function State_Patrol_Despawn_3(prox_obj, trigger_obj)
	if TestValid(trigger_obj) then
		if trigger_obj.Get_Type() == Find_Object_Type("OOM_SECURITY_SQUAD") 
		or trigger_obj.Get_Type() == Find_Object_Type("B1_DROID_MARINE_SQUAD_DEPLOYED")
		or trigger_obj.Get_Type() == Find_Object_Type("B2_DROID_DEPLOYED")
		or trigger_obj.Get_Type() == Find_Object_Type("BX_COMMANDO_TEAM_DEPLOYED")
		or trigger_obj.Get_Type() == Find_Object_Type("DWARF_SPIDER_DROID_SQUAD") then
			local droid_team = trigger_obj.Get_Parent_Object()
			if TestValid(droid_team) then
				if not droid_team.Has_Active_Orders() then
					droid_team.Despawn()
					Story_Event("REFILL_03")
				end
			end
		end
	end
end

function State_Patrol_Despawn_4(prox_obj, trigger_obj)
	if TestValid(trigger_obj) then
		if trigger_obj.Get_Type() == Find_Object_Type("OOM_SECURITY_SQUAD") 
		or trigger_obj.Get_Type() == Find_Object_Type("B1_DROID_MARINE_SQUAD_DEPLOYED")
		or trigger_obj.Get_Type() == Find_Object_Type("B2_DROID_DEPLOYED")
		or trigger_obj.Get_Type() == Find_Object_Type("BX_COMMANDO_TEAM_DEPLOYED")
		or trigger_obj.Get_Type() == Find_Object_Type("DWARF_SPIDER_DROID_SQUAD") then
			local droid_team = trigger_obj.Get_Parent_Object()
			if TestValid(droid_team) then
				if not droid_team.Has_Active_Orders() then
					droid_team.Despawn()
					Story_Event("REFILL_04")
				end
			end
		end
	end
end


function State_Patrol_Loop_1_1(prox_obj, trigger_obj)
	if TestValid(trigger_obj) then
		if trigger_obj.Get_Type() == Find_Object_Type("OOM_SECURITY_SQUAD") 
		or trigger_obj.Get_Type() == Find_Object_Type("B1_DROID_MARINE_SQUAD_DEPLOYED")
		or trigger_obj.Get_Type() == Find_Object_Type("B2_DROID_DEPLOYED")
		or trigger_obj.Get_Type() == Find_Object_Type("BX_COMMANDO_TEAM_DEPLOYED")
		or trigger_obj.Get_Type() == Find_Object_Type("DWARF_SPIDER_DROID_SQUAD") then
			local droid_team = trigger_obj.Get_Parent_Object()
			if TestValid(droid_team) then
				if not droid_team.Has_Active_Orders() then
					droid_team.Attack_Move(patrol_loop_1_2_marker.Get_Position())
				end
			end
		end
	end
end

function State_Patrol_Loop_1_2(prox_obj, trigger_obj)
	if TestValid(trigger_obj) then
		if trigger_obj.Get_Type() == Find_Object_Type("OOM_SECURITY_SQUAD") 
		or trigger_obj.Get_Type() == Find_Object_Type("B1_DROID_MARINE_SQUAD_DEPLOYED")
		or trigger_obj.Get_Type() == Find_Object_Type("B2_DROID_DEPLOYED")
		or trigger_obj.Get_Type() == Find_Object_Type("BX_COMMANDO_TEAM_DEPLOYED")
		or trigger_obj.Get_Type() == Find_Object_Type("DWARF_SPIDER_DROID_SQUAD") then
			local droid_team = trigger_obj.Get_Parent_Object()
			if TestValid(droid_team) then
				if not droid_team.Has_Active_Orders() then
					droid_team.Attack_Move(patrol_loop_1_3_marker.Get_Position())
				end
			end
		end
	end
end

function State_Patrol_Loop_1_3(prox_obj, trigger_obj)
	if TestValid(trigger_obj) then
		if trigger_obj.Get_Type() == Find_Object_Type("OOM_SECURITY_SQUAD") 
		or trigger_obj.Get_Type() == Find_Object_Type("B1_DROID_MARINE_SQUAD_DEPLOYED")
		or trigger_obj.Get_Type() == Find_Object_Type("B2_DROID_DEPLOYED")
		or trigger_obj.Get_Type() == Find_Object_Type("BX_COMMANDO_TEAM_DEPLOYED")
		or trigger_obj.Get_Type() == Find_Object_Type("DWARF_SPIDER_DROID_SQUAD") then
			local droid_team = trigger_obj.Get_Parent_Object()
			if TestValid(droid_team) then
				if not droid_team.Has_Active_Orders() then
					droid_team.Attack_Move(patrol_loop_1_4_marker.Get_Position())
				end
			end
		end
	end
end

function State_Patrol_Loop_1_4(prox_obj, trigger_obj)
	if TestValid(trigger_obj) then
		if trigger_obj.Get_Type() == Find_Object_Type("OOM_SECURITY_SQUAD") 
		or trigger_obj.Get_Type() == Find_Object_Type("B1_DROID_MARINE_SQUAD_DEPLOYED")
		or trigger_obj.Get_Type() == Find_Object_Type("B2_DROID_DEPLOYED")
		or trigger_obj.Get_Type() == Find_Object_Type("BX_COMMANDO_TEAM_DEPLOYED")
		or trigger_obj.Get_Type() == Find_Object_Type("DWARF_SPIDER_DROID_SQUAD") then
			local droid_team = trigger_obj.Get_Parent_Object()
			if TestValid(droid_team) then
				if not droid_team.Has_Active_Orders() then
					droid_team.Attack_Move(patrol_loop_1_5_marker.Get_Position())
				end
			end
		end
	end
end

function State_Patrol_Loop_1_5(prox_obj, trigger_obj)
	if TestValid(trigger_obj) then
		if trigger_obj.Get_Type() == Find_Object_Type("OOM_SECURITY_SQUAD") 
		or trigger_obj.Get_Type() == Find_Object_Type("B1_DROID_MARINE_SQUAD_DEPLOYED")
		or trigger_obj.Get_Type() == Find_Object_Type("B2_DROID_DEPLOYED")
		or trigger_obj.Get_Type() == Find_Object_Type("BX_COMMANDO_TEAM_DEPLOYED")
		or trigger_obj.Get_Type() == Find_Object_Type("DWARF_SPIDER_DROID_SQUAD") then
			local droid_team = trigger_obj.Get_Parent_Object()
			if TestValid(droid_team) then
				if not droid_team.Has_Active_Orders() then
					droid_team.Attack_Move(patrol_despawn_1_marker.Get_Position())
				end
			end
		end
	end
end


function State_Patrol_Loop_2_1(prox_obj, trigger_obj)
	if TestValid(trigger_obj) then
		if trigger_obj.Get_Type() == Find_Object_Type("OOM_SECURITY_SQUAD") 
		or trigger_obj.Get_Type() == Find_Object_Type("B1_DROID_MARINE_SQUAD_DEPLOYED")
		or trigger_obj.Get_Type() == Find_Object_Type("B2_DROID_DEPLOYED")
		or trigger_obj.Get_Type() == Find_Object_Type("BX_COMMANDO_TEAM_DEPLOYED")
		or trigger_obj.Get_Type() == Find_Object_Type("DWARF_SPIDER_DROID_SQUAD") then
			local droid_team = trigger_obj.Get_Parent_Object()
			if TestValid(droid_team) then
				if not droid_team.Has_Active_Orders() then
					droid_team.Attack_Move(patrol_loop_2_2_marker.Get_Position())
				end
			end
		end
	end
end

function State_Patrol_Loop_2_2(prox_obj, trigger_obj)
	if TestValid(trigger_obj) then
		if trigger_obj.Get_Type() == Find_Object_Type("OOM_SECURITY_SQUAD") 
		or trigger_obj.Get_Type() == Find_Object_Type("B1_DROID_MARINE_SQUAD_DEPLOYED")
		or trigger_obj.Get_Type() == Find_Object_Type("B2_DROID_DEPLOYED")
		or trigger_obj.Get_Type() == Find_Object_Type("BX_COMMANDO_TEAM_DEPLOYED")
		or trigger_obj.Get_Type() == Find_Object_Type("DWARF_SPIDER_DROID_SQUAD") then
			local droid_team = trigger_obj.Get_Parent_Object()
			if TestValid(droid_team) then
				if not droid_team.Has_Active_Orders() then
					droid_team.Attack_Move(patrol_loop_2_3_marker.Get_Position())
				end
			end
		end
	end
end

function State_Patrol_Loop_2_3(prox_obj, trigger_obj)
	if TestValid(trigger_obj) then
		if trigger_obj.Get_Type() == Find_Object_Type("OOM_SECURITY_SQUAD") 
		or trigger_obj.Get_Type() == Find_Object_Type("B1_DROID_MARINE_SQUAD_DEPLOYED")
		or trigger_obj.Get_Type() == Find_Object_Type("B2_DROID_DEPLOYED")
		or trigger_obj.Get_Type() == Find_Object_Type("BX_COMMANDO_TEAM_DEPLOYED")
		or trigger_obj.Get_Type() == Find_Object_Type("DWARF_SPIDER_DROID_SQUAD") then
			local droid_team = trigger_obj.Get_Parent_Object()
			if TestValid(droid_team) then
				if not droid_team.Has_Active_Orders() then
					droid_team.Attack_Move(patrol_loop_2_4_marker.Get_Position())
				end
			end
		end
	end
end

function State_Patrol_Loop_2_4(prox_obj, trigger_obj)
	if TestValid(trigger_obj) then
		if trigger_obj.Get_Type() == Find_Object_Type("OOM_SECURITY_SQUAD") 
		or trigger_obj.Get_Type() == Find_Object_Type("B1_DROID_MARINE_SQUAD_DEPLOYED")
		or trigger_obj.Get_Type() == Find_Object_Type("B2_DROID_DEPLOYED")
		or trigger_obj.Get_Type() == Find_Object_Type("BX_COMMANDO_TEAM_DEPLOYED")
		or trigger_obj.Get_Type() == Find_Object_Type("DWARF_SPIDER_DROID_SQUAD") then
			local droid_team = trigger_obj.Get_Parent_Object()
			if TestValid(droid_team) then
				if not droid_team.Has_Active_Orders() then
					droid_team.Attack_Move(patrol_loop_2_5_marker.Get_Position())
				end
			end
		end
	end
end

function State_Patrol_Loop_2_5(prox_obj, trigger_obj)
	if TestValid(trigger_obj) then
		if trigger_obj.Get_Type() == Find_Object_Type("OOM_SECURITY_SQUAD") 
		or trigger_obj.Get_Type() == Find_Object_Type("B1_DROID_MARINE_SQUAD_DEPLOYED")
		or trigger_obj.Get_Type() == Find_Object_Type("B2_DROID_DEPLOYED")
		or trigger_obj.Get_Type() == Find_Object_Type("BX_COMMANDO_TEAM_DEPLOYED")
		or trigger_obj.Get_Type() == Find_Object_Type("DWARF_SPIDER_DROID_SQUAD") then
			local droid_team = trigger_obj.Get_Parent_Object()
			if TestValid(droid_team) then
				if not droid_team.Has_Active_Orders() then
					droid_team.Attack_Move(patrol_despawn_2_marker.Get_Position())
				end
			end
		end
	end
end


function State_Patrol_Loop_3_1(prox_obj, trigger_obj)
	if TestValid(trigger_obj) then
		if trigger_obj.Get_Type() == Find_Object_Type("OOM_SECURITY_SQUAD") 
		or trigger_obj.Get_Type() == Find_Object_Type("B1_DROID_MARINE_SQUAD_DEPLOYED")
		or trigger_obj.Get_Type() == Find_Object_Type("B2_DROID_DEPLOYED")
		or trigger_obj.Get_Type() == Find_Object_Type("BX_COMMANDO_TEAM_DEPLOYED")
		or trigger_obj.Get_Type() == Find_Object_Type("DWARF_SPIDER_DROID_SQUAD") then
			local droid_team = trigger_obj.Get_Parent_Object()
			if TestValid(droid_team) then
				if not droid_team.Has_Active_Orders() then
					droid_team.Attack_Move(patrol_loop_3_2_marker.Get_Position())
				end
			end
		end
	end
end

function State_Patrol_Loop_3_2(prox_obj, trigger_obj)
	if TestValid(trigger_obj) then
		if trigger_obj.Get_Type() == Find_Object_Type("OOM_SECURITY_SQUAD") 
		or trigger_obj.Get_Type() == Find_Object_Type("B1_DROID_MARINE_SQUAD_DEPLOYED")
		or trigger_obj.Get_Type() == Find_Object_Type("B2_DROID_DEPLOYED")
		or trigger_obj.Get_Type() == Find_Object_Type("BX_COMMANDO_TEAM_DEPLOYED")
		or trigger_obj.Get_Type() == Find_Object_Type("DWARF_SPIDER_DROID_SQUAD") then
			local droid_team = trigger_obj.Get_Parent_Object()
			if TestValid(droid_team) then
				if not droid_team.Has_Active_Orders() then
					droid_team.Attack_Move(patrol_loop_3_3_marker.Get_Position())
				end
			end
		end
	end
end

function State_Patrol_Loop_3_3(prox_obj, trigger_obj)
	if TestValid(trigger_obj) then
		if trigger_obj.Get_Type() == Find_Object_Type("OOM_SECURITY_SQUAD") 
		or trigger_obj.Get_Type() == Find_Object_Type("B1_DROID_MARINE_SQUAD_DEPLOYED")
		or trigger_obj.Get_Type() == Find_Object_Type("B2_DROID_DEPLOYED")
		or trigger_obj.Get_Type() == Find_Object_Type("BX_COMMANDO_TEAM_DEPLOYED")
		or trigger_obj.Get_Type() == Find_Object_Type("DWARF_SPIDER_DROID_SQUAD") then
			local droid_team = trigger_obj.Get_Parent_Object()
			if TestValid(droid_team) then
				if not droid_team.Has_Active_Orders() then
					droid_team.Attack_Move(patrol_loop_3_4_marker.Get_Position())
				end
			end
		end
	end
end

function State_Patrol_Loop_3_4(prox_obj, trigger_obj)
	if TestValid(trigger_obj) then
		if trigger_obj.Get_Type() == Find_Object_Type("OOM_SECURITY_SQUAD") 
		or trigger_obj.Get_Type() == Find_Object_Type("B1_DROID_MARINE_SQUAD_DEPLOYED")
		or trigger_obj.Get_Type() == Find_Object_Type("B2_DROID_DEPLOYED")
		or trigger_obj.Get_Type() == Find_Object_Type("BX_COMMANDO_TEAM_DEPLOYED")
		or trigger_obj.Get_Type() == Find_Object_Type("DWARF_SPIDER_DROID_SQUAD") then
			local droid_team = trigger_obj.Get_Parent_Object()
			if TestValid(droid_team) then
				if not droid_team.Has_Active_Orders() then
					droid_team.Attack_Move(patrol_loop_3_5_marker.Get_Position())
				end
			end
		end
	end
end

function State_Patrol_Loop_3_5(prox_obj, trigger_obj)
	if TestValid(trigger_obj) then
		if trigger_obj.Get_Type() == Find_Object_Type("OOM_SECURITY_SQUAD") 
		or trigger_obj.Get_Type() == Find_Object_Type("B1_DROID_MARINE_SQUAD_DEPLOYED")
		or trigger_obj.Get_Type() == Find_Object_Type("B2_DROID_DEPLOYED")
		or trigger_obj.Get_Type() == Find_Object_Type("BX_COMMANDO_TEAM_DEPLOYED")
		or trigger_obj.Get_Type() == Find_Object_Type("DWARF_SPIDER_DROID_SQUAD") then
			local droid_team = trigger_obj.Get_Parent_Object()
			if TestValid(droid_team) then
				if not droid_team.Has_Active_Orders() then
					droid_team.Attack_Move(patrol_despawn_3_marker.Get_Position())
				end
			end
		end
	end
end


function State_Patrol_Loop_4_1(prox_obj, trigger_obj)
	if TestValid(trigger_obj) then
		if trigger_obj.Get_Type() == Find_Object_Type("OOM_SECURITY_SQUAD") 
		or trigger_obj.Get_Type() == Find_Object_Type("B1_DROID_MARINE_SQUAD_DEPLOYED")
		or trigger_obj.Get_Type() == Find_Object_Type("B2_DROID_DEPLOYED")
		or trigger_obj.Get_Type() == Find_Object_Type("BX_COMMANDO_TEAM_DEPLOYED")
		or trigger_obj.Get_Type() == Find_Object_Type("DWARF_SPIDER_DROID_SQUAD") then
			local droid_team = trigger_obj.Get_Parent_Object()
			if TestValid(droid_team) then
				if not droid_team.Has_Active_Orders() then
					droid_team.Attack_Move(patrol_loop_4_2_marker.Get_Position())
				end
			end
		end
	end
end

function State_Patrol_Loop_4_2(prox_obj, trigger_obj)
	if TestValid(trigger_obj) then
		if trigger_obj.Get_Type() == Find_Object_Type("OOM_SECURITY_SQUAD") 
		or trigger_obj.Get_Type() == Find_Object_Type("B1_DROID_MARINE_SQUAD_DEPLOYED")
		or trigger_obj.Get_Type() == Find_Object_Type("B2_DROID_DEPLOYED")
		or trigger_obj.Get_Type() == Find_Object_Type("BX_COMMANDO_TEAM_DEPLOYED")
		or trigger_obj.Get_Type() == Find_Object_Type("DWARF_SPIDER_DROID_SQUAD") then
			local droid_team = trigger_obj.Get_Parent_Object()
			if TestValid(droid_team) then
				if not droid_team.Has_Active_Orders() then
					droid_team.Attack_Move(patrol_loop_4_3_marker.Get_Position())
				end
			end
		end
	end
end

function State_Patrol_Loop_4_3(prox_obj, trigger_obj)
	if TestValid(trigger_obj) then
		if trigger_obj.Get_Type() == Find_Object_Type("OOM_SECURITY_SQUAD") 
		or trigger_obj.Get_Type() == Find_Object_Type("B1_DROID_MARINE_SQUAD_DEPLOYED")
		or trigger_obj.Get_Type() == Find_Object_Type("B2_DROID_DEPLOYED")
		or trigger_obj.Get_Type() == Find_Object_Type("BX_COMMANDO_TEAM_DEPLOYED")
		or trigger_obj.Get_Type() == Find_Object_Type("DWARF_SPIDER_DROID_SQUAD") then
			local droid_team = trigger_obj.Get_Parent_Object()
			if TestValid(droid_team) then
				if not droid_team.Has_Active_Orders() then
					droid_team.Attack_Move(patrol_loop_4_4_marker.Get_Position())
				end
			end
		end
	end
end

function State_Patrol_Loop_4_4(prox_obj, trigger_obj)
	if TestValid(trigger_obj) then
		if trigger_obj.Get_Type() == Find_Object_Type("OOM_SECURITY_SQUAD") 
		or trigger_obj.Get_Type() == Find_Object_Type("B1_DROID_MARINE_SQUAD_DEPLOYED")
		or trigger_obj.Get_Type() == Find_Object_Type("B2_DROID_DEPLOYED")
		or trigger_obj.Get_Type() == Find_Object_Type("BX_COMMANDO_TEAM_DEPLOYED")
		or trigger_obj.Get_Type() == Find_Object_Type("DWARF_SPIDER_DROID_SQUAD") then
			local droid_team = trigger_obj.Get_Parent_Object()
			if TestValid(droid_team) then
				if not droid_team.Has_Active_Orders() then
					droid_team.Attack_Move(patrol_loop_4_5_marker.Get_Position())
				end
			end
		end
	end
end

function State_Patrol_Loop_4_5(prox_obj, trigger_obj)
	if TestValid(trigger_obj) then
		if trigger_obj.Get_Type() == Find_Object_Type("OOM_SECURITY_SQUAD") 
		or trigger_obj.Get_Type() == Find_Object_Type("B1_DROID_MARINE_SQUAD_DEPLOYED")
		or trigger_obj.Get_Type() == Find_Object_Type("B2_DROID_DEPLOYED")
		or trigger_obj.Get_Type() == Find_Object_Type("BX_COMMANDO_TEAM_DEPLOYED")
		or trigger_obj.Get_Type() == Find_Object_Type("DWARF_SPIDER_DROID_SQUAD") then
			local droid_team = trigger_obj.Get_Parent_Object()
			if TestValid(droid_team) then
				if not droid_team.Has_Active_Orders() then
					droid_team.Attack_Move(patrol_despawn_4_marker.Get_Position())
				end
			end
		end
	end
end


function State_Padme_Reached(prox_obj, trigger_obj)
	if TestValid(trigger_obj) then
		if trigger_obj == player_anakin then
			prox_obj.Cancel_Event_Object_In_Range(State_Padme_Reached)

			padme_reached = true

			Stop_All_Music()
			StoryUtil.CinematicEnvironmentOn()

			StoryUtil.PlayGenericSpeech("Subjugator_Sabotage_02")
			Stop_All_Music()
			Play_Music("Silence_Theme")
			Story_Event("PADME_REACHED")

			player_padme.Change_Owner(p_republic)

			Remove_Radar_Blip("padme_blip")
			player_padme.Highlight(false)

			Add_Radar_Blip(elevator_entry_marker, "elevator_entry_blip")
			elevator_entry_marker.Highlight(true)

			Story_Event("GOAL_TRIGGER_REP_II")

			Register_Prox(elevator_entry_marker, State_Elevator_Entry_Reached, 150, p_republic)
			Register_Prox(bridge_marker, State_Bridge_Reached, 250, p_republic)

			act_1_active = false
			act_2_active = true

			Sleep(11)
			StoryUtil.CinematicEnvironmentOff()
		end
	end
end

function State_Elevator_Entry_Reached(prox_obj, trigger_obj)
	if TestValid(trigger_obj) then
		if trigger_obj == player_anakin then
			anakin_reached_elevator_entry = true
		end
		if trigger_obj == player_padme then
			padme_reached_elevator_entry = true
		end
		if anakin_reached_elevator_entry and padme_reached_elevator_entry then
			prox_obj.Cancel_Event_Object_In_Range(State_Elevator_Entry_Reached)
			elevator_entry_reached = true

			Remove_Radar_Blip("elevator_entry_blip")
			elevator_entry_marker.Highlight(false)

			Add_Radar_Blip(bridge_marker, "bridge_blip")
			bridge_marker.Highlight(true)

			player_anakin.Teleport_And_Face(midtro_1_anakin_marker)
			player_padme.Teleport_And_Face(midtro_1_padme_marker)

			player_obiwan.Change_Owner(p_neutral)
			Point_Camera_At(player_anakin)
		end
	end
end

function State_Bridge_Reached(prox_obj, trigger_obj)
	if TestValid(trigger_obj) then
		if trigger_obj == player_anakin then
			anakin_reached_bridge = true
		end
		if trigger_obj == player_padme then
			padme_reached_bridge = true
		end
		if anakin_reached_bridge and padme_reached_bridge then
			prox_obj.Cancel_Event_Object_In_Range(State_Bridge_Reached)

			bridge_reached = true

			Stop_All_Music()
			StoryUtil.CinematicEnvironmentOn()

			StoryUtil.PlayGenericSpeech("Subjugator_Sabotage_03")
			Stop_All_Music()
			Play_Music("Silence_Theme")
			Story_Event("BRIDGE_REACHED")

			Remove_Radar_Blip("bridge_blip")
			bridge_marker.Highlight(false)

			Add_Radar_Blip(bridge_exit_marker, "elevator_exit_blip")
			bridge_exit_marker.Highlight(true)

			door_list = Find_All_Objects_Of_Type("CIS_DOOR_HUGE_ANIMATED")
			for h,doors in pairs(door_list) do
				if TestValid(doors) then
					doors.Play_Animation("Cinematic", false, 1)
				end	
			end

			Register_Prox(bridge_exit_marker, State_Bridge_Exit_Reached, 100, p_republic)
			Sleep(27)

			if not cinematic_two then
				StoryUtil.CinematicEnvironmentOff()
				StoryUtil.CinematicEnvironmentOff()
			end
		end
	end
end

function State_Bridge_Exit_Reached(prox_obj, trigger_obj)
	if TestValid(trigger_obj) then
		if trigger_obj == player_anakin then
			anakin_reached_bridge_exit = true
		end
		if trigger_obj == player_padme then
			padme_reached_bridge_exit = true
		end

		if anakin_reached_bridge_exit and padme_reached_bridge_exit then
			prox_obj.Cancel_Event_Object_In_Range(State_Bridge_Exit_Reached)
			bridge_exit_reached = true

			Remove_Radar_Blip("elevator_exit_blip")
			bridge_exit_marker.Highlight(false)

			player_anakin.Teleport_And_Face(midtro_2_anakin_marker)
			player_anakin.Change_Owner(p_neutral)

			player_padme.Teleport_And_Face(midtro_2_padme_marker)
			player_padme.Change_Owner(p_neutral)

			player_obiwan.Change_Owner(p_republic)

			Point_Camera_At(player_obiwan)

			Story_Event("GOAL_TRIGGER_REP_III")

			Add_Radar_Blip(hyperdrive_marker, "hyperdrive_blip")
			hyperdrive_marker.Highlight(true)

			Register_Prox(hyperdrive_marker, State_Hyperdrive_Reached, 150, p_republic)

			act_2_active = false
			act_3_active = true
		end
	end
end

function State_Hyperdrive_Reached(prox_obj, trigger_obj)
	if TestValid(trigger_obj) then
		if trigger_obj == player_obiwan then
			prox_obj.Cancel_Event_Object_In_Range(State_Hyperdrive_Reached)
			Story_Event("HYPERDRIVE_REACHED")
			hyperdrive_reached = true
		end
	end
end

function State_Hyperdrive_Sabotage(message)
	if message == OnEnter then
		current_cinematic_thread_id = Create_Thread("Start_Cinematic_Midtro_03_Rep")
	end
end

function State_Escape_Reached(prox_obj, trigger_obj)
	if padme_reached and bridge_reached and hyperdrive_reached then
		if trigger_obj == player_anakin then
			anakin_reached_escape = true
		end
		if trigger_obj == player_obiwan then
			obiwan_reached_escape = true
		end
		if trigger_obj == player_padme then
			padme_reached_escape = true
		end

		if anakin_reached_escape and obiwan_reached_escape and padme_reached_escape then
			Remove_Radar_Blip("escape_blip")
			escape_marker.Highlight(false)
			Story_Event("ESCAPE_REACHED")
			prox_obj.Cancel_Event_Object_In_Range(State_Escape_Reached)
			current_cinematic_thread_id = Create_Thread("Start_Cinematic_Outro_Rep")
		end
	end
end


function Tell_Units_To_Guard(unit_list)

	for i, unit in pairs(unit_list) do
		if unit.Get_Hint() == "guard" then
			unit.Guard_Target(unit.Get_Position())
		end
	end
	
end


function Story_Handle_Esc()
	if mission_started then
		if p_cis.Is_Human() then
			if cinematic_one then
				if not cinematic_one_skipped then
					cinematic_one_skipped = true
					-- MessageBox("Escape Key Pressed!!!")

					if current_cinematic_thread_id ~= nil then
						Thread.Kill(current_cinematic_thread_id)
						current_cinematic_thread_id = nil
					end

					player_cinematic_door.Play_Animation("Cinematic", false, 1)

					Fade_On()
					Stop_All_Music()
					Stop_All_Speech()
					current_cinematic_thread_id = Create_Thread("Start_Cinematic_Midtro_01_CIS")
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

					Fade_On()
					Stop_All_Music()
					Stop_All_Speech()
					current_cinematic_thread_id = Create_Thread("Start_Cinematic_Midtro_02_CIS")
				end
			end
			if cinematic_three then
				if not cinematic_three_skipped then
					cinematic_three_skipped = true
					-- MessageBox("Escape Key Pressed!!!")

					if current_cinematic_thread_id ~= nil then
						Thread.Kill(current_cinematic_thread_id)
						current_cinematic_thread_id = nil
					end

					Fade_On()
					Stop_All_Music()
					Stop_All_Speech()
					current_cinematic_thread_id = Create_Thread("Start_Cinematic_Outro_CIS")
				end
			end
			if cinematic_five then
				if not cinematic_five_skipped then
					cinematic_five_skipped = true
					-- MessageBox("Escape Key Pressed!!!")

					if current_cinematic_thread_id ~= nil then
						Thread.Kill(current_cinematic_thread_id)
						current_cinematic_thread_id = nil
					end

					StoryUtil.CinematicEnvironmentOff()

					GlobalValue.Set("Allow_AI_Controlled_Fog_Reveal", 1)
					GlobalValue.Set("HfM_Malevolence_Alive", 0)

					StoryUtil.DeclareVictory(p_republic, false)
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

					player_cinematic_door.Play_Animation("Cinematic", false, 1)

					player_intro_b1_1 = Find_Hint("B1_DROID", "intro1b11")
					if TestValid(player_intro_b1_1) then
						player_intro_b1_1.Despawn()
					end

					player_intro_b1_2 = Find_Hint("B1_DROID", "intro1b12")
					if TestValid(player_intro_b1_2) then
						player_intro_b1_2.Despawn()
					end

					player_padme = Find_First_Object("PADME_AMIDALA")
					player_padme.Move_To(intro_2_padme_marker)

					player_anakin = Find_First_Object("ANAKIN2")
					player_anakin.Suspend_Locomotor(false)
					Hide_Sub_Object(player_anakin, 0, "lightsaber");
					player_anakin.Teleport_And_Face(intro_3_anakin_marker)

					player_obiwan = Find_First_Object("OBI_WAN")
					player_obiwan.Suspend_Locomotor(false)
					Hide_Sub_Object(player_obiwan, 0, "lightsaber");
					player_obiwan.Teleport_And_Face(intro_3_obiwan_marker)

					Letter_Box_Out(0)
					Point_Camera_At(player_anakin)
					Story_Event("GOAL_TRIGGER_REP_I")
					Lock_Controls(0)
					Suspend_AI(0)
					End_Cinematic_Camera()

					Add_Radar_Blip(player_padme, "padme_blip")
					player_padme.Highlight(true)

					p_republic.Make_Enemy(p_cis)
					p_cis.Make_Enemy(p_republic)

					cinematic_one = false
					act_1_active = true

					Register_Prox(player_padme, State_Padme_Reached, 150, p_republic)

					Fade_Screen_In(0.5)
					Sleep(0.5)
				end
			end
			if cinematic_four then
				if not cinematic_four_skipped then
					cinematic_four_skipped = true
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

					Remove_Radar_Blip("hyperdrive_blip")

					hyperdrive_marker.Highlight(false)

					Add_Radar_Blip(escape_marker, "escape_blip")
					escape_marker.Highlight(true)

					Register_Prox(escape_marker, State_Escape_Reached, 200, p_republic)

					player_anakin.Change_Owner(p_republic)
					player_anakin.Move_To(escape_marker)

					player_padme.Change_Owner(p_republic)
					player_padme.Move_To(escape_marker)

					player_obiwan.Teleport_And_Face(midtro_2_obiwan_marker)

					if not TestValid(player_grievous) then
						grievous_unit = Find_Object_Type("General_Grievous")
						grievous_list = Spawn_Unit(grievous_unit, midtro_1_grievous_marker, p_cis)
						player_grievous = grievous_list[1]
						player_grievous.Teleport_And_Face(midtro_1_grievous_marker)
						player_grievous.Set_Garrison_Spawn(false)

						magna_unit = Find_Object_Type("Magnaguard")

						magna_1_list = Spawn_Unit(magna_unit, midtro_1_magna_1_marker, p_cis)
						player_magna_1 = magna_1_list[1]
						player_magna_1.Teleport_And_Face(midtro_1_magna_1_marker)

						magna_2_list = Spawn_Unit(magna_unit, midtro_1_magna_2_marker, p_cis)
						player_magna_2 = magna_2_list[1]
						player_magna_2.Teleport_And_Face(midtro_1_magna_2_marker)
					end

					p_republic.Make_Enemy(p_cis)
					p_cis.Make_Enemy(p_republic)

					Letter_Box_Out(0)
					Point_Camera_At(player_obiwan)
					Story_Event("GOAL_TRIGGER_REP_IV")
					Lock_Controls(0)
					Suspend_AI(0)
					End_Cinematic_Camera()

					Fade_Screen_In(0.5)
					Sleep(0.5)

					cinematic_four = false
					act_4_active = true
				end
			end
			if cinematic_five then
				if not cinematic_five_skipped then
					cinematic_five_skipped = true
					-- MessageBox("Escape Key Pressed!!!")

					if current_cinematic_thread_id ~= nil then
						Thread.Kill(current_cinematic_thread_id)
						current_cinematic_thread_id = nil
					end

					StoryUtil.CinematicEnvironmentOff()

					GlobalValue.Set("Allow_AI_Controlled_Fog_Reveal", 1)
					GlobalValue.Set("HfM_Malevolence_Alive", 0)

					StoryUtil.DeclareVictory(p_republic, false)
				end
			end
		end
	end
end

function Story_Mode_Service()
	if p_republic.Is_Human() then
		if act_1_active or act_2_active or act_3_active then
			droid_marine_commander_list = Find_All_Objects_Of_Type("B1_Droid_Marine_Commander")
			if (table.getn(droid_marine_commander_list) < 10) then
				refill_gamble_2 = GameRandom(1, 4)
				if refill_gamble_2 == 1 then
					Story_Event("REFILL_01")
				elseif refill_gamble_2 == 2 then
					Story_Event("REFILL_02")
				elseif refill_gamble_2 == 3 then
					Story_Event("REFILL_03")
				elseif refill_gamble_2 == 4 then
					Story_Event("REFILL_04")
				end
			end
		end
	end
end


function Start_Cinematic_Intro_Rep()

	cinematic_one = true
	Start_Cinematic_Camera()
	Suspend_AI(1)
	Lock_Controls(1)
	Cancel_Fast_Forward()

	Stop_All_Music()
	StoryUtil.CinematicEnvironmentOn()

	Fade_On()

	StoryUtil.PlayGenericSpeech("Subjugator_Sabotage_01")
	StoryUtil.PlayGenericMusic("Silence_Theme")
	Sleep(0.25)

	player_intro_b1_1 = Find_Hint("B1_DROID", "intro1b11")
	player_intro_b1_1.Prevent_All_Fire(true)
	player_intro_b1_1.Teleport_And_Face(intro_1_b1_1_marker)
	player_intro_b1_1.Play_Animation("Idle", false, 1)

	player_intro_b1_2 = Find_Hint("B1_DROID", "intro1b12")
	player_intro_b1_2.Prevent_All_Fire(true)
	player_intro_b1_2.Teleport_And_Face(intro_1_b1_2_marker)

	Set_Cinematic_Camera_Key(introcam_1_marker, 0, 0, 0, 1, 0, 0, 0)
	Set_Cinematic_Target_Key(introcam_1_marker, 0, 0, 0, 0, player_intro_b1_1, 1, 0)
	Transition_Cinematic_Camera_Key(introcam_2_marker, 16, 0, 0, 0, 1, 0, 0, 0)
	Transition_Cinematic_Target_Key(introcam_2_marker, 16, 0, 0, 0, 0, player_intro_b1_1, 1, 0)

	Letter_Box_In(0.5)
	Fade_Screen_In(0.5)

	Sleep(2)

	player_intro_b1_1.Turn_To_Face(player_intro_b1_2)
	Sleep(1)

	player_intro_b1_1.Play_Animation("Idle", false, 0)
	Sleep(1)

	player_intro_b1_2.Turn_To_Face(player_intro_b1_1)
	Sleep(0.5)
	player_intro_b1_2.Play_Animation("Idle", false, 1)
	Sleep(1.5)

	player_intro_b1_1.Play_Animation("Idle", false, 1)
	Sleep(2)

	player_anakin = Find_First_Object("ANAKIN2")
	Hide_Sub_Object(player_anakin, 1, "lightsaber");
	player_anakin.Teleport_And_Face(intro_1_anakin_marker)

	player_obiwan = Find_First_Object("OBI_WAN")
	Hide_Sub_Object(player_obiwan, 1, "lightsaber");
	player_obiwan.Teleport_And_Face(intro_1_obiwan_marker)

	Set_Cinematic_Camera_Key(introcam_3_marker, 0, 0, 5, 1, 0, 0, 0)
	Set_Cinematic_Target_Key(introcam_3_marker, 0, 4, 1, 0, player_intro_b1_1, 1, 0)
	Transition_Cinematic_Camera_Key(introcam_4_marker, 24, 0, 0, 5, 1, 0, 0, 0)
	Transition_Cinematic_Target_Key(introcam_4_marker, 24, 0, 4, 1, 0, player_intro_b1_1, 1, 0)
	Sleep(4)

	Set_Cinematic_Camera_Key(introcam_5_marker, 0, 0, 5, 1, 0, 0, 0)
	Set_Cinematic_Target_Key(introcam_5_marker, 0, 2, 1, 0, player_obiwan, 1, 0)
	Transition_Cinematic_Camera_Key(introcam_6_marker, 8, 0, 0, 5, 1, 0, 0, 0)
	Transition_Cinematic_Target_Key(introcam_6_marker, 8, 0, 0, 0, 0, player_obiwan, 1, 0)

	player_obiwan.Turn_To_Face(player_anakin)
	player_obiwan.Play_Animation("Talk", false, 0)
	Sleep(4.5)

	player_anakin.Play_Animation("Talk", false, 0)
	Sleep(1.0)

	player_cinematic_door.Play_Animation("Cinematic", false, 1)
	player_obiwan.Turn_To_Face(introcam_4_marker)
	Sleep(0.5)
	player_obiwan.Play_Animation("Talk", false, 0)

	Set_Cinematic_Camera_Key(introcam_7_marker, 0, 0, 0, 1, 0, 0, 0)
	Set_Cinematic_Target_Key(introcam_7_marker, 0, 0, 0, 0, player_intro_b1_1, 1, 0)
	Transition_Cinematic_Camera_Key(introcam_8_marker, 6, 0, 0, 5, 1, 0, 0, 0)
	Transition_Cinematic_Target_Key(introcam_8_marker, 8, 0, 0, 0, 0, player_intro_b1_1, 1, 0)
	Sleep(0.5)

	player_intro_b1_1.Teleport_And_Face(intro_2_b1_1_marker)
	player_intro_b1_2.Teleport_And_Face(intro_2_b1_2_marker)
	Sleep(4.0)

	player_anakin.Teleport_And_Face(intro_2_anakin_marker)
	player_obiwan.Teleport_And_Face(intro_2_obiwan_marker)

	player_intro_b1_1.Change_Owner(p_cis)
	player_intro_b1_2.Change_Owner(p_cis)

	Hide_Sub_Object(player_anakin, 0, "lightsaber");
	player_anakin.Attack_Move(player_intro_b1_1)

	Hide_Sub_Object(player_obiwan, 0, "lightsaber");
	player_obiwan.Attack_Move(player_intro_b1_2)

	Sleep(0.5)

	Set_Cinematic_Camera_Key(introcam_9_marker, 0, 0, 0, 1, 0, 0, 0)
	Set_Cinematic_Target_Key(introcam_9_marker, 0, 0, 0, 0, player_anakin, 1, 0)
	Transition_Cinematic_Camera_Key(introcam_10_marker, 12, 0, 0, 5, 1, 0, 0, 0)
	Transition_Cinematic_Target_Key(introcam_10_marker, 12, 0, 0, 0, 0, player_obiwan, 1, 0)
	Sleep(1.0)

	player_padme = Find_First_Object("PADME_AMIDALA")

	player_anakin.Turn_To_Face(player_obiwan)
	player_obiwan.Turn_To_Face(player_anakin)
	Sleep(4)

	Set_Cinematic_Camera_Key(introcam_4_marker, 0, 0, 0, 1, 0, 0, 0)
	Set_Cinematic_Target_Key(introcam_4_marker, 0, 0, 0, 0, player_anakin, 1, 0)

	player_anakin.Turn_To_Face(outrocam_1_marker)
	player_anakin.Play_Animation("Talk", false, 0)

	Sleep(2)

	player_padme.Play_Animation("Idle", false, 0)
	Sleep(1)

	Set_Cinematic_Camera_Key(introcam_13_marker, 0, 0, 0, 1, 0, 0, 0)
	Set_Cinematic_Target_Key(introcam_13_marker, 0, 0, 0, 0, player_padme, 1, 0)
	Transition_Cinematic_Camera_Key(introcam_14_marker, 7, 0, 0, 0, 1, 0, 0, 0)
	Transition_Cinematic_Target_Key(introcam_14_marker, 7, 0, 0, 0, 0, player_padme, 1, 0)

	player_padme.Play_Animation("Idle", false, 2)
	Sleep(3)

	player_padme.Move_To(intro_2_padme_marker)
	Sleep(2)

	player_anakin.Teleport_And_Face(intro_3_anakin_marker)
	player_obiwan.Teleport_And_Face(intro_3_obiwan_marker)

	Set_Cinematic_Camera_Key(introcam_15_marker, 0, 0, 7, 1, 0, 0, 0)
	Set_Cinematic_Target_Key(introcam_15_marker, 0, 0, 0, 0, player_anakin, 1, 0)
	Transition_Cinematic_Camera_Key(introcam_16_marker, 4, 0, 0, 0, 1, 0, 0, 0)
	Transition_Cinematic_Target_Key(introcam_16_marker, 4, 0, 0, 0, 0, player_anakin, 1, 0)

	player_anakin.Turn_To_Face(player_obiwan)
	player_obiwan.Turn_To_Face(player_anakin)

	player_anakin.Play_Animation("Talk", false)
	Sleep(4)

	Hide_Sub_Object(player_anakin, 1, "lightsaber");
	Hide_Sub_Object(player_obiwan, 1, "lightsaber");

	Set_Cinematic_Camera_Key(introcam_17_marker, 0, 0, 7, 1, 0, 0, 0)
	Set_Cinematic_Target_Key(introcam_17_marker, 0, 0, 0, 0, player_anakin, 1, 0)
	Transition_Cinematic_Camera_Key(introcam_18_marker, 4, 0, 0, 0, 1, 0, 0, 0)
	Transition_Cinematic_Target_Key(introcam_18_marker, 4, 0, 0, 0, 0, player_anakin, 1, 0)

	player_anakin.Turn_To_Face(introcam_18_marker)
	player_obiwan.Turn_To_Face(introcam_18_marker)
	player_anakin.Play_Animation("Talk", false)

	Register_Prox(player_padme, State_Padme_Reached, 150, p_republic)

	Hide_Sub_Object(player_anakin, 0, "lightsaber");
	Hide_Sub_Object(player_obiwan, 0, "lightsaber");

	if not cinematic_one_skipped then
		current_cinematic_thread_id = Create_Thread("End_Cinematic_Intro_Rep")
	end
end

function End_Cinematic_Intro_Rep()

	Point_Camera_At(player_anakin)
	Transition_To_Tactical_Camera(1.5)
	Sleep(1.5)
	Letter_Box_Out(1.5)
	Sleep(1.5)
	End_Cinematic_Camera()
	Lock_Controls(0)
	Story_Event("GOAL_TRIGGER_REP_I")
	Suspend_AI(0)

	cinematic_one = false
	act_1_active = true

	Add_Radar_Blip(player_padme, "padme_blip")
	player_padme.Highlight(true)

	Sleep(15)

	StoryUtil.CinematicEnvironmentOff()
end

function Start_Cinematic_Midtro_03_Rep()

	act_3_active = false
	cinematic_four = true
	Start_Cinematic_Camera()
	Suspend_AI(1)
	Lock_Controls(1)
	Cancel_Fast_Forward()

	Remove_Radar_Blip("hyperdrive_blip")

	hyperdrive_marker.Highlight(false)

	p_republic.Make_Ally(p_cis)
	p_cis.Make_Ally(p_republic)

	Stop_All_Music()
	StoryUtil.CinematicEnvironmentOn()

	Fade_On()

	player_obiwan.Teleport_And_Face(midtro_2_obiwan_marker)

	grievous_unit = Find_Object_Type("General_Grievous")
	grievous_list = Spawn_Unit(grievous_unit, midtro_1_grievous_marker, p_cis)
	player_grievous = grievous_list[1]
	player_grievous.Teleport_And_Face(midtro_1_grievous_marker)
	player_grievous.Set_Garrison_Spawn(false)

	Hide_Sub_Object(player_grievous, 1, "Box01")
	Hide_Sub_Object(player_grievous, 1, "Box02")
	Hide_Sub_Object(player_grievous, 1, "Box03")
	Hide_Sub_Object(player_grievous, 1, "Box04")
	Hide_Sub_Object(player_grievous, 1, "Box05")
	Hide_Sub_Object(player_grievous, 1, "Box06")
	Hide_Sub_Object(player_grievous, 1, "Saber_BR")
	Hide_Sub_Object(player_grievous, 1, "Saber_BR01")
	Hide_Sub_Object(player_grievous, 1, "Saber_TR")
	Hide_Sub_Object(player_grievous, 1, "Saber_TR01")
	Hide_Sub_Object(player_grievous, 1, "Saberglow_BR")
	Hide_Sub_Object(player_grievous, 1, "Wooshglow_TR")

	StoryUtil.PlayGenericSpeech("Subjugator_Sabotage_04")
	StoryUtil.PlayGenericMusic("Silence_Theme")

	Set_Cinematic_Camera_Key(midtrocam_7_marker, 0, 0, 0, 1, 0, 0, 0)
	Set_Cinematic_Target_Key(midtrocam_7_marker, 0, 0, 0, 0, player_grievous, 1, 0)
	Transition_Cinematic_Camera_Key(midtrocam_8_marker, 6, 0, 0, 0, 1, 0, 0, 0)
	Transition_Cinematic_Target_Key(midtrocam_8_marker, 6, 0, 0, 0, 0, player_grievous, 1, 0)

	player_grievous.Play_Animation("Talk", false, 0)

	Letter_Box_In(0.5)
	Fade_Screen_In(0.5)
	Sleep(6)

	Set_Cinematic_Camera_Key(midtrocam_9_marker, 0, 0, 5, 1, 0, 0, 0)
	Set_Cinematic_Target_Key(midtrocam_9_marker, 0, 0, 0, 0, player_obiwan, 1, 0)
	Transition_Cinematic_Camera_Key(midtrocam_10_marker, 8, 0, 0, 5, 1, 0, 0, 0)
	Transition_Cinematic_Target_Key(midtrocam_10_marker, 8, 0, 0, 0, 0, player_obiwan, 1, 0)
	Sleep(1)

	player_obiwan.Play_Animation("Talk", false, 0)
	Sleep(1.5)

--player_obiwan.Play_Animation("Transition", false)
	Sleep(3.5)

	Hide_Sub_Object(player_grievous, 0, "Box01")
	Hide_Sub_Object(player_grievous, 0, "Box02")
	Hide_Sub_Object(player_grievous, 0, "Box03")
	Hide_Sub_Object(player_grievous, 0, "Box04")
	Hide_Sub_Object(player_grievous, 0, "Box05")
	Hide_Sub_Object(player_grievous, 0, "Box06")
	Hide_Sub_Object(player_grievous, 0, "Saber_BR")
	Hide_Sub_Object(player_grievous, 0, "Saber_BR01")
	Hide_Sub_Object(player_grievous, 0, "Saber_TR")
	Hide_Sub_Object(player_grievous, 0, "Saber_TR01")
	Hide_Sub_Object(player_grievous, 0, "Saberglow_BR")
	Hide_Sub_Object(player_grievous, 0, "Wooshglow_TR")
	
	player_grievous.Play_Animation("Talk", false, 2)
	
	Sleep(1.0)
	
	player_obiwan.Move_To(midtro_3_obiwan_marker)

	magna_unit = Find_Object_Type("Magnaguard")

	magna_1_list = Spawn_Unit(magna_unit, midtro_1_magna_1_marker, p_cis)
	player_magna_1 = magna_1_list[1]
	player_magna_1.Teleport_And_Face(midtro_1_magna_1_marker)
	player_magna_1.Attack_Move(player_obiwan)

	magna_2_list = Spawn_Unit(magna_unit, midtro_1_magna_2_marker, p_cis)
	player_magna_2 = magna_2_list[1]
	player_magna_2.Teleport_And_Face(midtro_1_magna_2_marker)
	player_magna_2.Attack_Move(player_obiwan)
	
	Sleep(1.0)
	
	player_grievous.Attack_Move(player_obiwan)

	if not cinematic_four_skipped then
		current_cinematic_thread_id = Create_Thread("End_Cinematic_Midtro_03_Rep")
	end
end

function End_Cinematic_Midtro_03_Rep()

	Point_Camera_At(player_obiwan)
	Transition_To_Tactical_Camera(3)
	Letter_Box_Out(3)
	Sleep(2.0)

	StoryUtil.CinematicEnvironmentOff()

	p_republic.Make_Enemy(p_cis)
	p_cis.Make_Enemy(p_republic)

	Sleep(1.0)

	End_Cinematic_Camera()
	Lock_Controls(0)
	Story_Event("GOAL_TRIGGER_REP_IV")
	Suspend_AI(0)

	cinematic_four = false
	act_4_active = true

	Add_Radar_Blip(escape_marker, "escape_blip")
	escape_marker.Highlight(true)

	Register_Prox(escape_marker, State_Escape_Reached, 200, p_republic)

	player_anakin.Change_Owner(p_republic)
	player_anakin.Move_To(escape_marker)

	player_padme.Change_Owner(p_republic)
	player_padme.Move_To(escape_marker)

end

function Start_Cinematic_Outro_Rep()

	act_4_active = false
	cinematic_five = true
	Fade_Screen_Out(0.5)
	Sleep(1)
	Suspend_AI(1)
	Lock_Controls(1)
	Start_Cinematic_Camera()
	Letter_Box_In(0)
	Stop_All_Music()
	Cancel_Fast_Forward()

	StoryUtil.CinematicEnvironmentOn()

	GlobalValue.Set("Allow_AI_Controlled_Fog_Reveal", 1)
	GlobalValue.Set("HfM_Malevolence_Alive", 0)

	StoryUtil.PlayGenericSpeech("Subjugator_Sabotage_05")
	StoryUtil.PlayGenericMusic("Silence_Theme")

	player_anakin = Find_First_Object("ANAKIN2")
	player_obiwan = Find_First_Object("OBI_WAN")
	player_padme = Find_First_Object("PADME_AMIDALA")

	player_anakin.In_End_Cinematic(true)
	player_obiwan.In_End_Cinematic(true)
	player_padme.In_End_Cinematic(true)

	Do_End_Cinematic_Cleanup()

	player_anakin.Teleport_And_Face(outro_1_anakin_marker)
	player_obiwan.Teleport_And_Face(outro_1_obiwan_marker)
	player_padme.Teleport_And_Face(outro_1_padme_marker)

	player_anakin.Make_Invulnerable(true)
	player_obiwan.Make_Invulnerable(true)
	player_padme.Make_Invulnerable(true)

	Set_Cinematic_Camera_Key(outrocam_1_marker, 0, 0, 0, 1, 0, 0, 0)
	Set_Cinematic_Target_Key(outrocam_1_marker, 0, 0, 5, 0, player_anakin, 1, 0)	
	Transition_Cinematic_Camera_Key(outrocam_2_marker, 7, 0, 0, 0, 1, 0, 0, 0)
	Transition_Cinematic_Target_Key(outrocam_2_marker, 7, 0, 0, 5, 0, player_anakin, 1, 0)
	Fade_Screen_In(0.5)

	player_anakin.Move_To(twilight_marker)
	player_obiwan.Move_To(twilight_marker)
	player_padme.Move_To(twilight_marker)
	
	outro_pilot_unit = Find_Object_Type("B1_Droid")

	outro_pilot_1_list = Spawn_Unit(outro_pilot_unit, outro_1_pilot_1_marker, p_cis)
	player_outro_pilot_1 = outro_pilot_1_list[1]
	player_outro_pilot_1.Teleport_And_Face(outro_1_pilot_1_marker)

	outro_pilot_2_list = Spawn_Unit(outro_pilot_unit, outro_1_pilot_2_marker, p_cis)
	player_outro_pilot_2 = outro_pilot_2_list[1]
	player_outro_pilot_2.Teleport_And_Face(outro_1_pilot_2_marker)

	outro_pilot_3_list = Spawn_Unit(outro_pilot_unit, outro_1_pilot_3_marker, p_cis)
	player_outro_pilot_3 = outro_pilot_3_list[1]
	player_outro_pilot_3.Teleport_And_Face(outro_1_pilot_3_marker)

	Sleep(4)

	player_cinematic_door.Play_Animation("Cinematic", false, 3)
	Sleep(3)

	Set_Cinematic_Camera_Key(outrocam_3_marker, 0, 0, 0, 1, 0, 0, 0)
	Set_Cinematic_Target_Key(outrocam_3_marker, 0, 0, 1, 0, player_outro_pilot_1, 1, 0)	
	Transition_Cinematic_Camera_Key(outrocam_4_marker, 7, 0, 0, 0, 1, 0, 0, 0)
	Transition_Cinematic_Target_Key(outrocam_4_marker, 7, 0, 0, 1, 0, player_outro_pilot_1, 1, 0)
	Sleep(5)

	Sleep(1.5)

	explosion_01 = Spawn_Unit(Find_Object_Type("Huge_Explosion_Land"), bridge_marker, p_neutral)
	explosion_02 = Spawn_Unit(Find_Object_Type("Huge_Explosion_Land"), player_outro_pilot_1, p_neutral)
	explosion_03 = Spawn_Unit(Find_Object_Type("Huge_Explosion_Land"), player_outro_pilot_2, p_neutral)
	explosion_04 = Spawn_Unit(Find_Object_Type("Huge_Explosion_Land"), player_outro_pilot_3, p_neutral)
	explosion_05 = Spawn_Unit(Find_Object_Type("Huge_Explosion_Land"), outrocam_4_marker, p_neutral)

	player_outro_pilot_1.Despawn()
	player_outro_pilot_2.Despawn()
	player_outro_pilot_3.Despawn()

	Fade_Screen_Out(1.5)
	Sleep(0.25)

	explosion_06 = Spawn_Unit(Find_Object_Type("Huge_Explosion_Land"), bridge_marker, p_neutral)
	explosion_07 = Spawn_Unit(Find_Object_Type("Huge_Explosion_Land"), outro_1_pilot_1_marker, p_neutral)
	explosion_08 = Spawn_Unit(Find_Object_Type("Huge_Explosion_Land"), outro_1_pilot_2_marker, p_neutral)
	explosion_09 = Spawn_Unit(Find_Object_Type("Huge_Explosion_Land"), outro_1_pilot_3_marker, p_neutral)
	explosion_10 = Spawn_Unit(Find_Object_Type("Huge_Explosion_Land"), outrocam_4_marker, p_neutral)

	Sleep(0.25)

	explosion_11 = Spawn_Unit(Find_Object_Type("Huge_Explosion_Land"), bridge_marker, p_neutral)
	explosion_12 = Spawn_Unit(Find_Object_Type("Huge_Explosion_Land"), outro_1_pilot_1_marker, p_neutral)
	explosion_13 = Spawn_Unit(Find_Object_Type("Huge_Explosion_Land"), outro_1_pilot_2_marker, p_neutral)
	explosion_14 = Spawn_Unit(Find_Object_Type("Huge_Explosion_Land"), outro_1_pilot_3_marker, p_neutral)
	explosion_15 = Spawn_Unit(Find_Object_Type("Huge_Explosion_Land"), outrocam_4_marker, p_neutral)

	Sleep(3)

	Fade_Screen_In(0.5)
	Play_Bink_Movie("Cinematic_Malevolence_Death")
	Fade_On()
	Sleep(13)

	StoryUtil.DeclareVictory(p_republic, false)

	StoryUtil.CinematicEnvironmentOff()
end


function Start_Cinematic_Intro_CIS()

	cinematic_one = true
	Start_Cinematic_Camera()
	Suspend_AI(1)
	Lock_Controls(1)
	Cancel_Fast_Forward()

	Stop_All_Music()
	StoryUtil.CinematicEnvironmentOn()

	Fade_On()

	StoryUtil.PlayGenericSpeech("Subjugator_Sabotage_01")
	StoryUtil.PlayGenericMusic("Silence_Theme")
	Sleep(0.25)

	player_intro_b1_1 = Find_Hint("B1_DROID", "intro1b11")
	player_intro_b1_1.Prevent_All_Fire(true)
	player_intro_b1_1.Teleport_And_Face(intro_1_b1_1_marker)
	player_intro_b1_1.Play_Animation("Idle", false, 1)

	player_intro_b1_2 = Find_Hint("B1_DROID", "intro1b12")
	player_intro_b1_2.Prevent_All_Fire(true)
	player_intro_b1_2.Teleport_And_Face(intro_1_b1_2_marker)

	Set_Cinematic_Camera_Key(introcam_1_marker, 0, 0, 0, 1, 0, 0, 0)
	Set_Cinematic_Target_Key(introcam_1_marker, 0, 0, 0, 0, player_intro_b1_1, 1, 0)
	Transition_Cinematic_Camera_Key(introcam_2_marker, 16, 0, 0, 0, 1, 0, 0, 0)
	Transition_Cinematic_Target_Key(introcam_2_marker, 16, 0, 0, 0, 0, player_intro_b1_1, 1, 0)

	Letter_Box_In(0.5)
	Fade_Screen_In(0.5)

	Sleep(2)

	player_intro_b1_1.Turn_To_Face(player_intro_b1_2)
	Sleep(1)

	player_intro_b1_1.Play_Animation("Idle", false, 0)
	Sleep(1)

	player_intro_b1_2.Turn_To_Face(player_intro_b1_1)
	Sleep(0.5)
	player_intro_b1_2.Play_Animation("Idle", false, 1)
	Sleep(1.5)

	player_intro_b1_1.Play_Animation("Idle", false, 1)
	Sleep(2)

	player_anakin = Find_First_Object("ANAKIN2")
	Hide_Sub_Object(player_anakin, 1, "lightsaber");
	player_anakin.Teleport_And_Face(intro_1_anakin_marker)

	player_obiwan = Find_First_Object("OBI_WAN")
	Hide_Sub_Object(player_obiwan, 1, "lightsaber");
	player_obiwan.Teleport_And_Face(intro_1_obiwan_marker)

	Set_Cinematic_Camera_Key(introcam_3_marker, 0, 0, 5, 1, 0, 0, 0)
	Set_Cinematic_Target_Key(introcam_3_marker, 0, 4, 1, 0, player_intro_b1_1, 1, 0)
	Transition_Cinematic_Camera_Key(introcam_4_marker, 24, 0, 0, 5, 1, 0, 0, 0)
	Transition_Cinematic_Target_Key(introcam_4_marker, 24, 0, 4, 1, 0, player_intro_b1_1, 1, 0)
	Sleep(4)

	Set_Cinematic_Camera_Key(introcam_5_marker, 0, 0, 5, 1, 0, 0, 0)
	Set_Cinematic_Target_Key(introcam_5_marker, 0, 2, 1, 0, player_obiwan, 1, 0)
	Transition_Cinematic_Camera_Key(introcam_6_marker, 8, 0, 0, 5, 1, 0, 0, 0)
	Transition_Cinematic_Target_Key(introcam_6_marker, 8, 0, 0, 0, 0, player_obiwan, 1, 0)

	player_obiwan.Turn_To_Face(player_anakin)
	player_obiwan.Play_Animation("Talk", false, 0)
	Sleep(4.5)

	player_anakin.Play_Animation("Talk", false, 0)
	Sleep(1.0)

	player_cinematic_door.Play_Animation("Cinematic", false, 1)
	player_obiwan.Turn_To_Face(introcam_4_marker)
	Sleep(0.5)
	player_obiwan.Play_Animation("Talk", false, 0)

	Set_Cinematic_Camera_Key(introcam_7_marker, 0, 0, 0, 1, 0, 0, 0)
	Set_Cinematic_Target_Key(introcam_7_marker, 0, 0, 0, 0, player_intro_b1_1, 1, 0)
	Transition_Cinematic_Camera_Key(introcam_8_marker, 6, 0, 0, 5, 1, 0, 0, 0)
	Transition_Cinematic_Target_Key(introcam_8_marker, 8, 0, 0, 0, 0, player_intro_b1_1, 1, 0)
	Sleep(0.5)

	player_intro_b1_1.Teleport_And_Face(intro_2_b1_1_marker)
	player_intro_b1_2.Teleport_And_Face(intro_2_b1_2_marker)
	Sleep(4.0)

	player_anakin.Teleport_And_Face(intro_2_anakin_marker)
	player_obiwan.Teleport_And_Face(intro_2_obiwan_marker)

	player_intro_b1_1.Change_Owner(p_cis)
	player_intro_b1_2.Change_Owner(p_cis)

	Hide_Sub_Object(player_anakin, 0, "lightsaber");
	player_anakin.Attack_Move(player_intro_b1_1)

	Hide_Sub_Object(player_obiwan, 0, "lightsaber");
	player_obiwan.Attack_Move(player_intro_b1_2)

	Sleep(0.5)

	Set_Cinematic_Camera_Key(introcam_9_marker, 0, 0, 0, 1, 0, 0, 0)
	Set_Cinematic_Target_Key(introcam_9_marker, 0, 0, 0, 0, player_anakin, 1, 0)
	Transition_Cinematic_Camera_Key(introcam_10_marker, 12, 0, 0, 5, 1, 0, 0, 0)
	Transition_Cinematic_Target_Key(introcam_10_marker, 12, 0, 0, 0, 0, player_obiwan, 1, 0)
	Sleep(1.0)

	player_padme = Find_First_Object("PADME_AMIDALA")

	player_anakin.Turn_To_Face(player_obiwan)
	player_obiwan.Turn_To_Face(player_anakin)
	Sleep(4)

	Set_Cinematic_Camera_Key(introcam_4_marker, 0, 0, 0, 1, 0, 0, 0)
	Set_Cinematic_Target_Key(introcam_4_marker, 0, 0, 0, 0, player_anakin, 1, 0)

	player_anakin.Turn_To_Face(outrocam_1_marker)
	player_anakin.Play_Animation("Talk", false, 0)

	Sleep(2)

	player_padme.Play_Animation("Idle", false, 0)
	Sleep(1)

	Set_Cinematic_Camera_Key(introcam_13_marker, 0, 0, 0, 1, 0, 0, 0)
	Set_Cinematic_Target_Key(introcam_13_marker, 0, 0, 0, 0, player_padme, 1, 0)
	Transition_Cinematic_Camera_Key(introcam_14_marker, 7, 0, 0, 0, 1, 0, 0, 0)
	Transition_Cinematic_Target_Key(introcam_14_marker, 7, 0, 0, 0, 0, player_padme, 1, 0)

	player_padme.Play_Animation("Idle", false, 2)
	Sleep(3)

	player_padme.Move_To(intro_2_padme_marker)
	Sleep(2)

	player_anakin.Teleport_And_Face(intro_3_anakin_marker)
	player_obiwan.Teleport_And_Face(intro_3_obiwan_marker)

	Set_Cinematic_Camera_Key(introcam_15_marker, 0, 0, 7, 1, 0, 0, 0)
	Set_Cinematic_Target_Key(introcam_15_marker, 0, 0, 0, 0, player_anakin, 1, 0)
	Transition_Cinematic_Camera_Key(introcam_16_marker, 7, 0, 0, 0, 1, 0, 0, 0)
	Transition_Cinematic_Target_Key(introcam_16_marker, 7, 0, 0, 0, 0, player_anakin, 1, 0)

	player_anakin.Turn_To_Face(player_obiwan)
	player_obiwan.Turn_To_Face(player_anakin)

	player_anakin.Play_Animation("Talk", false)
	Sleep(4)

	Hide_Sub_Object(player_anakin, 1, "lightsaber");
	Hide_Sub_Object(player_obiwan, 1, "lightsaber");
	Sleep(3)

	Set_Cinematic_Camera_Key(introcam_17_marker, 0, 0, 7, 1, 0, 0, 0)
	Set_Cinematic_Target_Key(introcam_17_marker, 0, 0, 0, 0, player_anakin, 1, 0)
	Transition_Cinematic_Camera_Key(introcam_18_marker, 7, 0, 0, 0, 1, 0, 0, 0)
	Transition_Cinematic_Target_Key(introcam_18_marker, 7, 0, 0, 0, 0, player_anakin, 1, 0)

	player_anakin.Turn_To_Face(introcam_18_marker)
	player_obiwan.Turn_To_Face(introcam_18_marker)
	player_anakin.Play_Animation("Talk", false)

	Hide_Sub_Object(player_anakin, 0, "lightsaber");
	Hide_Sub_Object(player_obiwan, 0, "lightsaber");
	Sleep(7)

	Set_Cinematic_Camera_Key(introcam_17_marker, 0, 0, 7, 1, 0, 0, 0)
	Set_Cinematic_Target_Key(introcam_17_marker, 0, 0, 0, 0, player_anakin, 1, 0)
	Transition_Cinematic_Camera_Key(introcam_18_marker, 6, 0, 0, 0, 1, 0, 0, 0)
	Transition_Cinematic_Target_Key(introcam_18_marker, 6, 0, 0, 0, 0, player_anakin, 1, 0)
	Sleep(3)

	Fade_Screen_Out(3)
	Sleep(5)

	if not cinematic_one_skipped then
		current_cinematic_thread_id = Create_Thread("Start_Cinematic_Midtro_01_CIS")
	end
end

function Start_Cinematic_Midtro_01_CIS()
	cinematic_one = false
	cinematic_two = true

	player_anakin = Find_First_Object("ANAKIN2")
	player_obiwan = Find_First_Object("OBI_WAN")
	player_padme = Find_First_Object("PADME_AMIDALA")

	player_anakin.In_End_Cinematic(true)
	player_obiwan.In_End_Cinematic(true)
	player_padme.In_End_Cinematic(true)

	Do_End_Cinematic_Cleanup()

	StoryUtil.PlayGenericSpeech("Subjugator_Sabotage_02")
	StoryUtil.PlayGenericMusic("Silence_Theme")
	Fade_On()

	player_anakin.Teleport_And_Face(intro_4_anakin_marker)
	player_padme.Teleport_And_Face(intro_2_padme_marker)

	Set_Cinematic_Camera_Key(midtrocam_1_marker, 0, 0, 0, 1, 0, 0, 0)
	Set_Cinematic_Target_Key(midtrocam_1_marker, 0, 0, 0, 0, player_anakin, 1, 0)
	Transition_Cinematic_Camera_Key(midtrocam_2_marker, 11, 0, 0, 0, 1, 0, 0, 0)
	Transition_Cinematic_Target_Key(midtrocam_2_marker, 11, 0, 0, 0, 0, player_anakin, 1, 0)

	player_anakin.Play_Animation("Talk", false, 0)

	Letter_Box_In(0.5)
	Fade_Screen_In(0.5)
	Sleep(7)
	Fade_Screen_Out(2.5)
	Sleep(4)

	if not cinematic_two_skipped then
		current_cinematic_thread_id = Create_Thread("Start_Cinematic_Midtro_02_CIS")
	end
end

function Start_Cinematic_Midtro_02_CIS()
	cinematic_two = false
	cinematic_three = true

	player_anakin = Find_First_Object("ANAKIN2")
	player_obiwan = Find_First_Object("OBI_WAN")
	player_padme = Find_First_Object("PADME_AMIDALA")

	StoryUtil.PlayGenericSpeech("Subjugator_Sabotage_03")
	StoryUtil.PlayGenericMusic("Silence_Theme")
	Fade_On()

	player_anakin.Teleport_And_Face(midtro_1_anakin_marker)
	player_padme.Teleport_And_Face(midtro_1_padme_marker)

	player_anakin.Move_To(outro_1_pilot_1_marker)
	player_padme.Move_To(outro_1_pilot_3_marker)

	Set_Cinematic_Camera_Key(midtrocam_3_marker, 0, 0, 0, 1, 0, 0, 0)
	Set_Cinematic_Target_Key(midtrocam_3_marker, 0, 0, 0, 0, player_anakin, 1, 0)
	Transition_Cinematic_Camera_Key(midtrocam_4_marker, 10, 0, 0, 0, 1, 0, 0, 0)
	Transition_Cinematic_Target_Key(midtrocam_4_marker, 10, 0, 0, 0, 0, player_anakin, 1, 0)

	Letter_Box_In(2.5)
	Fade_Screen_In(2.5)
	Sleep(10)

	Set_Cinematic_Camera_Key(midtrocam_5_marker, 0, 0, 0, 1, 0, 0, 0)
	Set_Cinematic_Target_Key(midtrocam_5_marker, 0, 0, 0, 0, player_anakin, 1, 0)
	Transition_Cinematic_Camera_Key(midtrocam_6_marker, 10, 0, 0, 0, 1, 0, 0, 0)
	Transition_Cinematic_Target_Key(midtrocam_6_marker, 10, 0, 0, 0, 0, player_anakin, 1, 0)

	player_anakin.Play_Animation("Talk", false, 0)
	Sleep(10)

	Set_Cinematic_Camera_Key(outrocam_3_marker, 0, 0, 0, 1, 0, 0, 0)
	Set_Cinematic_Target_Key(outrocam_3_marker, 0, 0, 0, 0, player_anakin, 1, 0)
	Transition_Cinematic_Camera_Key(midtrocam_3_marker, 11, 0, 0, 0, 1, 0, 0, 0)
	Transition_Cinematic_Target_Key(midtrocam_3_marker, 11, 0, 0, 0, 0, player_anakin, 1, 0)
	Sleep(3)

	Fade_Screen_Out(2.5)
	Sleep(4)

	if not cinematic_three_skipped then
		current_cinematic_thread_id = Create_Thread("Start_Cinematic_Outro_CIS")
	end
end

function Start_Cinematic_Outro_CIS()
	cinematic_three = false
	cinematic_five = true

	Stop_All_Music()
	Cancel_Fast_Forward()

	Stop_All_Music()
	GlobalValue.Set("Allow_AI_Controlled_Fog_Reveal", 1)
	GlobalValue.Set("HfM_Malevolence_Alive", 0)
	StoryUtil.PlayGenericSpeech("Subjugator_Sabotage_05")
	StoryUtil.PlayGenericMusic("Silence_Theme")
	Fade_On()

	player_anakin = Find_First_Object("ANAKIN2")
	player_obiwan = Find_First_Object("OBI_WAN")
	player_padme = Find_First_Object("PADME_AMIDALA")

	player_anakin.In_End_Cinematic(true)
	player_obiwan.In_End_Cinematic(true)
	player_padme.In_End_Cinematic(true)

	Do_End_Cinematic_Cleanup()

	player_anakin.Teleport_And_Face(outro_1_anakin_marker)
	player_obiwan.Teleport_And_Face(outro_1_obiwan_marker)
	player_padme.Teleport_And_Face(outro_1_padme_marker)

	player_anakin.Make_Invulnerable(true)
	player_obiwan.Make_Invulnerable(true)
	player_padme.Make_Invulnerable(true)

	Set_Cinematic_Camera_Key(outrocam_1_marker, 0, 0, 0, 1, 0, 0, 0)
	Set_Cinematic_Target_Key(outrocam_1_marker, 0, 0, 5, 0, player_anakin, 1, 0)	
	Transition_Cinematic_Camera_Key(outrocam_2_marker, 7, 0, 0, 0, 1, 0, 0, 0)
	Transition_Cinematic_Target_Key(outrocam_2_marker, 7, 0, 0, 5, 0, player_anakin, 1, 0)
	Fade_Screen_In(0.5)

	player_anakin.Move_To(twilight_marker)
	player_obiwan.Move_To(twilight_marker)
	player_padme.Move_To(twilight_marker)
	
	outro_pilot_unit = Find_Object_Type("B1_Droid")

	outro_pilot_1_list = Spawn_Unit(outro_pilot_unit, outro_1_pilot_1_marker, p_cis)
	player_outro_pilot_1 = outro_pilot_1_list[1]
	player_outro_pilot_1.Teleport_And_Face(outro_1_pilot_1_marker)

	outro_pilot_2_list = Spawn_Unit(outro_pilot_unit, outro_1_pilot_2_marker, p_cis)
	player_outro_pilot_2 = outro_pilot_2_list[1]
	player_outro_pilot_2.Teleport_And_Face(outro_1_pilot_2_marker)

	outro_pilot_3_list = Spawn_Unit(outro_pilot_unit, outro_1_pilot_3_marker, p_cis)
	player_outro_pilot_3 = outro_pilot_3_list[1]
	player_outro_pilot_3.Teleport_And_Face(outro_1_pilot_3_marker)

	Sleep(4)

	player_cinematic_door.Play_Animation("Cinematic", false, 3)
	Sleep(3)

	Set_Cinematic_Camera_Key(outrocam_3_marker, 0, 0, 0, 1, 0, 0, 0)
	Set_Cinematic_Target_Key(outrocam_3_marker, 0, 0, 1, 0, player_outro_pilot_1, 1, 0)	
	Transition_Cinematic_Camera_Key(outrocam_4_marker, 7, 0, 0, 0, 1, 0, 0, 0)
	Transition_Cinematic_Target_Key(outrocam_4_marker, 7, 0, 0, 1, 0, player_outro_pilot_1, 1, 0)
	Sleep(5)

	Sleep(1.5)

	explosion_01 = Spawn_Unit(Find_Object_Type("Huge_Explosion_Land"), bridge_marker, p_neutral)
	explosion_02 = Spawn_Unit(Find_Object_Type("Huge_Explosion_Land"), player_outro_pilot_1, p_neutral)
	explosion_03 = Spawn_Unit(Find_Object_Type("Huge_Explosion_Land"), player_outro_pilot_2, p_neutral)
	explosion_04 = Spawn_Unit(Find_Object_Type("Huge_Explosion_Land"), player_outro_pilot_3, p_neutral)
	explosion_05 = Spawn_Unit(Find_Object_Type("Huge_Explosion_Land"), outrocam_4_marker, p_neutral)

	player_outro_pilot_1.Despawn()
	player_outro_pilot_2.Despawn()
	player_outro_pilot_3.Despawn()

	Fade_Screen_Out(1.5)
	Sleep(0.25)

	explosion_06 = Spawn_Unit(Find_Object_Type("Huge_Explosion_Land"), bridge_marker, p_neutral)
	explosion_07 = Spawn_Unit(Find_Object_Type("Huge_Explosion_Land"), outro_1_pilot_1_marker, p_neutral)
	explosion_08 = Spawn_Unit(Find_Object_Type("Huge_Explosion_Land"), outro_1_pilot_2_marker, p_neutral)
	explosion_09 = Spawn_Unit(Find_Object_Type("Huge_Explosion_Land"), outro_1_pilot_3_marker, p_neutral)
	explosion_10 = Spawn_Unit(Find_Object_Type("Huge_Explosion_Land"), outrocam_4_marker, p_neutral)

	Sleep(0.25)

	explosion_11 = Spawn_Unit(Find_Object_Type("Huge_Explosion_Land"), bridge_marker, p_neutral)
	explosion_12 = Spawn_Unit(Find_Object_Type("Huge_Explosion_Land"), outro_1_pilot_1_marker, p_neutral)
	explosion_13 = Spawn_Unit(Find_Object_Type("Huge_Explosion_Land"), outro_1_pilot_2_marker, p_neutral)
	explosion_14 = Spawn_Unit(Find_Object_Type("Huge_Explosion_Land"), outro_1_pilot_3_marker, p_neutral)
	explosion_15 = Spawn_Unit(Find_Object_Type("Huge_Explosion_Land"), outrocam_4_marker, p_neutral)

	Sleep(3)

	Fade_Screen_In(0.5)
	Play_Bink_Movie("Cinematic_Malevolence_Death")
	Fade_On()
	Sleep(13)

	StoryUtil.DeclareVictory(p_republic, false)

	StoryUtil.CinematicEnvironmentOff()
end
