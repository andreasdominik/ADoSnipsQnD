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
`/etc/susi.toml`.
"""
function getSusiToml()

    return SUSI_TOML
end



"""
    function getLanguage()

Return a the language as 2-letter-code as defined in
`/etc/susi.toml` or 'en' if no language entry found.
"""
function getLanguage()

    if haskey(SUSI_TOML, "assistant") && haskey(SUSI_TOML["assistant"], "language") &&
       !isempty(SUSI_TOML["assistant"]["language"])
        language = SUSI_TOML["assistant"]["language"]
    else
        language = DEFAULT_LANG
    end
    return language[1:2]
end
