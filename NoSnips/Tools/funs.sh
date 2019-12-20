#!/bin/bash -xv
#

# read main config from toml, with path/file.toml
# as argument.
#
function readToml() {
  CONFIG=$1
  TOML="$(cat $CONFIG | toml2json)"
  PUBLISH="$(extractJSON .mqtt.publish $TOML)"
  SUBSCRIBE="$(extractJSON .mqtt.subscribe $TOML)"
  MQTT_PORT="$(extractJSON .mqtt.port $TOML)"
  MQTT_HOST="$(extractJSON .mqtt.host $TOML)"

  BASE_DIR="$(extractJSON .local.base_directory $TOML)"
  WORK_DIR="$(extractJSON .local.work_dir $TOML)"

  SITE_ID="$(extractJSON .local.siteId $TOML)"
}




# subscribe to MQTT topics and wait only for ONE message
# then parse the message and return topc and payload
# as TOPIC and PAYLOAD.
#
function subscribeOnce() {

  # add topics:
  #
  _TOPICS=""
  for T in $@ ; do
    _TOPICS="$_TOPICS -t $_T"
  done

  _RECIEVED=$($SUBSCRIBE -C 1 -h $MQTT_HOST -p $MQTT_PORT $_TOPICS -v)
  parseMQTT "$_RECIEVED"
}

function subscribeSiteOnce() {
  _SITE=$1
  shift
  _TOPICS=$@

  _MQTT_SITE="_no_site_"
  while [[ $_MQTT_SITE != $_SITE ]] ; do
    subscribeOnce $_TOPICS
    _MQTT_SITE="$(echo $PAYLOAD | jq -r '.local.siteId')"
  done
}

function parseMQTT() {
  MQTT=$1

  TOPIC=$(echo "$MQTT" | grep -Po '^.*?(?= {)')
  PAYLOAD=$(echo "$MQTT" | grep -Po '{.*}')
}


# extract a field from a JSON string:
# extractJSON .field.name {json string}
#    usage:
#    VAL=$(extractJSON .field {json})
#
# if only one arg, JSON is assumed to be in $TOML
#
function extractJSON() {
  _FIELD=$1
  if [[ $# -gt 1 ]] ; then
    shift
    _JSON=$@
  else
    _JSON=$TOML
  fi

  echo "$(echo $_JSON | jq -r $_FIELD)"
}
