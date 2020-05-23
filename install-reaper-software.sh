#!/bin/bash

sudo apt -y install pyqt5-dev pyqt5-dev-tools python-pyqt5 qtbase5-dev qdbus-qt5 python3-dbus.mainloop.pyqt5 python3.7 python-qt5-dev python3-pyqt5 pyqt5-dev-tools python-qt4-dev python3-pyqt4 pyqt4-dev-tools libjack-dev libqt4-dev qt4-dev-tools jackd qjackctl

pip3 install pyqt5 --user

git clone https://github.com/CodingSpiderFox/Cadence
cd Cadence
make
sudo make install
python3.6 src/cadence.py

sudo dpkg --add-architecture i386
wget -nc https://dl.winehq.org/wine-builds/winehq.key
sudo apt-key add winehq.key
sudo apt-add-repository 'deb https://dl.winehq.org/wine-builds/ubuntu/ bionic main'
sudo rm winehq.key
sudo apt-get update
#sudo apt-get install --install-recommends winehq-staging
sudo apt-get install --install-recommends winehq-stable cabextract

wget https://github.com/falkTX/Carla/releases/download/v2.0.0/Carla_2.0.0-linux64.tar.xz -O Carla.tar.xz
unxz Carla.tar.xz
rm Carla.tar.xz
tar -xvf Carla.tar
rm Carla.tar
cd Carla_2.0.0-linux64/
