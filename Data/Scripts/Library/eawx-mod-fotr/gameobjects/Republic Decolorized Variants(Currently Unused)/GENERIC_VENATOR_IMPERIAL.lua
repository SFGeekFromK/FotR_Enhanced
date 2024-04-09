return {
     Ship_Crew_Requirement = 10,
	Fighters = {
		["TORRENT_SQUADRON_IMPERIAL"] = {
			DEFAULT = {Initial = 1, Reserve = 4},
			EMPIRE = {Initial = 1, Reserve = 4, TechLevel = LessOrEqualTo(3)}
		},
		["GENERIC_V-WING_SQUADRON_IMPERIAL"] = {
			EMPIRE = {Initial = 1, Reserve = 4, HeroOverride = {{"SATE_PESTAGE","MON_MOTHMA"}, {"ELITE_GUARD_NIMBUS_SQUADRON","ELITE_GUARD_NIMBUS_SQUADRON"}}, TechLevel = GreaterThan(3)}
		},
		["GENERIC_ARC_170_SQUADRON_IMPERIAL"] = {
			DEFAULT = {Initial = 1, Reserve = 3}
		},
		["GENERIC_BTLB_Y-WING_SQUADRON"] = {
			DEFAULT = {Initial = 1, Reserve = 4}
		},
		["NTB_630_SQUADRON_IMPERIAL"] = {
			DEFAULT = {Initial = 1, Reserve = 3}
		}
	},
	Scripts = {"multilayer", "fighter-spawn"}
}