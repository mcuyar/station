#!/usr/bin/env bash

# Install unzip
sudo apt-get install unzip
sudo apt-get install python-boto
sudo apt-get install python-dev
sudo pip install awsebcli

su vagrant <<EOF
    sudo pip install awsebcli
EOF