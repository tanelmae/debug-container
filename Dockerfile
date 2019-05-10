FROM golang:1.12.5-alpine3.9 AS go-builder
RUN apk add --no-cache --update git
RUN go get github.com/fullstorydev/grpcurl
RUN go install github.com/fullstorydev/grpcurl/cmd/grpcurl

FROM alpine:latest

RUN apk add --no-cache --update \
  curl wget bash nmap bind-tools nano \
  jq netcat-openbsd iputils mtr \
  busybox-extras grep sed speedtest

COPY --from=go-builder /go/bin/grpcurl /bin/grpcurl
COPY bashrc /root/.bashrc
ENTRYPOINT [ "/bin/bash" ]
