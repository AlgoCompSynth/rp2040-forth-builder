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

echo 'Cloning Pimoroni repositories'
pushd $PICO_PATH
git clone -b main https://github.com/pimoroni/pimoroni-pico.git --recursive > pimoroni.log
git clone -b main https://github.com/pimoroni/picosystem.git >> pimoroni.log
echo "Building the examples"
for dir in pimoroni-pico picosystem
do
  pushd $dir
  echo "Building $dir"
  rm -fr build; mkdir build; cd build
  cmake .. >> pimoroni.log
  make --jobs=`nproc` >> pimoroni.log
  popd
done

echo ""
echo "Finished!"
