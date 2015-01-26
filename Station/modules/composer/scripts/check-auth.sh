#!/usr/bin/env bash

home=$(sudo -u vagrant pwd)

su vagrant <<EOF

    if [ ! -f $(sudo -u vagrant pwd)/.composer/auth.json ]; then sudo touch $(sudo -u vagrant pwd)/.composer/auth.json ; fi

EOF