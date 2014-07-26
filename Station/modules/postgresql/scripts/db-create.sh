#!/usr/bin/env bash

sudo -u postgres createdb -O $1 $2 || true