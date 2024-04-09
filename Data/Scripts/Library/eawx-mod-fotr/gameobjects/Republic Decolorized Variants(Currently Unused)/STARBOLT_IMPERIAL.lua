return {
	Ship_Crew_Requirement = 10,
	Fighters = {
		["TWIN_ION_ENGINE_STARFIGHTER_SQUADRON_HALF"] = {
			EMPIRE = {Initial = 1, Reserve = 2},
			HOSTILE = {Initial = 1, Reserve = 2},
			SECTOR_FORCES = {Initial = 1, Reserve = 2},
			WARLORDS = {Initial = 1, Reserve = 2}
		},
		["BTLS1_Y-WING_SQUADRON_HALF"] = {
			EMPIRE = {Initial = 1, Reserve = 2},
			HOSTILE = {Initial = 1, Reserve = 2},
			SECTOR_FORCES = {Initial = 1, Reserve = 2},
			WARLORDS = {Initial = 1, Reserve = 2}
		}
	},
	Scripts = {"multilayer", "fighter-spawn"},
	Flags = {HANGAR = true}
}