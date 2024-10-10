return {
	Ship_Crew_Requirement = 10,
	Fighters = {
		["GENERIC_Z95_HEADHUNTER_SQUADRON"] = {
			SECTOR_FORCES = {Initial = 1, Reserve = 1},
			WARLORDS = {Initial = 1, Reserve = 1}
		},
		["TORRENT_SQUADRON"] = {
			CIS = {Initial = 1, Reserve = 1, TechLevel = LessOrEqualTo(2)},
			EMPIRE = {Initial = 1, Reserve = 1, HeroOverride = {{"AUTEM_VENATOR","FORRAL_VENSENOR"}, {"GENERIC_Z95_HEADHUNTER_SQUADRON","GENERIC_Z95_HEADHUNTER_SQUADRON"}}, TechLevel = LessOrEqualTo(2)},
			HOSTILE = {Initial = 1, Reserve = 1, TechLevel = LessOrEqualTo(2)}
		},
		["REPUBLIC_Z95_HEADHUNTER_SQUADRON"] = {
			CIS = {Initial = 1, Reserve = 1, TechLevel = GreaterThan(2)},
			EMPIRE = {Initial = 1, Reserve = 1, HeroOverride = {{"AUTEM_VENATOR","FORRAL_VENSENOR"}, {"GENERIC_Z95_HEADHUNTER_SQUADRON","GENERIC_Z95_HEADHUNTER_SQUADRON"}}, TechLevel = GreaterThan(2)},
			HOSTILE = {Initial = 1, Reserve = 1, TechLevel = GreaterThan(2)}
		},
		["CLOAKSHAPE_SQUADRON"] = {
			SECTOR_FORCES = {Initial = 1, Reserve = 2}
		},
		["GENERIC_ARC_170_SQUADRON"] = {
			CIS = {Initial = 1, Reserve = 2},
			EMPIRE = {Initial = 1, Reserve = 2, HeroOverride = {{"AUTEM_VENATOR","FORRAL_VENSENOR"}, {"CLOAKSHAPE_SQUADRON","CLOAKSHAPE_SQUADRON"}}},
			HOSTILE = {Initial = 1, Reserve = 2},
			WARLORDS = {Initial = 1, Reserve = 2}
		},
		["2_WARPOD_SQUADRON"] = {
			EMPIRE = {Initial = 1, Reserve = 2, ResearchType = "RepublicWarpods"},
			SECTOR_FORCES = {Initial = 1, Reserve = 2}
		},
		["GENERIC_BTLB_Y-WING_SQUADRON"] = {
			CIS = {Initial = 1, Reserve = 2},
			EMPIRE = {Initial = 1, Reserve = 2, ResearchType = "~RepublicWarpods", HeroOverride = {{"AUTEM_VENATOR","FORRAL_VENSENOR"}, {"2_WARPOD_SQUADRON","2_WARPOD_SQUADRON"}}},
			HOSTILE = {Initial = 1, Reserve = 2},
			WARLORDS = {Initial = 1, Reserve = 2}
		},
		["MORNINGSTAR_A_SQUADRON"] = {
			HUTT_CARTELS = {Initial = 1, Reserve = 2}
		},
		["MORNINGSTAR_B_SQUADRON"] = {
			HUTT_CARTELS = {Initial = 1, Reserve = 1}
		},
		["MORNINGSTAR_C_SQUADRON"] = {
			HUTT_CARTELS = {Initial = 1, Reserve = 2}
		}
	},
	Scripts = {"multilayer", "fighter-spawn", "single-unit-retreat"}
}