#! /bin/bash

set -e

export PICO_PATH=$HOME/pico
export PICO_SDK_PATH=$PICO_PATH/pico-sdk
export PICO_EXAMPLES_PATH=$PICO_PATH/pico-examples
export PICO_EXTRAS=$PICO_PATH/pico-extras
export PICO_PLAYGROUND_PATH=$PICO_PATH/pico-playground
export PICO_PIMORONI_PATH=$PICO_PATH/pimoroni-pico

for i in $PICO_SDK_PATH $PICO_EXAMPLES_PATH $PICO_EXTRAS_PATH $PICO_PLAYGROUND_PATH $PICO_PIMORONI_PATH
do
  echo ""
  echo "Updating $i"
  pushd $i
  git pull --recurse-submodules
  popd
done
echo ""
echo "Finished"
