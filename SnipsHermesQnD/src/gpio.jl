#
# helper function for GPIO switching
# on the local server (main)
#
#
# the GPIO number is read form a config entry: Light-GPIO=24
#

"""
    setGPIO(gpio, onoff::Symbol)

Switch a GPIO on or off.

## Arguments:
* gpio: ID of GPIO (not pinID)
* onoff: one of :on or :off
"""
function setGPIO(gpio, onoff::Symbol)

    if gpio == :on
        shell = `pigs w $gpio 1`
        tryrun(shell, errorMsg = TEXTS[:error_gpio])
    elseif gpio == :off
        shell = `pigs w $gpio 0`
        tryrun(shell, errorMsg = TEXTS[:error_gpio])
    end
end
