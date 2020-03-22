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
`/etc/susi.toml` or an empty Dict if no file was found.
"""
function getSusiToml()

    return SUSI_TOML
end



"""
    function getSusiLanguage()

Return a the language as 2-letter-code as defined in
`/etc/susi.toml` or 'DEAFULT_LANGUAGE' if no language entry found.
"""
function getSusiLanguage()

    language = DEFAULT_LANG
    
    if haskey(SUSI_TOML, "assistant") && haskey(SUSI_TOML["assistant"], "language") &&
       !isempty(SUSI_TOML["assistant"]["language"])
        language = SUSI_TOML["assistant"]["language"]
    end
    return language[1:2]
end

"""
    function getLanguage()

Return a the framework language as 2-letter-code.
"""
function getLanguage()

    return global LANG
end
