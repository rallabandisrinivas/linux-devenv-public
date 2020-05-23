##!/bin/bash

sudo ufw enable
sudo ufw default deny incoming
sudo ufw default deny outgoing
sudo ufw allow out 22
sudo ufw allow out 53
sudo ufw allow out 443

sudo apt install unattended-upgrades nmap
sudo apt-get update && sudo apt-get upgrade -y
sudo systemctl stop cups.service
sudo systemctl disable cups.service
sudo systemctl stop cups-browsed.service
sudo systemctl disable cups-browsed.service
sudo systemctl stop postfix
sudo systemctl disable postfix
echo "export TMOUT=300" >> ~/.profile

echo "Installing audit tool called lynis"

git clone https://github.com/CodingSpiderFox/lynis ~/lynis
cd ~/lynis
sudo chown -R 0:0 ./

read -p "Do you want to run lynis now? y/n" answer

if [ $answer == "y" ]; then
  cd ~/lynis
  sudo ./lynis audit system
fi

cd -
