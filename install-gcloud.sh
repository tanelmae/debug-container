#!/usr/bin/env bash

DOWNLOAD_PATH=${1}
VERSION=${2}

echo "Arch: ${TARGETARCH}"
if [ "${TARGETARCH}" = "amd64" ]; then
	DOWNLOAD_ARCH="x86_64"
elif [ "${TARGETARCH}" = "arm64" ]; then
	DOWNLOAD_ARCH="arm"
else
	DOWNLOAD_ARCH="x86"
fi

LINK="https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-sdk-${VERSION}-linux-${DOWNLOAD_ARCH}.tar.gz"
echo "${LINK}"

mkdir -p "${DOWNLOAD_PATH}"
curl -sL "${LINK}" | tar xz -C "${DOWNLOAD_PATH}" --strip 1

"${DOWNLOAD_PATH}/bin/gcloud" components install --quiet \
	alpha beta gsutil core docker-credential-gcr

${DOWNLOAD_PATH}/bin/gcloud components update --quiet
