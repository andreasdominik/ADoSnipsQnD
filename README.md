# ADoSnipsOnOff

This is a helper skill for the generalised ON-OFF-intent of the SnipsHermesQnD framework for Snips.ai.

The general intent handles all ON- and OFF-requests in one place.
Every skill can subscribe to the intent to get the ON and OFF commands.
Because the intent may include more devices as actually are handled (in the
slot type `device_Type`), commands for unhandled devices can be
recognised by the NLU, but will not be answered. As a result the session
will stay alive until timeout.

This skill handles these devices and ends the session explicitly if
necessary.


For the moment, only German and English are supported.


# Julia

This skill is (like the entire SnipsHermesQnD framework) written in the
modern programming language Julia (because Julia is 50-100 times faster
then Python and coding is much much easier and much more straight forward).
However "Pythonians" often need some time to get familiar with Julia.

If you are ready for the step forward, start here: https://julialang.org/
