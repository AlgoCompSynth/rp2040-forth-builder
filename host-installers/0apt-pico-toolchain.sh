#! /bin/bash

set -e

export TOOLCHAIN_PATH=$HOME
export SKIP_VSCODE=1
export SKIP_UART=1
export PICO_PATH=$TOOLCHAIN_PATH/pico
echo ""
echo "Removing existing Pico tools!"
rm -fr $PICO_PATH

echo ""
echo "Installing Linux build tools"
sudo apt-get update
sudo apt-get -qqy upgrade
sudo apt-get -qqy install \
  build-essential \
  ca-certificates \
  cmake \
  gcc-arm-none-eabi \
  libnewlib-arm-none-eabi \
  software-properties-common \
  time \
  tree

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
/usr/bin/time ./pico_setup.sh > ./pico_setup.log || true
mv pico_setup.* pico/

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

echo "Cloning Pimoroni Pico repository"
sleep 5
pushd $PICO_PATH
git clone -b main https://github.com/pimoroni/pimoroni-pico.git --recurse-submodules > $PICO_PATH/pimoroni.log
popd

echo ""
echo "Finished!"

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
