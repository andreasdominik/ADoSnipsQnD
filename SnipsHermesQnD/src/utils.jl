"""
    addStringsToArray!( a, moreElements)

Add moreElements to a. If a is not an existing
Array of String, a new Array is created.

## Arguments:
* `a`: Array of String.
* `moreElements`: elements to be added.
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
    extractSlotValue(payload, slotName; multiple = false)

Return the value of a slot.

Nothing is returned, if
* no slots in payload,
* no slots with name slotName in payload,
* no values in slot slotName.

If multiple == `true`, a list of all slot values will be
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
    isInSlot(payload, slotName, value)

Return `true`, if the value is present in the slot slotName
of the JSON payload (i.e. one of the slot values must match).
Return `false` if something is wrong (value not in payload or no
slots slotName.)
"""
function isInSlot(payload, slotName, value)

    values = extractSlotValue(payload, slotName; multiple = true)
    return (values != nothing) && (value in values)
end





"""
    tryrun(cmd; wait = true, errorMsg = TEXTS[:error_script])

Try to run an external command and returns true if successful
or false if not.
"""
function tryrun(cmd; wait = true, errorMsg = :error_script)

    errorMsg = langText(errorMsg)
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


"""
    tryReadTextfile(fname, errorMsg = TEXTS[:error_read])

Try to read a text file from file system and
return the text as `String` or an `String` of length 0, if
something went wrong.
"""
function tryReadTextfile(fname, errorMsg = :error_read)

    errorMsg = langText(errorMsg)
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
    setLanguage(lang)

Set the default language for SnipsHermesQnD.
Currently supported laguages are "en" and "de".

This will affect publishSay() and all system messages.
Log-messages will always be in English.

## Arguments
* lang: one of `"en"` or `"de"`.
"""
function setLanguage(lang)

    if lang != nothing
        global LANG = lang
    else
        global LANG = DEFAULT_LANG
    end

    if LANG == "de"
        TEXTS = TEXTS_DE
    else
        TEXTS = TEXTS_EN
    end
end

"""
    addText(lang::AbstractString, key::Symbol, text)

Add the text to the dictionary of text sniplets for the language
`lang` and the key `key`.

## Arguments:
* lang: String with language code (`"en", "de", ...`)
* key: Symbol with unique key for the text
* text: String or array of String with the text(s) to be uttered.

## Details:
If text is an Array, all texts will be saved and the function `Snips.langText()`
will return a randomly selected text from the list.

If the key already exists, the new text will be added to the the
Array of texts for a key.
"""
function addText(lang::AbstractString, key::Symbol, text)

    if text isa AbstractString
        text = [text]
    end

    if !haskey(LANGUAGE_TEXTS, (lang, key))
        LANGUAGE_TEXTS[(lang, key)] = text
    else
        append!(LANGUAGE_TEXTS[(lang, key)], text)
    end
end


"""
    langText(key::Symbol)
    langText(key::Nothing)
    langText(key::AbstractString)

Return the text in the languages dictionary for the key and the
language set with `setLanguage()`.

If the key does not exists, the text in the default language is returned;
if this also does not exist, an error message is returned.

The variants make sure that nothing or the key itself are returned
if key is nothing or an AbstractString, respectively.
"""
function langText(key::Symbol)

    if haskey(LANGUAGE_TEXTS, (LANG, key))
        return StatsBase.sample(LANGUAGE_TEXTS[(LANG, key)])
    elseif haskey(LANGUAGE_TEXTS, (DEFAULT_LANG, key))
        return StatsBase.sample(LANGUAGE_TEXTS[(DEFAULT_LANG, key)])
    else
        return "I don't know what to say!"
    end
end

function langText(key::Nothing)

    return nothing
end


function langText(key::AbstractString)

    return key
end




"""
    setAppDir(appDir)

Store the directory `appDir` as APP_DIR in the
current session
"""
function setAppDir(appDir)

    global APP_DIR = appDir
end

"""
    getAppDir()

Return the directory ofthe currently running app
(i.e. the variable APP_DIR)
"""
function getAppDir()
    return APP_DIR
end
