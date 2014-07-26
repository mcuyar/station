#!/usr/bin/env bash

sudo -u postgres createuser -s $1 || true