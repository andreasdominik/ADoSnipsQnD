#
# API function goes here, to be called by the
# skill-actions:
#

function readScheduleDb()

    db = Snips.dbReadValue(:scheduler, :db)
    if db == nothing
        return Dict()
    else
        return db
    end
end
