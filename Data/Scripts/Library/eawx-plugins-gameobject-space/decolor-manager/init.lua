require("deepcore/std/plugintargets")

return {
    type = "plugin",
    target = PluginTargets.never(),
    init = function(self, ctx)
        DecolorManager = require("eawx-plugins-gameobject-space/decolor-manager/DecolorManager")
        return DecolorManager()
    end
}
