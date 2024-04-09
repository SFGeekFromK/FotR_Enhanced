return {
	["TORRENT_SQUADRON_DOUBLE"] = {
		DEFAULT = {Initial = 1, Reserve = 2},
		EMPIRE = {Initial = 1, Reserve = 2, TechLevel = LessOrEqualTo(2)}
	},
	["TORRENT_SQUADRON"] = {
		EMPIRE = {Initial = 1, Reserve = 2, TechLevel = EqualTo(3)}
	},
	["REPUBLIC_Z95_HEADHUNTER_SQUADRON"] = {
		EMPIRE = {Initial = 1, Reserve = 2, TechLevel = InInterval(3,4)}
	},
	["MISSILE_NIMBUS_SQUADRON"] = {
		EMPIRE = {Initial = 1, Reserve = 2, TechLevel = EqualTo(4)}
	},
	["MISSILE_NIMBUS_SQUADRON_DOUBLE"] = {
		EMPIRE = {Initial = 1, Reserve = 2, TechLevel = GreaterThan(4)}
	},
	["GENERIC_ARC_170_SQUADRON"] = {
		DEFAULT = {Initial = 1, Reserve = 4}
	},
	["2_WARPOD_SQUADRON_DOUBLE"] = {
		DEFAULT = {Initial = 1, Reserve = 3, ResearchType = "RepublicWarpods"}
	},
	["GENERIC_BTLB_Y-WING_SQUADRON_DOUBLE"] = {
		DEFAULT = {Initial = 1, Reserve = 3, ResearchType = "~RepublicWarpods"}
	},
	Scripts = {"multilayer", "fighter-spawn"}
}