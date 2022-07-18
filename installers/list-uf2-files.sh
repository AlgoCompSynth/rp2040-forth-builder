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

find $PICO_PATH -name '*.uf2'

echo ""
echo "Finished!"
