#!/usr/bin/env bash

sudo -u postgres psql --command "ALTER USER $1 with password '$2';"