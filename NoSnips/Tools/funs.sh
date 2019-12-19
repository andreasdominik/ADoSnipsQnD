#!/bin/bash -xv
#

# read main config from toml, with path/file.toml
# as argument.
#
function readToml() {
  CONFIG=$1
  TOML="$(cat $CONFIG | toml2json)"
  PUBLISH="$(echo $TOML | jq -r '.mqtt.publish')"
  SUBSCRIBE="$(echo $TOML | jq -r '.mqtt.subscribe')"
  MQTT_PORT="$(echo $TOML | jq -r '.mqtt.port')"
  MQTT_HOST="$(echo $TOML | jq -r '.mqtt.host')"

  BASE_DIR="$(echo $TOML | jq -r '.local.base_directory')"
  WORK_DIR="$(echo $TOML | jq -r '.local.work_dir')"

  SITE_ID="$(echo $TOML | jq -r '.local.siteId')"
}




# subscribe to MQTT topics and wait only for ONE message
# then parse the message and return topc and payload
# as TOPIC and PAYLOAD.
#
function subscribeOnce() {

  # add topics:
  #
  TOPICS=""
  for T in $@ ; do
    TOPICS="$TOPICS -t $T"
  done

  RECIEVED=$($SUBSCRIBE -C 1 -h $MQTT_HOST -p $MQTT_PORT $TOPICS -v)
  parseMQTT "$RECIEVED"
}

function parseMQTT() {
  MQTT=$1

  TOPIC=$(echo "$MQTT" | grep -Po '^.*?(?= {)')
  PAYLOAD=$(echo "$MQTT" | grep -Po '{.*}')
}
