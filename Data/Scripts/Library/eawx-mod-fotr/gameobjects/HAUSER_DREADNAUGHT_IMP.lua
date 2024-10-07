return {
	Fighters = {
		["TORRENT_SQUADRON"] = {
			DEFAULT = {Initial = 1, Reserve = 0, TechLevel = LessOrEqualTo(2)}
		},
		["REPUBLIC_Z95_HEADHUNTER_SQUADRON"] = {
			DEFAULT = {Initial = 1, Reserve = 0, TechLevel = GreaterOrEqualTo(3)}
		}
	},
	Scripts = {"multilayer", "fighter-spawn"}    
}