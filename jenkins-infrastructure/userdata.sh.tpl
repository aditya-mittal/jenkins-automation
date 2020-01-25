#!/bin/bash

#install python3 & pip
apt-get update
apt-get install -y python3-pip

#remove installed docker
apt-get remove docker docker-engine docker.io containerd runc

#install docker
apt-get install -y apt-transport-https ca-certificates curl gnupg-agent software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"
apt-get update
apt-get install -y docker-ce
usermod -aG docker ubuntu

su - ubuntu
export LANGUAGE=en_US.UTF-8
export LC_CTYPE=en_US.UTF-8
export LC_ALL=en_US.UTF-8

#install awscli
pip3 install awscli --upgrade --user
export PATH=~/.local/bin:$PATH

#login to ecr
$(aws ecr get-login --no-include-email --region ${aws_region})

#run jenkins docker container
docker run -d -p 8080:8080 \
    -e JENKINS_PASSWORD=${admin_password} \
    -e JENKINS_READ_ONLY_PASSWORD=${readonly_password} \
    -v /var/run/docker.sock:/var/run/docker.sock \
    --name jenkins \
    TBD_ECR_REPO_URL/jenkins:${image_tag}