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
function dbWritePayload(key, payload)

    if ! (key isa Symbol)
        key = Symbol(key)
    end

    if !dbLock()
        return false
    end

    db = dbRead()

    if haskey(db, key)
        entry = db[key]
    else
        entry = Dict()
        db[key] = entry
    end

    entry[:time] = Dates.now()
    entry[:writer] = CURRENT_APP_NAME
    entry[:payload] = payload

    dbWrite(db)
    dbUnlock()
end

"""
    dbWriteValue(entry, field, value)

Write a field=>value pair to the payload of a database entry.
The field is overwitten if the entry already exists,
or created elsewise.
"""
function dbWriteValue(key, field, value)

    if ! (key isa Symbol)
        key = Symbol(key)
    end
    if ! (field isa Symbol)
        field = Symbol(field)
    end

    if !dbLock()
        return false
    end

    db = dbRead()
    if haskey(db, key)
        entry = db[key]
    else
        entry = Dict()
        db[key] = entry
    end

    if !haskey(entry, :payload)
        entry[:payload] = Dict()
    end

    entry[:payload][field] = value
    entry[:time] = Dates.now()
    entry[:writer] = CURRENT_APP_NAME

    dbWrite(db)
    dbUnlock()
end




"""
    dbRead()

Read the status db from file.
Path is constructed from `config.ini` values
`<application_dir>/ADoSnipsQnD/<database>`.
"""
function dbRead()

    db = tryParseJSONfile(dbName(), quiet = true)
    if length(db) == 0
        printLog("Empty status DB read: $(dbName()).")
        db = Dict()
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

    printDebug("write db: $db")
    fname = dbName()
    printDebug("db file: $fname")
    open(fname, "w") do f
        JSON.print(f, db, 2)
    end
end




function dbLock()

    if !ispath( dbPath())
        mkpath( dbPath())
    end
    lockName = dbName() * ".lock"

    # wait until unlocked:
    #
    waitSecs = 10
    while isfile(lockName) && waitSecs > 0
        waitSecs -= 1
        sleep(1)
    end

    if waitSecs == 0
        printLog("ERROR: unable to lock home database file: $dbName")
        return false
    else
        open(lockName, "w") do f
            println(f, "database is locked")
        end
        return true
    end
end

function dbUnlock()

    lockName = dbName() * ".lock"
    rm(lockName, force = true)
end



function dbName()

    name = getConfig(:database_file)
    if name ==  nothing
        name = "$(dbPath())/home.json"
    else
        name = "$(dbPath())/$name"
    end
    printDebug("dbName = $name")
    return name
end



function dbPath()

    path = getConfig(:application_data_dir)
    if path ==  nothing
        path = "./ADoSnipsQnD"
    else
        path = "$path/ADoSnipsQnD"
    end
    printDebug("dbPath = $path")
    return path
end
