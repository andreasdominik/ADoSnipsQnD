
function startScheduler()

    if ! checkAllConfig()
        Snips.printLog("Error reading config -> scheduler not started!")
        return
    end

    db = readScheduleDb()

    # loop forever
    # and execute one trigger per loop, if one is due
    #
    interval = 5  # sec
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
        Snips.printDebug("length: $(length(db)), scheduler db: $db")

        # exec action since last iteration
        #
        if length(db) > 0 && isDue(db[1])
            nextAction = deepcopy(db[1])
            db = rm1stAction(db)
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
