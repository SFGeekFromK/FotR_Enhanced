require("deepcore/std/class")
require("eawx-plugins/government-manager/GovernmentRepublic")
require("eawx-plugins/government-manager/GovernmentCIS")
require("eawx-plugins/government-manager/GovernmentHutts")
require("eawx-plugins/government-manager/GovernmentFavour")
require("eawx-plugins/government-manager/ShipMarket")

---@class GovernmentManager
GovernmentManager = class()

function GovernmentManager:new(gc, id, gc_name)
    self.REPGOV = GovernmentRepublic(gc, id, gc_name)
    self.CISGOV = GovernmentCIS(gc, id, gc_name)
    self.FAVOUR = GovernmentFavour(gc, id)
    self.HUTTGOV = GovernmentHutts(gc, id)
    self.SHIPMARKET = ShipMarket(gc)

    self.human = Find_Player("local")
    self.HuttPlayer = Find_Player("Hutt_Cartels")
    self.CISPlayer = Find_Player("Rebel")

    self.gc_name = gc_name

	GCFavourTable = {
		["FTGU"] = 				{CISFavour = 20, RepFavour = 50},
		["PROGRESSIVE"] =		{CISFavour =  0, RepFavour = 50},
		["MALEVOLENCE"] =		{CISFavour = 85, RepFavour = 85},
		["RIMWARD"] = 			{CISFavour = 70, RepFavour = 65},
		["TENNUUTTA"] = 		{CISFavour = 80, RepFavour = 85},
		["KNIGHT_HAMMER"] = 	{CISFavour = 70, RepFavour = 75},
		["DURGES_LANCE"] = 		{CISFavour = 70, RepFavour = 75},
		["FOEROST"] = 			{CISFavour = 90, RepFavour = 80},
		["OUTER_RIM_SIEGES"] = 	{CISFavour = 85, RepFavour = 85},
	}

	FavourModifierTable = {
		["ERA_1"] = 			{CISModifier = 30, RepModifier =  5},
		["ERA_2"] = 			{CISModifier = 40, RepModifier = 15},
		["ERA_3"] = 			{CISModifier = 50, RepModifier = 20},
		["ERA_4"] = 			{CISModifier = 60, RepModifier = 25},
		["ERA_5"] = 			{CISModifier = 70, RepModifier = 30},
	}

    if self.gc_name == "PROGRESSIVE" then
		local SizeModifier = 10 
		local all_planets = FindPlanet.Get_All_Planets()

		if table.getn(all_planets) < 100 then
			GCFavourTable[self.gc_name].CISFavour = GCFavourTable[self.gc_name].CISFavour + SizeModifier
			GCFavourTable[self.gc_name].RepFavour = GCFavourTable[self.gc_name].RepFavour + SizeModifier
		end

		GCFavourTable[self.gc_name].CISFavour = GCFavourTable[self.gc_name].CISFavour + FavourModifierTable["ERA_".. GlobalValue.Get("CURRENT_ERA")].CISModifier
		GCFavourTable[self.gc_name].RepFavour = GCFavourTable[self.gc_name].RepFavour + FavourModifierTable["ERA_".. GlobalValue.Get("CURRENT_ERA")].RepModifier

	end

    for group, data in pairs(self.FAVOUR.FavourTables["REBEL"]) do
        self.FAVOUR:AdjustFavour(group, GCFavourTable[self.gc_name].CISFavour)
    end

    self.FAVOUR:AdjustFavour("SECTOR_FORCES", GCFavourTable[self.gc_name].RepFavour)
    self:Mobilization_Market_Adjustments()
    self:GC_Specific_Market_Setup()

    crossplot:subscribe("UPDATE_GOVERNMENT", self.UpdateDisplay, self)
    crossplot:subscribe("UPDATE_MOBILIZATION", self.Mobilization_Market_Adjustments, self)
    crossplot:subscribe("SHADOW_COLLECTIVE_AVAILABLE", self.Shadow_Collective_Formation, self)
    crossplot:subscribe("HUTT_EMPIRE_AVAILABLE", self.Hutt_Empire_Formation, self)
end

function GovernmentManager:update()
    self.REPGOV:Update()
    self.FAVOUR:Update()
    self.SHIPMARKET:Update()
    self.HUTTGOV:Update()
end

function GovernmentManager:Shadow_Collective_Formation()
    --Logger:trace("entering GovernmentManager:Shadow_Collective_Formation")
	if self.HuttPlayer.Is_Human() then
		if self.gc_name ~= "KNIGHT_HAMMER" then
			StoryUtil.Multimedia("TEXT_CONQUEST_GOVERNMENT_HUTTS_SHADOW_COLLECTIVE_FORMATION", 20, nil, "Generic_Sith_Loop", 0)
		end
	end
end

function GovernmentManager:Hutt_Empire_Formation()
    --Logger:trace("entering GovernmentManager:Hutt_Empire_Formation")
	if self.HuttPlayer.Is_Human() then
		StoryUtil.Multimedia("TEXT_CONQUEST_GOVERNMENT_HUTTS_EMPIRE_FORMATION", 20, nil, "Jabba_Loop", 0)
	end
end

function GovernmentManager:Mobilization_Market_Adjustments()
    --Logger:trace("entering GovernmentManager:Mobilization_Market_Adjustments")

    local adjustment_lists = {}
    local lock_lists = {}

    if self.REPGOV.CurrentMilitarizationTag == "WAR_MOBILIZATION" then
        adjustment_lists = {
            {"EMPIRE", "KDY_MARKET", "GENERIC_PROCURATOR", -25},
            {"EMPIRE", "KDY_MARKET", "GENERIC_PRAETOR", -10},
        }
        if self.REPGOV.Imperialization == false then
            lock_lists = {
                {"EMPIRE", "KDY_MARKET", "GENERIC_MAELSTROM", false},
            }
        end
    elseif self.REPGOV.CurrentMilitarizationTag == "IMPERIALIZATION" then
        adjustment_lists = {
            {"EMPIRE", "KDY_MARKET", "GENERIC_PROCURATOR", -15},
            {"EMPIRE", "KDY_MARKET", "GENERIC_PRAETOR", -10},
        }
        lock_lists = {
            {"EMPIRE", "KDY_MARKET", "GENERIC_MAELSTROM", true},
            {"EMPIRE", "KDY_MARKET", "GENERIC_TECTOR", false},
            {"EMPIRE", "KDY_MARKET", "GENERIC_SECUTOR", false},
            {"EMPIRE", "KDY_MARKET", "GENERIC_STAR_DESTROYER", false},
        }
    end

    if table.getn(adjustment_lists) > 0 then
        self.SHIPMARKET:adjust_ship_chance(adjustment_lists)
    end
    if table.getn(lock_lists) > 0 then
        self.SHIPMARKET:lock_or_unlock_options(lock_lists)
    end

end

function GovernmentManager:GC_Specific_Market_Setup()
    --Logger:trace("entering GovernmentManager:GC_Specific_Market_Setup")

    local gc_specific_table = {
        ["DURGES_LANCE"] = {
            adjustment_lists = {
                {"EMPIRE", "KDY_MARKET", "GENERIC_PRAETOR", 85, true},
            },
            lock_lists = {
                {"EMPIRE", "KDY_MARKET", "GENERIC_PROCURATOR", nil, nil, true},
                {"EMPIRE", "KDY_MARKET", "GENERIC_MAELSTROM", nil, nil, true},
            },
        },
        ["FOEROST"] = {
            adjustment_lists = {
                {"EMPIRE", "KDY_MARKET", "GENERIC_PROCURATOR", 60, true},
            },
            lock_lists = {
                {"EMPIRE", "KDY_MARKET", "GENERIC_PRAETOR", nil, nil, true},
                {"EMPIRE", "KDY_MARKET", "GENERIC_MAELSTROM", nil, nil, true},
            },
        },
        ["KNIGHT_HAMMER"] = {
            adjustment_lists = {
                {"EMPIRE", "KDY_MARKET", "GENERIC_PROCURATOR", 50, true},
                {"EMPIRE", "KDY_MARKET", "GENERIC_PRAETOR", 60, true},
                {"EMPIRE", "KDY_MARKET", "GENERIC_MAELSTROM", 20, true},
            },
            lock_lists = {
                {"EMPIRE", "KDY_MARKET", "GENERIC_MAELSTROM", false},
            },
        },
        ["MALEVOLENCE"] = {
            adjustment_lists = {
                {"EMPIRE", "KDY_MARKET", "GENERIC_MAELSTROM", 20, true},
            },
            lock_lists = {
                {"EMPIRE", "KDY_MARKET", "GENERIC_PROCURATOR", nil, nil, true},
                {"EMPIRE", "KDY_MARKET", "GENERIC_PRAETOR", nil, nil, true},
                {"EMPIRE", "KDY_MARKET", "GENERIC_MAELSTROM", false},
            },
        },
        ["OUTER_RIM_SIEGES"] = {
            adjustment_lists = {
                {"EMPIRE", "KDY_MARKET", "GENERIC_PRAETOR", 60, true},
            },
            lock_lists = {
                {"EMPIRE", "KDY_MARKET", "GENERIC_PROCURATOR", nil, nil, true},
                {"EMPIRE", "KDY_MARKET", "GENERIC_MAELSTROM", nil, nil, true},
            },
        },
        ["RIMWARD"] = {
            adjustment_lists = {
                {"EMPIRE", "KDY_MARKET", "GENERIC_PRAETOR", 40, true},
                {"EMPIRE", "KDY_MARKET", "GENERIC_MAELSTROM", 60, true},
            },
            lock_lists = {
                {"EMPIRE", "KDY_MARKET", "GENERIC_PROCURATOR", nil, nil, true},
                {"EMPIRE", "KDY_MARKET", "GENERIC_MAELSTROM", false},
            },
        },
        ["TENNUUTTA"] = {
            adjustment_lists = {
                {"EMPIRE", "KDY_MARKET", "GENERIC_TECTOR", 100, true},
                {"EMPIRE", "KDY_MARKET", "GENERIC_STAR_DESTROYER", 100, true},
            },
            lock_lists = {
                {"EMPIRE", "KDY_MARKET", "GENERIC_PROCURATOR", nil, nil, true},
                {"EMPIRE", "KDY_MARKET", "GENERIC_PRAETOR", nil, nil, true},
                {"EMPIRE", "KDY_MARKET", "GENERIC_MAELSTROM", nil, nil, true},
                {"EMPIRE", "KDY_MARKET", "GENERIC_SECUTOR", nil, nil, true},
                {"EMPIRE", "KDY_MARKET", "GENERIC_TECTOR", false},
                {"EMPIRE", "KDY_MARKET", "GENERIC_STAR_DESTROYER", false},
            },
            requirement_lists = {
                {"EMPIRE", "KDY_MARKET", "GENERIC_TECTOR", "[ Requires a Republic Naval Command Center ]"},
                {"EMPIRE", "KDY_MARKET", "GENERIC_STAR_DESTROYER", "[ Requires a Republic Naval Command Center ]"},
            },
        },
    }

    if gc_specific_table[self.gc_name] then
        if gc_specific_table[self.gc_name].adjustment_lists then
            self.SHIPMARKET:adjust_ship_chance(gc_specific_table[self.gc_name].adjustment_lists)
        end
        if gc_specific_table[self.gc_name].lock_lists then
            self.SHIPMARKET:lock_or_unlock_options(gc_specific_table[self.gc_name].lock_lists)
        end
        if gc_specific_table[self.gc_name].requirement_lists then
            self.SHIPMARKET:adjust_ship_requirements(gc_specific_table[self.gc_name].requirement_lists)
        end
    end
end

function GovernmentManager:UpdateDisplay()
    if self.human == Find_Player("Hutt_Cartels") then
        self.HUTTGOV:UpdateDisplay(self.FAVOUR.FavourTables["HUTT_CARTELS"])
    elseif self.human == Find_Player("Rebel") then
        self.CISGOV:UpdateDisplay(self.FAVOUR.FavourTables["REBEL"])
    elseif self.human == Find_Player("Empire") then
        self.REPGOV:UpdateDisplay(self.FAVOUR.FavourTables["EMPIRE"]["SECTOR_FORCES"],self.SHIPMARKET.market_types["EMPIRE"]["KDY_MARKET"].market_name, self.SHIPMARKET.market_types["EMPIRE"]["KDY_MARKET"].list)
    end
end

return GovernmentManager
