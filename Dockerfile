FROM alpine:3.12.2

RUN apk add --no-cache --update \
	curl wget bash nmap nmap-scripts bind-tools nano \
	jq netcat-openbsd iputils mtr openssl gnutls-utils \
	busybox-extras grep sed speedtest-cli \
	iptables postgresql-client

# grpcurl
RUN curl -L https://github.com/fullstorydev/grpcurl/releases/download/v1.8.0/grpcurl_1.8.0_linux_x86_64.tar.gz \
	| tar xvz -C /bin

# websocat
RUN curl -L https://github.com/vi/websocat/releases/download/v1.7.0/websocat_amd64-linux-static \
	-o /bin/websocat && chmod +x /bin/websocat

# ethr
RUN wget https://github.com/microsoft/ethr/releases/latest/download/ethr_linux.zip && \
	unzip ethr_linux.zip && mv ethr /bin/ethr

# nali
RUN curl -L https://github.com/zu1k/nali/releases/download/v0.2.3/nali-linux-amd64-v0.2.3.gz \
	| gunzip -c > /bin/nali && chmod +x /bin/nali

COPY bashrc /root/.bashrc
ENTRYPOINT [ "/bin/bash" ]
