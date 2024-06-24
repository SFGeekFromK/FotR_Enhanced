return {
	Ship_Crew_Requirement = 30,
	Fighters = {
		["TORRENT_SQUADRON_DOUBLE"] = {
			EMPIRE = {Initial = 1, Reserve = 2, TechLevel = LessOrEqualTo(3)}
		},
		["V-WING_SQUADRON_DOUBLE"] = {
			EMPIRE = {Initial = 1, Reserve = 2, TechLevel = GreaterThan(3)}
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
		["VADER_ETA"] = {
			DEFAULT = {Initial = 1, Reserve = 0}
	},
	Scripts = {"multilayer", "fighter-spawn"}
}