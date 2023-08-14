#!/bin/sh

set -xe

date

if [ -z "${DOMAIN}" ]; then
    echo "You must provide a domain"
    sleep 120
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
    sleep 120
    exit 1
fi

if [ -n "${NODEKEY}" ]; then
    NODEKEY=--nodekey=${NODEKEY}
fi

STORE_DB_URL=--store-message-db-url=sqlite:///etc/letsencrypt/waku-store.sqlite3

if [ -n "${POSTGRES_PASSWORD}" ]; then
    STORE_DB_URL="--store-message-db-url=postgres://${POSTGRES_USER}:${POSTGRES_PASSWORD}@postgres:5432/waku"

fi

exec "/usr/bin/wakunode" $@ \
    "--websocket-secure-key-path=${LETSENCRYPT_PATH}/privkey.pem"\
    "--websocket-secure-cert-path=${LETSENCRYPT_PATH}/cert.pem"\
    "--dns4-domain-name=${DOMAIN}"\
    "${STORE_DB_URL}"\
    "${NODEKEY}"
