FROM alpine:3.12.2

RUN apk add --no-cache --update \
	curl wget bash nmap nmap-scripts bind-tools nano \
	jq netcat-openbsd iputils mtr openssl gnutls-utils \
	busybox-extras grep sed speedtest-cli \
	iptables postgresql-client

RUN curl -L https://github.com/fullstorydev/grpcurl/releases/download/v1.7.0/grpcurl_1.7.0_linux_x86_64.tar.gz \
	| tar xvz -C /bin

RUN curl -L https://github.com/vi/websocat/releases/download/v1.5.0/websocat_amd64-linux-static \
	-o /bin/websocat && chmod +x /bin/websocat

COPY bashrc /root/.bashrc
ENTRYPOINT [ "/bin/bash" ]
