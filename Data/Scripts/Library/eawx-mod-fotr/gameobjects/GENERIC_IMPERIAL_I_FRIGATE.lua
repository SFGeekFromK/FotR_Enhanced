return {
	Ship_Crew_Requirement = 10,
	Fighters = {
		["GENERIC_Z95_HEADHUNTER_SQUADRON"] = {
			HOSTILE = {Initial = 1, Reserve = 2},
			SECTOR_FORCES = {Initial = 1, Reserve = 2},
			WARLORDS = {Initial = 1, Reserve = 2}
		},
		["TWIN_ION_ENGINE_STARFIGHTER_SQUADRON"] = {
			EMPIRE = {Initial = 1, Reserve = 2}
		},
		["2_WARPOD_SQUADRON"] = {
			EMPIRE = {Initial = 1, Reserve = 2, ResearchType = "RepublicWarpods"},
		},
		["GENERIC_BTLB_Y-WING_SQUADRON"] = {
			CIS = {Initial = 1, Reserve = 2},
			EMPIRE = {Initial = 1, Reserve = 2, ResearchType = "~RepublicWarpods"},
			SECTOR_FORCES = {Initial = 1, Reserve = 2},
			WARLORDS = {Initial = 1, Reserve = 2},
			HOSTILE = {Initial = 1, Reserve = 2}
		},
		["MORNINGSTAR_A_SQUADRON"] = {
			HUTT_CARTELS = {Initial = 1, Reserve = 2}
		},
		["KIMOGILA_SQUADRON"] = {
			HUTT_CARTELS = {Initial = 1, Reserve = 2}
		}
	},
	Scripts = {"multilayer", "fighter-spawn", "single-unit-retreat", "decolor-manager"}
}