return {
	Ship_Crew_Requirement = 1,
	Fighters = {
		["CLOAKSHAPE_STOCK_SQUADRON_HALF"] = {
			DEFAULT = {Initial = 1, Reserve = 2, HeroOverride = {{"PADME_AMIDALA"}, {"N1_SQUADRON_HALF"}}}
		},
		["2_WARPOD_SQUADRON_HALF"] = {
			DEFAULT = {Initial = 1, Reserve = 0}
		}
	},
	Scripts = {"multilayer", "fighter-spawn"},
	Flags = {HANGAR = true}
}