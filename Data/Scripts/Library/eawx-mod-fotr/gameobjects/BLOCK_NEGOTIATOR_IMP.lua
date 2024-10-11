return {
	Fighters = {
		["TORRENT_SQUADRON_IMP"] = {
			DEFAULT = {Initial = 1, Reserve = 4},
			EMPIRE = {Initial = 1, Reserve = 4, TechLevel = LessOrEqualTo(3)}
		},
		["REPUBLIC_Z95_HEADHUNTER_SQUADRON_HALF_IMP"] = {
			EMPIRE = {Initial = 2, Reserve = 0, TechLevel = EqualTo(3)}
		},
		["REPUBLIC_Z95_HEADHUNTER_SQUADRON_IMP"] = {
			EMPIRE = {Initial = 1, Reserve = 4, TechLevel = EqualTo(4)}
		},
		["MISSILE_NIMBUS_SQUADRON_IMP"] = {
			EMPIRE = {Initial = 1, Reserve = 4, TechLevel = GreaterThan(4)}
		},
		["ARC_170_OFC_SQUADRON_IMP"] = {
			DEFAULT = {Initial = 1, Reserve = 4}
		},
		["GENERIC_BTLB_Y-WING_SQUADRON_IMP"] = {
			DEFAULT = {Initial = 2, Reserve = 6}
		}
	},
	Scripts = {"multilayer", "fighter-spawn"}
}
-- needs changes