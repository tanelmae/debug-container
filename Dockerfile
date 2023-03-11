FROM golang:alpine AS builder

RUN apk add --no-cache git
RUN go install github.com/IBM-Cloud/redli@v0.7.0
RUN go install github.com/microsoft/ethr@v1.0.0

FROM gcr.io/google.com/cloudsdktool/google-cloud-cli:alpine AS gcloud
FROM alpine:latest

ARG TARGETARCH

RUN echo "@testing http://dl-cdn.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories
RUN apk add --upgrade apk-tools && \
	apk upgrade --available

RUN apk add --no-cache --update bash bash-completion git libc6-compat \
	curl wget nmap nmap-scripts bind-tools nano python3 py3-pip micro \
	jq netcat-openbsd iputils mtr openssl openssh gnutls-utils grpcurl@testing \
	busybox-extras grep sed speedtest-cli redis stunnel openrc aws-cli \
	iptables postgresql-client mysql-client websocat lynis@testing && \
	mkdir -p /etc/bash_completion.d

COPY --from=builder /go/bin/redli /usr/local/bin/
COPY --from=builder /go/bin/ethr /usr/local/bin/

COPY --from=gcloud /google-cloud-sdk /opt/google-cloud-sdk
ENV PATH "/opt/google-cloud-sdk/bin:$PATH"
RUN gcloud version

WORKDIR /root
COPY bashrc /root/.bashrc

# asdf
COPY asdf-global.sh /bin/asdf-global
RUN ASDF=0.11.2 && \
	curl -sL https://github.com/asdf-vm/asdf/archive/refs/tags/v${ASDF}.tar.gz \
	| tar xz -C /opt && mv "/opt/asdf-${ASDF}" /opt/asdf

# Only use asdf when plugin has multi-arch support
RUN asdf-global kubectl 1.21.6
RUN asdf-global vault 1.8.5

# kube-ps1
RUN KUBE_PS1=0.8.0 && \
	curl -sL "https://github.com/jonmosco/kube-ps1/archive/refs/tags/v${KUBE_PS1}.zip" \
	-o kube-ps1.zip && unzip -q kube-ps1.zip -d /opt && rm kube-ps1.zip && \
	mv "/opt/kube-ps1-${KUBE_PS1}" /opt/kube-ps1

ENTRYPOINT [ "/bin/bash" ]
