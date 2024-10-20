return {
	Ship_Crew_Requirement = 10,
	Fighters = {
		["GENERIC_Z95_HEADHUNTER_SQUADRON_DOUBLE"] = {
			SECTOR_FORCES = {Initial = 1, Reserve = 2},
			WARLORDS = {Initial = 1, Reserve = 2}
		},
		["TORRENT_SQUADRON_DOUBLE"] = {
			CIS = {Initial = 1, Reserve = 2},
			EMPIRE = {Initial = 1, Reserve = 2},
			HOSTILE = {Initial = 1, Reserve = 2}
		},
		["MORNINGSTAR_A_SQUADRON_DOUBLE"] = {
			HUTT_CARTELS = {Initial = 1, Reserve = 2}
		},
		["2_WARPOD_SQUADRON_DOUBLE"] = {
			EMPIRE = {Initial = 1, Reserve = 2, ResearchType = "RepublicWarpods"},
			SECTOR_FORCES = {Initial = 1, Reserve = 2},
			WARLORDS = {Initial = 1, Reserve = 2}
		},
		["GENERIC_BTLB_Y-WING_SQUADRON_DOUBLE"] = {
			CIS = {Initial = 1, Reserve = 2},
			EMPIRE = {Initial = 1, Reserve = 2, ResearchType = "~RepublicWarpods"},
			HOSTILE = {Initial = 1, Reserve = 2}
		},
		["MORNINGSTAR_C_SQUADRON_DOUBLE"] = {
			HUTT_CARTELS = {Initial = 1, Reserve = 2}
		}
	},
	Scripts = {"multilayer", "fighter-spawn", "single-unit-retreat", "decolor-manager"}
}