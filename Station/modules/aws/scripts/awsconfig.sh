#!/usr/bin/env bash

home=$(sudo -u vagrant pwd)
contents=$1
name=$2

su vagrant <<EOF

echo "$contents" > "$home/.aws/$name";

EOF
