require("deepcore/std/class")
require("eawx-plugins/government-manager/GovernmentNewRepublic")
require("eawx-plugins/government-manager/GovernmentEmpire")
require("eawx-plugins/government-manager/GovernmentFavour")
require("eawx-plugins/government-manager/GovernmentHutts")
require("eawx-plugins/government-manager/ShipMarket")
require("eawx-util/Sort")

---@class GovernmentManager
GovernmentManager = class()

---@param dummy_lifecycle_handler KeyDummyLifeCycleHandler
function GovernmentManager:new(gc, absorb, dark_empire, id, dummy_lifecycle_handler)
    self.NRGOV = GovernmentNewRepublic(id, dummy_lifecycle_handler)
    self.EMPIREGOV = GovernmentEmpire(gc, absorb, dark_empire, id)
    self.SHIPMARKET = ShipMarket(gc)
    self.FAVOUR = GovernmentFavour(gc, id)
    self.HUTTGOV = GovernmentHutts(gc, id)

    self.human = Find_Player("local")
    self.HuttPlayer = Find_Player("Hutt_Cartels")

    crossplot:subscribe("UPDATE_GOVERNMENT", self.UpdateDisplay, self)

end

function GovernmentManager:update()
    self.NRGOV:Update()
    self.EMPIREGOV:Update()
    self.SHIPMARKET:Update()
    self.FAVOUR:Update()
    self.HUTTGOV:Update()
end

function GovernmentManager:UpdateDisplay()
    if self.human == Find_Player("HUTT_CARTELS") then
        self.HUTTGOV:UpdateDisplay(self.FAVOUR.FavourTables["HUTT_CARTELS"])
    elseif self.human == Find_Player("EMPIRE") 
        or self.human == Find_Player("ERIADU_AUTHORITY") 
        or self.human == Find_Player("ZSINJ_EMPIRE") 
        or self.human == Find_Player("GREATER_MALDROOD") 
        or self.human == Find_Player("PENTASTAR") 
        then
            self.EMPIREGOV:UpdateDisplay()
    elseif self.human == Find_Player("REBEL") then
        self.NRGOV:UpdateDisplay()
    elseif self.human == Find_Player("CORPORATE_SECTOR") then
        local plot = Get_Story_Plot("Conquests\\Player_Agnostic_Plot.xml")
        local government_display_event = plot.Get_Event("Government_Display")

        government_display_event.Set_Reward_Parameter(1, "CORPORATE_SECTOR")
        government_display_event.Clear_Dialog_Text()

        government_display_event.Add_Dialog_Text("TEXT_DOCUMENTATION_BODY_SEPARATOR")
        government_display_event.Add_Dialog_Text("TEXT_GOVERNMENT_CSA")
        government_display_event.Add_Dialog_Text("TEXT_DOCUMENTATION_BODY_SEPARATOR")

        government_display_event.Add_Dialog_Text("TEXT_NONE")
        
        government_display_event.Add_Dialog_Text("TEXT_GOVERNMENT_CSA_OVERVIEW_HEADER")
        government_display_event.Add_Dialog_Text("TEXT_DOCUMENTATION_BODY_SEPARATOR")
        government_display_event.Add_Dialog_Text("TEXT_GOVERNMENT_CSA_OVERVIEW")
        government_display_event.Add_Dialog_Text("TEXT_DOCUMENTATION_BODY_SEPARATOR")
        government_display_event.Add_Dialog_Text("TEXT_NONE")
        government_display_event.Add_Dialog_Text("TEXT_GOVERNMENT_CSA_LIST_01")
        for i, ship in ipairs(SortKeysByElement(self.SHIPMARKET.market_types["CORPORATE_SECTOR"]["SHIP_MARKET"].list,"order","asc")) do
            local ship_data = self.SHIPMARKET.market_types["CORPORATE_SECTOR"]["SHIP_MARKET"].list[ship]
            if ship_data.amount > 0 then
                government_display_event.Add_Dialog_Text(ship_data.readable_name .." : "..tostring(ship_data.amount) .." - [ ".. tostring(ship_data.chance/10) .."%% ]")
            end
        end
        government_display_event.Add_Dialog_Text("TEXT_NONE")
        government_display_event.Add_Dialog_Text("None on the market:")
        for i, ship in ipairs(SortKeysByElement(self.SHIPMARKET.market_types["CORPORATE_SECTOR"]["SHIP_MARKET"].list,"order","asc")) do
            local ship_data = self.SHIPMARKET.market_types["CORPORATE_SECTOR"]["SHIP_MARKET"].list[ship]
            if ship_data.amount == 0 then
                government_display_event.Add_Dialog_Text(ship_data.readable_name .." : [ ".. tostring(ship_data.chance/10) .."%% ]")
            end
        end
        government_display_event.Add_Dialog_Text("TEXT_NONE")
        government_display_event.Add_Dialog_Text("TEXT_GOVERNMENT_CSA_LIST_MODIFIERS")
        for i, ship in ipairs(SortKeysByElement(self.SHIPMARKET.market_types["CORPORATE_SECTOR"]["SHIP_MARKET"].list,"order","asc")) do
            local ship_data = self.SHIPMARKET.market_types["CORPORATE_SECTOR"]["SHIP_MARKET"].list[ship]
            if string.len(ship_data.text_requirement) ~= 0 then
                government_display_event.Add_Dialog_Text(ship_data.readable_name ..": ".. ship_data.text_requirement)
            end
        end

        Story_Event("GOVERNMENT_DISPLAY")
    elseif self.human == Find_Player("HAPES_CONSORTIUM") then
        local plot = Get_Story_Plot("Conquests\\Player_Agnostic_Plot.xml")
        local government_display_event = plot.Get_Event("Government_Display")

        government_display_event.Set_Reward_Parameter(1, "HAPES_CONSORTIUM")

        government_display_event.Clear_Dialog_Text()

        government_display_event.Add_Dialog_Text("TEXT_DOCUMENTATION_BODY_SEPARATOR")
        government_display_event.Add_Dialog_Text("TEXT_GOVERNMENT_HAPAN")
        government_display_event.Add_Dialog_Text("TEXT_DOCUMENTATION_BODY_SEPARATOR")
        government_display_event.Add_Dialog_Text("TEXT_GOVERNMENT_HAPAN_DESCRIPTION_1")
        government_display_event.Add_Dialog_Text("TEXT_GOVERNMENT_HAPAN_DESCRIPTION_2")

        government_display_event.Add_Dialog_Text("TEXT_DOCUMENTATION_BODY_SEPARATOR")
        government_display_event.Add_Dialog_Text("TEXT_GOVERNMENT_HAPAN_LOYALTY_HEADER")
        for house, house_info in pairs(self.FAVOUR.FavourTables["HAPES_CONSORTIUM"]) do
            government_display_event.Add_Dialog_Text(
            "- "..house_info.name..": "..tostring(house_info.favour)
            )
        end
		
        government_display_event.Add_Dialog_Text("TEXT_NONE")
		government_display_event.Add_Dialog_Text("TEXT_GOVERNMENT_HAPAN_REWARD_HEADER")
		
		government_display_event.Add_Dialog_Text("TEXT_DOCUMENTATION_BODY_SEPARATOR")
		government_display_event.Add_Dialog_Text("TEXT_GOVERNMENT_HAPAN_ROYAL_HEADER")
		for i, reward in ipairs(SortKeysByElement(self.FAVOUR.FavourTables["HAPES_CONSORTIUM"]["ROYAL"].reward_list,"threshold","desc")) do
			local entry = self.FAVOUR.FavourTables["HAPES_CONSORTIUM"]["ROYAL"].reward_list[reward]
			
			government_display_event.Add_Dialog_Text(
				"- "..entry.tag.." - Favour Cost: "..tostring(entry.threshold)
			)
		end

		government_display_event.Add_Dialog_Text("TEXT_DOCUMENTATION_BODY_SEPARATOR")
		government_display_event.Add_Dialog_Text("TEXT_GOVERNMENT_HAPAN_REQUUD_HEADER")
		for i, reward in ipairs(SortKeysByElement(self.FAVOUR.FavourTables["HAPES_CONSORTIUM"]["REQUUD"].reward_list,"threshold","desc")) do
			local entry = self.FAVOUR.FavourTables["HAPES_CONSORTIUM"]["REQUUD"].reward_list[reward]
			
			government_display_event.Add_Dialog_Text(
				"- "..entry.tag.." - Favour Cost: "..tostring(entry.threshold)
			)
		end

		government_display_event.Add_Dialog_Text("TEXT_DOCUMENTATION_BODY_SEPARATOR")
		government_display_event.Add_Dialog_Text("TEXT_GOVERNMENT_HAPAN_GALNEY_HEADER")
		for i, reward in ipairs(SortKeysByElement(self.FAVOUR.FavourTables["HAPES_CONSORTIUM"]["GALNEY"].reward_list,"threshold","desc")) do
			local entry = self.FAVOUR.FavourTables["HAPES_CONSORTIUM"]["GALNEY"].reward_list[reward]
			
			government_display_event.Add_Dialog_Text(
				"- "..entry.tag.." - Favour Cost: "..tostring(entry.threshold)
			)
		end

		government_display_event.Add_Dialog_Text("TEXT_DOCUMENTATION_BODY_SEPARATOR")
		government_display_event.Add_Dialog_Text("TEXT_GOVERNMENT_HAPAN_MALURI_HEADER")
		for i, reward in ipairs(SortKeysByElement(self.FAVOUR.FavourTables["HAPES_CONSORTIUM"]["MALURI"].reward_list,"threshold","desc")) do
			local entry = self.FAVOUR.FavourTables["HAPES_CONSORTIUM"]["MALURI"].reward_list[reward]
			
			government_display_event.Add_Dialog_Text(
				"- "..entry.tag.." - Favour Cost: "..tostring(entry.threshold)
			)
		end

        Story_Event("GOVERNMENT_DISPLAY")
    end
end

return GovernmentManager
