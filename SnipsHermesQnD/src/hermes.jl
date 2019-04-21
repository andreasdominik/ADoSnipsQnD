# Hermes wrapper
#
#
# A. Dominik, 2019
#



"""
function subscribe2Intents(intents, callback; moreTopics = nothing)

    subscribe to one or a list of Intents, and listen forever, and run the callback
    if a matching intent is recieved.

# Arguments:
    * intents: Abstract String or List of Abtsract Strings to define
               intents to subscribe. The intents will be expanded
               to topics (i.e. "hermes/intent/SwitchOnLight")
    * callback: Function to be executed for a incoming message
    * moreTopics: keyword arg to provide additional topics to subscribe,

# Details:
    The callback function has the signature f(topic, intentMessage), where
    topic is a String and intentMessage a Dict{Symbol, Any} with the content
    of the payload (assuming, that the payload is in JSON-formate) or
    a String, if the payload is not valid JSON.
    The callback function is not spawned, but executed in the current
    thread. As a result the function is not listening during execution of the
    callback.
"""
function subscribe2Intents(intents, callback; moreTopics = nothing)

    topics = "hermes/intent/" .* intents
    topics = addStringsToArray!(topics, moreTopics)
    subscribeMQTT(topics, callback; hostname = nothing, port = nothing)
end



"""
function listenIntentsOnetime(intents; moreTopics = nothing)

    subscribe to one or a list of Intents, but listen only until one
    matching intent is recognised.

# Arguments
    * intents: Abstract String or List of Abtsract Strings to define
               intents to subscribe or nothing
   * moreTopics: keyword arg to provide additional topics to subscribe,

# Value:
   Return values are topic (as String) and payload (as Dict or as
   String if JSON parsing is not possible).
   If the topic is an intent, only the tntent id is returned
   (i.e.: devname:intentname without the leading hermes/intent/)
"""
function listenIntentsOnetime(intents; moreTopics = nothing)

    if intents == nothing
        topics = String[]
    else
        topics = "hermes/intent/" .* intents
    end
    topics = addStringsToArray!(topics, moreTopics)

    topic, payload = readOneMQTT(topics; hostname = nothing, port = nothing)
    #println(topic, " ", "$(typeof(topic))")
    intent = topic
    if intent isa AbstractString
        intent = replace(topic, "hermes/intent/"=>"")
    end

    return intent, payload
end



"""
function askYesOrNoOrUnknown(question)

    Ask the question and listen to the intent "ADoSnipsYesNoDE"
    and return :yes if "Yes" is answered or :no if "No" or
    :unknown otherwise.
"""
function askYesOrNoOrUnknown(question)

    intentListen = "andreasdominik:ADoSnipsYesNoDE"
    topicsListen = ["hermes/nlu/intentNotRecognized", "hermes/error/nlu",
                    "hermes/dialogueManager/intentNotRecognized"]
    slotName = "yes_or_no"

    listen = true
    intent = ""
    payload = Dict()

    configureIntent(intentListen, true)

    publishContinueSession(question, sessionId = CURRENT_SESSION_ID,
              intentFilter = intentListen,
              customData = nothing, sendIntentNotRecognized = true)
    # publishStartSessionAction(question, siteId = CURRENT_SITE_ID,
    #           intentFilter = intentListen,
    #           sendIntentNotRecognized = true)
    topic, payload = listenIntentsOnetime(intentListen,
                            moreTopics = topicsListen)

    configureIntent(intentListen, false)

    if isInSlot(payload, slotName, "YES")
        return :yes
    elseif isInSlot(payload, slotName, "NO")
        return :no
    else
        return :unknown
    end
end


"""
function askYesOrNoOrUnknown(question)

    Ask the question and listen to the intent "ADoSnipsYesNoDE"
    and return :true if "Yes" or "No" otherwise.
"""
function askYesOrNo(question)

    answer = askYesOrNoOrUnknown(question)
    return answer == :yes
end



"""
function publishEndSession(text; sessionId = CURRENT_SESSION_ID)

    MQTT publish end session.

# Arguments:
    * sessionId: ID of the session to be terminated as String
    * text: text to be said vie TTS
"""
function publishEndSession(text = nothing, sessionId = CURRENT_SESSION_ID)

    payload = Dict(:sessionId => sessionId)
    if text != nothing
        payload[:text] = text
    end
    publishMQTT("hermes/dialogueManager/endSession", payload)
end




"""
function publishContinueSession(text; sessionId = CURRENT_SESSION_ID,
         intentFilter = nothing,
         customData = nothing, sendIntentNotRecognized = false)

    MQTT publish continue session.

# Arguments:
    * sessionId: ID of the session to be terminated as String
    * text: text to be said via TTS
    * intentFilter: Optional Array of String - A list of intents names to
                    restrict the NLU resolution on the answer of this query.
    * customData: Optional String - an update to the session's custom data.
    * sendIntentNotRecognized: Optional Boolean -  Indicates whether the
                    dialogue manager should handle non recognized intents
                    by itself or sent them as an Intent Not Recognized for
                    the client to handle.
"""
function publishContinueSession(text; sessionId = CURRENT_SESSION_ID,
         intentFilter = nothing,
         customData = nothing, sendIntentNotRecognized = false)

    payload = Dict{Symbol, Any}(:sessionId => sessionId, :text => text)

    if intentFilter != nothing
        if intentFilter isa AbstractString
            intentFilter = [intentFilter]
        end
        payload[:intentFilter] = intentFilter
    end
    if customData != nothing
        payload[:customData] = customData
    end
    if sendIntentNotRecognized != nothing
        payload[:sendIntentNotRecognized] = sendIntentNotRecognized
    end

    publishMQTT("hermes/dialogueManager/continueSession", payload)
end


"""
function publishStartSessionAction(text; siteId = CURRENT_SITE_ID,
         intentFilter = nothing, sendIntentNotRecognized = false,
         customData = nothing)

    MQTT publish start session with init action

# Arguments:
    * siteId: ID of the session to be terminated as String
    * text: text to be said via TTS
    * intentFilter: Optional Array of String - A list of intents names to
                    restrict the NLU resolution on the answer of this query.
    * sendIntentNotRecognized: Optional Boolean -  Indicates whether the
                    dialogue manager should handle non recognized intents
                    by itself or sent them as an Intent Not Recognized for
                    the client to handle.
    * customData: data to be sent to the service.
"""
function publishStartSessionAction(text; siteId = CURRENT_SITE_ID,
                intentFilter = nothing, sendIntentNotRecognized = false,
                customData = nothing)

    if intentFilter != nothing
        if intentFilter isa AbstractString
            intentFilter = [intentFilter]
        end
    end

    init = Dict(:type => "action",
                :text => text,
                :canBeEnqueued => true,
                :sendIntentNotRecognized => sendIntentNotRecognized)
    if intentFilter != nothing
        init[:intentFilter] = intentFilter
    end

    publishStartSession(siteId, init, customData = customData, wait = true)
end


"""
function publishStartSessionNotification(text; siteId = CURRENT_SITE_ID,
                customData = nothing)

    MQTT publish start session with init notification

# Arguments:
    * siteId: ID of the session to be terminated as String
    * text: text to be said via TTS
    * customData: data to be sent to the service.
"""
function publishStartSessionNotification(text; siteId = CURRENT_SITE_ID,
                customData = nothing)

    init = Dict(:type => "notification",
                :text => text)

    publishStartSession(siteId, init, customData = customData, wait = true)
end



"""
function publishStartSession(siteId, init; customData = nothing,
                             wait = true)

    Worker function for publish start session; called for
    start session topics of type action or notification.
"""
function publishStartSession(siteId, init; customData = nothing,
                             wait = true)

    payload = Dict{Symbol, Any}(
                :siteId => siteId,
                :init => init)

    if customData != nothing
        payload[:customData] = customData
    end

    publishMQTT("hermes/dialogueManager/startSession", payload)
end





"""
function publishSay(text; sessionId = CURRENT_SESSION_ID,
                    lang = nothing, id = nothing, wait = true)

    Let the TTS say something.

# Arguments:
    * text: text to be said vie TTS
    * lang: Optional language code to use when saying the text.
            If nothing is provided, en_GB will be used
    * sessionId: optional ID of the session if there is one
    * id: optional A request identifier. If provided, it will be passed back
          in the response on hermes/tts/sayFinished.
    * wait: wait until the massege is spoken (i.i. wait for the
            MQTT-topic)
"""
function publishSay(text; sessionId = CURRENT_SESSION_ID,
                    siteId = nothing, lang = nothing,
                    id = nothing, wait = true)

    if siteId == nothing
        siteId = CURRENT_SITE_ID
    end

    payload = Dict(:text => text, :siteId => CURRENT_SITE_ID)

    if lang != nothing
        payload[:lang] = lang
    end

    payload[:sessionId] = sessionId

    # make unique ID:
    #
    if id == nothing
        id = ""
        for i in 1:25
            id = id * StatsBase.sample(collect("abcdefghijklmnopqrst0123456789"))
        end
    end
    payload[:id] = id

    publishMQTT("hermes/tts/say", payload)

    # wait until finished:
    #
    if wait == true
        while wait
            topic, payload = readOneMQTT("hermes/tts/sayFinished")
            if payload[:id] == id
                wait = false
            end
        end
    end
end


"""
function isOnOffMatched(payload, siteId, deviceName)

        action to be combined with the ADoSnipsOnOFF intent.
        Depending on the payload the function returns:
        * :on if "on"
        * :off
        * :matched, if the device is matched but no on or off
        * :unmatched, if one of
            * wrong siteId
            * wrong device
# Arguments:
    * payload: payload of intent
    * siteId: siteId of the device to be matched with the payload of intent
    * deviceName : name of device to be matched with the payload of intent
"""
function isOnOffMatched(payload, siteId, deviceName)

    result = :unmatched

    println("siteId, payload[:siteId]: $siteId, $(payload[:siteId])")
    println("deviceName: $deviceName")

    if siteId == payload[:siteId]

        # test device name from payload
        #
        if isInSlot(payload, "device", deviceName)
            if isInSlot(payload, "on_or_off", "ON")
                result = :on
            elseif isInSlot(payload, "on_or_off", "OFF")
                result = :off
            else
                result = :matched
            end
        end
    end
    return result
end




function configureIntent(intent, onoff)

    topic = "hermes/dialogueManager/configure"
    payload = Dict(:siteId=>CURRENT_SITE_ID,
                   :intents=>[Dict(:intentId=>intent, :enable=>onoff)])

    publishMQTT(topic, payload)
end
