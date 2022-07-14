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
  echo ""
  echo "rp2040-forth-builder/installers/apt-pico-toolchain.sh"
  echo ""
  echo "to install the tools."
  echo ""
  echo "Exiting."
  exit
fi

echo "Creating fresh 'cmake-build' directory"
rm -fr cmake-build; mkdir cmake-build; cd cmake-build
echo "Running 'cmake'"
cmake .. > $HERE/cmake.log 2>&1
echo "Running 'make'"
make > $HERE/make.log 2>&1
