#!/bin/bash -xv
#

function parseMQTT() {
  MQTT=$1

  TOPIC=$(echo "$MQTT" | grep -Po '^.*?(?= {)')
  PAYLOAD=$(echo "$MQTT" | grep -Po '{.*}')
}

# REC='/nosnips/bla/blu {"siteId": "default", "meins": "nix"}'
#
# parseMQTT "$REC"
#
# echo "topic: >$TOPIC<"
# echo "payload: >$PAYLOAD<"
