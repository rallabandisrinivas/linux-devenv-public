#!/bin/bash

proxyArgs=""
if [ -z "$http_proxy" ]; then
  echo "No using proxy for minikube because http_proxy env variable is not set"
else
  proxyArgs="--docker-env HTTP_PROXY=$http_proxy --docker-env HTTPS_PROXY=$http_proxy --docker-env NO_PROXY=$no_proxy"
fi

minikube start --vm-driver=kvm2 $proxyArgs
