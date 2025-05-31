FROM golang:1.23-alpine AS builder

RUN apk add --no-cache git
RUN go install github.com/IBM-Cloud/redli@v0.7.0
RUN go install github.com/microsoft/ethr@v1.0.0

FROM alpine:3.18

RUN echo "@testing http://dl-cdn.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories
RUN apk add --no-cache --update --upgrade apk-tools && \
	apk upgrade --available && \
	apk add --no-cache --update bash bash-completion git libc6-compat \
	curl wget nmap nmap-scripts bind-tools nano python3 py3-pip micro \
	jq netcat-openbsd iputils mtr openssl openssh gnutls-utils grpcurl@testing \
	busybox-extras grep sed speedtest-cli redis stunnel openrc aws-cli \
	iptables postgresql-client mysql-client websocat lynis@testing bzip2 p7zip && \
	mkdir -p /etc/bash_completion.d

COPY --from=builder /go/bin/redli /usr/local/bin/
COPY --from=builder /go/bin/ethr /usr/local/bin/

WORKDIR /root
COPY bashrc /root/.bashrc

# asdf
RUN ASDF=0.11.2 && \
	curl -sL https://github.com/asdf-vm/asdf/archive/refs/tags/v${ASDF}.tar.gz \
	| tar xz -C /opt && mv "/opt/asdf-${ASDF}" /opt/asdf

ENTRYPOINT [ "/bin/bash" ]
