export ZSH="/home/user/.oh-my-zsh"

mkdircd () {
  mkdir "$@"
  if [ "$1" = "-p" ]; then
      cd "$2"
  else
      cd "$1"
  fi
}

long_ls() {
  local VAR="Permissions(UGO)|Owner|Group|Size|Modified|Name"

  if [ ! "${1}" ]; then
    echo -e "$VAR" | column -t -s"|" && ls -l --color=auto
  else
    echo -e "$VAR" | column -t -s"|" && ls -l --color=auto "${1}"
  fi
}

plugins=(
  zsh-autosuggestions
  history-substring-search
  git
  git-flow
  docker
  docker-compose
  helm
  kubectl
  minikube
  mvn
  npm
  jhipster
  ng
  tmux
  rsync
  systemd
  ubuntu
  ansible
)
ZSH_THEME="agnoster"

source $ZSH/oh-my-zsh.sh

# Aliases
alias ug="sudo apt update; sudo apt upgrade -y; sudo apt autoremove -y&"
alias ggraph="glgaa"
alias ideau="if [ ! -f '/snap/bin/intellij-idea-ultimate' ]; then echo echo 'Installing IDEA Ultimate' snap install intellij-idea-ultimate --classic fi intellij-idea-ultimate"
alias gnucash="export LANG=de_DE.UTF-8 && export LANGUAGE=de_DE.UTF-8 && gnucash" #UTF-8 is needed on ubuntu based distro
alias backuphome="zip -r backup.zip \.* -x \*.wine\*"
alias gapac="git add -p && git commit"
alias gapacpush="git add -p && git commit && git push"
alias copy='xsel -ib'
alias paste='xsel --clipboard'
alias install="sudo apt install -y"
alias update="sudo apt update; sudo apt upgrade -y; sudo apt autoremove -y&"
alias upgrade="sudo apt update; sudo apt upgrade -y; sudo apt autoremove -y&"
alias nnao="code"
alias nnap="code"
alias nano="code"
alias nani="code"
alias idea="intellij-idea-community"
alias code.="code ."
alias ls="/bin/ls -alh --color=auto"
alias ll="ls -alh --color=auto"
alias lls="long_ls ${1}"
alias dd="sudo -k dd status=progress "
alias vmplayer="GTK_CSD=0 vmplayer&"
alias cmd="io.elementary.terminal&"
alias gti="git"
alias gpull="git pull"
alias gpu="git pull"
alias gpush="git push"
alias mspaint="pinta"
alias paint="pinta"
alias cd..="cd .."
alias ..="cd.."
alias mvnci="mvn clean install -DskipTests=true"
alias mvncit="mvn clean install"
alias npm="npq-hero"
builtin . /usr/share/io.elementary.terminal/enable-zsh-completion-notifications || builtin true
screenfetch
