#!/usr/bin/env bash

su vagrant <<EOF
    git config --global user.name "$1"
    git config --global user.email $2
    git config --global color.ui $3
    git config --global push.default $4
EOF