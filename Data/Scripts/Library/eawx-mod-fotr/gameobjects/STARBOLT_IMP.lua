return {
	Ship_Crew_Requirement = 10,
	Fighters = {
		["GENERIC_Z95_HEADHUNTER_SQUADRON_HALF"] = {
			CIS = {Initial = 1, Reserve = 2},
			HUTT_CARTELS = {Initial = 1, Reserve = 2},
			EMPIRE = {Initial = 1, Reserve = 2, TechLevel = LessOrEqualTo(3)},
			HOSTILE = {Initial = 1, Reserve = 2, TechLevel = LessOrEqualTo(3)},
			SECTOR_FORCES = {Initial = 1, Reserve = 2, TechLevel = LessOrEqualTo(3)},
			WARLORDS = {Initial = 1, Reserve = 2, TechLevel = LessOrEqualTo(3)}
		},
		["2_WARPOD_SQUADRON_HALF"] = {
			CIS = {Initial = 1, Reserve = 2},
			HUTT_CARTELS = {Initial = 1, Reserve = 2},
			EMPIRE = {Initial = 1, Reserve = 2, TechLevel = LessOrEqualTo(3)},
			HOSTILE = {Initial = 1, Reserve = 2, TechLevel = LessOrEqualTo(3)},
			SECTOR_FORCES = {Initial = 1, Reserve = 2, TechLevel = LessOrEqualTo(3)},
			WARLORDS = {Initial = 1, Reserve = 2, TechLevel = LessOrEqualTo(3)}
		},
		["TWIN_ION_ENGINE_STARFIGHTER_SQUADRON_HALF_IMP"] = {
			EMPIRE = {Initial = 1, Reserve = 2, TechLevel = GreaterThan(3)},
			HOSTILE = {Initial = 1, Reserve = 2, TechLevel = GreaterThan(3)},
			SECTOR_FORCES = {Initial = 1, Reserve = 2, TechLevel = GreaterThan(3)},
			WARLORDS = {Initial = 1, Reserve = 2, TechLevel = GreaterThan(3)}
		},
		["BTLS1_Y-WING_SQUADRON_HALF"] = {
			EMPIRE = {Initial = 1, Reserve = 2, TechLevel = GreaterThan(3)},
			HOSTILE = {Initial = 1, Reserve = 2, TechLevel = GreaterThan(3)},
			SECTOR_FORCES = {Initial = 1, Reserve = 2, TechLevel = GreaterThan(3)},
			WARLORDS = {Initial = 1, Reserve = 2, TechLevel = GreaterThan(3)}
		}
	},
	Scripts = {"multilayer", "fighter-spawn"},
	Flags = {HANGAR = true}
}