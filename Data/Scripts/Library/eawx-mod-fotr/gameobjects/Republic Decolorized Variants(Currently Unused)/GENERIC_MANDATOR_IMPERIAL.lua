return {
	Ship_Crew_Requirement = 150,
	Fighters = {
		["GENERIC_Z95_HEADHUNTER_SQUADRON_DOUBLE"] = {
			DEFAULT = {Initial = 1, Reserve = 3, TechLevel = LessOrEqualTo(3)}
		},
		["V-WING_SQUADRON_DOUBLE"] = {
			DEFAULT = {Initial = 1, Reserve = 3, TechLevel = GreaterThan(3)}
		},
		["CLOAKSHAPE_SQUADRON_DOUBLE"] = {
			DEFAULT = {Initial = 1, Reserve = 3, TechLevel = LessOrEqualTo(3)}
		},
		["TWIN_ION_ENGINE_STARFIGHTER_SQUADRON"] = {
			DEFAULT = {Initial = 1, Reserve = 3, TechLevel = GreaterThan(3)}
		},
		["GENERIC_ARC_170_SQUADRON"] = {
			DEFAULT = {Initial = 1, Reserve = 3, TechLevel = GreaterThan(3)}
		},
		["2_WARPOD_SQUADRON_DOUBLE"] = {
			DEFAULT = {Initial = 1, Reserve = 3, TechLevel = LessOrEqualTo(3)}
		},
		["GENERIC_BTLB_Y-WING_SQUADRON_DOUBLE"] = {
			DEFAULT = {Reserve = 3, Initial = 1, TechLevel = GreaterThan(3)}
		}
	},
	Scripts = {"multilayer", "fighter-spawn", "persistent-damage"}
}