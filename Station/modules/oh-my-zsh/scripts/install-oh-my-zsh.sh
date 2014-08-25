#!/usr/bin/env bash

su vagrant <<'EOF'

    # install git-flow and oh-my-zsh
    if [ ! -d ~/.oh-my-zsh ]; then
        sudo apt-get -y install git-flow
        sudo apt-get -y install zsh
        sudo apt-get install git-core
        wget https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh
        zsh install.sh
        echo 'vagrant' | chsh -s `which zsh`
    fi

EOF