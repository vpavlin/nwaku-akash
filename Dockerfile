FROM quay.io/wakuorg/nwaku-pr:1fb13b0

RUN apt-get update &&\
    apt-get install -y certbot &&\
    apt-get clean && rm -rf /var/lib/apt/lists/*

COPY ./run.sh /opt/run.sh
RUN chmod +x /opt/run.sh

ENTRYPOINT [ "/opt/run.sh" ]