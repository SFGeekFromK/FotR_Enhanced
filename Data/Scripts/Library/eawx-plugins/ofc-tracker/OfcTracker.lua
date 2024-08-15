require("deepcore/std/class")
require("deepcore/crossplot/crossplot")
require("PGStoryMode")

---@class OFC_Tracker
OFC_Tracker = class()

function OFC_Tracker:new(gc)
    self.human_player = Find_Player("local")
    
    self.ship_types = require("OFC_Options")

    self:first_week_setup()

    gc.Events.GalacticProductionStarted:attach_listener(self.on_production_queued, self)
    gc.Events.GalacticProductionCanceled:attach_listener(self.on_production_canceled, self)
    crossplot:subscribe("OCF_CAPACITY_DECREAMENT", self.lock_or_unlock_options, self)

    self.Events = {}
    self.Events.ShipsAdded = Observable()
end

function OFC_Tracker:first_week_setup()
    --Logger:trace("entering ShipMarket:first_week_setup")
    for faction, market_tables in pairs(self.ship_types) do
        for market, market_data in pairs(market_tables) do
            for ship, ship_data in pairs(market_data.list) do
                market_data.faction_object.Lock_Tech(Find_Object_Type(ship))
            end
        end
    end
end

function OFC_Tracker:Update()
    --Logger:trace("entering ShipMarket:Update")
    for faction, market_tables in pairs(self.ship_types) do
        for market, market_data in pairs(market_tables) do
            for ship, ship_data in pairs(market_data.list) do
                if GameRandom.Free_Random(1,1000) <= ship_data.chance and ship_data.locked == false and ship_data.gc_locked == false then
                    self.ship_types[faction][market].list[ship].amount = ship_data.amount + 1
                    if market_data.faction_object.Is_Human() then
                        self.Events.ShipsAdded:notify {
                            added = ship_data.readable_name,
                            market_name = market_data.market_name,
                            news_colour = market_data.news_colour
                        }
                    end     
                end
                if ship_data.amount > 0 then
                    market_data.faction_object.Unlock_Tech(Find_Object_Type(ship))
                end
            end
        end
    end
end

---@param planet Planet
function OFC_Tracker:on_production_canceled(planet, game_object_type_name)
    --Logger:trace("entering ShipMarket:on_production_canceled")
    local owner = planet:get_owner().Get_Faction_Name()
    if self.ship_types[owner] then
        self:find_market(owner, game_object_type_name, 1)
    end
end

function OFC_Tracker:on_production_queued(planet, game_object_type_name)
     --Logger:trace("entering ShipMarket:on_production_queued")
    local owner = planet:get_owner().Get_Faction_Name()
    if self.ship_types[owner] then
        self:find_market(owner, game_object_type_name, -1)
    end
end

function OFC_Tracker:find_market(owner, game_object_type_name, adjustment)
    --Logger:trace("entering ShipMarket:add_or_remove_constructor")
    local market_name = nil
    for market, market_data in pairs(self.ship_types[owner]) do
        if market_data.list[game_object_type_name] then
            market_name = market
            self:add_or_remove_amount({{owner, market_name, game_object_type_name, adjustment}})
            break
        end
    end
end

function OFC_Tracker:add_or_remove_amount(add_or_remove_tables)
     --Logger:trace("entering ShipMarket:add_or_remove_amount")
    DebugMessage("In ShipMarket:add_or_remove_amount")
    for _, add_or_remove_table in pairs(add_or_remove_tables) do
        local owner = add_or_remove_table[1] --faction
        local market = add_or_remove_table[2] --market
        local game_object_type_name = add_or_remove_table[3] --name
        local adjustment = add_or_remove_table[4] --adjustment
        local overwrite = add_or_remove_table[5] --overwrite

        if self.ship_types[owner][market].list[game_object_type_name] then
            if overwrite then
                self.ship_types[owner][market].list[game_object_type_name].amount = adjustment
            else
                self.ship_types[owner][market].list[game_object_type_name].amount = self.ship_types[owner][market].list[game_object_type_name].amount + adjustment
            end
            if self.ship_types[owner][market].list[game_object_type_name].amount < 1 then
                self.ship_types[owner][market].faction_object.Lock_Tech(Find_Object_Type(game_object_type_name))
            else
                self.ship_types[owner][market].faction_object.Unlock_Tech(Find_Object_Type(game_object_type_name))
            end
        end
    end
end

function OFC_Tracker:lock_or_unlock_options(lock_tables)
    --Logger:trace("entering ShipMarket:adjust_ship_chance")
    DebugMessage("In ShipMarket:adjust_ship_chance")
    for _, lock_table in pairs(lock_tables) do
        local owner = lock_table[1] --faction
        local market = lock_table[2] --market
        local game_object_type_name = lock_table[3] --name
        local lock = lock_table[4] --lock status
        local remove_existing = lock_table[5] --reduce existing
        local gc_lock = lock_table[6] --GC lock status

        if self.ship_types[owner][market].list[game_object_type_name] then
            if gc_lock == true then
                self.ship_types[owner][market].list[game_object_type_name].gc_locked = true
            elseif gc_lock == false then
                self.ship_types[owner][market].list[game_object_type_name].gc_locked = false
            end

            if lock == true then
                self.ship_types[owner][market].list[game_object_type_name].locked = true
            elseif lock == false then
                self.ship_types[owner][market].list[game_object_type_name].locked = false
            end

            if remove_existing == true then
                self:add_or_remove_amount({{owner, market, game_object_type_name, 0, true}})
            end
        end
    end
end

function OFC_Tracker:adjust_ship_requirements(adjustment_tables)
    --Logger:trace("entering ShipMarket:adjust_ship_requirements")
    DebugMessage("In ShipMarket:adjust_ship_requirements")
    for _, adjustment_table in pairs(adjustment_tables) do
        local owner = adjustment_table[1] --faction
        local market = adjustment_table[2] --market
        local game_object_type_name = adjustment_table[3] --name
        local new_requirement = adjustment_table[4] --new requirements (always overwrites)

        if self.ship_types[owner][market].list[game_object_type_name] then
            self.ship_types[owner][market].list[game_object_type_name].text_requirement = new_requirement
        end
    end
end

return ShipMarket