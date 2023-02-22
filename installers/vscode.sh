#! /bin/bash

set -e

if [ "$1" = "" ]
then
  echo ""
  echo "This script needs an argument to specify a path for"
  echo "installing the Raspberry Pi Pico tools."
  echo ""
  echo "Usage: ./pico-toolchain.sh /path/to/install/tools"
  echo ""
  echo "The path will be created if it does not exist yet."
  echo "The tools will be installed as *sub-directories* of"
  echo "/path/to/install/tools/pico."
  exit -1
fi

export TOOLCHAIN_PATH=$1
export PICO_PATH=$TOOLCHAIN_PATH/pico
if [ -d "$PICO_PATH" ]
then
  echo "Directory $PICO_PATH already exists."
  echo "You will need to remove it to re-install the"
  echo "toolchain."
  echo ""
  echo "Exiting."
  exit -2
fi

if grep -qEi "(Microsoft|WSL)" /proc/version &> /dev/null
then
  export VSCODE_LOC=`which code`
  if [ -x "$VSCODE_LOC" ]
  then
    echo "VSCode detected at $VSCODE_LOC - you can ignore"
    echo "VSCode-related error messages."
    sleep 5
  else
    echo "WSL detected - you will need to install *Windows*"
    echo "Visual Studio Code if you want to use VSCode."
    sleep 5
  fi
elif [ -f "/etc/apt/sources.list.d/raspi.list" ]
then
  echo "Raspberry Pi detected - VSCode will be installed" 
  echo "from Raspberry Pi repos."
  sleep 5
else
  echo "Installing Visual Studio Code from Microsoft"
  echo "repository now"
  sleep 5
  curl https://packages.microsoft.com/keys/microsoft.asc | \
    gpg --dearmor > microsoft.gpg
  sudo install -o root -g root -m 644 microsoft.gpg \
    /usr/share/keyrings/microsoft-archive-keyring.gpg
  sudo sh -c \
    'echo "deb [arch=amd64,arm64,armhf signed-by=/usr/share/keyrings/microsoft-archive-keyring.gpg] https://packages.microsoft.com/repos/vscode stable main" > /etc/apt/sources.list.d/vscode.list'

  sudo apt-get update
  sudo apt-get install -qqy --no-install-recommends \
    code
fi
