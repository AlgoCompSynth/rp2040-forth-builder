#! /bin/bash

set -e

export TOOLCHAIN_PATH=$HOME
export PICO_PATH=$TOOLCHAIN_PATH/pico
export PICO_SDK_PATH=$PICO_PATH/pico-sdk
export PICO_EXAMPLES_PATH=$PICO_PATH/pico-examples
export PICO_EXTRAS_PATH=$PICO_PATH/pico-extras
export PICO_PIMORONI_PATH=$PICO_PATH/pimoroni-pico

echo ""
echo "Building the Pimoroni examples"
sleep 5
for dir in $PICO_PIMORONI_PATH
do
  pushd $dir
  echo ""
  echo "Building $dir"
  sleep 5
  rm -fr build; mkdir build; cd build
  cmake .. -DPICO_SDK_POST_LIST_DIRS=$PICO_EXTRAS_PATH 2>&1 | tee cmake.log
  /usr/bin/time make -j8 2>&1 | tee make.log || true
  popd
done

echo ""
echo "Finished!"
