#!/bin/bash

./install-docker.sh

curl -O https://raw.githubusercontent.com/CodingSpiderFox/halyard/master/install/debian/InstallHalyard.sh

sudo bash InstallHalyard.sh

hal -v

. ~/.bashrc

read -p "Download common docker images? (y/n)" answer

if [ $answer == "y" ]; then
  sudo ./download-docker-images.sh
fi