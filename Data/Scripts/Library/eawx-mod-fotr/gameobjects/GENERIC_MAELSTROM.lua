return {
	Ship_Crew_Requirement = 35,
	Fighters = {
		["TORRENT_SQUADRON_DOUBLE"] = {
			DEFAULT = {Initial = 1, Reserve = 2, TechLevel = LessOrEqualTo(3)}
		},
		["GENERIC_V-WING_SQUADRON_DOUBLE"] = {
			DEFAULT = {Initial = 1, Reserve = 2, HeroOverride = {{"SATE_PESTAGE","MON_MOTHMA"}, {"ELITE_GUARD_NIMBUS_SQUADRON_DOUBLE","ELITE_GUARD_NIMBUS_SQUADRON_DOUBLE"}}, TechLevel = GreaterThan(3)}
		},
		["2_WARPOD_SQUADRON"] = {
			DEFAULT = {Initial = 1, Reserve = 3, ResearchType = "RepublicWarpods"}
		},
		["GENERIC_BTLB_Y-WING_SQUADRON"] = {
			DEFAULT = {Initial = 1, Reserve = 3, ResearchType = "~RepublicWarpods"}
		},
		["EARLY_SKIPRAY_SQUADRON_HALF"] = {
			DEFAULT = {Initial = 1, Reserve = 3}
		}		
	},
	Scripts = {"multilayer", "fighter-spawn", "decolor-manager"}
}