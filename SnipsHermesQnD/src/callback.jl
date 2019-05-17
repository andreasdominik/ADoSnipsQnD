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

    # extract developer name and intent from topic:
    #
    m = match(r"([a-zA-Z0-1]+):([a-zA-Z0-1]+)", topic)
    if match != nothing
        developer = m.captures[1]
        intent = m.captures[2]
    else
        developer = "unknowndeveloper"
        intent = topic
    end
    println("[QnD framework] Intent $topic recognised")

    # get list of matched intents:
    #
    matchedIntents = filter(Main.INTENT_ACTIONS) do i
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
