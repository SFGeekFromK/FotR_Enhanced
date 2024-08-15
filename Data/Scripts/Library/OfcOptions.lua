return {
	["EMPIRE"] = {
		["OPEN_CIRCLE_FLEET"] = {
			market_name = "Open Circle Fleet",
			faction_object = Find_Player("Empire"),
			news_colour = {r = 250, g = 44, b = 44},
			list = {
				
				["VENATOR_OFC"] = {
					locked = true,
					gc_locked = false,
					amount = 0,
					amount_limit = 12,
					perception_modifier = nil,
					association = nil,
					readable_name = "OCF Venator Star Destroyer",
					text_requirement = "[ Requires Venator Research & OCF Establishment, Locked after order 66 ]",
					order = 1,
				},
				["ACCLAMATOR_ASSAULT_SHIP_I_OFC"] = {
					locked = true,
					gc_locked = false,
					amount = 0,
					amount_limit = 20,
					perception_modifier = nil,
					association = nil,
					readable_name = "OCF Acclamator-I (Carrier Loadout)",
					text_requirement = "[ Requires OCF Establishment, Locked after order 66 ]",
					order = 2,
				},
				["CHARGER_C70_OFC"] = {
					locked = true,
					gc_locked = false,
					amount = 0,
					amount_limit = 40,
					perception_modifier = nil,
					association = nil,
					readable_name = "OCF Charger C70",
					text_requirement = "[ Requires OCF Establishment, Locked after order 66 ]",
					order = 3,
				},
			},
		},
	},
}