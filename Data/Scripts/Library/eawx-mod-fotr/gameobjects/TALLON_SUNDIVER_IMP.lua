return {
	Fighters = {
		["GENERIC_Z95_HEADHUNTER_SQUADRON_DOUBLE"] = {
			DEFAULT = {Initial = 1, TechLevel = LessOrEqualTo(2), Reserve = 2}
		},
		["MISSILE_TIE_SQUADRON_DOUBLE_IMP"] = {
			DEFAULT = {Initial = 1, TechLevel = GreaterThan(2), Reserve = 2}
		},
		["GENERIC_BTLB_Y-WING_SQUADRON_DOUBLE_IMP"] = {
			CIS = {Initial = 1, Reserve = 2},
			EMPIRE = {Initial = 1, Reserve = 2},
			HOSTILE = {Initial = 1, Reserve = 2}
		}
	},
	Scripts = {"multilayer", "fighter-spawn"}
}