#!/bin/bash

read -p "Remove old snap vscode? (y/n)" answer

if [ $answer == "y" ]; then
 sudo snap remove vscode
fi

read -p "Install new snap code? (y/n)" answer

if [ $answer == "y" ]; then
  sudo  snap install code --classic

  export PATH=$PATH:/snap/bin/
  code --skip-getting-started

  proxyArgsForVsCodeExtensions=""
  if [ -z "$http_proxy" ]; then
    echo "Not using proxy because no env variable is set"
  else
    proxyArgsForVsCodeExtensions="--proxy-server=http=$http_proxy"
    proxyArgsForVsCodeExtensions="$proxyArgsForVsCodeExtensions --proxy-server=https=$http_proxy"
  fi

  echo "Proxy args for vscode extension installation: $proxyArgsForVsCodeExtensions"

  code --skip-getting-started --install-extension samuelcolvin.jinjahtml $proxyArgsForVsCodeExtensions --force --user-data-dir ~/.config/Code
  code --skip-getting-started --install-extension coolbear.systemd-unit-file $proxyArgsForVsCodeExtensions --force --user-data-dir ~/.config/Code
  code --skip-getting-started --install-extension aaron-bond.better-comments $proxyArgsForVsCodeExtensions --force --user-data-dir ~/.config/Code
  code --skip-getting-started --install-extension mathiasfrohlich.kotlin $proxyArgsForVsCodeExtensions --force --user-data-dir ~/.config/Code
  code --skip-getting-started --install-extension ms-python.python $proxyArgsForVsCodeExtensions --force --user-data-dir ~/.config/Code
  code --skip-getting-started --install-extension ms-vscode.powershell $proxyArgsForVsCodeExtensions --force --user-data-dir ~/.config/Code
  code --skip-getting-started --install-extension mrorz.language-gettext $proxyArgsForVsCodeExtensions --force --user-data-dir ~/.config/Code
  code --skip-getting-started --install-extension ms-vscode.go $proxyArgsForVsCodeExtensions --force --user-data-dir ~/.config/Code
  code --skip-getting-started --install-extension dotjoshjohnson.xml $proxyArgsForVsCodeExtensions --force --user-data-dir ~/.config/Code
  code --skip-getting-started --install-extension ms-azuretools.vscode-docker $proxyArgsForVsCodeExtensions --force --user-data-dir ~/.config/Code
  code --skip-getting-started --install-extension webfreak.debug $proxyArgsForVsCodeExtensions --force --user-data-dir ~/.config/Code/
  code --skip-getting-started --install-extension ms-vscode.cpptools $proxyArgsForVsCodeExtensions --force --user-data-dir ~/.config/Code/
  code --skip-getting-started --install-extension thiagoabreu.vala $proxyArgsForVsCodeExtensions --force --user-data-dir ~/.config/Code/
  code --skip-getting-started --install-extension vscjava.vscode-java-pack $proxyArgsForVsCodeExtensions --force --user-data-dir ~/.config/Code/
  code --skip-getting-started --install-extension esbenp.prettier-vscode $proxyArgsForVsCodeExtensions --force --user-data-dir ~/.config/Code/
  code --skip-getting-started --install-extension msjsdiag.debugger-for-chrome $proxyArgsForVsCodeExtensions --force --user-data-dir ~/.config/Code/
  code --skip-getting-started --install-extension dsznajder.es7-react-js-snippets $proxyArgsForVsCodeExtensions --force --user-data-dir ~/.config/Code/
  code --skip-getting-started --install-extension msjsdiag.vscode-react-native $proxyArgsForVsCodeExtensions --force --user-data-dir ~/.config/Code/
  code --skip-getting-started --install-extension eg2.tslint $proxyArgsForVsCodeExtensions --force --user-data-dir ~/.config/Code/
  code --skip-getting-started --install-extension pivotal.vscode-boot-dev-pack $proxyArgsForVsCodeExtensions --force --user-data-dir ~/.config/Code/
  code --skip-getting-started --install-extension zignd.html-css-class-completion $proxyArgsForVsCodeExtensions --force --user-data-dir ~/.config/Code/
  code --skip-getting-started --install-extension gencer.html-slim-scss-css-class-completion $proxyArgsForVsCodeExtensions --force --user-data-dir ~/.config/Code/
  code --skip-getting-started --install-extension abusaidm.html-snippets $proxyArgsForVsCodeExtensions --force --user-data-dir ~/.config/Code/
  code --skip-getting-started --install-extension cssho.vscode-svgviewer $proxyArgsForVsCodeExtensions --force --user-data-dir ~/.config/Code/
  code --skip-getting-started --install-extension jock.svg $proxyArgsForVsCodeExtensions --force --user-data-dir ~/.config/Code/
  code --skip-getting-started --install-extension rogalmic.bash-debug $proxyArgsForVsCodeExtensions --force --user-data-dir ~/.config/Code/
  code --skip-getting-started --install-extension peterjausovec.vscode-docker $proxyArgsForVsCodeExtensions --force --user-data-dir ~/.config/Code/
  code --skip-getting-started --install-extension eamodio.gitlens $proxyArgsForVsCodeExtensions --force --user-data-dir ~/.config/Code/
  code --skip-getting-started --install-extension technosophos.vscode-helm $proxyArgsForVsCodeExtensions --force --user-data-dir ~/.config/Code/
  code --skip-getting-started --install-extension rust-lang.rust $proxyArgsForVsCodeExtensions --force --user-data-dir ~/.config/Code/

  mkdir -p ~/.config/Code/User
  cp home/user/.config/Code/User/* ~/.config/Code/User/
  sudo chown -R $(whoami):$(whoami) ~/.config/Code
fi
