return {
	Ship_Crew_Requirement = 10,
	Fighters = {
		["TORRENT_SQUADRON"] = {
			DEFAULT = {Initial = 1, Reserve = 4},
			EMPIRE = {Initial = 1, Reserve = 4, TechLevel = LessOrEqualTo(3)}
		},
		["GENERIC_V-WING_SQUADRON"] = {
			EMPIRE = {Initial = 1, Reserve = 4, HeroOverride = {{"SATE_PESTAGE","MON_MOTHMA"}, {"ELITE_GUARD_NIMBUS_SQUADRON","ELITE_GUARD_NIMBUS_SQUADRON"}}, TechLevel = GreaterThan(3)}
		},
		["GENERIC_ARC_170_SQUADRON"] = {
			DEFAULT = {Initial = 1, Reserve = 3}
		},
		["2_WARPOD_SQUADRON"] = {
			DEFAULT = {Initial = 1, Reserve = 4, ResearchType = "RepublicWarpods"}
		},
		["GENERIC_BTLB_Y-WING_SQUADRON"] = {
			DEFAULT = {Initial = 1, Reserve = 4, ResearchType = "~RepublicWarpods"}
		},
		["NTB_630_SQUADRON"] = {
			DEFAULT = {Initial = 1, Reserve = 3}
		}
	},
	Scripts = {"multilayer", "fighter-spawn"}
}