#!/usr/bin/env bash

ARCHIVE="awscliv2.zip"

echo "Arch: ${TARGETARCH}"
if [ "${TARGETARCH}" = "arm64" ]; then
	DOWNLOAD_ARCH="aarch64"
else
	DOWNLOAD_ARCH="x86_64"
fi

curl "https://awscli.amazonaws.com/awscli-exe-linux-${DOWNLOAD_ARCH}.zip" -o "${ARCHIVE}"

unzip "${ARCHIVE}"
./aws/install
rm -Rf ./aws
