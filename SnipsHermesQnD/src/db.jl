#
# functions to read and write status db
#
# The db looks like:
# {
#     "irrigation" :
#     {
#         "time" : <modification time>,
#         "writer" : "ADoSnipsIrrigation",
#         "payload" :
#         {
#             "status" : "on",
#             "next_status" : "off"
#         }
#     }
# }
#

"""
    dbWritePayload(entry, payload)

Write a complete payload to a database entry.
The payload is overwitten if the entry already exists,
or created otherwise.
"""
function dbWritePayload(entry, payload)

    if ! (entry isa Symbol)
        entry = Symbol(entry)
    end

    dbLock()
    db = dbRead()

    if haskey(db, entry)
        record = db[entry]
    else
        record = Dict()
        db[entry] = record
    end

    record[:time] = Dates.now()
    record[:writer] = CURRENT_APP_NAME
    record[:payload] = payload

    dbWrite()
    dbUnlock()
end

"""
    dbWriteValue(entry, field, value)

Write a field=>value pair to the payload of a database entry.
The field is overwitten if the entry already exists,
or created elsewise.
"""
function dbWriteValue(entry, field, value)

    if ! (entry isa Symbol)
        entry = Symbol(entry)
    end
    if ! (key isa Symbol)
        key = Symbol(entry)
    end

    dbLock()
    db = dbRead()

    if haskey(db, entry)
        record = db[entry]
    else
        record = Dict()
        db[entry] = record
    end

    if !haskey(record, :payload)
        record[:payload] = Dict()
    end

    record[:payload][field] = value
    record[:time] = Dates.now()
    record[:writer] = CURRENT_APP_NAME

    dbWrite()
    dbUnlock()
end




"""
    dbRead()

Read the status db from file.
Path is constructed from `config.ini` values
`<application_dir>/ADoSnipsQnD/<database>`.
"""
function dbRead()

    db = Snips.tryParseJSONfile(dbName(), quiet = true)
    if length(db) == 0
        Snips.printLog("Empty status DB read: $(dbName()).")
        db = Dict{}[]
    end

    return db
end


"""
    dbWrite()

Write the status db to a file.
Path is constructed from `config.ini` values
`<application_dir>/ADoSnipsQnD/<database>`.
"""
function dbWrite(db)

    if !ispath( dbPath())
        mkpath( dbPath())
    end

    Snips.printDebug("write db: $db")
    fname = dbName()
    Snips.printDebug("db file: $fName")
    open(fname, "w") do f
        JSON.print(f, db, 2)
    end
end




function dbLock()

    lockName = dbName() * ".lock"
    open(lockName, "w") do f
        println(f, "database is locked"
    end
end

function dbUnlock()

    lockName = dbName() * ".lock"
    rm(lockName, force = true)
end



function dbName()

    return "$(dbPath())/$(getConfig(:database)))"
end
function dbPath()

    return "$(getConfig(:application_dir))/ADoSnipsQnD"
end
