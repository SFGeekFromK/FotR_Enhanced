return {
	Fighters = {
		["TORRENT_SQUADRON"] = {
			DEFAULT = {Initial = 1, Reserve = 4, TechLevel = LessOrEqualTo(3)}
		},
		["REPUBLIC_Z95_HEADHUNTER_SQUADRON_HALF"] = {
			EMPIRE = {Initial = 2, Reserve = 0, TechLevel = EqualTo(3)}
		},
		["REPUBLIC_Z95_HEADHUNTER_SQUADRON"] = {
			DEFAULT = {Initial = 1,  Reserve = 2, TechLevel = GreaterThan(3)}
		},
		["MISSILE_NIMBUS_SQUADRON"] = {
			DEFAULT = {Initial = 1,  Reserve = 2, TechLevel = GreaterThan(3)}
		},
        ["ARC_170_OFC_SQUADRON"] = {
            DEFAULT = {Initial = 1, Reserve = 4}
        },
		["2_WARPOD_SQUADRON"] = {
			DEFAULT = {Initial = 2, Reserve = 6, ResearchType = "RepublicWarpods"}
		},
		["GENERIC_BTLB_Y-WING_SQUADRON"] = {
			DEFAULT = {Initial = 2, Reserve = 6, ResearchType = "~RepublicWarpods"}
		}
	},
	Scripts = {"multilayer", "fighter-spawn", "decolor-manager"}
}