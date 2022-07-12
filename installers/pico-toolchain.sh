#! /bin/bash

set -e

if [ "$1" = "" ]
then
  echo ''
  echo 'This script needs an argument to specify a path for'
  echo 'installing the Raspberry Pi Pico tools.'
  echo ''
  echo 'Usage: ./pico-toolchain.sh "path/to/install/tools"'
  echo ''
  echo 'The path will be created if it does not exist yet.'
  echo 'The tools will be installed as sub-directories of'
  echo '"path/to/install/tools/pico".'
  exit
fi

export TOOLCHAIN_PATH=$1
mkdir --parents $TOOLCHAIN_PATH
pushd $TOOLCHAIN_PATH
echo 'Downloading installer script'
wget -q -nc https://raw.githubusercontent.com/raspberrypi/pico-setup/master/pico_setup.sh
chmod +x pico_setup.sh

if [ -d "pico" ]
then
  echo "Directory $TOOLCHAIN_PATH/pico already exists."
  echo "You will need to remove it to re-install the"
  echo "toolchain."
  echo ""
  echo "Exiting."
  exit
fi
echo 'Running installer script'
./pico_setup.sh
popd

echo ""
echo 'Updating PATH settings'
if [ -f "$HOME/.bashrc" ]
then
  grep -v -e "export PICO_" $HOME/.bashrc > bash_temp
  sed "s;TOOLCHAIN_PATH;$TOOLCHAIN_PATH;" export-skeleton >> bash_temp
  echo "Updating $HOME/.bashrc"
  diff bash_temp $HOME/.bashrc || true
  cp bash_temp $HOME/.bashrc
fi

if [ -f "$HOME/.zshrc" ]
then
  grep -v -e "export PICO_" $HOME/.zshrc > zsh_temp
  sed "s;TOOLCHAIN_PATH;$TOOLCHAIN_PATH;" export-skeleton >> zsh_temp
  echo "Updating $HOME/.zshrc"
  diff zsh_temp $HOME/.zshrc || true
  cp zsh_temp $HOME/.zshrc
fi

echo "If you received the error message"
echo ""
echo "E: Unable to locate package code"
echo ""
echo "you will need to install Visual Studio Code"
echo "if you want to use it."
echo ""
echo "You will need to restart your shell before"
echo "using the Raspberry Pi toolchain."
echo ""
echo 'Finished!'
