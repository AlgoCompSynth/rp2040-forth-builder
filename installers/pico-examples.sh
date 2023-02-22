#! /bin/bash

set -e

pushd $PICO_EXAMPLES_PATH
rm -fr build; mkdir build
cd build
cmake .. 2>&1 | tee ../cmake-examples.log
/usr/bin/time make 2>&1 | tee ../make-examples.log
popd
