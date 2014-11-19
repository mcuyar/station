#!/usr/bin/env bash

NAME=$1
URL=$2
SITEPATH=$3

su vagrant <<EOF

    # Check if directory doesn't exist
    if [ ! -d "$SITEPATH" ]; then
        sudo mkdir -p "$SITEPATH"
    fi

    # Check if the folder is empty and clone
    if [ "$(ls -A $SITEPATH)" ]; then
        echo "$NAME has already been cloned. Please update manually"
    else
        echo "Cloning $NAME";
        echo $URL;
        echo $SITEPATH;
        git clone $URL $SITEPATH;
        #echo "Setting up git flow";
        #cd $SITEPATH;
        #git flow init -fd;
    fi

    # Install Composer Dependencies
#    if [ -f "$SITEPATH/composer.json" ]; then
#        if [ ! -f "$SITEPATH/composer.lock" ]; then
#            cd $SITEPATH
#            sudo composer install
#        fi
#    fi

EOF