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

    fullIntent = payload[:intent][:intentName]
    (developer, intent) = split(intent, ":")

    # get list of matched intents:
    #
    matchedIntents = filter(INTENT_ACTIONS) do i
                        i[1] == intent && i[2] == developer
                    end

    # run the functions of matched intents:
    #
    for i in matchedIntents

        f = i[4]   # action function
        m = i[3]   # module
        m.callbackRun(f, intent, payload)
    end
end
