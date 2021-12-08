#!/usr/bin/env bash

echo "Arch: ${TARGETARCH}"
if [ "${TARGETARCH}" = "amd64" ]; then
	GRPCURL_ARCH="x86_64"
else
	GRPCURL_ARCH=${TARGETARCH}
fi

LINK="https://github.com/fullstorydev/grpcurl/releases/download/v${1}/grpcurl_${1}_linux_${GRPCURL_ARCH}.tar.gz"
echo ${LINK}
curl -L ${LINK} | tar xvz -C /usr/local/bin
