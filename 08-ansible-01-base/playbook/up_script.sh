#!/usr/bin/env bash

# Run ness containers
docker run -it --name=centos7 -d centos /bin/bash > /dev/null
echo "centos7 started successfully"
docker run -it --name=ubuntu -d fnndsc/ubuntu-python3 > /dev/null
echo "ubuntu started successfully"
docker run -it --name=fedora -d pycontribs/fedora /bin/bash > /dev/null
echo "fedora started successfully"

# run ans playbook
ansible-playbook site.yml -i inventory/prod.yml --ask-vault-pass

# stop and remove containers
docker stop fedora ubuntu centos7 > /dev/null
docker rm fedora ubuntu centos7 > /dev/null
echo "all containers has been removed"
