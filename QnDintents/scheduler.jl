
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

        # add actions to db:
        # read from channel, until empty:
        #
        while isready(actionChannel)
            action = take!(actionChannel)
            Snips.printDebug("action from Channel: $action")
            addAction!(db, action)
        end
        Snips.printDebug("scheduler db: $db")

        # exec action since last iteration
        #
        if length(db) > 0 && isDue(db[1])
            removeAction(nextAction, db)
            runAction(nextAction)
        end


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
