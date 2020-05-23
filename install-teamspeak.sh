#!/bin/bash

cd ~/Downloads
wget https://files.teamspeak-services.com/releases/client/3.5.3/TeamSpeak3-Client-linux_amd64-3.5.3.run
chmod +x TeamSpeak3-Client-linux_amd64-3.5.3.run
./TeamSpeak3-Client-linux_amd64-3.5.3.run
rm TeamSpeak3-Client-linux_amd64-3.5.3.run
mkdir -p ~/Apps
mv TeamSpeak3-Client-linux_amd64 ~/Apps/
bash ~/Apps/TeamSpeak3-Client-linux_amd64/ts3client_runscript.sh
cd -

cat <<- EOF > ~/.local/share/applications/teamspeak3-client.desktop
[Desktop Entry]
Name=Teamspeak 3 Client
GenericName=Teamspeak
Comment=Speak with friends
Comment[de]=Spreche mit Freunden
Exec=~/Apps/TeamSpeak3-Client-linux_amd64/ts3client_runscript.sh
Terminal=false
X-MultipleArgs=false
Type=Application
Icon=audio-headsets
StartupWMClass=TeamSpeak 3
StartupNotify=true
EOF

cat <<- EOF > ~/.config/plank/dock1/launchers/ts3.dockitem
[PlankDockItemPreferences]
Launcher=file:///usr/share/applications/teamspeak3-client.desktop
EOF
