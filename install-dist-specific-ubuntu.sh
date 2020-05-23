#!/bin/bash

read -p "Set key binding behaviour like windows 10? (y/n)" answer

if [ $answer == "y" ]; then
  gsettings set org.gnome.settings-daemon.plugins.media-keys home "'<Super>e'"
  gsettings set org.gnome.settings-daemon.plugins.media-keys terminal "'<Super>t'"
fi

#Dracula Theme Gnome Terminal
git clone https://github.com/CodingSpiderFox/gnome-terminal-colors-dracula
cd gnome-terminal-colors-dracula
./install.sh
cd -
sudo rm -rf gnome-terminal-colors-dracula/

sudo add-apt-repository ppa:ricotz/docky
sudo apt-get update
sudo apt-get install plank