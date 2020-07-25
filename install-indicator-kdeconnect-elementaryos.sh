#!/bin/bash

mkdir -p ~/.config/autostart

cp /etc/xdg/autostart/indicator-application.desktop ~/.config/autostart/

sed -i 's/^OnlyShowIn.*/OnlyShowIn=Unity;GNOME;Pantheon;/' ~/.config/autostart/indicator-application.desktop

git clone https://github.com/CodingSpiderFox/wingpanel-indicator-ayatana
cd wingpanel-indicator-ayatana
meson build --prefix=/usr
cd build
ninja
sudo ninja install
cd -
rm -rf wingpanel-indicator-ayatana