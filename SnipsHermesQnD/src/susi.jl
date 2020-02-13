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
