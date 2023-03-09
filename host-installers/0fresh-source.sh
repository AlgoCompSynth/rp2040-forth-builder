#! /bin/bash

set -e

export TOOLCHAIN_PATH=$HOME
export PICO_PATH=$TOOLCHAIN_PATH/pico
export PICO_SDK_PATH=$PICO_PATH/pico-sdk
export PICO_EXAMPLES_PATH=$PICO_PATH/pico-examples
export PICO_EXTRAS_PATH=$PICO_PATH/pico-extras
export PICO_PIMORONI_PATH=$PICO_PATH/pimoroni-pico
echo ""
echo "Removing existing Pico tools!"
rm -fr $PICO_PATH; mkdir --parents $PICO_PATH

echo ""
echo "Installing Linux build tools"
sudo apt-get update
sudo apt-get -qqy upgrade
sudo apt-get -qqy install \
  build-essential \
  ca-certificates \
  cmake \
  gcc-arm-none-eabi \
  git \
  libnewlib-arm-none-eabi \
  libstdc++-arm-none-eabi-newlib \
  software-properties-common \
  time \
  tree

pushd $PICO_PATH
echo ""
echo "Downloading Pico SDK"
sleep 5
git clone -b master https://github.com/raspberrypi/pico-sdk.git --recurse-submodules
echo ""
echo "Downloading Pico examples"
sleep 5
git clone -b master https://github.com/raspberrypi/pico-examples.git --recurse-submodules
echo ""
echo "Downloading Pico extras"
sleep 5
git clone -b master https://github.com/raspberrypi/pico-extras.git --recurse-submodules
echo ""
echo "Downloading Pimoroni examples"
sleep 5
git clone -b main https://github.com/pimoroni/pimoroni-pico.git --recurse-submodules
echo ""
echo "Finished"
