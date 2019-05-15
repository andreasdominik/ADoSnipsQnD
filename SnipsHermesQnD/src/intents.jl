"""
    registerIntentAction(intent, developer, inModule, action)

Add an intent to the list of intents to be subscribed to.
Each function that shall be executed if Snips recognises
an intent must be registered with this function.
The framework will collect all these links, subscribe to all
needed intents and execute the respectve functions.
The links nieed not to be unique (in both directions):
It is possible to assign several functions to one intent
(all of them will be executed), or to assing one function to
more then one intent.


## Arguments:
- intent: Name of the intend (without developer name)
- developer: Name of skill developer
- inModule: current module (can be accessed with `@__MODULE__`)
- action: the function to be linked with the intent
"""
function registerIntentAction(intent, developer, inModule, action)

    global SKILL_INTENT_ACTIONS
    push!(SKILL_INTENT_ACTIONS, (intent, developer, inModule, action))
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
