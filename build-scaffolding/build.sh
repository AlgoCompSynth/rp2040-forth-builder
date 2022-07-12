#! /bin/bash

set -e

echo "Checking for $PICO_SDK_PATH/external/pico_sdk_import.cmake"
if [ -f "$PICO_SDK_PATH/external/pico_sdk_import.cmake" ]
then
  cp "$PICO_SDK_PATH/external/pico_sdk_import.cmake" .
else
  echo ""
  echo "Cannot find "$PICO_SDK_PATH/external/pico_sdk_import.cmake""
  echo "Building requires this file. You probably need to run"
  echo "./pico-toolchain.sh" to install the tools."this"pico_sdk_import.cmake""
  echo ""
  echo "Exiting."
  exit
fi

echo "Creating fresh 'cmake-build' directory"
rm -fr cmake-build; mkdir cmake-build
cd cmake-build
echo "Configuring"
cmake ..
echo "Cross-compiling and linking"
make
cd ..

echo ""
echo "Listing .uf2 files"
find . -name '*.uf2'
