
function startScheduler()

    if ! checkAllConfig()
        Snips.printLog("Error reading config -> scheduler not started!")
        return
    end

    db = readScheduleDb()

    # loop forever
    interval = 5  # 60 sec = 1 minute
    while true

        global actionChannel

        # exec action since last iteration
        #
        # nextAction = checkSchedules()
        # if nextAction != nothing
        #     removeAction(nextAction, db)
        #     writeDB(db)
        #     runAction(nextAction)
        # end

        # add actions to db:
        # read from channel, until empty:
        #
        while isready(actionChannel)
            action = take!(actionChannel)
            Snips.printDebug("action: $action")
            addAction(action,db)
            writeDB(db)
        end
        Snips.printDebug("db: $db")

        # TODO: use a 2nd channel to delete actions!
        #
        #
        #
        sleep(interval)
    end
end


function checkAllConfig()

    return true
end
