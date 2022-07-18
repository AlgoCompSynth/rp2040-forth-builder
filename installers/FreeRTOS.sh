#! /bin/bash

set -e

if [ ! -d $PICO_PATH ]
then
  echo ""
  echo "Pico tools directory not found - you probably need"
  echo "to run"
  echo ""
  echo "./apt-pico-toolchain.sh /path/to/install/tools"
  exit
fi

echo ""
echo "Cloning FreeRTOS-SMP-Demos repository"
sleep 5
pushd $PICO_PATH
git clone https://github.com/FreeRTOS/FreeRTOS-SMP-Demos.git --recurse-submodules >> FreeRTOS.log
echo ""
echo "Building the demos"
sleep 5
cd FreeRTOS-SMP-Demos/FreeRTOS/Demo/CORTEX_M0+_RP2040
mkdir build
cd build
cmake .. >> $PICO_PATH/FreeRTOS.log
make >> $PICO_PATH/FreeRTOS.log
echo ""
echo "Listing uf2 files"
sleep 5
find $PICO_PATH/FreeRTOS-SMP-Demos -name '*.uf2'

popd

echo ""
echo "Finished!"
