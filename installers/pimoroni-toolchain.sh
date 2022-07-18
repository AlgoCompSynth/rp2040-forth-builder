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

echo "Cloning Pimoroni repositories"
sleep 5
pushd $PICO_PATH
git clone -b main https://github.com/pimoroni/pimoroni-pico.git --recurse-submodules > pimoroni.log
git clone -b main https://github.com/pimoroni/picosystem.git >> pimoroni.log
echo ""
echo "Building the examples"
sleep 5
for dir in pimoroni-pico picosystem
do
  pushd $dir
  echo ""
  echo "Building $dir"
  sleep 5
  rm -fr build; mkdir build; cd build
  cmake .. >> pimoroni.log
  make --jobs=`nproc` >> pimoroni.log
  echo ""
  echo "Listing uf2 files"
  sleep 5
  find $PICO_PATH/$dir -name '*.uf2'
  popd
done

echo ""
echo "Finished!"
