module SnipsHermesQnD

import JSON
import StatsBase
using Dates
using Distributed

include("utils.jl")
include("snips.jl")
include("mqtt.jl")
include("hermes.jl")
include("intents.jl")
include("config.jl")
include("dates.jl")
include("gpio.jl")
include("languages.jl")
include("callback.jl")

CONFIG_INI = Dict{Symbol, Any}()
CURRENT_SITE_ID = "default"
CURRENT_SESSION_ID = "1"
CURRENT_DEVEL_NAME = "unknown"
CURRENT_MODULE = Main
CURRENT_INTENT = "none"

# set default language and texts to en
#
DEFAULT_LANG = "en"
LANG = DEFAULT_LANG
TEXTS = TEXTS_EN
setLanguage(LANG)

# List of intents to listen to:
# (intent, developer, complete topic, module, skill-action)
#
SKILL_INTENT_ACTIONS = Tuple{AbstractString, AbstractString, AbstractString,
                             Module, Function}[]

export subscribeMQTT, readOneMQTT, publishMQTT,
       subscribe2Intents, subscribe2Topics, listenIntentsOneTime,
       publishEndSession, publishContinueSession,
       publishStartSessionAction, publishStartSessionNotification,
       publishSystemTrigger,
       configureIntent,
       registerIntentAction, registerTriggerAction,
       getIntentActions, setIntentActions,
       askYesOrNoOrUnknown, askYesOrNo,
       publishSay,
       setLanguage, setSiteId, getSiteId,
       setSessionId, getSessionId,
       setDeveloperName, getDeveloperName, setModule, getModule,
       setTopic, getTopic,
       readConfig, matchConfig, getConfig, isInConfig, getAllConfig,
       tryrun, tryReadTextfile,
       tryParseJSONfile, tryParseJSON, tryMkJSON,
       extractSlotValue, isInSlot, isOnOffMatched,
       readableDateTime, setGPIO

end # module
