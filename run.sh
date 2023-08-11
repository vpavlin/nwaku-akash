#!/bin/sh

set -xe


exec "/usr/bin/wakunode" $@ "--websocket-secure-key-path=${LETSENCRYPT_PATH}/privkey.pem" "--websocket-secure-cert-path=${LETSENCRYPT_PATH}/cert.pem" "--dns4-domain-name=${DOMAIN}"
