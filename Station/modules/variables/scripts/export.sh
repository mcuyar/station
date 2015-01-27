#!/usr/bin/env bash

home=$(sudo -u vagrant pwd)
pattern='if [ -f ~/envars ]; then source ~/envars; fi'

su vagrant <<EOF

    if ! grep -Fxq '$pattern' $home/.bashrc ; then
        echo -e "$pattern" >> $home/.bashrc
    fi

    if ! grep -Fxq '$pattern' $home/.zshrc ; then
        echo -e "$pattern" >> $home/.zshrc
    fi

EOF