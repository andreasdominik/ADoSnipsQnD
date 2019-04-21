#
# helper function for GPIO switching
# on the local server (main)
#
#
# the GPIO number is read form a config entry: Light-GPIO=24
#

"""
function setGPIOtoON(name)

    Switches GPIO on.

# Arguments:
    * gpio: Name of GPIO to be switched as defind in config.ini.
      config.ini must has an entry like:
      GPIOtvLivingroom=24
"""
function setGPIOtoON(name)

    return setGPIO( name, 1)
end


"""
function setGPIOtoOFF(name)

    Switches GPIO off.

# Arguments:
        * gpio: Name of GPIO to be switched as defind in config.ini.
          config.ini must has an entry like:
          GPIOtvLivingroom=24
"""
function setGPIOtoOFF(name)

    return setGPIO( name, 0)
end


"""
function setGPIO(name, onoff)

    Switches GPIO on or off.
"""
function setGPIO(name, onoff)

    gpio = getConfig(name)
    if gpio != nothing
        shell = `pigs w $gpio $onoff`
        tryrun(shell, errorMsg = TEXTS[:error_gpio])
    end
end
