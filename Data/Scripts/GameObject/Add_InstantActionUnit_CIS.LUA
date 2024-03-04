--//////////////////////////////////////////////////////////////////////////////////////
-- Add Units to the reinforcement pool// This script is part of the Survival Mode
-- � Pox
--//////////////////////////////////////////////////////////////////////////////////////

require("IA_Spawn_Generic")

function Definitions()
	
	DebugMessage("%s -- In Definitions", tostring(Script))

	-- possible units to spawn
	unit_table = {
	"PURSUER_ENFORCEMENT_SHIP_SQUADRON",
	"GOZANTI_CRUISER_SQUADRON",
	"INTERCEPTOR_FRIGATE",
	"ACTION_VI_SUPPORT",
	"DIAMOND_FRIGATE",
	"HARDCELL_TENDER",
	"HARDCELL",
	"MARAUDER_CRUISER",
	"LUPUS_MISSILE_FRIGATE",
	"SABAOTH_FRIGATE",
	"SABAOTH_HEX_DEPLOYER",
	"GEONOSIAN_CRUISER",
	"C9979_CARRIER",
	"MUNIFEX",
	"MUNIFICENT",
	"RECUSANT_DREADNOUGHT", --Must be above Recusant so IA_Recusant_Dreadnought doesn't match with Recusant first
	"RECUSANT",
	"CAPTOR",
	"SABAOTH_DESTROYER",
	"BULWARK_II",
	"BULWARK_I",
	"SUPPLY_SHIP",
	"GENERIC_PROVIDENCE",
	"GENERIC_LUCREHULK_CONTROL",
	"GENERIC_LUCREHULK",
	"BATTLESHIP_LUCREHULK",
	"AUXILIARY_LUCREHULK_CONTROL",
	"AUXILIARY_LUCREHULK",
	"AUXILIA",
	"SUBJUGATOR",
	"PROVIDENCE_DREADNOUGHT",
	"STORM_FLEET_DESTROYER",
	"LUCREHULK_CORE_DESTROYER",
	"CIS_DREADNAUGHT_LASERS",
	"CIS_DREADNAUGHT"
}

	Define_State("State_Init", State_Init);


end


function State_Init(message)
	if message == OnEnter then	
		IA_Spawn(Object.Get_Type().Get_Name(), "INSTANTACTION_MARKER_NEWREP", "Rebel", unit_table)
		ScriptExit()
		
	end
end