FROM alpine:3.13

ENV GRPCULR 1.8.5
ENV WEBSOCAT 1.9.0
ENV ETHR 1.0.0
ENV NALI 0.3.2
ENV KUBECTL 1.21.6
ENV KUBE_PS1 0.7.0
ENV REDLI 0.5.2

RUN apk add --upgrade apk-tools && \
	apk upgrade --available

RUN apk add --no-cache --update bash-completion \
	curl wget bash nmap nmap-scripts bind-tools nano \
	jq netcat-openbsd iputils mtr openssl gnutls-utils \
	busybox-extras grep sed speedtest-cli redis stunnel \
	iptables postgresql-client && mkdir -p /etc/bash_completion.d

WORKDIR /root
# grpcurl
RUN curl -L "https://github.com/fullstorydev/grpcurl/releases/download/v${GRPCULR}/grpcurl_${GRPCULR}_linux_x86_64.tar.gz" \
	| tar xvz -C /usr/bin

# websocat
RUN curl -L "https://github.com/vi/websocat/releases/download/v${WEBSOCAT}/websocat_amd64-linux-static" \
	-o /usr/bin/websocat && chmod +x /usr/bin/websocat

# ethr
RUN wget "https://github.com/microsoft/ethr/releases/download/v${ETHR}/ethr_linux.zip" && \
	unzip ethr_linux.zip && rm ethr_linux.zip && mv ethr /usr/bin/ethr

# nali
RUN curl -L "https://github.com/zu1k/nali/releases/download/v${NALI}/nali-linux-amd64-v${NALI}.gz" \
	| gunzip -c > /usr/bin/nali && chmod +x /usr/bin/nali

# kubectl
RUN curl -L "https://dl.k8s.io/release/v${KUBECTL}/bin/linux/amd64/kubectl" \
	-o /usr/bin/kubectl && chmod +x /usr/bin/kubectl && \
	/usr/bin/kubectl completion bash > /etc/bash_completion.d/kubectl

# kube-ps1
RUN curl -L "https://github.com/jonmosco/kube-ps1/archive/refs/tags/v${KUBE_PS1}.zip" \
	-o kube-ps1.zip && unzip kube-ps1.zip -d /opt && rm kube-ps1.zip && \
	mv "/opt/kube-ps1-${KUBE_PS1}" /opt/kube-ps1

# redli
RUN curl -L "https://github.com/IBM-Cloud/redli/releases/download/v${REDLI}/redli_${REDLI}_darwin_amd64.tar.gz" \
	| tar xvz -C /usr/bin

COPY bashrc /root/.bashrc
ENTRYPOINT [ "/bin/bash" ]
