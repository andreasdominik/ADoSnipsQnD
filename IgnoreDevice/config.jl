
# language settings:
# 1) set LANG to "en", "de", "fr", etc.
# 2) link the Dict with messages to the version with
#    desired language as defined in languages.jl:
#
LANG = "de"
TEXTS = TEXTS_DE

# DO NOT CHANGE THE FOLLOWING 3 LINES UNLESS YOU KNOW
# WHAT YOU ARE DOING!
# set CONTINUE_WO_HOTWORD to true to be able to chain
# commands without need of a hotword in between:
#
CONTINUE_WO_HOTWORD = true
DEVELOPER_NAME = "andreasdominik"
lang = Snips.getConfig(:language)
const LANG = (lang != nothing) ? lang : "de"


# Slots:
# Name of slots to be extracted from intents:
#
SLOT_ROOM = "room"
SLOT_DEVICE = "device"
SLOT_ON_OFF = "on_or_off"

# name of entry in config.ini:
#
INI_NAME = "not_handled"


#
# link between actions and intents:
#
Snips.registerIntentAction("ADoSnipsOnOffDE", DEVELOPER_NAME,
                            @__MODULE__, templateAction)
