#!/bin/sh

set -xe

date
if [ -z "${IP_ADDR}" ]; then
    echo "You must provide the nodes public IP address"
    sleep 120
    exit 1
fi

DNS_WSS_CMD=

if [ -n "${DOMAIN}" ]; then
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

    WS_SUPPORT="--websocket-support=true"
    WSS_SUPPORT="--websocket-secure-support=true"
    WSS_KEY="--websocket-secure-key-path=${LETSENCRYPT_PATH}/privkey.pem"
    WSS_CERT="--websocket-secure-cert-path=${LETSENCRYPT_PATH}/cert.pem"
    DNS4_DOMAIN="--dns4-domain-name=${DOMAIN}"

    DNS_WSS_CMD="${WS_SUPPORT} ${WSS_SUPPORT} ${WSS_CERT} ${WSS_KEY} ${DNS4_DOMAIN}"
fi

if [ "${NODEKEY}" != "" ]; then
    NODEKEY=--nodekey=${NODEKEY}
fi

STORE_DB_URL=--store-message-db-url=sqlite:///etc/letsencrypt/wakustore.sqlite3

if [ "${POSTGRES_PASSWORD}" != "" ]; then
    STORE_DB_URL="--store-message-db-url=postgres://${POSTGRES_USER}:${POSTGRES_PASSWORD}@postgres:5432/waku"
fi

exec "/usr/bin/wakunode" $@ ${DNS_WSS_CMD}\
    ${STORE_DB_URL}\
    ${NODEKEY}\
    --nat=extip:${IP_ADDR}
