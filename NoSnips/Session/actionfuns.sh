#!/bin/bash
#
# functions to run one action, triggered by hotword
#

TOPIC_ASK_AUDIO="nosnips/record/asc"
TOPIC_AUDIO="nosnips/record/audio"

TOPIC_ASK_STT="nosnips/stt/asc"
TOPIC_STT="nosnips/stt/transscript"


# runs all snips-replacements to process one action:
#
function runactionfun() {

  # ask satellite to record command
  # and wait for audio (or exit if no audio):
  #
  REQUEST_ID="$(uuidgen)"
  PAYLOAD="{
             \"sessionId\": \"$REQUEST_ID\",
             \"siteId\": \"$SESSION_SITE_ID\",
             \"requestId\": \"$REQUEST_ID\"
           }"

  $PUBLISH -t $TOPIC_ASK_AUDIO -m $PAYLOAD

  MQTT_REQ_ID="no_ID"
  while [[ $MQTT_REQ_ID == "no_ID" ]] ; do
    subscribeSiteOnce $SESION_SITE_ID $TOPIC_AUDIO
    MQTT_REQ_ID="$(extractJSON .requestId $MQTT_PAYLOAD)"
  done

  AUDIO="$($extractJSON .audio $MQTT_PAYLOAD)"

  if [[ -z $AUDIO ]] ; then
    return
  fi


  # send audio to STT
  # and wait for text:
  #
  REQUEST_ID="$(uuidgen)"
  PAYLOAD="{
             \"sessionId\": \"$REQUEST_ID\",
             \"siteId\": \"$SESSION_SITE_ID\",
             \"requestId\": \"$REQUEST_ID\",
             \"audio\": \"$AUDIO\"
           }"

  $PUBLISH -t $TOPIC_ASK_STT -m $PAYLOAD

  MQTT_REQ_ID="no_ID"
  while [[ $MQTT_REQ_ID == "no_ID" ]] ; do
    subscribeSiteOnce $SESION_SITE_ID $TOPIC_STT
    MQTT_REQ_ID="$(extractJSON .requestId $MQTT_PAYLOAD)"
  done

  TS="$($extractJSON .transscript $MQTT_PAYLOAD)"

  if [[ -z $TS ]] ; then
    return
  fi

  # send command to NLU
  # and receive result:
  #
  REQUEST_ID="$(uuidgen)"
  PAYLOAD="{
             \"sessionId\": \"$REQUEST_ID\",
             \"siteId\": \"$SESSION_SITE_ID\",
             \"requestId\": \"$REQUEST_ID\",
             \"transscript\": \"$TS\"
           }"

  $PUBLISH -t $TOPIC_ASK_NLU -m $PAYLOAD

  MQTT_REQ_ID="no_ID"
  while [[ $MQTT_REQ_ID == "no_ID" ]] ; do
    subscribeSiteOnce $SESION_SITE_ID $TOPIC_NLU
    MQTT_REQ_ID="$(extractJSON .requestId $MQTT_PAYLOAD)"
  done

  INTENT="$($extractJSON .intent $MQTT_PAYLOAD)"

  if [[ -z $INTENT ]] ; then
    return

  # publish intent:
  #
  INTENT_NAME="$(extractJSON .intent.intentName, $INTENT)"
  $PUBLISH -t $INTENT_NAME -m $INTENT
}
