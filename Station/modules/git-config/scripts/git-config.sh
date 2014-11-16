#!/usr/bin/env bash

echo "Setting git config"
home=$(sudo -u vagrant pwd)

if [ -f $home/.gitconfig ]; then
  rm -f $home/.gitconfig
fi