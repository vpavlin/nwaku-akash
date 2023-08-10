#!/bin/sh

set -xe

if [ -z "${DOMAIN}" ]; then
    echo "You must provide a domain"
    exit 1
fi

LETSENCRYPT_PATH=/etc/letsencrypt/live/${DOMAIN}

if ! [ -d "${LETSENCRYPT_PATH}" ]; then
    certbot certonly\
        --non-interactive\
        --agree-tos\
        --no-eff-email\
        --no-redirect\
        --email user@${DOMAIN}\
        -d ${DOMAIN}\
        --standalone
fi

if ! [ -e "${LETSENCRYPT_PATH}/privkey.pem" ]; then
    echo "The certificate does not exist"
    sleep 10
    exit 1
fi

exec "/usr/bin/wakunode $@ --websocket-secure-key-path=${LETSENCRYPT_PATH}/privkey.pem --websocket-secure-cert-path=${LETSENCRYPT_PATH}/cert.pem"
