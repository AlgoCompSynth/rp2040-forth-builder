#! /bin/bash

set -e

for i in $PICO_EXAMPLES_PATH $PICO_EXTRAS_PATH $PICO_PLAYGROUND_PATH
do
  pushd $i
  rm -fr build; mkdir build
  cd build
  cmake .. 2>&1 | tee ../cmake-examples.log
  /usr/bin/time make 2>&1 | tee ../make-examples.log
  popd
done
