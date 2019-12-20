#!/bin/bash -xv
#

# read main config from toml, with path/file.toml
# as argument.
#
function readToml() {
  CONFIG=$1
  TOML="$(cat $CONFIG | toml2json)"
  MQTT_PORT="$(extractJSON .mqtt.port $TOML)"
  MQTT_HOST="$(extractJSON .mqtt.host $TOML)"
  MQTT_USER="$(extractJSON .mqtt.user $TOML)"
  MQTT_PW="$(extractJSON .mqtt.password $TOML)"

  BASE_DIR="$(extractJSON .local.base_directory $TOML)"
  WORK_DIR="$(extractJSON .local.work_dir $TOML)"

  SITE_ID="$(extractJSON .local.siteId $TOML)"

  SUBSCRIBE="$(extractJSON .mqtt.subscribe $TOML)"
  SUBSCRIBE="$SUBSCRIBE -C 1 -v $(mqtt_auth)"
  PUBLISH="$(extractJSON .mqtt.publish $TOML)"
  PUBLISH="$PUBLISH $(mqtt_auth)"
}



# mqtt_sub/pub command with optional user/password:
#
function mqtt_auth() {

  # _FLAGS="-C 1 -v"
  _FLAGS=""

  [[ -n $MQTT_HOST ]] && _FLAGS="$_FLAGS -h $MQTT_HOST"
  [[ -n $MQTT_PORT ]] && _FLAGS="$_FLAGS -p $MQTT_PORT"
  [[ -n $MQTT_USER ]] && _FLAGS="$_FLAGS -u $MQTT_USER"
  [[ -n $MQTT_PW ]] && _FLAGS="$_FLAGS -P $MQTT_PW"

  echo "$_FLAGS"
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

  _RECIEVED="$($SUBSCRIBE $_TOPICS)"
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
  _MQTT=$1

  MQTT_TOPIC=$(echo "$MQTT" | grep -Po '^.*?(?= {)')
  MQTT_PAYLOAD=$(echo "$MQTT" | grep -Po '{.*}')
  MQTT_SITE_ID=$(extractJSON .siteId $MQTT_PAYLOAD)
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
