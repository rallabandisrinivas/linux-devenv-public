#!/bin/bash

gsettings set org.gnome.settings-daemon.plugins.color night-light-enabled true

sudo find /etc/apt/ -not -path '*/\.*' -type f -print0 | sudo xargs -0 sed -i 's/deb http:\/\/de.archive.ubuntu.com/deb [trusted=yes] https:\/\/mirror.one.com/g'

sudo apt -y install git
git config --global user.email "codingspiderfox@gmail.com"
git config --global user.name "CodingSpiderFox"
git remote set-url origin ssh://git@github.com/CodingSpiderFox/linux-devenv

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
  sudo rm -rf ~/Music ~/Videos ~/Public
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

  export intellijDir="${intellijDir}/config/plugins/"
  export startDir=$(pwd)
  mkdir ijplugins/
  cd ijplugins
  wget "https://plugins.jetbrains.com/files/12206/69769/codestream-jb-4.0.1+18.zip?updateId=69769&pluginId=12206&family=INTELLIJ" -O "CodeStream.zip"
  wget "https://plugins.jetbrains.com/files/7179/63619/MavenRunHelper.zip?updateId=63619&pluginId=7179&family=INTELLIJ" -O "MavenHelper.zip"
  wget "https://plugins.jetbrains.com/files/8015/66212/bitbucket-linky.zip?updateId=66212&pluginId=8015&family=INTELLIJ" -O "BitbucketLinky.zip"
  wget "https://plugins.jetbrains.com/files/6317/67665/lombok-plugin-0.26.2-2019.2.zip?updateId=67665&pluginId=6317&family=INTELLIJ" -O "Lombok.zip"
  wget "https://plugins.jetbrains.com/files/1065/66249/checkstyle-idea-5.31.0.zip?updateId=66249&pluginId=1065&family=INTELLIJ" -O "Checkstyle-idea.zip"
  wget "https://plugins.jetbrains.com/files/10080/66362/repo-5.21.zip?updateId=66362&pluginId=10080&family=INTELLIJ" -O "Rainbowbrackets.zip"
  wget "https://plugins.jetbrains.com/files/7638/68066/codota-3.0.4.zip?updateId=68066&pluginId=7638&family=INTELLIJ" -O "Codota.zip"
  wget "https://plugins.jetbrains.com/files/7724/68006/Docker.zip?updateId=68006&pluginId=7724&family=INTELLIJ" -O "Docker.zip"
  wget "https://plugins.jetbrains.com/files/1800/68136/DBN-18.0.zip?updateId=68136&pluginId=1800&family=INTELLIJ" -O "Databasenavigator.zip"
  wget "https://plugins.jetbrains.com/files/7495/66736/idea-gitignore-3.2.1.192.zip?updateId=66736&pluginId=7495&family=INTELLIJ" -O "Gitignoreaddon.zip"
  wget "https://plugins.jetbrains.com/files/7973/66755/SonarLint-4.1.0.3312.zip?updateId=66755&pluginId=7973&family=INTELLIJ" -O "SonarLint.zip"
  wget "https://plugins.jetbrains.com/files/4509/63731/Statistic-3.5.jar?updateId=63731&pluginId=4509&family=INTELLIJ" -O "Statistic.zip"
  wget "https://plugins.jetbrains.com/files/9792/67862/IntelliJ-Key-Promoter-X-2019.2.3.zip?updateId=67862&pluginId=9792&family=INTELLIJ" -O "KeyPromoterX.zip"
  wget "https://plugins.jetbrains.com/files/8527/65404/gjf.zip?updateId=65404&pluginId=8527&family=INTELLIJ" -O "google-java-format.zip"
  wget "https://plugins.jetbrains.com/files/10229/44968/intellij-spring-assistant-0.12.0.zip?updateId=44968&pluginId=10229&family=INTELLIJ" -O "springAssistant.zip"
  wget "https://plugins.jetbrains.com/plugin/download?rel=true&updateId=52308" -O "run_configuration_as_action.zip"
  wget "https://plugins.jetbrains.com/files/3146/45792/infinitest-intellij-5.2.0-dist.zip?updateId=45792&pluginId=3146&family=INTELLIJ" -O "Infinitest.zip"
  wget "https://plugins.jetbrains.com/files/1137/78319/PMD-Intellij.zip?updateId=78319&pluginId=1137&family=INTELLIJ" -O PMDPlugin.zip
  wget "https://plugins.jetbrains.com/plugin/download?rel=true&updateId=60412" -O QAPlug.zip
  wget "https://plugins.jetbrains.com/files/9960/72483/JsonToKotlinClass-3.5.1.zip?updateId=72483&pluginId=9960&family=INTELLIJ" -O JSONToKotlinClass.zip
  wget "https://plugins.jetbrains.com/files/11585/58981/kotlintest-intellij-plugin-3.3.0.11.zip?updateId=58981&pluginId=11585&family=INTELLIJ" -O kotlintest.zip
  wget "https://plugins.jetbrains.com/files/7642/77136/intellij-plugin-save-actions-2.0.0.jar?updateId=77136&pluginId=7642&family=INTELLIJ" -O saveactions.zip
  wget "https://plugins.jetbrains.com/files/7792/35585/intellij-ansible-0.9.5.zip?updateId=35585&pluginId=7792&family=INTELLIJ" -O ansible.zip
  wget "https://plugins.jetbrains.com/files/10485/82843/Kubernetes.zip?updateId=82843&pluginId=10485&family=INTELLIJ" -O Kubernetes.zip
  mkdir -p $intellijDir
  cp *.zip $intellijDir
  cd $intellijDir
  unzip \*.zip
  cd $startDir
  mv ijplugins ~/Downloads/

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
npm install -g npq

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

if [ $answer == "yes" ]; then
  ./harden-ubuntu-baseos.sh
fi

read -p "Reboot now? y/n" answer

if [ $answer == "y" ]; then
  sudo reboot
fi
