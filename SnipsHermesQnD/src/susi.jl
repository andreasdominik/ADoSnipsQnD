# adaption of the frameworks to NoSnips/Susi:
#
#
# Pkg.TOML is used to parse tomls config files:
#
using Pkg
TOML = Pkg.TOML

const SUSI_CONFIG = "/etc/susi.toml"


function parseSusiConfig(tomlFile=SUSI_CONFIG)

    config = Dict()
    try
        config = TOML.parsefile(tomlFile)
    catch
        printLog("ERROR reading susi config file $tomlFile")
    end

    return config
end


"""
    function getSusiToml()

Return a dictionary with all settings of the file
`/etc/sisu.toml`.
"""
function getSusiToml()

    return SUSI_TOML
end
