"""
    registerIntentAction(intent, developer, inModule, action)
    registerIntentAction(intent, action)

Add an intent to the list of intents to subscribe to.
Each function that shall be executed if Snips recognises
an intent must be registered with this function.
The framework will collect all these links, subscribe to all
needed intents and execute the respective functions.
The links need not to be unique (in both directions):
It is possible to assign several functions to one intent
(all of them will be executed), or to assign one function to
more then one intent.

The variant with only `(intent, action)` as arguments
applies the variables CURRENT_DEVEL_NAME and CURRENT_MODULE as
stored in the framework.
The variants registerIntent... create topics with prefix
`hermes/intent/developer:intent`.

## Arguments:
- intent: Name of the intend (without developer name)
- developer: Name of skill developer
- inModule: current module (can be accessed with `@__MODULE__`)
- action: the function to be linked with the intent
"""
function registerIntentAction(intent, developer, inModule, action)

    global SKILL_INTENT_ACTIONS
    topic = "hermes/intent/$developer:$intent"
    push!(SKILL_INTENT_ACTIONS, (intent, developer, topic, inModule, action))
end


function registerIntentAction(intent, action)

    registerIntentAction(intent, CURRENT_DEVEL_NAME, CURRENT_MODULE, action)
end




"""
    registerTriggerAction(intent, developer, inModule, action)
    registerTriggerAction(intent, action)

Add an intent to the list of intents to subscribe to.
Each function that shall be executed if Snips recognises
The variants registerTrigger... create topics with prefix
`QnD/trigger/developer:intent`.

See `registerIntentAction()` for details.
"""
function registerTriggerAction(intent, developer, inModule, action)

    global SKILL_INTENT_ACTIONS
    topic = "qnd/trigger/$developer:$intent"
    push!(SKILL_INTENT_ACTIONS, (intent, developer, topic, inModule, action))
end

function registerTriggerAction(intent, action)

    registerTriggerAction(intent, CURRENT_DEVEL_NAME, CURRENT_MODULE, action)
end





"""
    getIntentActions()

Return the list of all intent-function mappings for this app.
The function is exported to deliver the mappings
to the Main context.
"""
function getIntentActions()

    global SKILL_INTENT_ACTIONS
    return SKILL_INTENT_ACTIONS
end




"""
    setIntentActions(intentActions)

Overwrite the complete list of all intent-function mappings for this app.
The function is exported to get the mappings
from the Main context.

## Arguments:
* intentActions: Array of intent-action mappings as Tuple of
                 (intent::AbstractString, developer::AbstractString,
                  inModule::Module, action::Function)
"""
function setIntentActions(intentActions)

    global SKILL_INTENT_ACTIONS
    SKILL_INTENT_ACTIONS = intentActions
end


"""
    publishSystemTrigger(topic, trigger)

Publish a system trigger with topic and payload.

## Arguments:
* topic: MQTT topic, with or w/o the developername. If no
         developername is included, CURRENT_DEVEL_NAME will be added.
         If the topic does not start with `qnd/trigger/`, this
         will be added.
* trigger: specific payload for the trigger.
"""
function publishSystemTrigger(topic, trigger)

    if !occursin(r":", topic)
        topic = "$CURRENT_DEVEL_NAME:$topic"
    end
    if !occursin(r"^qnd/trigger/", topic)
        topic = "qnd/trigger/$topic"
    end

    payload = Dict( :target => topic,
                    :origin => "$CURRENT_MODULE",
                    :time => "$(now())",
                    :sessionId => CURRENT_SESSION_ID,
                    :siteId => CURRENT_SITE_ID,
                    :trigger => trigger
                  )

    publishMQTT(topic, payload)
end
