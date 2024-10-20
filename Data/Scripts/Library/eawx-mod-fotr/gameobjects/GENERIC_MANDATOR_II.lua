return {
	Ship_Crew_Requirement = 150,
	Fighters = {
		["GENERIC_Z95_HEADHUNTER_SQUADRON_DOUBLE"] = {
			DEFAULT = {Initial = 1, Reserve = 3, TechLevel = LessOrEqualTo(3)}
		},
		["TWIN_ION_ENGINE_STARFIGHTER_SQUADRON_DOUBLE"] = {
			DEFAULT = {Initial = 1, Reserve = 3, TechLevel = GreaterThan(3)}
		},
		["TORRENT_SQUADRON_DOUBLE"] = {
			DEFAULT = {Initial = 1, Reserve = 3, TechLevel = LessOrEqualTo(3)}
		},
		["V-WING_SQUADRON_DOUBLE"] = {
			DEFAULT = {Initial = 1, Reserve = 3, TechLevel = GreaterThan(3)}
		},
		["GENERIC_ARC_170_SQUADRON"] = {
			DEFAULT = {Initial = 1, Reserve = 3}
		},
		["2_WARPOD_SQUADRON_DOUBLE"] = {
			EMPIRE = {Initial = 1, Reserve = 3, ResearchType = "RepublicWarpods"},
			SECTOR_FORCES = {Initial = 1, Reserve = 3},
			WARLORDS = {Initial = 1, Reserve = 3}
		},
		["GENERIC_BTLB_Y-WING_SQUADRON_DOUBLE"] = {
			CIS = {Initial = 1, Reserve = 3},
			HUTT_CARTELS = {Initial = 1, Reserve = 3},
			EMPIRE = {Initial = 1, Reserve = 3, ResearchType = "~RepublicWarpods"},
			HOSTILE = {Initial = 1, Reserve = 3}
		}
	},
	Scripts = {"multilayer", "fighter-spawn", "persistent-damage", "decolor-manager"}
}