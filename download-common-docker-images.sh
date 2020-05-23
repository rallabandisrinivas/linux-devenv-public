#!/bin/bash

docker pull jenkins
docker pull ubuntu
docker pull postgres
docker pull postgres:9.6
docker pull postgres:11-alpine
docker pull redis:5-alpine
docker pull nginx:1.17-alpine
docker pull netboxcommunity/netbox
docker pull alpine
docker pull debian
docker pull redis
docker pull nginx
docker pull httpd
docker pull mysql
docker pull mariadb
docker pull mongo
docker pull mongo-express
docker pull memcached
docker pull sonarqube
docker pull elasticsearch:7.5.1
docker pull logstash:7.5.1
docker pull kibana:7.5.1
docker pull metricbeat:7.5.1
docker pull sonatype/nexus3
docker pull tomcat
docker pull jboss/wildfly
docker pull gitlab/gitlab-ce:latest
docker pull selenium/hub
docker pull selenium/node-firefox
docker pull selenium/node-chrome
docker pull portainer
docker pull traefik
docker pull replicated/dockerfilelint
docker pull atlassian/jira-software
docker pull atlassian/bitbucket-server
docker pull swaggerapi/swagger-editor
docker pull swaggerapi/swagger-ui

git clone -b release https://github.com/CodingSpiderFox/netbox-docker.git
cd netbox-docker
docker-compose pull
docker-compose up -d

# possibly interesting:
#docker pull jc21/nginx-proxy-manager:latest
#docker pull bitnami/dokuwiki
#docker pull bitnami/etcd
#docker pull opensuse/portus
#docker pull quay.io/coreos/clair
#docker pull library/registry
#curl https://raw.githubusercontent.com/CodingSpiderFox/gitkube/master/gimme.sh | bash
#docker pull lambci/lambda

#git clone https://github.com/CodingSpiderFox/openwhisk-devtools.git
#cd openwhisk-devtools/docker-compose
#make quick-start
