return {
	Fighters = {
		["GENERIC_Z95_HEADHUNTER_SQUADRON"] = {
			DEFAULT = {Initial = 3, Reserve = 10, TechLevel = LessOrEqualTo(2)}
		},
		["REPUBLIC_Z95_HEADHUNTER_SQUADRON"] = {
			DEFAULT = {Initial = 3, Reserve = 10, TechLevel = GreaterThan(2)}
		},
		["GENERIC_ARC_170_SQUADRON_DOUBLE"] = {
			DEFAULT = {Initial = 1, Reserve = 2}
		}
	},
	Scripts = {"multilayer", "fighter-spawn", "microjump", "decolor-manager"}
}