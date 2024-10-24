--**************************************************************************************************
--*    _______ __                                                                                  *
--*   |_     _|  |--.----.---.-.--.--.--.-----.-----.                                              *
--*     |   | |     |   _|  _  |  |  |  |     |__ --|                                              *
--*     |___| |__|__|__| |___._|________|__|__|_____|                                              *
--*    ______                                                                                      *
--*   |   __ \.-----.--.--.-----.-----.-----.-----.                                                *
--*   |      <|  -__|  |  |  -__|     |  _  |  -__|                                                *
--*   |___|__||_____|\___/|_____|__|__|___  |_____|                                                *
--*                                   |_____|                                                      *
--*                                                                                                *
--*                                                                                                *
--*       File:              init.lua                                                              *
--*       File Created:      Monday, 24th February 2020 12:01                                      *
--*       Author:            [TR] Pox                                                              *
--*       Last Modified:     Monday, 24th February 2020 12:05                                      *
--*       Modified By:       [TR] Pox                                                              *
--*       Copyright:         Thrawns Revenge Development Team                                      *
--*       License:           This code may not be used without the author's explicit permission    *
--**************************************************************************************************

require("deepcore/std/plugintargets")
require("eawx-plugins/government-manager/GovernmentManager")
require("eawx-plugins/government-manager/GovernmentNewsSource")

return {
    type = "plugin",
    target = PluginTargets.weekly(),
    dependencies = {"ui/galactic-display"},
    ---@param ctx table<string, any>
    ---@param galactic_display DisplayComponentContainer
    init = function(self, ctx, galactic_display)
        local government_manager = GovernmentManager(ctx.galactic_conquest, ctx.id, ctx.gc_name)
        local news_feed = galactic_display:get_component("news_feed")
        news_feed:add_news_source(GovernmentNewsSource(government_manager))


        return government_manager
    end
}