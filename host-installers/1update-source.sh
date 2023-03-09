#! /bin/bash

set -e

source set_pico_envars

for i in \
  $PICO_SDK_PATH \
  $PICO_EXAMPLES_PATH \
  $PICO_EXTRAS_PATH \
  $PICO_PLAYGROUND_PATH \
  $PICO_PIMORONI_PATH \
  $PICO_OPENOCD_PATH \
  $PICO_PICOTOOL_PATH
do
  echo ""
  echo "Updating $i"
  pushd $i
  git pull --recurse-submodules
  popd
done
echo ""
echo "Finished"
