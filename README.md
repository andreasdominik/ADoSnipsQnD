# ADoSnipsOnOff

This is a helper skill for the generalised ON-OFF-intent of the SnipsHermesQnD framework for Snips.ai.

The general intent handles all ON- and OFF-requests on one place.
Every skill can subscribe to the intent to get the ON and OFF commands.
Because the intent may include more devices as actually are handled (in the
slot type "device_Type"), commands for unhandled devices can be
recognised by the NLU, but will not be answered. As a result the session
will stay alive until timeout.

This skill handles these devices and end the session explicitly if
necessary.


For the moment, only German and English are supported.
