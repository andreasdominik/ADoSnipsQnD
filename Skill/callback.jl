#
# main callback function:
#
# Normally, it is NOT necessary to change anything in this file,
# unless you know what you are doing!
#

function mainCallback(topic, payload)

    # println("""*********************************************
    #         $payload
    #         ************************************************""")

    intent = payload[:intent][:intentName]
    intent = replace(intent, "$DEVELOPER_NAME:"=>"")

    # run action for intent only if the siteId matches or if
    # siteId is not defined in config.ini:
    #
    if Snips.isinConfig(:siteId) && !Snips.matchConfig(:siteId, payload[:siteId])
        return
    end

    if haskey(INTENT_ACTIONS, intent)
        Snips.setSiteId(payload[:siteId])
        Snips.setSessionId(payload[:sessionId])
        result = INTENT_ACTIONS[intent](topic, payload)

        if CONTINUE_WO_HOTWORD && result
            Snips.publishStartSessionAction("")
        end
    end
end
