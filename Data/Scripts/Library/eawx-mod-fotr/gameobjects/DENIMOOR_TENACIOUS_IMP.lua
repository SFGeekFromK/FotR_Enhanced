return {
	Fighters = {
		["TORRENT_SQUADRON_IMP"] = {
			DEFAULT = {Initial = 1, Reserve = 4, TechLevel = LessOrEqualTo(3)}
		},
		["MISSILE_NIMBUS_SQUADRON_IMP"] = {
			DEFAULT = {Initial = 1, Reserve = 4, TechLevel = GreaterThan(3)}
		},
		["GENERIC_ARC_170_SQUADRON_IMP"] = {
			DEFAULT = {Initial = 1, Reserve = 3}
		},
		["GENERIC_BTLB_Y-WING_SQUADRON_IMP"] = {
			DEFAULT = {Initial = 1, Reserve = 4}
		},
		["NTB_630_SQUADRON_IMP"] = {
			DEFAULT = {Initial = 1, Reserve = 3}
		}
	},
	Scripts = {"multilayer", "fighter-spawn"}
}