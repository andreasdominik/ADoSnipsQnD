#!/usr/local/bin/julia
#
# main executable skill script.
#
# Normally, it is NOT necessary to change anything in this file,
# unless you know what you are doing!
#
# A. Dominik, April 2019, © GPL3
#

APP_DIR = dirname(Base.source_path())

using Pkg
Pkg.activate(APP_DIR)

import JSON
include("$APP_DIR/SnipsHermesQnD/src/SnipsHermesQnD.jl")
import Main.SnipsHermesQnD
Snips = Main.SnipsHermesQnD

include("$APP_DIR/Skill/Skill.jl")
import Main.Skill


function main()

    Snips.readConfig("$APP_DIR")

    intents = Skill.DEVELOPER_NAME * ":" .* keys(Skill.INTENT_ACTIONS)
    Snips.subscribe2Intents(intents, Skill.mainCallback)
end

main()
