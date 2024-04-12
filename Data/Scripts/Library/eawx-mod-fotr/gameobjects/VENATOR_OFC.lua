return {
	Ship_Crew_Requirement = 10,
	Fighters = {
		["TORRENT_SQUADRON_DOUBLE"] = {
			DEFAULT = {Initial = 1, Reserve = 2},
			EMPIRE = {Initial = 1, Reserve = 2, TechLevel = LessOrEqualTo(2)}
		},
		["GENERIC_V-WING_SQUADRON"] = {
			EMPIRE = {Initial = 1, Reserve = 3, HeroOverride = {{"SATE_PESTAGE","MON_MOTHMA"}, {"ELITE_GUARD_NIMBUS_SQUADRON","ELITE_GUARD_NIMBUS_SQUADRON"}}, TechLevel = GreaterThan(3)}
		},
		["GENERIC_ARC_170_SQUADRON"] = {
			DEFAULT = {Initial = 1, Reserve = 4}
		},
		["2_WARPOD_SQUADRON"] = {
			DEFAULT = {Initial = 2, Reserve = 5, ResearchType = "RepublicWarpods"}
		},
		["GENERIC_BTLB_Y-WING_SQUADRON"] = {
			DEFAULT = {Initial = 2, Reserve = 5, HeroOverride = {{"AUTEM_VENATOR", "WESSEX_REDOUBT"}, {"NTB_630_SQUADRON","NTB_630_SQUADRON"}}, ResearchType = "~RepublicWarpods"}
		}
	},
	Scripts = {"multilayer", "fighter-spawn"}
}