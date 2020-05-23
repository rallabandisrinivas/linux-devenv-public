#!/bin/bash

sudo apt install -y curl zsh

sh -c "$(curl -fsSL https://raw.githubusercontent.com/codingspiderfox/oh-my-zsh/master/tools/install.sh)"

git clone https://github.com/CodingSpiderFox/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git clone https://github.com/CodingSpiderFox/jhipster-oh-my-zsh-plugin ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/jhipster

cp home/user/.zshrc ~/.zshrc
sudo ln -s $HOME/.oh-my-zsh /root/.oh-my-zsh
sudo ln -s $HOME/.zshrc /root/.zshrc

exit