#!/bin/bash

# https://docs.docker.com/engine/install/fedora/

sudo rm -f /etc/docker/daemon.json;

sudo dnf remove -y docker \
                  docker-client \
                  docker-client-latest \
                  docker-common \
                  docker-latest \
                  docker-latest-logrotate \
                  docker-logrotate \
                  docker-selinux \
                  docker-engine-selinux \
                  docker-engine;

sudo dnf -y install dnf-plugins-core;

sudo dnf config-manager \
    --add-repo \
    https://download.docker.com/linux/fedora/docker-ce.repo;

sudo dnf -y update;
sudo dnf -y install docker-ce docker-ce-cli containerd.io;

# Copy paste and run:
# sudo systemctl start docker; sudo docker run hello-world;
