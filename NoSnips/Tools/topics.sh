
# Topics:
#

# Snips dialogueManager topics:
#
TOPIC_API="hermes/dialogueManager/startSession"
TOPIC_END="hermes/dialogueManager/endSession"
TOPIC_CONTINUE="hermes/dialogueManager/continueSession"
TOPIC_SESSION_ENDED="hermes/dialogueManager/sessionEnded"


# Snips Hermes and QnD topics:
#
TOPIC=TOPIC_HOTWORD_ON="hermes/hotword/toggleOn"
TOPIC=TOPIC_HOTWORD_OFF="hermes/hotword/toggleOff"
TOPIC_HOTWORD="hermes/hotword/default/detected"

TOPIC_ASR_START="hermes/asr/startListening"
TOPIC_ASR_AUDIO="qnd/asr/audioCaptured"
TOPIC_ASR_TRANSSCRIBE="qnd/asr/transsribe"
TOPIC_ASR_TEXT="hermes/asr/textCaptured"

TOPIC_NLU_QUERY="hermes/nlu/query"
TOPIC_NLU_PARSED="hermes/nlu/intentParsed"
TOPIC_NLU_NOT="hermes/nlu/intentNotRecognized"


# QnD NoSnips topics:
#
TOPIC_TIMEOUT="qnd/session/timeout"
TOPIC_WATCH_LOG="qnd/watch/log"
