#
# helper function for switching of a shelly device
#
#


"""
    switchShelly1(ip, action; timer = 10)

Switch a shelly1 device with IP `ip` on or off, depending
on the value given as action and
return `true`, if successful.

## Arguments:
- `ip`: IP address or DNS name of Shelly1 device
- `action`: demanded action as symbol; one of `:on`, `:off` or `:timer`.
- `timer`: if action == `timer`, the device is switched on and
           off again after `timer` secs (default 10s).

For the API-doc of the Shelly devices see:
`<https://shelly-api-docs.shelly.cloud>`.
"""
function switchShelly1(ip, action; timer = 10)

    timeout = 10
    if action == :on
        cmd = `curl -v -m $timeout http://$ip/relay/0?turn=on`
    elseif action == :timer
        cmd = `curl -v -m $timeout http://$ip/relay/0?turn=on&timer=$timer`
    elseif action == :off
        cmd = `curl -v -m $timeout http://$ip/relay/0?turn=off`
    else
        printLog("ERROR in switchShelly1: action $action is not supported")
        publishSay("Try to switch a Shelly-one with an unsuppored command!")
    end

    return(tryrun(cmd))
end
