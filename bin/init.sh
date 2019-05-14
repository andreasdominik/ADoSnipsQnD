#!/bin/bash -xv
#
# Create a new Snips skill from the template!
#
# (c) A. Dominik, may 2019
#

# ask user for skill name:
#
echo "Give your new skill a name."
echo "The name must be"
echo " - one word"
echo " - unique (within all your skills)"
echo " - unique (within all your GitHub repos)"
read -p "Name of the new skill [myNewJuliaSkill]: " SKILLNAME
SKILLNAME="${SKILLNAME:-myNewJuliaSkill}"

echo ""
if [[ -z $SKILLNAME ]] ; then
  echo "ERROR: The skill name is required!"
  exit 1
elif [[ "$SKILLNAME" =~ ' ' ]] ; then
  echo "ERROR: The name must not contain whitespace!"
  exit 2
fi

read -p "Your GitHub username: " USERNAME

echo ""
if [[ -z $USERNAME ]] ; then
  echo "ERROR: The username is required!"
  exit 3
fi

echo "Specify the directory in which the new skill skeleton will be created."
read -p "directory [.]: " SKILLDIR
SKILLDIR=${SKILLDIR:-'.'}

if ! [[ -d "$SKILLDIR" ]] ; then
  echo "ERROR: The directory $SKILLDIR does not exist!"
  echo "Please create the base directory for your skills."
  exit 5
fi

if [[ -d $SKILLDIR/$SKILLNAME ]] ; then
  echo "ERROR: A directory with name $SKILLDIR/$SKILLNAME aleady exists!"
  echo "       Change name or directory or delete the existing directory."
  exit 6
fi

# clone the template skill into the target dir:
#
cd $SKILLDIR
git clone git@github.com:andreasdominik/ADoSnipsTemplate.git

# create the project on GitHub:
#
curl -u "$USERNAME" https://api.github.com/user/repos -d "{\"name\":\"$SKILLNAME\"}"

# change the remote for the new projekct:
#
git remote set-url origin git@github.com:${USERNAME}/${SKILLNAME}.git

# modify code:
#  - change name of module
#  - import new module
#  - rename loader function
#
sed "s/module ADoSnipsTemplate/module ${SKILLNAME}/" Skill/Skill.jl > Skill/${SKILLNAME}.jl
rm -f Skill/Skill.jl

sed "s+/Skill/ADoSnipsTemplate.jl+/Skill/${SKILLNAME}.jl+" |
    "s+import Main.ADoSnipsTemplate+import Main.${SKILLNAME}+" |
    "s+ADoSnipsTemplate.getIntentActions()+${SKILLNAME}.getIntentActions()+" > loader-${SKILLNAME}.jl
rm loader-ADoSnipsTemplate.jl

echo "You're done!"
echo "Change to $SKILLDIR/$SKILLNAME and add the action code to your skill!"
