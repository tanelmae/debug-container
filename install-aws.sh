#!/usr/bin/env bash

CLI_VERSION=${1}

echo "Arch: ${TARGETARCH}"
if [ "${TARGETARCH}" = "arm64" ]; then
	DOWNLOAD_ARCH="aarch64"
else
	DOWNLOAD_ARCH="x86_64"
fi

curl -sL \
	"https://github.com/simnalamburt/awscliv2.appimage/releases/download/v${CLI_VERSION}/aws-${DOWNLOAD_ARCH}.AppImage" \
	-o /usr/local/bin/aws && chmod +x /usr/local/bin/aws
