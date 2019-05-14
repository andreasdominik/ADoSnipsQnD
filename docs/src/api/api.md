# API documentation

## Hermes functions

These functions publish and subscribe to Hermes MQTT-topics.

```@docs
subscribe2Intents
publishStartSessionAction
publishStartSessionNotification
publishEndSession
```


## Dialogue manager functions

In addition to functions to work with the dialogue manager
advanced direct dialogues are provided that can be included
in the control flow of the program.

```@docs
publishContinueSession
listenIntentsOneTime
configureIntent
askYesOrNoOrUnknown
askYesOrNo
publishSay
```


## config.ini functions

Helper functions for read values from the file `config.ini`.

`config.ini` files follow the normal rules as for all Snips apps, with
one extension:

- no spaces around the `=`
- if value of the parameter (right side) includes commas,
  the value can be interpreted as a comma-separated list of values.
  In this case, the reader-function will return an array of Strings
  with the values (which an be accessed by their index).


```@docs
readConfig
matchConfig
getConfig
isInConfig
getAllConfig
```


## Slot access functions

Functions to read values from slots of recognised intents.

```@docs
extractSlotValue
isInSlot
isOnOffMatched
```


## MQTT functions

Low-level API to MQTT messages (publish and subscribe).
In the QuickAndDirty framework, these functions are calling
Eclipse `mosquitto_pub` and `mosquitto_sub`. However
this first (and preliminary) implementation is surpriningly
robust and easy to maintain - it seems there is no need to change.

```@docs
subscribeMQTT
readOneMQTT
publishMQTT
```


## Utility functions

Little helpers to provide functionality whichis commonly needed
when develloping a skill.

### Handle siteId from recognised intent
```@docs
setSiteId
getSiteId
setSessionId
getSessionId
```


### Other Utils
```@docs
setLanguage
readableDateTime
tryrun
tryReadTextfile
tryParseJSONfile
tryParseJSON
tryMkJSON
setGPIO
```

## Index

```@index
```
