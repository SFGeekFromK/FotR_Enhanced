return {
	Fighters = {
		["TORRENT_SQUADRON"] = {
			DEFAULT = {Initial = 1, Reserve = 4},
			EMPIRE = {Initial = 1, Reserve = 4, TechLevel = LessOrEqualTo(3)}
		},
		["REPUBLIC_Z95_HEADHUNTER_SQUADRON_HALF"] = {
			EMPIRE = {Initial = 2, Reserve = 0, TechLevel = EqualTo(3)}
		},
		["REPUBLIC_Z95_HEADHUNTER_SQUADRON"] = {
			EMPIRE = {Initial = 1, Reserve = 4, TechLevel = EqualTo(4)}
		},
		["MISSILE_NIMBUS_SQUADRON"] = {
			EMPIRE = {Initial = 1, Reserve = 4, TechLevel = GreaterThan(4)}
		},
		["GENERIC_ARC_170_SQUADRON"] = {
			DEFAULT = {Initial = 1, Reserve = 4}
		},
		["2_WARPOD_SQUADRON"] = {
			DEFAULT = {Initial = 2, Reserve = 6, ResearchType = "RepublicWarpods"}
		},
		["GENERIC_BTLB_Y-WING_SQUADRON"] = {
			DEFAULT = {Initial = 2, Reserve = 6, ResearchType = "~RepublicWarpods"}
		}
	},
	Scripts = {"multilayer", "fighter-spawn"}
}