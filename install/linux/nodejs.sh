#!/bin/bash

# Install NodeJs LTS
apt-get update
apt install -y sudo
curl -sL https://deb.nodesource.com/setup_16.x -o nodesource_setup.sh
sudo bash nodesource_setup.sh
apt install -y nodejs