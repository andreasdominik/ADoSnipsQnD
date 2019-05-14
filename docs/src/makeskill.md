# How to write a new skill

This brief tutorials guides through the process of
making a new skill from this template in Julia language.


## Set up a new project

To start with a new SnipsHermesQnD skill, just set up a new GitHub repository for
the code of your skill (such as mySkill),
get a clone of the GitHub project ADoSnipsTemplate and
define your repo as remote for the local clone of the template.

All file- and directory names can be left unchanged; however you
may want to rename the project directory and
the file `action-ADoSnipsTemplate.jl` to a name
that identifies your new skill. The new name of the
action-executable **must** start with
`action-`, because the snips skill manager identifies executable
apps by this naming convention:

```sh
cd Documents
cd SnipsSkills
git clone git@github.com:andreasdominik/ADoSnipsTemplate.git

mv ADoSnipsTemplate mySkill
cd mySkill/
mv action-ADoSnipsTemplate.jl action-mySkill.jl

git rm action-ADoSnipsTemplate.jl
git add action-mySkill.jl
git status
git commit -m 'initial commit'
git remote set-url origin git@github.com:yourGitHubName/mySkill.git
git push origin master
```


## Files in the template

The template consists of several files, but only some of them need to be
adapted for a new skill.

filename | comment | needs to be adapted
---------|---------|--------------------
`api.jl` | source code of Julia low-level API for a controlled device | optional
`callback.jl` | holds the callback, used in the background | no
`config.jl`   | global definitions for a skill             | yes
`languages.jl`| text fragments for multi-language support  | optional
`skill-actions.jl` | functions to be executed, if an intent is recognised | yes
`Skill.jl`    | the julia module for the skill             | no

In a minimum-setup only 2 things need to be adapted for a new
skill:
- the action-functions which respond to an intent (the *direct* action, no callback)
  must be definded and implemented (`skill-actions.jl`)
- the action-functions must be connected with the corresponding intent names
  (`config.jl`).

Optionally, more fine-grained software engineering is possible by
- separating the user-interaction from the API of controlled devices (latter
  will go to `api.jl`)
- adding multi-language support, by specifying phrases in different languages
  (`languages.jl`) and by using different intents, depending on the language
  defined in `config.ini`.


## Example with low-level API

This tutorial shows how a skill to control an external device
can be derived from the template.

The idea is to control an Amazon fire stick with a minimum set of commands
`on, off, play, pause`.
More commands can be implement easily the same way.

Switching on and off is implemented based on the common on-off-intent,
included in the framework.


### The Amazon fire low-level API

The low-level API which sends commands to the Amazon fire is borrowed from
Matt's ADBee project (`git@github.com:mattgyver83/adbee.git`) that provides
a shell-script to send commands to the Amazon device.
Please read theer for the steps to prepare the Amazon device for
the remote control via ADB.

Although Python programmes usually find Python packages for every task, it is
a very good idea to implement the lowest level af any device-control API
as a shell script. Advantages:
- easy to write
- fast and without any overhead
- easy to test: the API canbe tested by just running the script
  from commandline as `controlFire ON` or `controlFire OFF` and see
  what happens.

 The simplified ADBee-script is:

```sh
#!/bin/bash -xv
# control fireTv via adb

COMMANDS=$@
IP=amazon-fire  # set to 192.168.1.200 by dhcp
PORT=5555
ADB=adb
SEND_KEY="$ADB -s $IP:$PORT shell input keyevent"

adb connect amazon-fire

for CMD in $COMMANDS ; do
  case $CMD in
    wake)
      $SEND_KEY KEYCODE_WAKEUP
      ;;
    sleep)
      $SEND_KEY KEYCODE_POWER
      ;;
    play)
      $SEND_KEY KEYCODE_MEDIA_PLAY_PAUSE
      ;;
    pause)
      $SEND_KEY KEYCODE_MEDIA_PLAY_PAUSE
      ;;
    # more commands may go here ...
  esac
done
```

Once this script is tested, the Julia API can be set up.


### The Julia API

By default the API goes into the file api.jl, which is empty
in the template.

In this case only a wrapper is needed, to make the API-commands
available in the Julia program.
The framework provide a function `tryrun()` to execute external
commands safely (i.e. if an error occures, the program will not crash,
but reading the error message via Hermes text to speech).

This API definition splits in the function to execute the ADBee-script and
functions to be called by the user:

```Julia
function adbCmds(cmds)

    return tryrun(`$ADB $(split(cmds))`, errorMsg =
            """An error occured while sending commands $cmds
            to Amazon fire."""
end




function amazonON()
    adbCmds("wake")
end

function amazonOFF()
    adbCmds("sleep")
end

function amazonPlay()
    adbCmds("play")
end

function amazonPause()
    adbCmds("pause")
end
```


### The skill-action for on/off

This functions are executed by the framework if an intent is
recognised.
The functions are defined in the file `skill-actions.jl`.
On/off is handled via the common on/off-intent, all other actions
need a specific intent, that must be set up in the Snips console.

```Julia
"""
function powerOnOff(topic, payload)

    Power on or of with SnipsHermesQnD mechanism.
"""
function powerOnOff(topic, payload)

    if isOnOffMatched(payload, DEVICE_NAME) == :on
        Snips.publishEndSession("I wake up the Amazon Fire Stick.")
        amazonON()
        return true

    elseif isOnOffMatched(payload, DEVICE_NAME) == :off
        Snips.publishEndSession("I send the Amazon Fire Stick to sleep.")
        amazonOFF()
        return true

    else
        return false
    end
end
```

Returning `false` will disable the *continue without hotword* function; i.e.
a hotword is necessary before the next command can be uttered.
This is necessary for the default-case, because probably a different
app will execute this non-recognised command.


### The skill-action for all other commands

All other commands must be handled by an intent that you must
create in the Snips console.
Let's assume the intent has the name `ControlAmazon` and delivers
the command in the slot `Command`.
The slot should know all known commands with synonyms.

To handle this, a second skill-action has to be defined in the file
`skill-actions.jl`:

```Julia
"""
function commands(topic, payload)

    Send commands to Amamzon device.
"""
function commands(topic, payload)

    if Snips.isInSlot(payload, SLOT_NAME, "play")
        Snips.publishEndSession("I play the current selection!")
        amazonPlay()
        return true

    elseif Snips.isInSlot(payload, SLOT_NAME, "pause")
        Snips.publishEndSession("I pause the movie.")
        amazonPause()
        return true

    else
        Snips.publishEndSession("I cannot respond!")
        return true
    end
end
```


### Tying everything together

The last step is to tell the skill the names of intents to listen
and the names of the slots to extract values from.
Both is defined in the file `config.jl`:

- The slot names are simply defined as global constants
  (they are global within the Module Skill).
- Intents and respective functions are stored in a Dictionary with
  the intent names as keys and the functions as values.

```Julia
const SLOT_NAME = "Command"

...

INTENT_ACTIONS = Dict{String, Function}()
INTENT_ACTIONS["AdoSnipsOnOffEN"] = powerOnOff
INTENT_ACTIONS["ControlAmazon"] = commands
```
