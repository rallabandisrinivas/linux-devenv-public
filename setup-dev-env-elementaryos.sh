#!/bin/bash

./setup-dev-env-ubuntu.sh
sleep 3
sudo apt install -y meson valac geany nemiver com.github.mdh34.quickdocs
sleep 3
./install-dist-specific-elementaryos.sh
sudo apt-add-repository ppa:versable/elementary-update
sudo apt-get install linux-generic-hwe-18.04