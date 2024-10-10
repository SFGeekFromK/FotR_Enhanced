return {
	Fighters = {
		["TORRENT_SQUADRON_IMP"] = {
			DEFAULT = {Initial = 1, Reserve = 4},
			EMPIRE = {Initial = 1, Reserve = 4, TechLevel = LessOrEqualTo(3)}
		},
		["TWIN_ION_ENGINE_STARFIGHTER_SQUADRON_HALF_IMP"] = {
			EMPIRE = {Initial = 2, Reserve = 0, TechLevel = EqualTo(3)}
		},
		["TWIN_ION_ENGINE_STARFIGHTER_SQUADRON_HALF"] = {
			EMPIRE = {Initial = 1, Reserve = 4, TechLevel = EqualTo(4)}
		},
		["MISSILE_NIMBUS_SQUADRON"] = {
			EMPIRE = {Initial = 1, Reserve = 4, TechLevel = GreaterThan(4)}
		},
		["ARC_170_OFC_Squadron"] = {
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
-- needs changes