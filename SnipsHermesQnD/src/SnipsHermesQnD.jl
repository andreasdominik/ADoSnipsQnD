module SnipsHermesQnD

import JSON
import StatsBase

include("utils.jl")
include("snips.jl")
include("mqtt.jl")
include("hermes.jl")
include("config.jl")
include("gpio.jl")
include("languages.jl")

CONFIG_INI = Dict{Symbol, Any}()
CURRENT_SITE_ID = "default"
CURRENT_SESSION_ID = "1"
TEXTS = TEXTS_EN

export subscribeMQTT, readOneMQTT, publishMQTT,
       subscribe2Intents, listen2Intents,
       publishEndSession, publishContinueSession,
       publishStartSessionAction, publishStartSessionNotification,
       askYesOrNoOrUnknown, askYesOrNo,
       publishSay,
       setLanguage, setSiteId, getSiteId,
       readConfig, matchConfig, getConfig, isinConfig, getAllConfig
       tryrun, tryReadTextfile,
       tryParseJSONfile, tryParseJSON, tryMkJSON,
       extractSlotValue, isInSlot, isOnOffMatched,
       setGPIOtoON, setGPIOtoOFF

end # module
