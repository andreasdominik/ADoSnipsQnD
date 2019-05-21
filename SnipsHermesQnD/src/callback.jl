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

        if occursin(r"hermes/intent/", topic)
            println("[QnD framework]: Hermes intent $topic recognised; execute $fun in $skill.")
        else occursin(r"qnd/trigger/", topic)
            println("[QnD framework]: System trigger $topic recognised; execute $fun in $skill.")
        end
        skill.callbackRun(fun, topic, payload)
    end

    #println("*********** mainCallback() ended! ****************")
end
