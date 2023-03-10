#! /bin/bash

set -e

source set_pico_envars

echo ""
echo "Configuring OpenOCD"
pushd $PICO_OPENOCD_PATH
make clean || true
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
echo "Configuring picotool"
pushd $PICO_PICOTOOL_PATH
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

echo ""
echo "Finished"
