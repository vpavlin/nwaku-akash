#!/bin/sh

set -xe

if [ -z "${DOMAIN}" ]; then
    echo "You must provide a domain"
    exit 1
fi

certbot certonly\
    --non-interactive\
    --agree-tos\
    --no-eff-email\
    --no-redirect\
    --email user@${DOMAIN}\
    -d ${DOMAIN}\
    --standalone

LETSENCRYPT_PATH=/etc/letsencrypt/live/${DOMAIN}

if ! [ -e "${LETSENCRYPTPATH}/privkey.pem" ]; then
    echo "The certificate does not exist"
    sleep 10
    exit 1

exec "/usr/bin/wakunode" $@ --websocket-secure-key-path=${LETSENCRYPTPATH}/privkey.pem --websocket-secure-cert-path=${LETSENCRYPTPATH}/cert.pem