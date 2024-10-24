return {
	Fighters = {
		["TORRENT_SQUADRON"] = {
			DEFAULT = {Initial = 1, TechLevel = LessOrEqualTo(3), Reserve = 4}
		},
		["MISSILE_NIMBUS_SQUADRON"] = {
			DEFAULT = {Initial = 1, TechLevel = GreaterThan(3), Reserve = 4}
		},
		["GENERIC_ARC_170_SQUADRON"] = {
			DEFAULT = {Initial = 1, Reserve = 3}
		},
		["2_WARPOD_SQUADRON"] = {
			DEFAULT = {Initial = 1, Reserve = 4, ResearchType = "RepublicWarpods"}
		},
		["GENERIC_BTLB_Y-WING_SQUADRON"] = {
			DEFAULT = {Initial = 1, Reserve = 4, ResearchType = "~RepublicWarpods"}
		},
		["NTB_630_SQUADRON"] = {
			DEFAULT = {Initial = 1, Reserve = 3}
		}
	},
	Scripts = {"multilayer", "fighter-spawn", "decolor-manager"}
}