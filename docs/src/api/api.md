# API documentation

## Hermes functions

These functions publish and subscribe to Hermes MQTT-topics.

```@docs
subscribe2Intents
subscribe2Topics
publishStartSessionAction
publishStartSessionNotification
publishEndSession
```


## Dialogue manager functions

In addition to functions to work with the dialogue manager,
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


## Functions to handle intents

```@docs
registerIntentAction
registerTriggerAction
getIntentActions
setIntentActions
publishSystemTrigger
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
getConfig
getAllConfig
readConfig
matchConfig
isInConfig
isConfigValid
```


## Slot access functions

Functions to read values from slots of recognised intents.

```@docs
extractSlotValue
isInSlot
isOnOffMatched
isValidOrEnd
```


## MQTT functions

Low-level API to MQTT messages (publish and subscribe).
In the QuickAndDirty framework, these functions are calling
Eclipse `mosquitto_pub` and `mosquitto_sub`. However
this first (and preliminary) implementation is surpriningly
robust and easy to maintain - there might be no need to change.

```@docs
subscribeMQTT
readOneMQTT
publishMQTT
```



## Handle background information of recognised intent
```@docs
setSiteId
getSiteId
setSessionId
getSessionId
setDeveloperName
getDeveloperName
setModule
getModule
setAppDir
getAppDir
setAppName
getAppName
setTopic
getTopic
```

## Multi-language utilities
```@docs
setLanguage
addText
langText
```

## Utility functions

Little helpers to provide functionality which is commonly needed
when developing a skill.

```@docs
readableDateTime
tryrun
ping
tryReadTextfile
tryParseJSONfile
tryParseJSON
tryMkJSON
setGPIO
printDebug
```

## Index

```@index
```
