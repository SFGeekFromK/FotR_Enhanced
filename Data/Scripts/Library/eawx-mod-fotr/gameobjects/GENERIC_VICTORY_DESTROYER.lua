return {
	Ship_Crew_Requirement = 15,
	Fighters = {
		["TORRENT_SQUADRON"] = {
			DEFAULT = {Initial = 1, Reserve = 1, TechLevel = LessOrEqualTo(3)}
		},
		["GENERIC_V-WING_SQUADRON"] = {
			DEFAULT = {Initial = 1, Reserve = 1, HeroOverride = {{"SATE_PESTAGE","MON_MOTHMA"}, {"ELITE_GUARD_NIMBUS_SQUADRON","ELITE_GUARD_NIMBUS_SQUADRON"}}, TechLevel = GreaterThan(3)}
		}
	},
	Scripts = {"multilayer", "fighter-spawn", "decolor-manager"}
}