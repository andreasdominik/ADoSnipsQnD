# functions for the QnD scheduler
#
#


"""
    schedulerAddActions(executeTime, topic, trigger;
            sessionId = CURRENT_SESSION_ID,
            origin = CURRENT_APP_NAME,
            siteId = CURRENT_SITE_ID)

Add the `trigger` to the database of scheduled actions for
execution at `executeTime`.

## Arguments:
- `executeTime`: DateTime object
- `topic`: topic to which the system trigger will be published.
           topic has the format: `"qnd/trigger/andreasdominik:ADoSnipsLights"`.
           The prefix `"qnd/trigger/"` and the developer name are added if
           missing in the argument.
- `trigger`: The system trigger to be published as Dict(). Format of the
           trigger is defined by the target skill.
`sessionId`, `origin` and `siteId` defaults to the current
values, if not given. SessionId and origin can be used to select
scheduled actions for deletion.
"""
schedulerAddAction(executeTime, topic, trigger;
            sessionId = CURRENT_SESSION_ID,
            origin = CURRENT_APP_NAME,
            siteId = CURRENT_SITE_ID)

    action = Dict()
    action[:topic] = topic
    action[:origin] = origin
    action[:execute_time] = executeTime
    action[:trigger] = trigger

    actions = [action]
    publishSystemTrigger("ADoSnipsScheduler", actions)
end
