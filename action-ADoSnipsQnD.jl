#!/usr/local/bin/julia
#
# main executable script of ADos's SniosHermesQnD framework.
# It loads all skills into one Julia environment.
#
# Normally, it is NOT necessary to change anything in this file,
# unless you know what you are doing!
#
# A. Dominik, April 2019, © GPL3
#

# get dir of framework installation and
# skill installations (one level higher)
#
const FRAMEWORK_DIR = @__DIR__
const SKILLS_DIR = replace(FRAMEWORK_DIR, r"/[^/]*/?$"=>"")
include("$FRAMEWORK_DIR/SnipsHermesQnD/src/SnipsHermesQnD.jl")

INTENT_ACTIONS = Tuple{AbstractString,Function}[]


function main()

    # search all dir-tree for files like loader-<name>.jl
    #
    for (root, dirs, files) in walkdir(SKILLS_DIR)

        loaders = filter(files) do f
                      occursin(r"^loader-.*\.jl", f)
                  end
        loaders = root .* "/" .* loaders

        for loader in loaders
            println("[ADoSnipsQnD] loading Julia app $loader")
            include(loader)
        end
    end
end

main()
