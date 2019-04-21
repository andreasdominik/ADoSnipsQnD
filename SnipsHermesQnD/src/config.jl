#
# helpers to work with config.ini

"""
function readConfig(appDir)

    Read the lines of the App's config file and
    return a Dict with config values.

# Arguments:
    * appDir: Directory of the currently running app.
"""
function readConfig(appDir)

    global CONFIG_INI
    fileName = "$appDir/config.ini"

    configLines = []
    try
        configLines = readlines(fileName)

        # read lines as "param_name=value"
        # or "param_name=value1,value2,value3"
        #
        rgx = r"^(?<name>[^[:space:]]+)=(?<val>.+)$"
        for line in configLines
            m = match(rgx, line)
            if m != nothing
                name = Symbol(m[:name])
                rawVals = split(chomp(m[:val]), r"[,; ]")
                vals = [strip(rv) for rv in rawVals if length(strip(rv)) > 0]

                if length(vals) == 1
                    CONFIG_INI[name] = vals[1]
                elseif length(vals) > 1
                    CONFIG_INI[name] = vals
                end
            end
        end
    catch
        println("Warning: no config file found!")
    end

end


"""
function matchConfig(name::Symbol, val::String)

    return true if the parameter name of the config Dict has the value
    val (== val or one element == val)

# Arguments:
    * name: name of the config parameter as Symbol
    * val: desired value
"""
function matchConfig(name::Symbol, val::String)

    global CONFIG_INI

    if haskey(CONFIG_INI, name)
        if CONFIG_INI[name] isa AbstactString
            return val == CONFIG_INI[name]

        elseif CONFIG_INI[name] isa AbstractArray
            return val in CONFIG_INI[name]
        end
    end
    return false
end



"""
function getConfig(name::Symbol)

    return the parameter value of the config Dict config with
    name or nothing if the param does not exist.

# Arguments:
    * name: name of the config parameter as Symbol
"""
function getConfig(name::Symbol)

    global CONFIG_INI

    if haskey(CONFIG_INI, name)
        return CONFIG_INI[name]
    else
        return nothing
    end
end

function getConfig(name::Any)

    return getConfig(Symbol(name))
end


"""
function getAllConfig()

    return the complete CONFIG_INI Dict.
"""
function getAllConfig()

    return CONFIG_INI
end


"""
function isinConfig(name::Symbol)

    return true if the parameter with name exists.

# Arguments:
    * name: name of the config parameter as Symbol
"""
function isinConfig(name::Symbol)

    global CONFIG_INI
    return haskey(CONFIG_INI, name)
end
