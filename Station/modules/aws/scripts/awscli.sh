#!/usr/bin/env bash

home=$(sudo -u vagrant pwd)

su vagrant <<EOF

    sudo apt-get remove -y python-pip
    wget https://raw.github.com/pypa/pip/master/contrib/get-pip.py
    sudo python get-pip.py

    if [ ! -d $home/.aws ]; then mkdir $home/.aws; fi

    if [ ! -f $home/aws_installed ]; then
        sudo pip install awscli
        touch $home/aws_installed
    else
        sudo pip install --upgrade awscli
    fi

EOF