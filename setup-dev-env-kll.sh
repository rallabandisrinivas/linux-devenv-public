#!/bin/bash

echo "deb https://ppa.launchpad.net/elementary-os/stable/ubuntu bionic main" | tee /etc/apt/sources.list
echo "deb-src https://ppa.launchpad.net/elementary-os/stable/ubuntu bionic main"  | tee /etc/apt/sources.list

apt update -y
apt install -y nmap io.elementary.terminal whois
./install-ohmyzsh.sh
update-alternatives --config x-terminal-emulator

echo "Please change your password"
echo ""

passwd
