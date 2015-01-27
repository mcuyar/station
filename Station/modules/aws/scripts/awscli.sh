#!/usr/bin/env bash

home=$(sudo -u vagrant pwd)

su vagrant <<EOF

    if [ ! -d $home/.aws ]; then mkdir $home/.aws; fi

    if [ ! -f $home/aws_installed ]; then
        #sudo apt-get -y install python-dev
        sudo pip install awscli
        touch $home/aws_installed
    else
        sudo pip install --upgrade awscli
    fi

EOF
