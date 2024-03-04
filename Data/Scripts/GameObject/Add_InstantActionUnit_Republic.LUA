--//////////////////////////////////////////////////////////////////////////////////////
-- Add Units to the reinforcement pool// This script is part of the Survival Mode
-- � Pox
--//////////////////////////////////////////////////////////////////////////////////////

require("IA_Spawn_Generic")

function Definitions()
	
	DebugMessage("%s -- In Definitions", tostring(Script))

	-- possible units to spawn
	unit_table = {
	"CORELLIAN_CORVETTE",
	"CORELLIAN_GUNBOAT",
	"CHARGER_C70",
	"ARQUITENS",
	"CARRACK_CRUISER_LASERS",
	"CARRACK_CRUISER",
	"GENERIC_ACCLAMATOR_ASSAULT_SHIP_II",
	"GENERIC_ACCLAMATOR_ASSAULT_SHIP_LEVELER",
	"GENERIC_ACCLAMATOR_ASSAULT_SHIP_I",
	"DREADNAUGHT_LASERS",
	"DREADNAUGHT_CARRIER",
	"DREADNAUGHT",
	"GENERIC_VICTORY_DESTROYER_TWO",
	"GENERIC_VICTORY_DESTROYER",
	"GENERIC_VENATOR",
	"INVINCIBLE_CRUISER",
	"GENERIC_STAR_DESTROYER",
	"GENERIC_SECUTOR",
	"GENERIC_TECTOR",
	"GENERIC_MAELSTROM",
	"GENERIC_PROCURATOR",
	"GENERIC_PRAETOR",
	"PELTA_ASSAULT",
	"PELTA_SUPPORT",
	"NEUTRON_STAR",
	"GENERIC_MANDATOR_II",
	"GENERIC_MANDATOR",
	"CITADEL_CRUISER_SQUADRON",
	"CUSTOMS_CORVETTE",
	"IPV1_SYSTEM_PATROL_CRAFT",
	"CLASS_C_SUPPORT",
	"CLASS_C_FRIGATE",
	"GALLEON",
	"CEC_LIGHT_CRUISER",
	"STARBOLT",
	"LAC",
	"CONSULAR_REFIT",
	"LANCER_FRIGATE",
	"VICTORY_I_FRIGATE",
	"GENERIC_GLADIATOR",
	"GENERIC_IMPERIAL_I_FRIGATE",
	-- FotR_Enhanced
	"VENATOR_OFC"
}

	Define_State("State_Init", State_Init);


end


function State_Init(message)
	if message == OnEnter then
		IA_Spawn(Object.Get_Type().Get_Name(), "INSTANTACTION_MARKER_EMPIRE", "Empire", unit_table)
		ScriptExit()
		
	end
end