
--****************************************************--
--***  Fall of the Republic: Government Republic   ***--
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
			Trigger_Choice_Republic_Future = State_Choice_Republic_Future,
			Trigger_Republic_Future_Palpatine = State_Republic_Future_Palpatine,
			Republic_Future_Order_66_Speech_13 = State_Republic_Future_Mace_Gone,
			Republic_Future_Order_66_Speech_16 = State_Republic_Future_Jedi_Gone,
			Trigger_Republic_Future_New_Order = State_Republic_Future_New_Order,
			Trigger_Republic_Imperialization_Proposal = State_Republic_Imperialization_Proposal,
			Trigger_Republic_Imperialization_Execution = State_Republic_Imperialization_Execution,
			Trigger_Republic_Future_Mothma = State_Republic_Future_Mothma,
			Trigger_Choice_Military_Enhancement = State_Choice_Military_Enhancement,
			Trigger_Choice_Kuat_Power_Struggle = State_Choice_Kuat_Power_Struggle,
			Trigger_Choice_Enhanced_Security_Act = State_Choice_Enhanced_Security_Act,
			Trigger_Choice_Sector_Governance = State_Choice_Sector_Governance,
	}
	crossplot:galactic()
end

function State_Choice_Republic_Future(message)
    if message == OnEnter then
		Find_Player("Empire").Unlock_Tech(Find_Object_Type("Republic_Future_Support_Mothma"))
		Find_Player("Empire").Unlock_Tech(Find_Object_Type("Republic_Future_Support_Palpatine"))
	end
end

function State_Republic_Future_Palpatine(message)
    if message == OnEnter then
		Find_Player("Empire").Unlock_Tech(Find_Object_Type("Execute_Order_66_Dummy"))
		Story_Event("START_ORDER_66_PRELUDE")
	end
end

function State_Republic_Future_Mace_Gone(message)
    if message == OnEnter then
		UnitUtil.DespawnList({
			"MACE_WINDU", "MACE_WINDU2", 
			"KIT_FISTO", "KIT_FISTO2",
		})
	end
end

function State_Republic_Future_Jedi_Gone(message)
    if message == OnEnter then
		UnitUtil.SetLockList("EMPIRE", {"Jedi_Temple", "Republic_Jedi_Squad", "View_Council", --[[FotR_Enhanced]] "Generic_Venator_OFC"}, false)

		UnitUtil.DespawnList({
			"YODA", "YODA2",
			"MACE_WINDU", "MACE_WINDU2", 
			"PLO_KOON",
			"KIT_FISTO", "KIT_FISTO2",
			"KI_ADI_MUNDI", "KI_ADI_MUNDI2",
			"LUMINARA_UNDULI", "LUMINARA_UNDULI2",
			"BARRISS_OFFEE","BARRISS_OFFEE2",
			"AHSOKA","AHSOKA2",
			"AAYLA_SECURA","AAYLA_SECURA2",
			"SHAAK_TI","SHAAK_TI2",
			"RAHM_KOTA",
			"NEJAA_HALCYON",
			"KNOL_VENNARI",
			"OPPO_RANCISIS",
			"OBI_WAN", "OBI_WAN2",
			"JEDI_TEMPLE",
			"REPUBLIC_JEDI_KNIGHT",
			"KOTAS_MILITIA_TROOPER", "KOTAS_MILITIA_TROOPER_GUNNER_HEAVY", "KOTAS_MILITIA_TROOPER_GRENADIER", "KOTAS_MILITIA_TROOPER_HAT", "KOTAS_MILITIA_TROOPER_SERGEANT_SPAWNER",
			"ANTARIAN_RANGER_RIFLE", "ANTARIAN_RANGER_RIFLE_GRENADIER", "ANTARIAN_RANGER_RIFLE_CAPTAIN_SPAWNER",
		})

		local Non_OFC_Units = {
			"Generic_Venator",
			"Generic_Acclamator_Assault_Ship_I",
			"Charger_C70",
		}

        for _, Non_OFC_Unit in pairs(Non_OFC_Units) do --Loop each unit in Non_OFC_Units
			local OFC_Unit = Non_OFC_Unit.."_OFC" --Assign suffix name to unit
			if TestValid(Find_First_Object(OFC_Unit)) then --Check OFC object exists
				local Unit_Object_List = Find_All_Objects_Of_Type(OFC_Unit) --Get all objects of OFC unit
				if table.getn(Unit_Object_List) ~= 0 then --Check if list is not empty
					for _, despawn_target in pairs(Unit_Object_List) do --Loop through list
						UnitUtil.ReplaceAtLocation(despawn_target, Non_OFC_Unit) --Replace OFC unit with non OFC
					end
				end
			end
		end
		
		local SPHA_T_Ven = "Generic_Venator_SPHA_T" --Same process as above
		if TestValid(Find_First_Object(SPHA_T_Ven)) then
			local SPHA_T_List = Find_All_Objects_Of_Type(SPHA_T_Ven)
			if table.getn(SPHA_T_List) ~= 0 then
				for _, despawn_target in pairs(SPHA_T_List) do
					UnitUtil.ReplaceAtLocation(despawn_target, "Generic_Venator")
				end
			end
		end
		crossplot:publish("ORDER_66_EXECUTED", "empty")
	else
		crossplot:update()
	end
end

function State_Republic_Future_New_Order(message)
    if message == OnEnter then
		GlobalValue.Set("ChiefOfState", "DUMMY_CHIEFOFSTATE_EMPEROR_PALPATINE")
		GlobalValue.Set("SHIPS_DECOLORED", 1)
		UnitUtil.SetLockList("EMPIRE", {--[[FotR_Enhanced]] "Yularen_Resolute_66_Upgrade_Invincible", "Yularen_Integrity_66_Upgrade_Invincible"})

		UnitUtil.ReplaceAtLocation("Anakin", "Vader_Team")
		UnitUtil.ReplaceAtLocation("Anakin2", "Vader_Team")

		StoryUtil.SpawnAtSafePlanet("CORUSCANT", Find_Player("Empire"), StoryUtil.GetSafePlanetTable(), {"Emperor_Palpatine_Team"})  
	end
end

function State_Republic_Imperialization_Proposal(message)
    if message == OnEnter then
		Story_Event("REPUBLIC_IMPERIALIZATION_START")
		Sleep(20.0)
		Find_Player("Empire").Unlock_Tech(Find_Object_Type("Dummy_KDY_Contract"))
	end
end

function State_Republic_Imperialization_Execution(message)
    if message == OnEnter then
		Story_Event("REPUBLIC_IMPERIALIZATION_DONE")
		Find_Player("Empire").Unlock_Tech(Find_Object_Type("Tarkin_Executrix_Upgrade"))
		StoryUtil.SpawnAtSafePlanet("CORUSCANT", Find_Player("Empire"), StoryUtil.GetSafePlanetTable(), {"Mulleen_Imperator", --[[FotR_Enhanced]] "Rohn_Team"})  
	end
end

function State_Republic_Future_Mothma(message)
    if message == OnEnter then
		Story_Event("START_REPUBLIC_NEW_ELECTIONS")
		GlobalValue.Set("ChiefOfState", "DUMMY_CHIEFOFSTATE_MOTHMA")
		-- FotR_Enhanced
		crossplot:publish("ORDER_65_EXECUTED", "empty")
		--	
		UnitUtil.DespawnList({"Sate_Pestage"})
		StoryUtil.SpawnAtSafePlanet("CORUSCANT", Find_Player("Empire"), StoryUtil.GetSafePlanetTable(), {"Mon_Mothma_Team", "Garm_Team", "Bail_Team", "Raymus_Tantive"})  

		Find_Player("Empire").Unlock_Tech(Find_Object_Type("Tallon_Battalion_Upgrade"))
		Find_Player("Empire").Unlock_Tech(Find_Object_Type("Neutron_Star"))
	end
end

function State_Choice_Military_Enhancement(message)
    if message == OnEnter then
		Find_Player("Empire").Unlock_Tech(Find_Object_Type("Support_Reduced_Military_Expanses_Bill"))
		Find_Player("Empire").Unlock_Tech(Find_Object_Type("Support_Military_Enhancement_Bill"))
	end
end

function State_Choice_Kuat_Power_Struggle(message)
    if message == OnEnter then
		Find_Player("Empire").Unlock_Tech(Find_Object_Type("Support_Kuat_Power_Struggle_Onara"))
		Find_Player("Empire").Unlock_Tech(Find_Object_Type("Support_Kuat_Power_Struggle_Giddean"))
	end
end

function State_Choice_Enhanced_Security_Act(message)
    if message == OnEnter then
		Find_Player("Empire").Unlock_Tech(Find_Object_Type("Support_Enhanced_Security_Act"))
		Find_Player("Empire").Unlock_Tech(Find_Object_Type("Support_Enhanced_Security_Act_Not"))
	end
end

function State_Choice_Sector_Governance(message)
    if message == OnEnter then
		Find_Player("Empire").Unlock_Tech(Find_Object_Type("Support_Expanded_Senate_Control_Bill"))
		Find_Player("Empire").Unlock_Tech(Find_Object_Type("Support_Sector_Governance_Decree"))
	end
end
