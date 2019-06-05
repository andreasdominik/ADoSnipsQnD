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

    println("[ADoSnipsOnOff]: action ignoreDevice() started.")
    # find the device in payload:
    #
    device = Snips.extractSlotValue(payload, SLOT_DEVICE)
    # if device != nothing
    #     println(device)
    # else
    #     println("nothing")
    # end
    # println(Snips.getConfig(INI_NAMES))
    
    # test if is in list of devices to be handled:
    #
    if !(device isa AbstractString)
        println("[ADoSnipsOnOff]: No device: ignored and session ended.")
        Snips.publishEndSession("$(TEXTS[:not_handled])")
        return true     # no hotword needed for next command

    elseif !Snips.matchConfig(INI_NAMES, device)
        println("[ADoSnipsOnOff]: device $device ignored and session ended.")
        Snips.publishEndSession("$(TEXTS[:not_handled]) $device")
        return true     # no hotword needed for next command
    else
        # just ignore and let another app deal with the session...
        #
        return false    # hotword needed for next command
    end
end
