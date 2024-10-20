return {
	Ship_Crew_Requirement = 5,
	Fighters = {
		["GENERIC_Z95_HEADHUNTER_SQUADRON_HALF"] = {
			HUTT_CARTELS = {Initial = 1, Reserve = 1},
			WARLORDS = {Initial = 1, Reserve = 1},
			HOSTILE = {Initial = 1, Reserve = 1},
			EMPIRE = {Initial = 1, Reserve = 1, TechLevel = LessOrEqualTo(3)},
			SECTOR_FORCES = {Initial = 1, Reserve = 1, TechLevel = LessOrEqualTo(3)}
		},
		["TWIN_ION_ENGINE_STARFIGHTER_SQUADRON_HALF"] = {
			EMPIRE = {Initial = 1, Reserve = 1, TechLevel = GreaterThan(3)},
			SECTOR_FORCES = {Initial = 1, Reserve = 1, TechLevel = GreaterThan(3)}
		}
	},
	Scripts = {"multilayer", "fighter-spawn", "single-unit-retreat", "decolor-manager"},
	Flags = {HANGAR = true}
}