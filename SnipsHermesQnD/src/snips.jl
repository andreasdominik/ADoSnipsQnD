#
#
# Helper function for JSON:
#
#
"""
    tryParseJSON(text)

parses a JSON and returns a hierarchy of Dicts{Symbol, Any} and Arrays with
the content or a string (text), if text is not a valid JSON string is
returned.
"""
function tryParseJSON(text)

    json = Dict()
    try
        json = JSON.parse(text)
        json = key2symbol(json)
    catch
        json = text
    end

    return json
end





"""
    key2symbol(arr::Array)

Wrapper for key2symbol, if 1st hierarchy is an Array
"""
function key2symbol(arr::Array)

    return [key2symbol(elem) for elem in arr]
end


"""
    key2symbol(dict::Dict)

Return a new Dict() with all keys replaced by Symbols.
d is scanned hierarchically.
"""
function key2symbol(dict::Dict)

    mkSymbol(s) = Symbol(replace(s, r"[^a-zA-Z0-9]"=>"_"))

    d = Dict{Symbol}{Any}()
    for (k,v) in dict

        if v isa Dict
            d[mkSymbol(k)] = key2symbol(v)
        elseif v isa Array
            d[mkSymbol(k)] = [(elem isa Dict) ? key2symbol(elem) : elem for elem in v]
        else
            d[mkSymbol(k)] = v
        end
    end
    return d
end

"""
    tryMkJSON(payload)

Create a JSON representation of the input (nested Dict or Array)
and return an empty string if not possible.
"""
function tryMkJSON(payload)

    json = Dict()
    try
        json = JSON.json(payload)
    catch
        json = ""
    end

    return json
end


"""
    tryParseJSONfile(fname)

Parse a JSON file and return a hierarchy of Dicts with
the content.
* keys are changed to Symbol
* if error, nothing is returned
"""
function tryParseJSONfile(fname; quiet = false)

    json = Dict()
    try
        json = JSON.parsefile( fname)
    catch
        msg = TEXTS[:error_json]
        if ! quiet
            publishSay(msg, CURRENT_SITE_ID)
        end
        println("$msg : $fname")
    end

    json = key2symbol(json)
    return json
end


"""
    setSiteId(siteId)

Set the siteId in the Module SnipsHermesQnD
(necessary to direct the say() output to the current room)
"""
function setSiteId(siteId)

    global CURRENT_SITE_ID = siteId
end

"""
    getSiteId()

Return the siteId in the Module SnipsHermesQnD
(necessary to direct the say() output to the current room)
"""
function getSiteId()

    return CURRENT_SITE_ID
end



"""
    setSessionId(sessionId)

Set the sessionId in the Module SnipsHermesQnD.
The sessionId will be used to publish Hermes messages
inside a runing session. The framework handles this in the background.

## Arguments:
* sessionId: as String from a Hermes payload.
"""
function setSessionId(sessionId)

    global CURRENT_SESSION_ID = sessionId
end

"""
    getSessionId()

Return the sessionId of the currently running session.
"""
function getSessionId()

    return CURRENT_SESSION_ID
end
