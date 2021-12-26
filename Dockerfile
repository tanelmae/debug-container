FROM golang:alpine3.15

ARG TARGETARCH

ENV REDLI 0.5.2
ENV ETHR 1.0.0
ENV KUBECTL 1.21.6
ENV KUBE_PS1 0.7.0
ENV ASDF 0.8.1
ENV VAULT 1.8.5
ENV GRPCURL 1.8.5
ENV GCLOUD 366.0.0
ENV AWS_CLI 2.4.7

RUN echo "@testing http://dl-cdn.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories
RUN apk add --upgrade apk-tools && \
	apk upgrade --available

RUN apk add --no-cache --update bash bash-completion git libc6-compat \
	curl wget nmap nmap-scripts bind-tools nano python3 py3-pip \
	jq netcat-openbsd iputils mtr openssl gnutls-utils \
	busybox-extras grep sed speedtest-cli redis stunnel openrc \
	iptables postgresql-client mysql-client websocat lynis@testing && \
	mkdir -p /etc/bash_completion.d

WORKDIR /root
COPY bashrc /root/.bashrc

RUN go install github.com/IBM-Cloud/redli@v${REDLI}

COPY install-* ./

RUN ./install-grpcurl.sh ${GRPCURL}
RUN ./install-aws.sh ${AWS_CLI}
RUN ./install-micro.sh

RUN ./install-gcloud.sh /opt/google-cloud-sdk ${GCLOUD}
ENV PATH "/opt/google-cloud-sdk/bin:$PATH"

# asdf
COPY asdf-global.sh /bin/asdf-global
RUN curl -sL https://github.com/asdf-vm/asdf/archive/refs/tags/v${ASDF}.tar.gz \
	| tar xz -C /opt && mv "/opt/asdf-${ASDF}" /opt/asdf

# Only use asdf when plugin has multi-arch support
RUN asdf-global kubectl ${KUBECTL}
RUN asdf-global vault ${VAULT}

# kube-ps1
RUN curl -sL "https://github.com/jonmosco/kube-ps1/archive/refs/tags/v${KUBE_PS1}.zip" \
	-o kube-ps1.zip && unzip -q kube-ps1.zip -d /opt && rm kube-ps1.zip && \
	mv "/opt/kube-ps1-${KUBE_PS1}" /opt/kube-ps1

ENTRYPOINT [ "/bin/bash" ]
