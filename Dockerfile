FROM statusteam/nim-waku:v0.19.0-rc.1

RUN apk add --no-cache certbot

COPY ./run.sh /opt/run.sh
RUN chmod +x /opt/run.sh

ENTRYPOINT [ "/opt/run.sh" ]