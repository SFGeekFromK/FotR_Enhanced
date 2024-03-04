
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
		UnitUtil.SetLockList("EMPIRE", {"Jedi_Temple", "Republic_Jedi_Squad", "View_Council", "Generic_Venator", "Venator_OFC"}, false)
		
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
			"OBI_WAN", "OBI_WAN2",
			"JEDI_TEMPLE",
			"REPUBLIC_JEDI_KNIGHT",
			"KOTAS_MILITIA_TROOPER", "KOTAS_MILITIA_TROOPER_GUNNER_HEAVY", "KOTAS_MILITIA_TROOPER_GRENADIER", "KOTAS_MILITIA_TROOPER_HAT", "KOTAS_MILITIA_TROOPER_SERGEANT_SPAWNER",
			"ANTARIAN_RANGER_RIFLE", "ANTARIAN_RANGER_RIFLE_GRENADIER", "ANTARIAN_RANGER_RIFLE_CAPTAIN_SPAWNER",
		})

		local Generic_Venator_All=Find_All_Objects_Of_Type("Generic_Venator")
		for _, Venator_Despawn in pairs(Generic_Venators_All) do
			UnitUtil.ReplaceAtLocation(Venator_Despawn, "Venator_Imperial")
		end

		local Venator_OFC_All=Find_All_Objects_Of_Type("Venator_OFC")
		for i, Venator_OFC_Despawn in pairs(Venator_OFC_All) do
			UnitUtil.ReplaceAtLocation(Venator_OFC_Despawn, "Venator_Imperial")
		end

		local Venator_SPHA_T_All=Find_All_Objects_Of_Type("Venator_SPHA_T")
		for j, Venator_SPHA_T_Despawn in pairs(Venator_SPHA_T_All) do
			UnitUtil.ReplaceAtLocation(Venator_SPHA_T_Despawn, "Venator_Imperial")
		end

		crossplot:publish("ORDER_66_EXECUTED", "empty")
	end
end

function State_Republic_Future_New_Order(message)
    if message == OnEnter then
		GlobalValue.Set("ChiefOfState", "DUMMY_CHIEFOFSTATE_EMPEROR_PALPATINE")
		UnitUtil.SetLockList("EMPIRE", {"Yularen_Resolute_Upgrade_Invincible", "Yularen_Integrity_Upgrade_Invincible"})

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
		StoryUtil.SpawnAtSafePlanet("CORUSCANT", Find_Player("Empire"), StoryUtil.GetSafePlanetTable(), {"Mulleen_Imperator"})  
	end
end

function State_Republic_Future_Mothma(message)
    if message == OnEnter then
		Story_Event("START_REPUBLIC_NEW_ELECTIONS")
		GlobalValue.Set("ChiefOfState", "DUMMY_CHIEFOFSTATE_MOTHMA")

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
