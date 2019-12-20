
# Definition of NoSnips MQTT-payloads

## Snips payloads

### Example intent

```
{
  "siteId": "default",
  "sessionId": "d15eb1a0-67ba-4a3b-a378-a5b06e370719",
  "input": "bitte schalte die stehlampe an",
  "intent": {
    "intentName": "andreasdominik:ADoSnipsOnOffDE",
    "confidenceScore": 1
  },
  "slots": [
    {
      "rawValue": "stehlampe",
      "value": {
        "kind": "Custom",
        "value": "floor_light"
      },
      "range": {
        "start": 18,
        "end": 27
      },
      "entity": "device_Type",
      "slotName": "device"
    },
    {
      "rawValue": "an",
      "value": {
        "kind": "Custom",
        "value": "ON"
      },
      "range": {
        "start": 28,
        "end": 30
      },
      "entity": "on_off_Type",
      "slotName": "on_or_off"
    }
  ]
}
```


## NoNsips payloads

### Topic: nosnips/record/asc

Ask the NoSnips `Record` component of a satellite
to record a command:

```
{
  "sessionId": "d15eb1a0-67ba-4a3b-a378-a5b06e370719",
  "siteId": "default",
  "requestId": "ff64e565-8398-4ca5-9742-a4f1712153e3"
}
```



### Topic: nosnips/record/audio

Sent by the NoSnips `Record` component of a satellite
to deliver a base64-encoded audio recording of a command.
All IDs match the IDs of the request:

```
{
  "sessionId": "d15eb1a0-67ba-4a3b-a378-a5b06e370719",
  "siteId": "default",
  "requestId": "ff64e565-8398-4ca5-9742-a4f1712153e3",
  "audio": "UG9seWZvbiB6d2l0c2NoZXJuZCBhw59lbiBNw6R4Y2hlbnMgVsO2Z2VsIF
            LDvGJlbiwgSm9naHVydCB1bmQgUXVhcms="
}
```
