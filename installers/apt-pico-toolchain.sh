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
  sudo cp vscode.list /etc/apt/sources.list.d/
  sudo apt-get update
  sudo apt-get install -qqy --no-install-recommends \
    code
fi

mkdir --parents $TOOLCHAIN_PATH
pushd $TOOLCHAIN_PATH
echo ""
echo "Downloading installer script"
sleep 5
wget -q -nc https://raw.githubusercontent.com/raspberrypi/pico-setup/master/pico_setup.sh
chmod +x pico_setup.sh

echo ""
echo "Running installer script"
sleep 5
./pico_setup.sh > ./pico_setup.log || true
mv pico_setup.* pico/

echo ""
echo "Rebuilding the examples"
sleep 5
pushd pico/pico-examples
rm -fr build; mkdir build; cd build
cmake .. >> ../pico_setup.log
make --jobs=`nproc` >> ../pico_setup.log
echo ""
echo "Listing uf2 files"
sleep 5
find $PICO_PATH/pico-examples -name '*.uf2'
popd

popd

echo ""
echo "Updating PATH settings"
sleep 5
if [ -f "$HOME/.bashrc" ]
then
  grep -v -e "export PICO_" $HOME/.bashrc > bash_temp
  sed "s;TOOLCHAIN_PATH;$TOOLCHAIN_PATH;" export-skeleton >> bash_temp
  echo "Updating $HOME/.bashrc"
  cp bash_temp $HOME/.bashrc
fi

if [ -f "$HOME/.zshrc" ]
then
  grep -v -e "export PICO_" $HOME/.zshrc > zsh_temp
  sed "s;TOOLCHAIN_PATH;$TOOLCHAIN_PATH;" export-skeleton >> zsh_temp
  echo "Updating $HOME/.zshrc"
  cp zsh_temp $HOME/.zshrc
fi

echo "If you received the error message"
echo ""
echo "E: Unable to locate package code"
echo ""
echo "or"
echo ""
echo "E: Package 'code' has no installation candidate"
echo ""
echo "you will need to install Visual Studio Code"
echo "manually if you want to use it. If you are on"
echo "WSL and already installed Windows VSCode, you"
echo "can ignore the error!"
echo ""
echo "To use Visual Studio Code with the Windows"
echo "Subsystem for Linux, please install Visual"
echo "Studio Code in Windows and uninstall the Linux"
echo "version in WSL. You can then use the `code`"
echo "command in a WSL terminal just as you would"
echo "in a normal command prompt."
echo ""
echo "You will need to restart your shell to set these"
echo "environment variables before using the Raspberry"
echo "Pi Pico toolchain:"
echo ""
grep -e "^export PICO" bash_temp | sed 's/export //'
echo ""
echo "Finished!"
