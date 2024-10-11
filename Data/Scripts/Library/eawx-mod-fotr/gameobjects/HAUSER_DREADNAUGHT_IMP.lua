return {
	Fighters = {
		["TORRENT_SQUADRON_IMP"] = {
			DEFAULT = {Initial = 1, Reserve = 0, TechLevel = LessOrEqualTo(2)}
		},
		["REPUBLIC_Z95_HEADHUNTER_SQUADRON_IMP"] = {
			DEFAULT = {Initial = 1, Reserve = 0, TechLevel = GreaterOrEqualTo(3)}
		}
	},
	Scripts = {"multilayer", "fighter-spawn"}    
}