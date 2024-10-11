return {
	Ship_Crew_Requirement = 10,
	Fighters = {
		["DELTA6_SQUADRON_IMP"] = {
			CIS = {Initial = 1, Reserve = 1, TechLevel = LessOrEqualTo(2)},
			EMPIRE = {Initial = 1, Reserve = 1, TechLevel = LessOrEqualTo(2)},
			HOSTILE = {Initial = 1, Reserve = 1, TechLevel = LessOrEqualTo(2)},
			SECTOR_FORCES = {Initial = 1, Reserve = 1, TechLevel = LessOrEqualTo(2)},
			WARLORDS = {Initial = 1, Reserve = 1, TechLevel = LessOrEqualTo(2)}
		},
		["ETA2_ACTIS_SQUADRON_IMP"] = {
			CIS = {Initial = 1, Reserve = 1, TechLevel = GreaterThan(2)},
			EMPIRE = {Initial = 1, Reserve = 1, TechLevel = GreaterThan(2)},
			HOSTILE = {Initial = 1, Reserve = 1, TechLevel = GreaterThan(2)},
			SECTOR_FORCES = {Initial = 1, Reserve = 1, TechLevel = GreaterThan(2)},
			WARLORDS = {Initial = 1, Reserve = 1, TechLevel = GreaterThan(2)}
		},
		["MORNINGSTAR_B_SQUADRON"] = {
			HUTT_CARTELS = {Initial = 1, Reserve = 1}
		}
	},
	Scripts = {"multilayer", "fighter-spawn", "single-unit-retreat"}
}