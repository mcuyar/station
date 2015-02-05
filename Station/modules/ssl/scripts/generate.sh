#!/usr/bin/env bash

# https://serversforhackers.com/ssl-certs/

# Specify where we will install
# the xip.io certificate
SSL_DIR="/etc/ssl"

# Set the wildcarded domain
# we want to use
DOMAIN="$1"

# A blank passphrase
PASSPHRASE=""

# Set our CSR variables
SUBJ="$2"

# Generate our Private Key, CSR and Certificate
if [ ! -f "$SSL_DIR/$DOMAIN.key" ]; then
    sudo openssl genrsa -out "$SSL_DIR/$DOMAIN.key" 2048
fi

if [ ! -f "$SSL_DIR/$DOMAIN.csr" ]; then
    sudo openssl req -new -subj "/$(echo -n "$SUBJ" | tr "\n" "/")" -key "$SSL_DIR/$DOMAIN.key" -out "$SSL_DIR/$DOMAIN.csr" -passin pass:$PASSPHRASE
fi

if [ ! -f "$SSL_DIR/$DOMAIN.crt" ]; then
    sudo openssl x509 -req -days 365 -in "$SSL_DIR/$DOMAIN.csr" -signkey "$SSL_DIR/$DOMAIN.key" -out "$SSL_DIR/$DOMAIN.crt"
fi