return {
	Ship_Crew_Requirement = 35,
	Fighters = {
		["TORRENT_SQUADRON_IMP"] = {
			DEFAULT = {Initial = 3, Reserve = 8, TechLevel = LessOrEqualTo(3)}
		},
		["GENERIC_V-WING_SQUADRON_IMP"] = {
			DEFAULT = {Initial = 3, Reserve = 8, HeroOverride = {{"EMPEROR_PALPATINE"}, {"ELITE_GUARD_NIMBUS_SQUADRON"}}, TechLevel = GreaterThan(3)}
		},
		["TWIN_ION_ENGINE_STARFIGHTER_SQUADRON_IMP"] = {
			DEFAULT = {Initial = 1, Reserve = 2}
		},
		["2_WARPOD_SQUADRON_DOUBLE"] = {
			SECTOR_FORCES = {Initial = 1, Reserve = 2},
			WARLORDS = {Initial = 1, Reserve = 2}
		},
		["GENERIC_BTLB_Y-WING_SQUADRON_DOUBLE_IMP"] = {
			CIS = {Initial = 1, Reserve = 2},
			EMPIRE = {Initial = 1, Reserve = 2},
			HOSTILE = {Initial = 1, Reserve = 2}
		},
		["KIMOGILA_SQUADRON_DOUBLE"] = {
			HUTT_CARTELS = {Initial = 1, Reserve = 2}
		},
		["NTB_630_SQUADRON_IMP"] = {
			DEFAULT = {Initial = 1, Reserve = 4}
		}
	},
	Scripts = {"multilayer", "fighter-spawn"}
}