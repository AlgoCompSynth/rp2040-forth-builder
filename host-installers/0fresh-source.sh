#! /bin/bash

set -e

export PICO_PATH=$HOME/pico
export PICO_SDK_PATH=$PICO_PATH/pico-sdk
export PICO_EXAMPLES_PATH=$PICO_PATH/pico-examples
export PICO_EXTRAS_PATH=$PICO_PATH/pico-extras
export PICO_PLAYGROUND_PATH=$PICO_PATH/pico-playground
export PICO_PIMORONI_PATH=$PICO_PATH/pimoroni-pico
echo ""
echo "Removing existing Pico tools!"
rm -fr $PICO_PATH; mkdir --parents $PICO_PATH

echo ""
echo "Installing Linux build tools"
sudo apt-get update
sudo apt-get -qqy upgrade
sudo apt-get -qqy install \
  autoconf \
  automake \
  build-essential \
  ca-certificates \
  cmake \
  gcc-arm-none-eabi \
  git \
  libftdi-dev \
  libnewlib-arm-none-eabi \
  libstdc++-arm-none-eabi-newlib \
  libtool \
  libusb-1.0-0-dev \
  software-properties-common \
  texinfo \
  time \
  tree

pushd $PICO_PATH

echo ""
echo "Downloading Pico SDK"
sleep 5
git clone https://github.com/raspberrypi/pico-sdk.git --recurse-submodules

echo ""
echo "Downloading Pico examples"
sleep 5
git clone https://github.com/raspberrypi/pico-examples.git --recurse-submodules

echo ""
echo "Downloading Pico extras"
sleep 5
git clone https://github.com/raspberrypi/pico-extras.git --recurse-submodules

echo ""
echo "Downloading Pico playground"
sleep 5
git clone https://github.com/raspberrypi/pico-playground.git --recurse-submodules

echo ""
echo "Downloading Pimoroni examples"
sleep 5
git clone -b main https://github.com/pimoroni/pimoroni-pico.git --recurse-submodules

echo ""
echo "Downloading OpenOCD"
sleep 5
git clone https://github.com/raspberrypi/openocd.git --branch rp2040 --recursive --depth=1
echo ""
echo "Configuring OpenOCD"
pushd openocd
./bootstrap
./configure --enable-ftdi --enable-sysfsgpio --enable-bcm2835gpio
echo ""
echo "Compiling OpenOCD"
make -j8
echo ""
echo "Installing OpenOCD"
sudo make install
popd
openocd --help || true

echo ""
echo "Downloading picotool"
sleep 5
git clone https://github.com/raspberrypi/picotool.git --branch master
echo ""
echo "Configuring picotool"
pushd picotool
rm -fr build; mkdir build; cd build
cmake ..
echo ""
echo "Compiling picotool"
make -j8
echo ""
echo "Installing picotool"
sudo cp picotool /usr/local/bin
popd
picotool help || true

popd

echo ""
echo "Finished"
