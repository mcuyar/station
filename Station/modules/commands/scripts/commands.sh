#!/usr/bin/env bash
echo $2
su vagrant <<EOF
    if [ -f envars ]; then source envars; fi
    $3
    cd $1
    $2 || true
EOF