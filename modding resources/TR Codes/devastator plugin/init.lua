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
--*       File Created:      Saturday, 29th February 2020 19:52                                    *
--*       Author:            [TR] Pox                                                              *
--*       Last Modified:     Saturday, 29th February 2020 19:52                                    *
--*       Modified By:       [TR] Pox                                                              *
--*       Copyright:         Thrawns Revenge Development Team                                      *
--*       License:           This code may not be used without the author's explicit permission    *
--**************************************************************************************************

require("deepcore/std/plugintargets")
require("eawx-plugins/world-devastator-handler/DevastatorHandler")

return {
    type = "plugin",
    target = PluginTargets.weekly(),
    dependencies = {"ui/galactic-display"},
    init = function(self, ctx, galactic_display)
        return DevastatorHandler(galactic_display, ctx.galactic_conquest)
    end
}
