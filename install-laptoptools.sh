#!/bin/bash

sudo apt autoremove -y

gsettings set io.elementary.dpms standby-time 180

sudo apt -y install tlp tlp-rdw inotify-tools macchanger
macchanger -r wlp3s0
macchanger -r enp1s0f0

read -p "Install laptop-mode-tools (unstable)? (y/n)" answer

if [ $answer == "y" ]; then
  sudo add-apt-repository ppa:webupd8team/unstable -y
  sudo apt-get update
  sudo apt -y install laptop-mode-tools
  cd /usr/sbin
  sudo ./lmt-config-gui
  cd -
fi

read -p "Install screen brightness indicator? (y/n)" answer

if [ $answer == "y" ]; then
  sudo add-apt-repository ppa:indicator-brightness/ppa -y
  sudo apt-get update
  sudo apt-get -y install indicator-brightness
  #Or you can download the .deb package and double-click to install it from Launchpad.net
  #Once installed, open it from the app menu. Add these commands to your custom keyboard shortcuts to control brightness with your keyboard. You need Elementary Tweak to add a custom shortcut key.
  #/opt/extras.ubuntu.com/indicator-brightness/indicator-brightness-adjust --up
  #and:
  #/opt/extras.ubuntu.com/indicator-brightness/indicator-brightness-adjust --down
fi

sudo cp etc/systemd/system/mute_before_sleep.service /etc/systemd/system/mute_before_sleep.service
sudo cp var/suspend.sh /var/
sudo systemctl enable mute_before_sleep.service
