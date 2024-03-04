--******************************************************************************
--     _______ __
--    |_     _|  |--.----.---.-.--.--.--.-----.-----.
--      |   | |     |   _|  _  |  |  |  |     |__ --|
--      |___| |__|__|__| |___._|________|__|__|_____|
--     ______
--    |   __ \.-----.--.--.-----.-----.-----.-----.
--    |      <|  -__|  |  |  -__|     |  _  |  -__|
--    |___|__||_____|\___/|_____|__|__|___  |_____|
--                                    |_____|
--*   @Author:              [TR]Pox <Pox>
--*   @Date:                2018-01-06T18:36:14+01:00
--*   @Project:             Imperial Civil War
--*   @Filename:            GameObjectLibrary.lua
--*   @Last modified by:    [TR]Pox
--*   @Last modified time:  2018-04-12T00:17:51+02:00
--*   @License:             This source code may only be used with explicit permission from the developers
--*   @Copyright:           © TR: Imperial Civil War Development Team
--******************************************************************************

require("eawx-util/Comparators")

GameObjectLibrary = {
    Interdictors = {
		"Galleon",
		"Pelta_Support",
		"Supply_Ship",
        "Interdiction_Minefield_Container"
    },
    Numbers = {
        "Display_One",
        "Display_Two",
        "Display_Three",
        "Display_Four",
        "Display_Five",
        "Display_Six",
        "Display_Seven",
        "Display_Eight",
        "Display_Nine",
        "Display_Ten"
    },
    OrbitalStructures = {
		["GENERIC_SHIPYARD_LEVEL_ONE"] = {
            Text = "TEXT_DISPLAY_SHIPYARD1",
            Equation = "Planet_Has_Shipyard_One"
        },
        ["GENERIC_SHIPYARD_LEVEL_TWO"] = {
            Text = "TEXT_DISPLAY_SHIPYARD2",
            Equation = "Planet_Has_Shipyard_Two"
        },
        ["GENERIC_SHIPYARD_LEVEL_THREE"] = {
            Text = "TEXT_DISPLAY_SHIPYARD3",
            Equation = "Planet_Has_Shipyard_Three"
        },
        ["GENERIC_SHIPYARD_LEVEL_FOUR"] = {
            Text = "TEXT_DISPLAY_SHIPYARD4",
            Equation = "Planet_Has_Shipyard_Four"
        },
		["SECONDARY_HAVEN"] = {
            Text = "TEXT_DISPLAY_HAVEN_STATION",
            Equation = "Planet_Has_Haven"
        },
        ["SECONDARY_TF_OUTPOST"] = {
            Text = "TEXT_DISPLAY_TF_OUTPOST_STATION",
            Equation = "Planet_Has_TF_Outpost"
        },
		["SECONDARY_GOLAN_ONE"] = {
            Text = "TEXT_DISPLAY_GOLAN_ONE_STATION",
            Equation = "Planet_Has_Golan_One"
        },
        ["SECONDARY_GOLAN_TWO"] = {
            Text = "TEXT_DISPLAY_GOLAN_TWO_STATION",
            Equation = "Planet_Has_Golan_Two"
        },
        ["GENERIC_TRADESTATION"] = {
            Text = "TEXT_DISPLAY_TRADE",
            Equation = "Planet_Has_Trade_Station"
        },
		["GENERIC_COLONY_ONE"] = {
            Text = "TEXT_DISPLAY_COLONY_ONE",
            Equation = "Planet_Has_Colony_One"
        },
		["GENERIC_COLONY_TWO"] = {
            Text = "TEXT_DISPLAY_COLONY_TWO",
            Equation = "Planet_Has_Colony_Two"
        },
		["REPUBLIC_NAVAL_COMMAND_CENTRE"] = {
            Text = "TEXT_DISPLAY_REPUBLIC_NAVAL_COMMAND_CENTRE",
            Equation = "Planet_Has_Republic_Naval_Command_Centre"
        },
		["SABAOTH_HQ"] = {
            Text = "TEXT_DISPLAY_SABAOTH_HQ",
            Equation = "Planet_Has_Sabaoth_HQ"
        },
		["PIRATE_BASE"] = {
            Text = "TEXT_DISPLAY_PIRATE_BASE",
            Equation = "Planet_Has_Pirate_Base"
        },
        ["VALIDUSIA"] = {
            Text = "TEXT_DISPLAY_VALIDUSIA",
            Equation = "Planet_Has_Validusia"
        },
		["EMPRESS_STATION"] = {
            Text = "TEXT_DISPLAY_EMPRESS",
            Equation = "Planet_Has_Empress"
        }
        --  ["CREW_RESOURCE_DUMMY"]={
        --      Text="TEXT_DISPLAY_SLAYN_KORPIL"
        --  },
        --    ["PLACEHOLDER_CATEGORY_DUMMY"]={
        --        Text="TEXT_DISPLAY_PLACEHOLDER_CATEGORY_DUMMY"
        --    },
        --    ["NON_CAPITAL_CATEGORY_DUMMY"]={
        --        Text="TEXT_DISPLAY_NON_CAPITAL_CATEGORY_DUMMY"
        --    },
        --    ["CAPITAL_CATEGORY_DUMMY"]={
        --        Text="TEXT_DISPLAY_CAPITAL_CATEGORY_DUMMY"
        --    },
        --    ["STRUCTURE_CATEGORY_DUMMY"]={
        --        Text="TEXT_DISPLAY_STRUCTURE_CATEGORY_DUMMY"
        --    }
    },
    InfluenceLevels = {
        ["INFLUENCE_ONE"] = {},
        ["INFLUENCE_TWO"] = {},
        ["INFLUENCE_THREE"] = {},
        ["INFLUENCE_FOUR"] = {},
        ["INFLUENCE_FIVE"] = {},
        ["INFLUENCE_SIX"] = {},
        ["INFLUENCE_SEVEN"] = {},
        ["INFLUENCE_EIGHT"] = {},
        ["INFLUENCE_NINE"] = {},
        ["INFLUENCE_TEN"] = {},
        ["BONUS_PLACEHOLDER"] = {}
    },
    Units = require("GameObjectList")
}
return GameObjectLibrary
