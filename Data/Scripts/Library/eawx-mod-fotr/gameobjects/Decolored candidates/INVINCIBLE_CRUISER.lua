return {
	Ship_Crew_Requirement = 35,
	Fighters = {
		["GENERIC_Z95_HEADHUNTER_SQUADRON_DOUBLE"] = {
			CIS = {Initial = 1, Reserve = 2},
			HUTT_CARTELS = {Initial = 1, Reserve = 2},
			EMPIRE = {Initial = 1, Reserve = 2, TechLevel = LessOrEqualTo(3)},
			HOSTILE = {Initial = 1, Reserve = 2, TechLevel = LessOrEqualTo(3)},
			SECTOR_FORCES = {Initial = 1, Reserve = 2, TechLevel = LessOrEqualTo(3)},
			WARLORDS = {Initial = 1, Reserve = 2, TechLevel = LessOrEqualTo(3)}
		},
		["TWIN_ION_ENGINE_STARFIGHTER_SQUADRON_DOUBLE"] = {
			EMPIRE = {Initial = 1, Reserve = 2, TechLevel = GreaterThan(3)},
			HOSTILE = {Initial = 1, Reserve = 2, TechLevel = GreaterThan(3)}
		},
		["CLOAKSHAPE_STOCK_SQUADRON"] = {
			CIS = {Initial = 1, Reserve = 4},
			HUTT_CARTELS = {Initial = 1, Reserve = 4},
			EMPIRE = {Initial = 1, Reserve = 4, TechLevel = LessThan(2)},
			HOSTILE = {Initial = 1, Reserve = 4, TechLevel = LessThan(2)},
			SECTOR_FORCES = {Initial = 1, Reserve = 4, TechLevel = LessThan(2)},
			WARLORDS = {Initial = 1, Reserve = 4, TechLevel = LessThan(2)}
		},
		["TORRENT_SQUADRON"] = {
			EMPIRE = {Initial = 1, Reserve = 4, TechLevel = IsOneOf({2, 3})},
			HOSTILE = {Initial = 1, Reserve = 4, TechLevel = IsOneOf({2, 3})},
			SECTOR_FORCES = {Initial = 1, Reserve = 4, TechLevel = IsOneOf({2, 3})},
			WARLORDS = {Initial = 1, Reserve = 4, TechLevel = IsOneOf({2, 3})}
		},
		["GENERIC_V-WING_SQUADRON"] = {
			EMPIRE = {Initial = 1, Reserve = 2, TechLevel = GreaterThan(3)},
			HOSTILE = {Initial = 1, Reserve = 2, TechLevel = GreaterThan(3)},
			SECTOR_FORCES = {Initial = 1, Reserve = 2, TechLevel = GreaterThan(3)},
			WARLORDS = {Initial = 1, Reserve = 2, TechLevel = GreaterThan(3)}
		},
		["2_WARPOD_SQUADRON_DOUBLE"] = {
			SECTOR_FORCES = {Initial = 1, Reserve = 1},
			WARLORDS = {Initial = 1, Reserve = 1}
		},
		["H60_TEMPEST_SQUADRON_DOUBLE"] = {
			CIS = {Reserve = 1, Initial = 1},
			EMPIRE = {Reserve = 1, Initial = 1},
			HOSTILE = {Reserve = 1, Initial = 1}
		},
		["SCURRG_H6_PROTOTYPE_SQUADRON_DOUBLE"] = {
			HUTT_CARTELS = {Reserve = 1, Initial = 1}
		}
	},
	Scripts = {"multilayer", "fighter-spawn", "decolor-manager"}
}