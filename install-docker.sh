#!/bin/bash

sudo apt-get update
sudo apt-get install -y apt-transport-https ca-certificates curl software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo apt-key fingerprint 0EBFCD88

read -p "Is this fingerprint for the docker apt key correct? y/n" answer
if [ $answer == "y" ]; then
  sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu bionic stable" -y
  sudo apt-get update
  sudo apt-get install -y docker-ce=18.06.1~ce~3-0~ubuntu

  sudo usermod -a -G docker $(whoami)

  sudo tee -a /etc/docker/daemon.json > /dev/null <<EOF
{
  "log-driver": "json-file",
  "log-opts": {
    "max-size": "1m",
    "max-file": "3"
  }
}
EOF

  if [ -z "$http_proxy" ]; then
    echo "Not using proxy for docker daemon because no env variable is set"
  else
    sudo mkdir -p /etc/systemd/system/docker.service.d
    if ! grep -q "PROXY" /etc/systemd/system/docker.service.d/http-proxy.conf; then
      sudo tee -a /etc/systemd/system/docker.service.d/http-proxy.conf > /dev/null <<EOF
[Service]
Environment=HTTP_PROXY=$http_proxy
Environment=HTTPS_PROXY=$http_proxy
Environment=NO_PROXY=$no_proxy
EOF
    fi

    sudo systemctl daemon-reload
    sudo systemctl enable docker
    sudo systemctl start docker
  fi

  git clone https://github.com/CodingSpiderFox/raspi-utils
  sudo cp raspi-utils/etc/docker/* /etc/docker/

  read -p "Install minikube? (y/n)" answer

  if [ $answer == "y" ]; then
    sudo apt-get update && sudo apt-get install -y apt-transport-https
    curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
    echo "deb https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee -a /etc/apt/sources.list.d/kubernetes.list
    sudo apt-get update
    sudo apt-get install -y kubectl

    echo "Kubectl installed"
    echo "Running kubectl version"
    kubectl version

    # install minikube without VM support

    curl -Lo minikube https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64 && chmod +x minikube && sudo cp minikube /usr/local/bin/ && rm minikube

    export MINIKUBE_WANTUPDATENOTIFICATION=false
    export MINIKUBE_WANTREPORTERRORPROMPT=false
    export MINIKUBE_HOME=$HOME
    export CHANGE_MINIKUBE_NONE_USER=true
    mkdir -p $HOME/.kube
    mkdir -p $HOME/.minikube
    touch $HOME/.kube/config

    export KUBECONFIG=$HOME/.kube/config
    sudo minikube start --vm-driver=none

    # this for loop waits until kubectl can access the api server that Minikube has created
    for i in {1..150}; do # timeout for 5 minutes
      kubectl get po &> /dev/null
      if [ $? -ne 1 ]; then
        break
      fi
      sleep 2
    done

    ./install-helm.sh
  fi
fi

pip3 install docker-compose

read -p "Install CUDA docker support?" answer

if [ $answer == "y" ]; then
  curl -s -L https://nvidia.github.io/nvidia-docker/gpgkey | sudo apt-key add -
  curl -s -L https://nvidia.github.io/nvidia-docker/ubuntu18.04/amd64/nvidia-docker.list | \
    sudo tee /etc/apt/sources.list.d/nvidia-docker.list

  sudo apt-get update

  #Before installing nvidia-docker2 utility, I need to ensure that I use docker-ce, the latest official Docker release. Based on official documentation, here is the process to follow:
  # see https://marmelab.com/blog/2018/03/21/using-nvidia-gpu-within-docker-container.html

  # remove all previous Docker versions
  sudo apt-get remove docker docker-engine docker.io

  # add Docker official GPG key
  curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

  # Add Docker repository (for Ubuntu Bionic)
  sudo add-apt-repository \
      "deb [arch=amd64] https://download.docker.com/linux/ubuntu bionic stable"

  sudo apt-get update
  sudo apt install docker-ce

  wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu1804/x86_64/cuda-drivers_440.64.00-1_amd64.deb -O cuda-drivers.deb
  sudo dpkg -i cuda-drivers.deb
  sudo apt install --fix-broken
  rm cuda-drivers.deb

  # Install nvidia-docker2 and reload the Docker daemon configuration
  # see https://github.com/NVIDIA/nvidia-docker
  curl -s -L https://nvidia.github.io/nvidia-docker/gpgkey | sudo apt-key add -
  curl -s -L https://nvidia.github.io/nvidia-docker/ubuntu18.04/nvidia-docker.list | sudo tee /etc/apt/sources.list.d/nvidia-docker.list
  sudo apt-get update & sudo apt-get install -y nvidia-container-toolkit
  sudo systemctl restart docker

  # test
  docker run --gpus 2 nvidia/cuda:10.0-base nvidia-smi
fi

read -p "Download common docker images? (y/n) " answer

if [ $answer == "y" ]; then
  sudo ./download-common-docker-images.sh&
fi
