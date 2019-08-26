#
# API function goes here, to be called by the
# skill-actions:
#

# Scheduler functions:
#
#
# The db looks like:
# [
#   {
#     "create_time" : "2019-08-25T10:01:35.399"
#     "execute_time" : "2019-08-26T10:12:13.177"
#     "topic" : "qnd/trigger/andreasdominik:ADoSnipsLights",
#     "trigger" :
#     {
#       "room" : "default",
#       "device" : "floor_lamp",
#       "onOrOff" : "ON",
#       "settings" : "undefined"
#     }
#   },
#   {
#     ...
#   }
# ]
#
# The db is always sorted; i.e. the entry with the oldest scheduled
# execution time is first.
#


function readScheduleDb()

    db = Snips.dbReadValue(:scheduler, :db)
    if db == nothing
        return Dict()
    else
        return db
    end
end

function addAction!(db, action)

    push!(db, action)
    sort!(db, by = x->x[:execute_time])
    Snips.dbWriteValue(:scheduler, :db, db)
end

function rmAction!(db, action)

    db = db[2:end]
    Snips.dbWriteValue(:scheduler, :db, db)
end

"""
    function isDue(action)

Check, if the scheduled execution stime of action is in the past
and return `true` or `false` if not.
"""
function isDue(action)

    if haskey(action, :exec_time)
        return DateTime(action) < Dates.now()
    else
        return false
    end
end
