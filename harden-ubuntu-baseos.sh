##!/bin/bash

sudo ufw enable
sudo ufw default deny incoming
sudo ufw default deny outgoing
read -p "Enter a.b.c.d/e CIDR notation of your local network to allow port 80 outgoing to" answer
sudo ufw allow out to $answer proto tcp port 80

# if proxy file exists
if test -f "/etc/apt/apt.conf.d/01proxy"; then
  proxyFileContents=$(sudo cat /etc/apt/apt.conf.d/01proxy)
  sudo ufw $(python3.6 utilityscripts/extractor.py "$proxyFileContents")
fi

sudo ufw allow out 22 proto tcp
sudo ufw allow out 53
sudo ufw allow out 443 proto tcp

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
