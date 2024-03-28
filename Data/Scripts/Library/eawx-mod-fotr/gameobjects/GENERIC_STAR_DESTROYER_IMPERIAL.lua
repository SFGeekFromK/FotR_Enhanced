return {
	Ship_Crew_Requirement = 30,
	Fighters = {
		["TORRENT_SQUADRON_DOUBLE"] = {
			EMPIRE = {Initial = 1, Reserve = 2, TechLevel = LessOrEqualTo(3)},
			HOSTILE = {Initial = 1, Reserve = 2},
			WARLORDS = {Initial = 1, Reserve = 2}
		},
		["V-WING_SQUADRON_DOUBLE"] = {
			EMPIRE = {Initial = 1, Reserve = 2, HeroOverride = {{"EMPEROR_PALPATINE"}, {"ELITE_GUARD_NIMBUS_SQUADRON"}}, TechLevel = GreaterThan(3)}
		},
		["GENERIC_ARC_170_SQUADRON"] = {
			DEFAULT = {Initial = 1, Reserve = 2}
		},
		["EARLY_SKIPRAY_SQUADRON_HALF"] = {
			DEFAULT = {Initial = 1, Reserve = 1}
		},
		["2_WARPOD_SQUADRON"] = {
			DEFAULT = {Initial = 1, Reserve = 2, ResearchType = "RepublicWarpods"}
		},
		["GENERIC_BTLB_Y-WING_SQUADRON"] = {
			DEFAULT = {Initial = 1, Reserve = 2, ResearchType = "~RepublicWarpods"}
		},
		["TRIFIGHTER_SQUADRON"] = {
			REBEL = {Initial = 1, Reserve = 2}
		},
		["VULTURE_SQUADRON_DOUBLE"] = {
			REBEL = {Initial = 1, Reserve = 2}
		},
		["NANTEX_SQUADRON_HALF"] = {
			REBEL = {Initial = 1, Reserve = 1}
		},
		["BELBULLAB24_SQUADRON"] = {
			REBEL = {Initial = 1, Reserve = 2}
		},
		["MORNINGSTAR_A_SQUADRON_DOUBLE"] = {
			HUTT_CARTELS = {Initial = 1, Reserve = 2}
		}
	},
	Scripts = {"multilayer", "fighter-spawn"}
}