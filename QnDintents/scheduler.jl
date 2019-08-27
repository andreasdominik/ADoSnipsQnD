
function startScheduler()

    if ! checkAllConfig()
        Snips.printLog("Error reading config -> scheduler not started!")
        return
    end

    db = readScheduleDb()

    # loop forever
    # and execute one trigger per loop, if one is due
    #
    interval = 15  # sec
    while true

        global actionChannel
        global deleteChannel

        # add actions to db:
        # read from channel, until empty:
        #
        while isready(actionChannel)
            action = take!(actionChannel)
            # Snips.printDebug("action from Channel: $action")
            addAction!(db, action)
        end
        # listen to delete signals:
        # read from channel, until empty:
        #
        while isready(deleteChannel)
            deletion = take!(deleteChannel)
            # Snips.printDebug("deletion from Channel: $deletion")
            rmActions!(db, deletion)
        end
        # Snips.printDebug("length: $(length(db))")
        # Snips.printDebug("length: $(length(db)), scheduler db: $db")

        # exec action since last iteration
        #
        if length(db) > 0 && isDue(db[1])
            nextAction = deepcopy(db[1])
            rm1stAction!(db)
            runAction(nextAction)
        end

        sleep(interval)
    end
end


function checkAllConfig()

    return true
end
