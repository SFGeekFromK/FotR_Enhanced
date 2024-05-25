require("deepcore/std/plugintargets")

return {
    type = "plugin",
    target = PluginTargets.never(),
    init = function(self, ctx)
        OfcOfficer = require("eawx-plugins-gamescoring/ofc-officer/OfcOfficer")
        return OfcOfficer()
    end
}
