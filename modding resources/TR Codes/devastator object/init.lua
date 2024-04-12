require("deepcore/std/plugintargets")

return {
    type = "plugin",
    target = PluginTargets.never(),
    init = function(self, ctx)
        Devastator = require("eawx-plugins-gameobject-space/world-devastator/Devastator")
        return Devastator()
    end
}
