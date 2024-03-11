return {
	Ship_Crew_Requirement = 10,
	Fighters = {
		["TORRENT_SQUADRON_TRIPLE"] = {
			CIS = {Initial = 1, Reserve = 3},
			EMPIRE = {Initial = 1, Reserve = 3, TechLevel = LessOrEqualTo(2)},
			HOSTILE = {Initial = 1, Reserve = 3},
			SECTOR_FORCES = {Initial = 1, Reserve = 3},
			WARLORDS = {Initial = 1, Reserve = 3}
		},
		["2_WARPOD_SQUADRON"] = {
			DEFAULT = {Initial = 1, Reserve = 3, ResearchType = "RepublicWarpods"}
		},
		["BTLB_Y-WING_SQUADRON"] = {
			DEFAULT = {Initial = 1, Reserve = 3, ResearchType = "~RepublicWarpods"}
		},
		["TORRENT_SQUADRON_DOUBLE"] = {
			EMPIRE = {Initial = 1, Reserve = 3, TechLevel = EqualTo(3)}
		},
		["GENERIC_ARC_170_SQUADRON"] = {
			EMPIRE = {Initial = 1, Reserve = 3, TechLevel = GreaterThan(2)}
		},
		["TORRENT_SQUADRON"] = {
			EMPIRE = {Initial = 1, Reserve = 3, TechLevel = EqualTo(4)}
		},
		["REPUBLIC_Z95_HEADHUNTER_SQUADRON"] = {
			EMPIRE = {Initial = 1, Reserve = 3, TechLevel = GreaterOrEqualTo(4)}
		},
		["V-WING_SQUADRON"] = {
			EMPIRE = {Initial = 1, Reserve = 3, TechLevel = GreaterThan(4)}
		}
	},
	Scripts = {"multilayer", "fighter-spawn"}
}