##!/bin/bash

sudo snap install helm --classic
helm init
sleep 10
helm repo add bitnami https://charts.bitnami.com/bitnami
helm repo update
helm install stable/mysql
helm install bitnami/kafka
helm plugin install https://github.com/futuresimple/helm-secrets
