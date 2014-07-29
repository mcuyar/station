#!/usr/bin/env bash

su vagrant <<EOF

    # Add domain to known hosts
    ssh-keyscan $1 > ~/.ssh/known_hosts

EOF