FROM golang:1.13.4-alpine3.10 AS go-builder
RUN apk add --no-cache --update git
RUN go get github.com/fullstorydev/grpcurl
RUN go install github.com/fullstorydev/grpcurl/cmd/grpcurl

FROM alpine:3.10.3

RUN apk add --no-cache --update \
	curl wget bash nmap bind-tools nano \
	jq netcat-openbsd iputils mtr \
	busybox-extras grep sed speedtest-cli

COPY --from=go-builder /go/bin/grpcurl /bin/grpcurl
COPY bashrc /root/.bashrc
ENTRYPOINT [ "/bin/bash" ]
