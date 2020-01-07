FROM golang:1.13.5-alpine3.10 AS go-builder
RUN apk add --no-cache --update git
RUN go get github.com/fullstorydev/grpcurl
RUN go install github.com/fullstorydev/grpcurl/cmd/grpcurl

FROM alpine:3.11.2

RUN apk add --no-cache --update \
	curl wget bash nmap bind-tools nano \
	jq netcat-openbsd iputils mtr openssl \
	busybox-extras grep sed speedtest-cli \
	iptables

RUN curl -L https://github.com/vi/websocat/releases/download/v1.5.0/websocat_amd64-linux-static \
	-o /bin/websocat && chmod +x /bin/websocat

COPY --from=go-builder /go/bin/grpcurl /bin/grpcurl
COPY bashrc /root/.bashrc
ENTRYPOINT [ "/bin/bash" ]
