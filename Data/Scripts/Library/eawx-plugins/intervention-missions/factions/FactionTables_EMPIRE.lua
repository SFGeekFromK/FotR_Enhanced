return {
	Missions = {
		["ACCUMULATE"] = {active = false, chance = 4},
		["CARGO_CONVOY"] = {active = false, chance = 12},
		["CONQUER"] = {active = false, chance = 12},
		["CONSTRUCT"] = {active = false, chance = 12},
		["CREW_RECRUITMENT"] = {active = false, chance = 4},
		["HERO_CONVOY"] = {active = false, chance = 12},
		["INFRASTRUCTURE_EXPANSION"] = {active = false, chance = 8},
		["LIBERATE"] = {active = false, chance = 12},
--		["RAISE_INFLUENCE"] = {active = false, chance = 8},
		["RECON"] = {active = false, chance = 12},
		["UPGRADE"] = {active = false, chance = 12},
	},
	RewardGroups = {
		"REP",
		"REP",
		"REP",
		"REP",
		"PDF"
	},
	RewardGroupDetails = {
		["REP"] = {
			DialogName = "REP",
			RewardName = "ERA",
			GroupSupport = "SECTOR_FORCES",
			SupportArg = 1
			-- SupportArg = 50
		},
		["PDF"] = {
			DialogName = "PDF",
			RewardName = "PDF",
			GroupSupport = nil,
		}
	}
}
