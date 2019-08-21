#
# helper function for switching of a shelly device
#
#

"""
    shelly1on(ip)

Switch a shelly1 device on and returns true, if successful.
For the API-doc of teh Shelly devices see:
`https://shelly-api-docs.shelly.cloud`.
"""
function shelly1on(ip)

    return(switchShelly1(ip, :on))
end

"""
    shelly1off(ip)

Switch a shelly1 device off and returns true, if successful.
For the API-doc of teh Shelly devices see:
`https://shelly-api-docs.shelly.cloud`.
"""
function shelly1off(ip)

    return(switchShelly1(ip, :off))
end


"""
    shelly1onoff(ip, timer)

Switch a shelly1 device on and off again after `timer` secs.
Returns true, if successful.
For the API-doc of teh Shelly devices see: 
`https://shelly-api-docs.shelly.cloud`.
"""
function shelly1onoff(ip, timer)

    timout = 10
    cmd = `curl -v -m $timeout http://$ip/relay/0?turn=:on&timer=$timer`
    return(Snips.tryrun(cmd))
end


function switchShelly1(ip,action)

    if action == :on
        parameter = "on"
    else
        parameter = "off"
    end

    timout = 10
    cmd = `curl -v -m $timeout http://$ip/relay/0?turn=$parameter`
    return(Snips.tryrun(cmd))
end
