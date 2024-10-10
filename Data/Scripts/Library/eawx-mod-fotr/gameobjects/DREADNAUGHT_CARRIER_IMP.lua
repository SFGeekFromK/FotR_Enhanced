return {
	Ship_Crew_Requirement = 20,
	Fighters = {
		["GENERIC_Z95_HEADHUNTER_SQUADRON"] = {
			DEFAULT = {Initial = 1, Reserve = 1, HeroOverride = {{"PADME_AMIDALA"}, {"N1_SQUADRON"}}}
		},
		["GENERIC_Z95_BOMBER_SQUADRON"] = {
			DEFAULT = {Initial = 1, Reserve = 2}
		}
	},
	Scripts = {"multilayer", "fighter-spawn"}
}