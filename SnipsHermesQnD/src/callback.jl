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

    # find the intents or triggers that match the current
    # message:
    matchedTopics = filter(Main.INTENT_ACTIONS) do i
                        i[3] == topic
                    end

    for t in matchedTopics

        topic = t[3]
        fun = t[5]   # action function
        skill = t[4]   # module

        if occursin(r"hermes/intent/", t[3])
            println("[QnD framework]: Hermes intent $t recognised")
        else occursin(r"qnd/trigger/", t[3])
            println("[QnD framework]: System trigger $t recognised")
        end
        # @spawn skill.callbackRun(fun, topic, payload)
        skill.callbackRun(fun, topic, payload)
    end
end
