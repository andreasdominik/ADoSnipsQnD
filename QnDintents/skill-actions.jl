#
# actions called by the main callback()
# provide one function for each intent, defined in the Snips Console.
#
# ... and link the function with the intent name as shown in config.jl
#
# The functions will be called by the main callback function with
# 2 arguments:
# * MQTT-Topic as String
# * MQTT-Payload (The JSON part) as a nested dictionary, with all keys
#   as Symbols (Julia-style)
#
"""
function ignoreDevice(topic, payload)

    Ignore (i.e. end session) when unified OnOff-Intent is recognised for
    a unhandled device.
"""
function ignoreDevice(topic, payload)

    Snips.printLog("action ignoreDevice() started.")
    # find the device in payload:
    #
    device = Snips.extractSlotValue(payload, SLOT_DEVICE)

    # test if is in list of devices to be handled:
    #
    if !(device isa AbstractString)
        Snips.printLog("no device: ignored and session ended.")
        Snips.publishEndSession("$(TEXTS[:not_handled])")
        return true     # no hotword needed for next command

    elseif !Snips.matchConfig(INI_NAMES, device)
        Snips.printDebug("Device: $device, List: $(Snips.getConfig(INI_NAMES))")
        Snips.printLog("device $device ignored and session ended.")
        Snips.publishEndSession("$(TEXTS[:not_handled]) $device")
        return true     # no hotword needed for next command
    else
        # just ignore and let another app deal with the session...
        #
        return false    # hotword needed for next command
    end
end


"""
    schedulerAction(topic, payload)

Trigger action for the scheduler. Each schedulerTrigger must
contain a trigger and an execution time for the trigger.

## Trigger: add new schedule

A scheduler trigger addresses the scheduler (as target) and must
include a complete trigger object as payload (i.e. trigger):
```
{
  "topic" : "qnd/trigger/andreasdominik:ADoSnipsScheduler",
  "origin" : "ADoSnipsPlanLights",
  "time" : "2019-08-26T10:12:13.177",
  "trigger" :
  {
    "origin" : "ADoSnipsPlanLights",
    "mode" : "add schedule",
    "time" : "2019-08-26T10:12:13.177",
    "topic" : "qnd/trigger/andreasdominik:ADoSnipsLights",
    "execute_time" : "2019-08-12T08:12:33.329"
    "trigger" :
    {
      "room" : "default",
      "device" : "floor_lamp",
      "onOrOff" : "ON",
      "settings" : "undefined"
    }
  }
}
```

## Trigger: delete schedules

The trigger can delete **all** schedules or all schedules
for a specific trigger. The field `topic` is ignored for `mode == all`:
```
{
  "topic" : "qnd/trigger/andreasdominik:ADoSnipsScheduler",
  "time" : "2019-08-26T10:12:13.177",
  "trigger" :
  {
    "origin" : "ADoSnipsPlanLights",
    "mode" : "delete all",              // or "delete topic"
    "time" : "2019-08-26T10:12:13.177",
    "topic" : "qnd/trigger/andreasdominik:ADoSnipsLights",
  }
}
```
"""
function schedulerAction(topic, payload)

    global actionChannel

    Snips.printLog("trigger action schedulerAction() started.")


    if !haskey(payload, :trigger)
        Snips.printLog("ERROR: Trigger for ADoSnipsScheduler has no payload trigger!")
        return false
    end
    trigger = payload[:trigger]
    if !haskey(trigger, :origin)
        trigger[:origin] = payload[:origin]
    end

    if !haskey(trigger, :mode)
        Snips.printLog("ERROR: Trigger for ADoSnipsScheduler has no mode!")
        return false
    end

    # if mode == add new schedule:
    #
    if trigger[:mode] == "add schedule"
        if !haskey(trigger, :topic) ||
           !haskey(trigger, :execute_time) ||
           !haskey(trigger, :trigger)
            Snips.printLog("ERROR: Trigger for ADoSnipsScheduler is incomplete!")
            return false
        end

        Snips.printDebug("new action found. $trigger")
        put!(actionChannel, trigger)

    # else delete ...
    #
    elseif trigger[:mode] == "delete by topic"
        if !haskey(trigger, :topic)
            Snips.printLog("ERROR: ADoSnipsScheduler delete by topic but no topic in trigger!")
            return false
        end
        Snips.printDebug("New delete schedule by topic trigger found: $trigger)")
        put!(deleteChannel, trigger)

    elseif trigger[:mode] == "delete by origin"
        if !haskey(trigger, :origin)
            Snips.printLog("ERROR: ADoSnipsScheduler delete by origin but no origin in trigger!")
            return false
        end
        Snips.printDebug("New delete schedule by origin trigger found: $trigger)")
        put!(deleteChannel, trigger)

    elseif trigger[:mode] == "delete all"
        Snips.printDebug("New delete all schedules: $trigger)")
        put!(deleteChannel, trigger)

    else
        Snips.printDebug("Trigger has no valid mode: $trigger)")
    end
    return false
end
