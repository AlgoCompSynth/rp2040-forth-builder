#! /bin/bash

set -e

export TOOLCHAIN_PATH=$HOME
export SKIP_VSCODE=1
export SKIP_UART=1
export PICO_PATH=$TOOLCHAIN_PATH/pico
export PICO_SDK_PATH=$PICO_PATH/pico-sdk
export PICO_EXAMPLES_PATH=$PICO_PATH/pico-examples
export PICO_PIMORONI_PATH=$PICO_PATH/pimoroni-pico

for i in $PICO_SDK_PATH $PICO_EXAMPLES_PATH $PICO_PIMORONI_PATH
do
  echo ""
  echo "Updating $i"
  pushd $i
  git pull --recurse-submodules
  popd
done
echo ""
echo "Finished"
