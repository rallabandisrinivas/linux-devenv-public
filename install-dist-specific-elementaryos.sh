#!/bin/bash

wget https://images.wallpaperscraft.com/image/glare_rainbow_circles_background_20329_1920x1080.jpg -O backgroundCustom.jpg
sudo cp backgroundCustom.jpg /usr/share/backgrounds/
echo "default-wallpaper=/usr/share/backgrounds/backgroundCustom.jpg" | sudo tee /etc/lightdm/pantheon-greeter.conf
rm backgroundCustom.jpg
gsettings set org.gnome.desktop.background picture-uri "file:///usr/share/backgrounds/backgroundCustom.jpg"

sudo apt install -y software-properties-common wmctrl

sudo apt-add-repository ppa:philip.scott/elementary-tweaks -y
sudo add-apt-repository ppa:go-for-it-team/go-for-it-stable -y
sudo apt update
sudo apt install -y glade elementary-tweaks gdebi elementary-sdk libchamplain-0.12-dev libchamplain-gtk-0.12-dev libclutter-1.0-dev libecal1.2-dev libedataserverui1.2-dev libfolks-dev libgee-0.8-dev libgeocode-glib-dev libgeoclue-2-dev libglib2.0-dev libgranite-dev libgtk-3-dev libical-dev meson valac libswitchboard-2.0-dev libnm-dev libnma-dev poedit gnome-builder devhelp com.github.danrabbit.lookbook go-for-it com.github.babluboy.nutty libvte-2.91-dev libgit2-glib-1.0-dev libcloudproviders-dev libnotify-dev libcanberra-dev libzeitgeist-2.0-de

read -p "Set key binding behaviour like windows 10? (y/n)" answer

if [ $answer == "y" ]; then
  gsettings set org.gnome.mutter overlay-key "'Super_L'"
  gsettings set org.pantheon.desktop.gala.behavior overlay-action "'wingpanel --toggle-indicator=app-launcher'"
  gsettings set org.gnome.desktop.wm.keybindings show-desktop "['<Super>d']"
  gsettings set org.gnome.settings-daemon.plugins.media-keys home "'<Super>e'"
  gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-right "['']"
  gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-left "['']"
  gsettings set org.gnome.desktop.wm.keybindings toggle-maximized "['<Super>Up']"
  gsettings set org.gnome.desktop.wm.keybindings unmaximize "['<Super>Down']"
  gsettings set org.gnome.mutter.keybindings toggle-tiled-left "['<Super>Left']"
  gsettings set org.gnome.mutter.keybindings toggle-tiled-right "['<Super>Right']"
  gsettings set org.gnome.desktop.wm.keybindings begin-move "['']"
fi

gsettings set io.elementary.desktop.wingpanel.datetime show-weeks true

# fix Alt+Tab+Shift issue (otherwise switching through desktop windows is delayed)
# also see https://elementaryos.stackexchange.com/questions/7742/switching-windows-backwards-alt-shift-tab-works-in-a-strange-way
gsettings set org.gnome.desktop.input-sources xkb-options "['grp:alt_caps_toggle']"

# Dark theme
gsettings set io.elementary.terminal.settings prefer-dark-style true

# Nightlight
gsettings set org.gnome.settings-daemon.plugins.color night-light-enabled true
gsettings set org.gnome.settings-daemon.plugins.color night-light-temperature 'uint32 3720'

# Power percent
gsettings set io.elementary.desktop.wingpanel.power show-percentage true

gsettings set io.elementary.files.preferences single-click false
gsettings set io.elementary.files.preferences date-format 'iso'
gsettings set io.elementary.files.preferences show-hiddenfiles true
gsettings set io.elementary.files.preferences default-viewmode list

# Set Elementary OS Files as default file browser
sudo xdg-mime default io.elementary.files.desktop inode/directory application/x-gnome-saved-search
sudo xdg-mime default io.elementary.files.desktop  $(grep MimeType /usr/share/applications/io.elementary.files.desktop | sed 's/MimeType=//' | sed 's/;/ /g')

# Revert by executing:
# sudo xdg-mime default org.gnome.Nautilus.desktop inode/directory application/x-gnome-saved-search
# sudo xdg-mime default org.gnome.Nautilus.desktop  $(grep MimeType /usr/share/applications/org.gnome.Nautilus.desktop | sed 's/MimeType=//' | sed 's/;/ /g')

sudo apt purge -y epiphany-browser epiphany-browser-data pantheon-mail audience io.elementary.code noise

gsettings set io.elementary.desktop.wingpanel.power show-percentage true
gsettings set org.gnome.settings-daemon.plugins.color night-light-enabled true
#gsettings set org.pantheon.desktop.gala.behavior hotcorner-topleft 'open-launcher'
#gsettings set org.pantheon.desktop.gala.behavior hotcorner-topright 'window-overview-all'
#gsettings set org.pantheon.desktop.gala.behavior hotcorner-bottomright 'show-workspace-view'
#gsettings set org.pantheon.desktop.gala.behavior hotcorner-bottomleft 'show-workspace-view'
gsettings set org.pantheon.desktop.gala.behavior overlay-action 'wingpanel --toggle-indicator=app-launcher'
#gsettings set io.elementary.code.settings font 'Ubuntu Mono 12'
#gsettings set io.elementary.code.settings auto-indent true
#gsettings set io.elementary.code.settings autosave false
#gsettings set io.elementary.code.settings draw-spaces 'Always'
#gsettings set io.elementary.code.settings highlight-matching-brackets false
#gsettings set io.elementary.code.settings indent-width 2
#gsettings set io.elementary.code.settings plugins-enabled "['outline', 'preserve-indent', 'strip-trailing-save', 'brackets-completion', 'detect-indent', 'highlight-word-selection', 'editorconfig']"
#gsettings set io.elementary.code.settings show-mini-map true
gsettings set org.gnome.desktop.interface monospace-font-name 'Ubuntu Mono 12'
gsettings set org.pantheon.desktop.gala.appearance button-layout close,minimize,maximize

dconf write /org/pantheon/desktop/gala/notifications/applications/gala-other/sounds false

cat <<- EOF > ~/.config/plank/dock1/launchers/firefox.dockitem
[PlankDockItemPreferences]
Launcher=file:///usr/share/applications/firefox.desktop
EOF

cat <<- EOF > ~/.config/plank/dock1/launchers/thunderbird.dockitem
[PlankDockItemPreferences]
Launcher=file:///usr/share/applications/thunderbird.desktop
EOF

#TODO spotify (only if installed)
#TODO steam (only if installed)
#TODO tdesktop (only if installed)

#usage: name, command, keys
python3 utilityscripts/create-custom-shortcut.py 'show desktop' 'wmctrl -k on' '<Super>d'
python3 utilityscripts/create-custom-shortcut.py 'show desktop' 'wmctrl -k off' '<Shift><Super>d'
python3 utilityscripts/create-custom-shortcut.py 'open system settings' 'io.elementary.switchboard' '<Super>i'
python3 utilityscripts/create-custom-shortcut.py 'screenshot of selection' 'shutter --select' '<Shift><Super>s'

rm ~/.config/plank/dock1/launchers/io.elementary.photos.dockitem
cp home/user/.config/plank/dock1/launchers/* ~/.config/plank/dock1/launchers/

### Install autoplank

sudo apt install -y golang-go xdotool
git clone https://github.com/codingspiderfox/autoplank
cd autoplank
make
sudo cp autoplank /usr/bin/
mkdir -p $HOME/.config/systemd/user/
cp autoplank.service $HOME/.config/systemd/user/autoplank.service
systemctl enable autoplank --user
systemctl start autoplank --user

cd -

flatpak install --from https://flathub.org/repo/appstream/org.gnome.Builder.flatpakref

#Remove unneeded languagepacks
sudo apt --purge autoremove wbulgarian wbrazilian wfrench witalian wspanish wportuguese wdanish wdutch wpolish wukrainian wnorwegian wcatalan wswedish wamerican wbritish wswiss

sudo cp etc/default/grub /etc/default/grub
sudo cp etc/rc.local /etc/

sudo cp cp etc/xdg/autostart/indicator-application.desktop /etc/xdg/autostart/
wget https://ppa.launchpad.net/elementary-os/stable/ubuntu/pool/main/w/wingpanel-indicator-ayatana/wingpanel-indicator-ayatana_2.0.3+r27+pkg17\~ubuntu0.4.1.1_amd64.deb --no-check-certificate
sudo dpkg -i wingpanel-indicator-ayatana_2.0.3+r27+pkg17~ubuntu0.4.1.1_amd64.deb
# remove all deb package files downloaded
rm *.deb*

sudo chown -R $(whoami):$(whoami) ~/

cat etc/profile_elementary | sudo tee -a /etc/profile

# dont display password stars
sudo mv /etc/sudoers.d/pwfeedback /etc/sudoers.d/pwfeedback.disabled

git clone https://github.com/CodingSpiderFox/files
cd files
git checkout feature/bluediskusagebars
git remote add upstream https://github.com/elementary/files
git pull upstream master
meson build --prefix=/usr && cd build && ninja && sudo ninja install
cd -

io.elementary.files ftp://devenv@datensenke/devenv
