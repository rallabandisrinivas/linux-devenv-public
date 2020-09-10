#!/bin/bash

gsettings set org.gnome.settings-daemon.plugins.color night-light-enabled true

sudo find /etc/apt/ -not -path '*/\.*' -type f -print0 | sudo xargs -0 sed -i 's/deb http:\/\/de.archive.ubuntu.com/deb [trusted=yes] https:\/\/mirror.one.com/g'

sudo apt -y install git
git config --global user.email "codingspiderfox@gmail.com"
git config --global user.name "CodingSpiderFox"
git remote set-url origin ssh://git@github.com/CodingSpiderFox/linux-devenv-public

# the proxy vars are read from /etc/environment by snapd
if [ -z "$http_proxy" ]; then
  echo "No proxy env vars set, not setting env vars for snapd"
else
  if ! grep -q "proxy" /etc/environment; then
    sudo tee -a /etc/environment > /dev/null <<EOF
http_proxy=$http_proxy
HTTP_proxy=$http_proxy
https_proxy=$http_proxy
HTTPS_proxy=$http_proxy
no_proxy=$no_proxy
NO_proxy=$no_proxy
EOF
  fi
fi

./install-software.sh

# this is needed because when snapd is installed on elementaryOS, the PATH entry to snap bin is missing (it's written by install-software.sh into ~/.profile"
source ~/.profile

read -p "Install CUDA? (y/n)" answer

if [ $answer == "y" ]; then

  #https://marmelab.com/blog/2018/03/21/using-nvidia-gpu-within-docker-container.html

  wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu1804/x86_64/cuda-repo-ubuntu1804_10.2.89-1_amd64.deb -O cuda-repo.deb
  sudo dpkg --install cuda-repo.deb
  rm cuda-repo.deb
  wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu1804/x86_64/cuda-samples-10-2_10.2.89-1_amd64.deb -O cuda-samples.deb
  sudo dpkg --install cuda-samples.deb
  sudo apt install --fix-broken
  rm cuda-samples.deb

  sudo apt-key adv --fetch-keys https://developer.download.nvidia.com/compute/cuda/repos/ubuntu1804/x86_64/7fa2af80.pub

  echo 'export PATH="/usr/local/cuda-10.2/bin:$PATH"' | sudo tee -a /etc/profile > /dev/null
  echo 'export LD_LIBRARY_PATH="/usr/local/cuda-10.2/lib64:$LD_LIBRARY_PATH"' | sudo tee -a /etc/profile > /dev/null

  source /etc/.profile

  sudo cp lib/udev/rules.d/40-vm-hotadd.rules /lib/udev/rules.d/
  sudo cp etc/systemd/system/nvidia-persistenced.service /etc/systemd/system/nvidia-persistenced.service

  sudo systemctl enable nvidia-persistenced

  # developer tools
  sudo apt install -y gnupg-curl cuda kdiff3 g++ autoconf automake libtool make openjdk-8-jdk graphviz chromium-browser vim maven graphviz remmina python-pip python3-pip jq cmake clang qtcreator g++ unattended-upgrades
  sudo dpkg-reconfigure unattended-upgrades
fi

export PATH=$PATH:/snap/bin

sudo snap install robo3t-snap postman

pip3 install --upgrade pip
pip3 install tensorflow
pip3 install --upgrade tensorflow

read -p "Install atom editor? (y/n)" answer

if [ $answer == "y" ]; then
  sudo snap install atom --classic
fi

read -p "Install maker software? (y/n)" answer

if [ $answer == "y" ]; then
  code --install-extension platformio.platformio-ide
  pip install -U platformio

  sudo usermod -a -G tty $(whoami)

  # install platformio cli to shells (bash+zsh)
  echo "export PATH=\$PATH:~/.platformio/penv/bin" >> ~/.profile
  echo "emulate sh -c '. ~/.profile'" >> ~/.zprofile

  source ~/.profile

  #Install platforms
  pio platform install espressif32@1.5.0
  pio platform install espressif8266@1.8.0

  #Adafruit Neopixel library
  pio lib --global install 28@1.1.7
  #Adafruit SSD1306
  pio lib --global install 135@1.2.9
  #Adafruit DHT11 / DHT22
  pio lib --global install 19@1.3.0
  #Adafruit_GFX
  pio lib --global install 13@1.3.5
  #Adafruit Unified Sensor
  pio lib --global install 31@1.0.2
  #MQTT Client
  pio lib --global install PubSubClient@2.7
  #ArduinoJSON
  pio lib --global install ArduinoJson@5.13.3

  sudo cp 99-platformio-udev.rules /etc/udev/rules.d/99-platformio-udev.rules

  sudo udevadm control --reload-rules
  sudo udevadm trigger

  sudo apt install -y kicad clang g++
fi

snap install kontena-lens --classic

read -p "Do you want to remove the default ubuntu folders \"Music\", etc. (y/n)?" answer

if [ $answer == "y" ]; then
  sudo rm -rf ~/Music ~/Videos ~/Public ~/Templates
fi

read -p "Install android studio? (y/n)" answer

if [ $answer == "y" ]; then
  sudo snap install android-studio --classic
  sudo adduser user kvm
fi

read -p "Install intellij? (y/n)" answer

if [ $answer == "y" ]; then
  read -p "(u)ltimate or (c)ommunity?" answer
  if [ $answer == "c" ]; then
    sudo snap install intellij-idea-community --classic
    sudo -H -u user /snap/intellij-idea-community/current/bin/idea.sh& sleep 7 && sudo killall java&
    # find config folder to add plugins
    export intellijDir=$(find   ~/ -name "*.IdeaC*" -type d)
  else
    sudo snap install intellij-idea-ultimate --classic
    sudo -H -u user /snap/intellij-idea-ultimate/current/bin/idea.sh& sleep 7 && sudo killall java&
    # find config folder to add plugins
    export intellijDir=$(find   ~/ -name "*.IntelliJIdea*" -type d)
  fi

  sudo /bin/su -c "echo 'fs.inotify.max_user_watches = 524288' >> /etc/sysctl.conf"
  sudo sysctl -p --system
fi

#sudo snap install --classic eclipse

read -p "Install jetbrains toolbox? (y/n)" answer

if [ $answer == "y" ]; then
  wget -O ./jetbrains-toolbox.tar.gz https://download.jetbrains.com/toolbox/jetbrains-toolbox-1.6.2914.tar.gz
  if mkdir /opt/jetbrains-toolbox; then
    tar -xzf ./jetbrains-toolbox.tar.gz -C /opt/jetbrains-toolbox --strip-components=1
    chmod -R +rwx /opt/jetbrains-toolbox
    ln /opt/jetbrains-toolbox/jetbrains-toolbox /usr/bin/jetbrains-toolbox
   jetbrains-toolbox >> /dev/null
  fi
fi

read -p "Install pycharm? y/n" answer

if [ $answer == "y" ]; then
  sudo snap install pycharm-community --classic
fi

read -p "Install webstorm? y/n" answer
if [ $answer == "y" ]; then
  sudo snap install webstorm --classic
fi

read -p "Install dotnetcore development environment? y/n" answer

if [ $answer == "y" ]; then
  sudo snap install rider --classic
  wget -q https://packages.microsoft.com/config/ubuntu/18.04/packages-microsoft-prod.deb
  sudo dpkg -i packages-microsoft-prod.deb
  sudo apt install -y apt-transport-https
  sudo apt update
  sudo apt install -y libcurl3 dotnet-runtime-2.0.9 dotnet-hosting-2.0.9 dotnet-sdk-2.2 libcurl4

  sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 3FA7E0328081BFF6A14DA29AA6A19B38D3D831EF
  echo "deb https://download.mono-project.com/repo/ubuntu stable-bionic main" | sudo tee /etc/apt/sources.list.d/mono-official-stable.list
  sudo apt update
  sudo apt install -y mono-devel mono-complete
  sudo apt install -y python3-pip
fi

./install-docker.sh

# JetBrains Dracula Theme
git clone https://github.com/dracula/jetbrains.git
mv jetbrains/Dracula.ics ~./Intellijdirectory/config/colors/
sudo rm packages-microsoft-prod.deb

curl -sL https://deb.nodesource.com/setup_12.x | sudo -E bash -
sudo apt-get install -y nodejs
sudo chown -R $(whoami):$(whoami) ~/
sudo chown -R $(whoami):$(whoami) /usr/lib/nodejs/
sudo chown -R $(whoami):$(whoami) /usr/lib/node_modules/
sudo npm install -g npq
sudo npm install -g @angular/cli
sudo npm install -g typescript
sudo npm install -g tslint
sudo npm install -g protractor
git clone https://github.com/teradata/covalent
cd covalent
npm ci
npm run serve&
cd ..

read -p "Install jhispter? y/n" answer

if [ $answer == "y" ]; then
  sudo npm install -g yo@latest
  sudo chown -R $(whoami):$(whoami) ~/
  sudo chown -R $(whoami):$(whoami) /usr/lib/nodejs/
  sudo chown -R $(whoami):$(whoami) /usr/lib/node_modules/
  sudo npm install -g generator-jhipster
  sudo chown -R $(whoami):$(whoami) ~/
  sudo chown -R $(whoami):$(whoami) /usr/lib/nodejs/
  sudo chown -R $(whoami):$(whoami) /usr/lib/node_modules/
  sudo npm install -g generator-jhipster-kotlin
  sudo chown -R $(whoami):$(whoami) ~/
  sudo chown -R $(whoami):$(whoami) /usr/lib/nodejs/
  sudo chown -R $(whoami):$(whoami) /usr/lib/node_modules/
fi

sudo apt autoremove -y

sudo apt install -y --install-recommends linux-generic-hwe-18.04 xserver-xorg-hwe-18.04
sudo apt install -y screenfetch

read -p "Install ohmyzsh? y/n" answer

if [ $answer == "y" ]; then
  ./install-ohmyzsh.sh
fi

read -p "Do some system hardening? y/n?" answer

if [ $answer == "y" ]; then
  ./harden-ubuntu-baseos.sh
fi
