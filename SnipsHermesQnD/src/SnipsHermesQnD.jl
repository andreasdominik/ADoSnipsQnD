module SnipsHermesQnD

import JSON
import StatsBase
using Dates

include("utils.jl")
include("snips.jl")
include("mqtt.jl")
include("hermes.jl")
include("intents.jl")
include("config.jl")
include("dates.jl")
include("gpio.jl")
include("languages.jl")

CONFIG_INI = Dict{Symbol, Any}()
CURRENT_SITE_ID = "default"
CURRENT_SESSION_ID = "1"

# set default language and texts to en
#
DEFAULT_LANG = "en"
LANG = DEFAULT_LANG
TEXTS = TEXTS_EN
setLanguage(LANG)

# List of intents to listen to:
#
SKILL_INTENT_ACTIONS = Tuple{AbstractString,Function}[]

export subscribeMQTT, readOneMQTT, publishMQTT,
       subscribe2Intents, listenIntentsOneTime,
       publishEndSession, publishContinueSession,
       publishStartSessionAction, publishStartSessionNotification,
       configureIntent,
       registerIntentAction, getIntentActions,
       askYesOrNoOrUnknown, askYesOrNo,
       publishSay,
       setLanguage, setSiteId, getSiteId,
       setSessionId, getSessionId,
       readConfig, matchConfig, getConfig, isInConfig, getAllConfig,
       tryrun, tryReadTextfile,
       tryParseJSONfile, tryParseJSON, tryMkJSON,
       extractSlotValue, isInSlot, isOnOffMatched,
       readableDateTime, setGPIO

end # module
