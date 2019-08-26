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

## Details

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
"""
function schedulerAction(topic, payload)

    global actionChannel

    Snips.printLog("trigger action schedulerAction() started.")

    if !haskey(payload, :trigger)
        Snips.printLog("ERROR: Trigger for ADoSnipsScheduler has not payload trigger!")
        return false
    end

    if !haskey(payload[:trigger], :topic) ||
       !haskey(payload[:trigger], :execute_time) ||
       !haskey(payload[:trigger], :trigger)
        Snips.printLog("ERROR: Trigger for ADoSnipsScheduler is incomplete!")
        return false
    end

    global actionChannel

    action = payload[:trigger]
    Snips.printDebug("new action found. $action")
    put!(actionChannel, action)

    return false
end
