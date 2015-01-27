#!/usr/bin/env bash

path=$1
content=$2

su vagrant <<EOF

    if [ ! -f $path ]; then touch $path; fi

    echo "$content" > $path;

EOF
