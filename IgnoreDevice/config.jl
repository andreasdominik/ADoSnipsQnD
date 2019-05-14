
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
Snips.setLanguage(LANG)


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
# intent is linked to action{Funktion}
# the action is only matched, if
#   * intentname matches and
#   * if the siteId matches, if site is  defined in config.ini
#     (such as: "switch TV in room abc").
#
INTENT_ACTIONS = Dict{String, Function}()
INTENT_ACTIONS["ADoSnipsOnOffDE"] = ignoreDevice
# INTENT_ACTIONS["BrewCoffee"] = brewCoffee
