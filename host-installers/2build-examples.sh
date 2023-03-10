#! /bin/bash

set -e

source set_pico_envars

echo ""
echo "Building the examples"
sleep 5
for dir in $PICO_EXAMPLES_PATH $PICO_PLAYGROUND_PATH $PICO_PIMORONI_PATH
do
  pushd $dir
  echo ""
  echo "Building $dir"
  sleep 5
  rm -fr build; mkdir build; cd build
  cmake .. -DCMAKE_BUILD_TYPE=Debug -DPICO_SDK_POST_LIST_DIRS=$PICO_EXTRAS_PATH 2>&1 | tee cmake.log
  /usr/bin/time make -j8 2>&1 | tee make.log || true
  popd
done

echo ""
echo "Finished!"
