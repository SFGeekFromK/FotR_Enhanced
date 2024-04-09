return {
	Ship_Crew_Requirement = 10,
	Fighters = {
		["TORRENT_SQUADRON_DOUBLE"] = {
			DEFAULT = {Initial = 1, Reserve = 2},
			EMPIRE = {Initial = 1, Reserve = 2, TechLevel = LessOrEqualTo(2)}
		},
		["TORRENT_SQUADRON"] = {
			EMPIRE = {Initial = 1, Reserve = 2, TechLevel = EqualTo(3)}
		},
		["REPUBLIC_Z95_HEADHUNTER_SQUADRON"] = {
			EMPIRE = {Initial = 1, Reserve = 2, TechLevel = InInterval(3,4), HeroOverride = {{"AUTEM_VENATOR"}, {"GENERIC_ARC_170_SQUADRON"}}}
		},
		["GENERIC_V-WING_SQUADRON"] = {
			EMPIRE = {Initial = 1, Reserve = 2, HeroOverride = {{"SATE_PESTAGE","MON_MOTHMA"}, {"ELITE_GUARD_NIMBUS_SQUADRON","ELITE_GUARD_NIMBUS_SQUADRON"}}, TechLevel = EqualTo(4)}
		},
		["GENERIC_V-WING_SQUADRON_DOUBLE"] = {
			EMPIRE = {Initial = 1, Reserve = 2, HeroOverride = {{"SATE_PESTAGE","MON_MOTHMA"}, {"ELITE_GUARD_NIMBUS_SQUADRON_DOUBLE","ELITE_GUARD_NIMBUS_SQUADRON_DOUBLE"}}, TechLevel = GreaterThan(4)}
		},
		["GENERIC_ARC_170_SQUADRON"] = {
			DEFAULT = {Initial = 1, Reserve = 4}
		},
		["2_WARPOD_SQUADRON_DOUBLE"] = {
			DEFAULT = {Initial = 1, Reserve = 3, ResearchType = "RepublicWarpods"}
		},
		["GENERIC_BTLB_Y-WING_SQUADRON_DOUBLE"] = {
			DEFAULT = {Initial = 1, Reserve = 3, ResearchType = "~RepublicWarpods", HeroOverride = {{"AUTEM_VENATOR"}, {"NTB_630_SQUADRON_DOUBLE"}}}
		}
	},
	Scripts = {"multilayer", "fighter-spawn"}
}