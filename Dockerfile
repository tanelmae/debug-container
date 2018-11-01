FROM alpine:latest

MAINTAINER Tanel Mae <tanel.mae@gmail.com>
RUN apk add --no-cache --update \
  curl wget bash nmap bind-tools \
  jq netcat-openbsd iputils mtr \
  && rm -rf /var/cache/apk/*

COPY bashrc /root/.bashrc
ENTRYPOINT [ "/bin/bash" ]
