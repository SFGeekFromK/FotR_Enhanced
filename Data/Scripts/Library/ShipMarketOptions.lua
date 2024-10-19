return {
	["EMPIRE"] = {
		["KDY_MARKET"] = {
			market_name = "KDY Market",
			faction_object = Find_Player("Empire"),
			news_colour = {r = 250, g = 44, b = 44},
			list = {
				--Pre-Clone War Units
				["GENERIC_PROCURATOR"] = {
					locked = false,
					gc_locked = false,
					amount = 0,
					chance = 40,
					perception_modifier = nil,
					association = nil,
					readable_name = "Procurator-class Battlecruiser",
					text_requirement = "",
					order = 1,
				},
				["GENERIC_PRAETOR"] = {
					locked = false,
					gc_locked = false,
					amount = 0,
					chance = 20,
					perception_modifier = nil,
					association = nil,
					readable_name = "Praetor Mark I Battlecruiser",
					text_requirement = "",
					order = 2,
				},

				--War Mobilization Units
				["GENERIC_MAELSTROM"] = {
					locked = true,
					gc_locked = false,
					amount = 0,
					chance = 40,
					perception_modifier = nil,
					association = nil,
					readable_name = "Maelstrom-class Battlecruiser",
					text_requirement = "[ Requires Venator Research, Locked after the KDY Contract ]",
					order = 3,
				},

				--Imperialization Units
				["GENERIC_SECUTOR"] = {
					locked = true,
					gc_locked = false,
					amount = 0,
					chance = 80,
					perception_modifier = nil,
					association = nil,
					readable_name = "Secutor-class Star Destroyer",
					text_requirement = "[ Requires Order 66 and the KDY Contract ]",
					order = 4,
				},
				["GENERIC_TECTOR"] = {
					locked = true,
					gc_locked = false,
					amount = 0,
					chance = 100,
					perception_modifier = nil,
					association = nil,
					readable_name = "Tector-class Star Destroyer",
					text_requirement = "[ Requires Order 66 and the KDY Contract ]",
					order = 5,
				},
				["GENERIC_STAR_DESTROYER"] = {
					locked = true,
					gc_locked = false,
					amount = 0,
					chance = 100,
					perception_modifier = nil,
					association = nil,
					readable_name = "Imperator-class Star Destroyer",
					text_requirement = "[ Requires Order 66 and the KDY Contract ]",
					order = 6,
				},
			},
		},
	},
}