"""
function addStringsToArray!( a, moreElements)

    add moreElements to a. If a is not an existing
    Array of String, a new Array is created.

# Arguments:
    * a: Array of String.
    * moreElements: elements to be added.
"""
function addStringsToArray!( a, moreElements)

    if a isa AbstractString
        a = [a]
    elseif !(a isa AbstractArray{String})
        a = String[]
    end

    if moreElements isa AbstractString
        push!(a, moreElements)
    elseif moreElements isa AbstractArray
        for t in moreElements
            push!(a, t)
        end
    end
    return a
end



"""
function extractSlotValue(payload, slotName; multiple = false)

    return the value of a slot or nothing, if
    * no slots in payload,
    * no slots with name slotName in payload,
    * no values in slot slotName.

    If multiple == true, a list of all slot values will be
    returned. If false, only the 1st one as String.
"""
function extractSlotValue(payload, slotName; multiple = false)

    if !haskey(payload, :slots)
        return nothing
    end

    values = []
    for sl in payload[:slots]
        if sl[:slotName] == slotName
            if haskey(sl, :value) && haskey(sl[:value], :value)
                push!(values,sl[:value][:value])
            end
        end
    end

    if length(values) < 1
        return nothing
    elseif !multiple
        return values[1]
    else
        return values
    end
end


"""
function isInSlot(payload, slotName, value)

    return true, if the value is present in the slot slotName
    of the JSON payload (i.e. one of the slot values must match).
    return false if something is wrong (value not inpayload or no
    slots slotName.)
"""
function isInSlot(payload, slotName, value)

    values = extractSlotValue(payload, slotName; multiple = true)
    return (values != nothing) && (value in values)
end





"""
function tryrun(cmd; wait = true, errorMsg = "bla bla")

    tries to run an external command and returns true if successful
    or false if not.
"""
function tryrun(cmd; wait = true, errorMsg = TEXTS[:error_script])

    result = true
    try
        run(cmd; wait = wait)
    catch
        result = false
        publishSay(errorMsg, lang = LANG)
        println("Error running script $cmd")
    end

    return result
end


function tryReadTextfile(fname, errMsg = TEXTS[:error_read])

    text = ""
    try
        text = open(fname) do file
                  read(file, String)
               end
    catch
        publishSay(errMsg, lang = LANG)
        println("Error opening text file $fname")
        text = ""
    end

    return text
end


"""
function setLanguage(lang)

    sets the default language for SnipsHermesQnD.
"""
function setLanguage(lang)

    LANGUAGE = lang

    if lang == "en"
        TEXTS = TEXTS_EN
    elseif lang == "de"
        TEXTS = TEXTS_DE
    else
        TEXTS = TEXTS_EN
    end

end
