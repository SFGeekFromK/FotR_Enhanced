return {
	Ship_Crew_Requirement = 35,
	Fighters = {
		["DELTA6_SQUADRON"] = {
			DEFAULT = {Initial = 1, Reserve = 2, TechLevel = LessOrEqualTo(2)}
		},
		["ETA2_ACTIS_SQUADRON"] = {
			DEFAULT = {Initial = 1, Reserve = 2, TechLevel = GreaterThan(2)}
		},
		["CLOAKSHAPE_STOCK_SQUADRON"] = {
			DEFAULT = {Initial = 1, Reserve = 2, TechLevel = LessOrEqualTo(3)}
		},		
		["GENERIC_V-WING_SQUADRON"] = {
			DEFAULT = {Initial = 1, Reserve = 2, TechLevel = GreaterThan(3)}
		}
	},
	Scripts = {"multilayer", "fighter-spawn"}
}