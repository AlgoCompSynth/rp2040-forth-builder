#! /bin/bash

set -e

echo "Downloading .deb package"
pushd /tmp
rm -fr vscode*
curl -Ls "https://code.visualstudio.com/sha/download?build=stable&os=linux-deb-x64" > vscode.deb
sudo apt-get install -qqy --no-install-recommends \
  ./vscode.deb
popd
