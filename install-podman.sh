#!/bin/bash

sudo apt-get install -y \
  btrfs-tools \
  git \
  golang-go \
  go-md2man \
  iptables \
  libassuan-dev \
  libc6-dev \
  libdevmapper-dev \
  libglib2.0-dev \
  libgpgme-dev \
  libgpg-error-dev \
  libostree-dev \
  libprotobuf-dev \
  libprotobuf-c0-dev \
  libseccomp-dev \
  libselinux1-dev \
  libsystemd-dev \
  pkg-config \
  runc \
  uidmap

sudo apt-get update -qq
sudo apt-get install -qq -y software-properties-common uidmap
sudo add-apt-repository -y ppa:projectatomic/ppa
sudo apt-get update -qq
sudo apt-get -qq -y install podman
