# The SnipsHermesQnD framework

## Julia

This template skill is (like the entire SnipsHermesQnD framework) written in the
modern programming language Julia (because Julia is faster
then Python and coding is much easier and much more straight forward).
However "Pythonians" often need some time to get familiar with Julia.

If you are ready for the step forward, start here:
[https://julialang.org/](https://julialang.org/)

### Installation of Julia language

Installation of Julia is simple:
* just download the tar-ball for
  your architecture (most probably Raspberry-Pi/arm).
* save it in an appropriate folder (`/opt/Julia/` might be a good idea).
* unpack: `tar -xvzf julia-<version>.tar.gz`
* make sure, that the julia executable is executable. You find it
  as `/opt/Julia/julia-<version>/bin/julia`.
  If it is not executable run `chmod 755 /opt/Julia/julia-<version>/bin/julia`
* Add a symbolic link from a location which is in the search path, such as
  `/usr/local/bin`:

All together:

```sh
sudo chown $(whoami) /opt    
mkdir /opt/Julia    
mv ~/Downloads/julia-<version>.tar.gz .    
tar -xvzf julia-<version>.tar.gz    
chmod 755 /opt/Julia/julia-<version>/bin/julia    
cd /usr/local/bin    
sudo ln -s /opt/Julia/julia-<version>/bin/julia    
```

  **... and you are done!**

  For a very quick *get into,* see
  [learn Julia in Y minutes](http://learnxinyminutes.com/docs/julia/).

### IDEs

Softwarte development is made comfortable by
IDEs (Integrated Development Environements). For Julia, best choices
include:

* [Atom editor](http://atom.io/) with the
  [Juno package](http://junolab.org) installed (my favourite).
* [Visual Studio Code](https://code.visualstudio.com) also
  provides very good support for Julia.
* Playing around and learning is best done with
  [Jupyter notebooks](http://jupyter.org). The Jupyter stack can be installed
  easily from the Julia REPL by adding the Package `IJulia`.

### Noteworthy differences between Julia and Python

Julia code looks very much like Python code, except of
* there are no colons,
* whitespaces have no meaning; blocks end with an `end`,
* sometimes types should be given explicitly (for performance and
  explicit polymorphism).

However, Julia is a typed language with all advantages; and code is
run-time-compiled only once, with consequences:
* If a function is called for the first time, there is a time lack, because
  the compiler must finish his work before the actual code is executed.
* Future function calls will use the compiled machine code, making Julia
  code execute as fast as compiled c-code!

## Installation

### Installation of the framework

The framework is installed, by adding the app `ADoSnipsHermesQnD` to a
Snips assistant. This will install the library and general `SwitchOnOff` intent.

It is a good idea to install the template skill in addition. The skill is
fully functional and can be used to explore the framework.

MQTT communication is performed via `Eclipse modquitto`,
therefore this must be installed, too. On a Raspberry Pi the packages
`mosquitto` and `mosquitto-clients` are needed:

```sh
sudo apt-get install mosquitto
sudo apt-get install mosquitto-clients
```

### App ADoSnipsHermesQnD

To use skills, developed with SnipsHermesQnD, just add the ADoSnipsHermesQnD
App to your assistant. There are versions in German and English language
(`ADoSnipsHermesQnD_DE` and `ADoSnipsHermesQnD_EN`).

### Adapt timeouts

One major difference between the languages Python and Julia is that
Julia is compiled only once at runtime with a compiler that produces
highly optimised code.

As a result, Julia code runs as fast as other compiled code, such as c code.
The downside is the time necessary for compilation. Whereas Python scripts
just run away when started (because the compile cost is averaged over the
entire runtime), Julia functions need an extra time for compilation, when they
are started for the first time.

In consequence there is a time lack at the start of a Julia program; and
for the same reason additional time is necessary when a function
is executed for the first time.

Some things need to be considered to handle this in the Snips environement:
- When the Snips skill manager starts an assistant, the Julia apps
  will need up to 1 minute on a Rsapberry Pi until they are ready.
  When whatching the processes with `top` or `htop`, the Julia-processes
  are visible at the top with 100% CPU load. This is the compiler!
- The settings for `session_timeout` and `lambda_timeout` in the Snips
  configuration file `snips.toml` should be set to a high value
  (such as 1 minute) in order to keep a session alive until the app reacts
  the first time. This is only
  an issue when a function behind an intent is executed for the first time,
  any subsequent call will be very fast.


## Template skill

The template `ADosnipsTemplate` is already a fully functional skill. To test it,
just add the ADoSnipsTemplate-skill to your assistant in the Snips console and
update your assistant with sam (`sam update-assistant`).
The skill is available in English and German and shows how the
multi-language support of the framework works.

During installation with `sam` you will be asked to confirm the settings in
`config.ini`.
- Please set the language to the laguage you need (currently
  `en` and `de` are supported)
- Please give your assistant a name. The Skill will repeat the name, when
  activated in order to show the code necessary to access `config.ini`
  values.

The Template Skill includes the intent `pleaseRepeat` (as `pleaseRepeatDE` and
`pleaseRepeatEN`) which allows to say things like:
```Julia
"please repeat the word holydays"
"please say: movie"
...
```

or in German:
```Julia
"Bitte sprich mit nach: Auto"
"Bitte sage: Kaffeemaschine"
...
```

The app will repeat the word.



## SnipsHermesQnD details

### Strategy

The idea behind the framework is, to put as much as possible in the background
so that a developer only needs to provide the code for the
functions executed for an intent.

The MQTT-messages of *Hermes* and the *Dialogue Manager* are wrapped, and
additional interfaces to *Hermes* are provided to enable direct
dialogues without using callbacks.

In addion background information, such as current session-ID or
current site-ID, are handled in the background and not exposed to a skill
developer.

Additional utilities are provided to
- read values from intent slots,
- read values from `config.ini`,
- write apps for more then one language,
- get an answer form the NLU back as function value in the
  control flow of a function,
- use a global intent for switching a device on or off,
- let Snips ask a question and get "yes" or "no" back as boolean value,
- let Snips continue a conversation without the need to utter the,
  hotword again,
- execute actions of other skills by submitting system triggers.


### Common intent for on/off

The on/off-intent, integrated with the SnipsHermesQnD framework, allows for
writing apps to power up or down devices, without the need to create a new
intent for every device.

Background: All home assistants run into problems when many intents are
responsible to switch on or off a device. Obviously all these intends
are very similar and reliable detection of the correct intent is not easy.

SnipsHermesQnD tries to work around this issue, by using only one intent
for all on/off-commands.

All supported devices are listed in the slot `device` of the intent
`ADoSnipsOnOff<EN/DE>` and defined in the slot type `device_Type`.

The app `ADoSnipsHermesQnD` has some code behind to handle unrecognised
devises. The associated `config.ini` defines the list of devices handled
by skills in your assistant.
Any device that is not in this list, will be ignored; i.e. the framework will
end the respective ADoSnipsOnOff-session without any action immediately.

If you want to use the intent to swich an additional device on or off
- firstly look in the intent `ADoSnipsOnOff<EN/DE>` if the device
  is already defined in the slot type `device_Type`. If not,
  you will have to
  create a fork of the intent and add a new device to the values
  of the slot type `device_Type`.
- secondly the new device must be added to the list of devices in the
  `config.ini` of the framework (`ADoSnipsHermesQnD_<EN/DE>`). Add the
  name to the comma-separated list of devices in the parameter
  `on_off_devices`.

The framework comes with a function `isOnOffMatched(payload, DEVICE_NAME)`
which can be called with the current payload and the name (and
optionally with the siteId) of the device of interest.
It will return one of
- `:on`, if an "ON" is recognised for the device
- `:off`, if an "OFF" is recognised for the device
- `:matched`, if the device is recognised but no specific on or off
- `:unmatched`, if the device is not recognised.

The tutorial shows a simple example how to use this functionality.



### Ask and answer Yes-or-No

An often needed functionality is a quick confirmation feedback
of the user. This is provided by the framework function `askYesOrNo(question)`.

See the following self-exlpaining code as example:

```Julia
"""
    destroyAction(topic, payload)

Initialise self-destruction.
"""
function destroyAction(topic, payload)

  # log message:
  println("[ADoSnipsDestroyYourself]: action destroyAction() started.")

  if askYesOrNo("Do you really want to initiate self-destruction?")
    Snips.publishEndSession("Self-destruction sequence started!")
    boom()
  else
    Snips.publishEndSession("""OK.
                            Self-destruction sequence is aborted!
                            Live long and in peace.""")
  end

  return true
end
```

The intent to capture the user response comes with the framework and
is activated just for this dialogue.


### Continue conversation without hotword

Sometimes it is necessary to control a device with a sequence of several
comands. In this case it is not natural to speak the hotword everytime.
like:

> *hey Snips*
>
> *switch on the light*
>
> *hey Snips*
>
> *dim the light*
>
> *hey Snips*
>
> *dim the light again*
>
> *hey Snips*
>
> *dim the light again*    

Instead, we want something like:

> *hey Snips*
>
> *switch on the light*
>
> *dim the light*
>
> *dim the light again*
>
> *dim the light again*    


This can be achieved by starting a new session just after an intent is processed.
In the SnipsHermesQnD framework this is controlled by two mechanisms:

The `config.jl` defines a constant `const CONTINUE_WO_HOTWORD = true`.
`true` is the default and hence continuation without hotword is enabled
by default. To completely disable it for your skill, just set the constant
to `false`.    
The second mechanism is the return value of every single skill-action.
A new session will only be started if both are true, the
constant `CONTINUE_WO_HOTWORD` and the return value of the function.
This way it is possible to decide for each action individually, if
a hotword is required for the next command.


### Multi-language support

Multi-language skills need to be able to switch between laguages.
In the context of Snips this requires special handling in two cases:
- All text, uttered by the assistant must be defined in all languages.
- An intent is always tied to one language. Therefore for multi-language
  skills similar intents (with the same slots) must be created for each supported language.

Multi-language support ist added in 4 steps:

#### 1) Define language in config.ini:

The `config.ini` must have a line like:
```Julia
language=en
```

#### 2) Define the texts in all languages:
To let Snips speak different languages, all texts must be defined in
dictionaries for all target languages. These are defined in the file
`languages.jl`, as shown in the Template:

```Julia
TEXTS_DE = Dict(
:iam => "Ich bin dein Assistent",
:bravo => "Bravo, du hast erfolgreich das Template installiert!",
:noname => "Ich finde keinen Namen in der config Datei!",
:dunno => "Ich habe nicht verstanden was ich sagen soll!"
)

TEXTS_EN = Dict(
:iam => "I am your home assistant",
:bravo => "Bravo, you managed to install the template!",
:noname => "My name is not configured in the config file!",
:dunno => "I did not catch what you want me to say!"
)
```


#### 3) Create similar intents for all languages:

The most time-consuming step ist to create the intents in the
Snips console - however this is necessary, because speach-to-text as well as
natural language understanding highly depend on the language.


#### 4) Switch between languages:

The `config.jl` of the template app shows how switching languages is
possible within SnipsHermesQnD:

```Julia
const LANG = Snips.getIniLanguage() != nothing ? Snips.getIniLanguage() : "en"

...

if LANG == "de"
    Snips.registerIntentAction("myNewIntentDE", myNewSkillfun)
    Snips.registerIntentAction("myNextIntentDE", myNextSkillfun)
    TEXTS = TEXTS_DE
elseif LANG == "en"
    Snips.registerIntentAction("myNewIntentEN", myNewSkillfun)
    Snips.registerIntentAction("myNextIntentEN", myNextSkillfun)
    TEXTS = TEXTS_EN
else
    Snips.registerIntentAction("myNewIntentEN", myNewSkillfun)
    Snips.registerIntentAction("myNextIntentEN", myNextSkillfun)
    TEXTS = TEXTS_EN
end
```

The first line tries to read the language from `config.ini` and sets it
to the default if no definition is found.
The latter part selects the intents and texts to be used.



### Managing the Julia footprint

The language Julia has a much bigger footprint as Python, consuming
between 50-200 MB per Julia instance. In consequence it is not possible
to run many Julia skills as separate processes, like it is possible
with Python programs.

To work around this issue, all skills within this framework are
running in the same Julia progress. This reduces the footprint as well as the
compile times (because the libraries must be compiled only once).

It is still possible to add skills in the Snips console
like all other skills.
The only difference is, that the `action-...` executable of a skill
is replaced by a `loader-...` script, which is recognised by the
framework and loaded.
