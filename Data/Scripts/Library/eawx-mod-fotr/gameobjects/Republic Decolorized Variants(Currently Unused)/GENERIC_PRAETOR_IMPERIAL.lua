return {
	Ship_Crew_Requirement = 150,
	Fighters = {
		["GENERIC_Z95_HEADHUNTER_SQUADRON_DOUBLE"] = {
			DEFAULT = {Initial = 1, Reserve = 4},
			CIS = {Initial = 1, Reserve = 4, TechLevel = LessOrEqualTo(3)},
			EMPIRE = {Initial = 1, Reserve = 4, TechLevel = LessOrEqualTo(3)},
			HOSTILE = {Initial = 1, Reserve = 4, TechLevel = LessOrEqualTo(3)}
		},
		["TWIN_ION_ENGINE_STARFIGHTER_SQUADRON_DOUBLE"] = {
			CIS = {Initial = 1, Reserve = 4, TechLevel = GreaterThan(3)},
			EMPIRE = {Initial = 1, Reserve = 4, TechLevel = GreaterThan(3)},
			HOSTILE = {Initial = 1, Reserve = 4, TechLevel = GreaterThan(3)}
		},
		["CLOAKSHAPE_SQUADRON"] = {
			DEFAULT = {Initial = 1, Reserve = 4, TechLevel = LessOrEqualTo(2)}
		},
		["GENERIC_ARC_170_SQUADRON"] = {
			DEFAULT = {Initial = 1, Reserve = 4, TechLevel = GreaterThan(2)}
		}
	},
	Scripts = {"multilayer", "fighter-spawn", "single-unit-retreat"}
}