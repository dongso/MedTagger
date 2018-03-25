#!/usr/bin/env bash

echo "Installing all APT packages..."
apt install -y make
if [ ! -e /usr/bin/python3.6 ]
then
    add-apt-repository ppa:jonathonf/python-3.6
    apt-get update
    apt install -y python3.6
    apt install -y python3.6-dev
    apt install -y python3-pip
fi

echo "Installing all system dependencies..."
cd /vagrant/backend
sudo make install_system_dependencies

echo "Applying environment variables..."
. ./devenv.sh

if [ ! -e /usr/local/bin/docker-compose ]
then
    echo "Installing Docker Compose..."
    curl -L https://github.com/docker/compose/releases/download/1.18.0/docker-compose-`uname -s`-`uname -m` -o /usr/local/bin/docker-compose
    chmod +x /usr/local/bin/docker-compose
fi

echo "Running all Docker dependencies..."
docker-compose -f /vagrant/docker-compose.yml up -d hbase postgres rabbitmq

echo "Installing all Python packages..."
make install_packages
make install_dev_packages

echo "Preparing backend..."
./scripts/dev__prepare_backend.sh

