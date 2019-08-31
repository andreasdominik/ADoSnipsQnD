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
publishListenTrigger
isFalseDetection
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
setConfigPrefix
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
setIntent
getIntent
```

## Multi-language utilities
```@docs
setLanguage
addText
langText
```

## Hardware control

Some devices can be directly controlled by the framework.
In order to stay in the style of Snips, it is possible to
run Shelly WiFi-switches without any cloud accounts and
services.
The Shelly-devices come with an own WiFi network. After installing the
device just connect to Shelly's access point (somthing like `shelly1-35FA58`)
and configure the switch for DHCP in your network with  teh selft-explaining
the web-interface of the device. At no point it's necessary to create an account
or use a cloud service (although the Shelly1 documentation recommends).

```@docs
setGPIO
switchShelly1
```

## Status database

The framework handles a database to save status about
house and devices, controlled by the assistant.
The database is stored on disk in order to persist in case
of a system crash or restart.

Every skill can store and read Dicts() as entries with a unique key
or values as field-value-pairs as part of an entry.

The db looks somehow like:
```
{
    "irrigation" :
    {
        "time" : "2019-08-26T10:12:13.177"
        "writer" : "ADoSnipsIrrigation",
        "payload" :
        {
            "status" : "on",
            "next_status" : "off"
        }
    }
}
```


Location of the database file is
`<application_data_dir>/ADoSnipsQnD/<database_file>`
where `application_data_dir` and `database_file>` are parameters in the
`config.ini` of the framework.

```@docs
dbWritePayload
dbWriteValue
dbHasEntry
dbReadEntry
dbReadValue
```

## Scheduler

The QnD framework provides a scheduler which allows to execute
system triggers at a specified time in the future.

Schedules are added by sending a trigger with the
following format to the scheduler. A list of triggers
can be scheduled with one trigger:

```
{
  "origin": "ADoSnipsAuto",
  "topic": "qnd/trigger/andreasdominik:ADoSnipsSchedule",
  "siteId": "default",
  "sessionId": "7dab7a26-84fb-4855-8ad0-acd955408072",
  "trigger": {
    "mode": "add schedules",
    "sessionId": "7dab7a26-84fb-4855-8ad0-acd955408072",
    "siteId": "default",
    "time": "2019-08-26T14:07:55.623",
    "origin": "ADoSnipsAuto",
    "actions": [
      {
        "topic": "qnd/trigger/andreasdominik:ADoSnipsLights",
        "origin": "ADoSnipsAuto",
        "execute_time": "2019-08-28T10:00:20.534",
        "trigger": {
          "settings": "undefined",
          "device": "main_light",
          "onOrOff": "ON",
          "room": "default"
        }
      },
      {
        "topic": "qnd/trigger/andreasdominik:ADoSnipsLights",
        "origin": "ADoSnipsAuto",
        "execute_time": "2019-08-28T10:00:30.534",
        "trigger": {
          "settings": "undefined",
          "device": "main_light",
          "onOrOff": "OFF",
          "room": "default"
        }
      }
    ]
  }
}
```

A trigger with a `mode` od `"delete all"`, `"delete by topic"` or
`"delete by origin"` will delete the matching schedules:

```
{
  "origin": "Main.ADoSnipsTemplate",
  "topic": "qnd/trigger/andreasdominik:ADoSnipsSchedule",
  "siteId": "default",
  "sessionId": "7dab7a26-84fb-4855-8ad0-acd955408072",
  "trigger": {
    "mode": "delete all",
    "sessionId": "7dab7a26-84fb-4855-8ad0-acd955408072",
    "siteId": "default",
    "topic": "dummy",
    "origin": "dummy",
    "time": "2019-08-26T14:07:55.623"
  }
}
```

However, it is normally not necessary to set up these triggers manually;
the following API functions provide an interface:

```@docs
schedulerAddAction
schedulerAddActions
schedulerMakeAction
schedulerDeleteAll
schedulerDeleteTopic
schedulerDeleteOrigin
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
printLog
printDebug
```

## Index

```@index
```
