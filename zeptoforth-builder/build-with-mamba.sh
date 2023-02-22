#! /bin/bash

set -e

echo "Upgrading Linux"
sudo apt-get update && \
  sudo apt-get -qqy upgrade

echo ""
echo "Installing build dependencies"
sudo apt-get install -qqy --no-install-recommends \
  binutils-arm-none-eabi \
  build-essential \
  ca-certificates \
  gcc-arm-none-eabi
echo ""
echo "Enabling conda and mamba"
. "$HOME/mambaforge/etc/profile.d/conda.sh"
. "$HOME/mambaforge/etc/profile.d/mamba.sh"
echo "Creating fresh zeptoforth build environment"
mamba create --force --yes --name zeptoforth-build "python>=3.10" myst-parser
echo "Activating zeptoforth-build"
mamba activate zeptoforth-build

pushd $HOME/Projects
if [ -d zeptoforth ]
then
  echo "\nexisting zeptoforth repo will be used"
else
  echo "\nCloning zeptoforth"
  git clone git@github.com:AlgoCompSynth/zeptoforth.git
fi
cd zeptoforth

echo ""
echo "Building fresh releases"
make clean
make

echo ""
echo "Making HTML documentation"
make html
echo ""
echo "Making EPUB documentation"
mkdir --parents epub
make epub

echo ""
echo "git status"
git status

popd

echo ""
echo "Done!"
