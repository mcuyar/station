#!/usr/bin/env bash
echo $2
su vagrant <<EOF
    cd $1
    $2 || true
EOF