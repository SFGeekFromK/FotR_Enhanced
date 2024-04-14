return {
	Ship_Crew_Requirement = 10,
	Fighters = {
		["TORRENT_SQUADRON"] = {
			DEFAULT = {Initial = 1, Reserve = 4},
			EMPIRE = {Initial = 1, Reserve = 4, TechLevel = LessOrEqualTo(3)}
		},
		["REPUBLIC_Z95_HEADHUNTER_SQUADRON_HALF"] = {
			EMPIRE = {Initial = 2, Reserve = 0, TechLevel = EqualTo(3)}
		},
		["REPUBLIC_Z95_HEADHUNTER_SQUADRON"] = {
			EMPIRE = {Initial = 1, Reserve = 2, HeroOverride = {{"AUTEM_VENATOR", "WESSEX_REDOUBT"}, {"GENERIC_V-WING_SQUADRON","GENERIC_V-WING_SQUADRON"}}, TechLevel = GreaterThan(3)}
		},
		["GENERIC_V-WING_SQUADRON"] = {
			EMPIRE = {Initial = 1, Reserve = 2, HeroOverride = {{"SATE_PESTAGE","MON_MOTHMA"}, {"ELITE_GUARD_NIMBUS_SQUADRON","ELITE_GUARD_NIMBUS_SQUADRON"}}, TechLevel = GreaterThan(3)}
		},
		["GENERIC_ARC_170_SQUADRON"] = {
			DEFAULT = {Initial = 1, Reserve = 4}
		},
		["2_WARPOD_SQUADRON"] = {
			DEFAULT = {Initial = 2, Reserve = 6, ResearchType = "RepublicWarpods"}
		},
		["GENERIC_BTLB_Y-WING_SQUADRON"] = {
			DEFAULT = {Initial = 2, Reserve = 6, HeroOverride = {{"AUTEM_VENATOR", "WESSEX_REDOUBT"}, {"NTB_630_SQUADRON","NTB_630_SQUADRON"}}, ResearchType = "~RepublicWarpods"}
		}
	},
	Scripts = {"multilayer", "fighter-spawn"}
}