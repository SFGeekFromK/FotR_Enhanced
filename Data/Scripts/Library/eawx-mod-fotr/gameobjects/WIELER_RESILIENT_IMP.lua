return {
	Fighters = {
		["TORRENT_SQUADRON_DOUBLE_IMP"] = {
			DEFAULT = {Initial = 2, Reserve = 6, TechLevel = LessOrEqualTo(3)}
		},
		["V-WING_SQUADRON_DOUBLE_IMP"] = {
			DEFAULT = {Initial = 2, Reserve = 6, HeroOverride = {{"SATE_PESTAGE","MON_MOTHMA"}, {"ELITE_GUARD_NIMBUS_SQUADRON","ELITE_GUARD_NIMBUS_SQUADRON"}}, TechLevel = GreaterThan(3)}
		},
		["DELTA6_SQUADRON_DOUBLE_IMP"] = {
			DEFAULT = {Initial = 2, Reserve = 6, TechLevel = LessOrEqualTo(2)}
		},
		["ETA2_ACTIS_SQUADRON_DOUBLE"] = { --Maybe swap this for Delta in Era 2?
			DEFAULT = {Initial = 2, Reserve = 6, TechLevel = GreaterThan(2)}
		},
		["GENERIC_ARC_170_SQUADRON_IMP"] = {
			DEFAULT = {Initial = 1, Reserve = 2}
		}
	},
	Scripts = {"multilayer", "fighter-spawn"}
}