#!/usr/bin/env bash
set -e

TOOL=${1}
VERSION=${2}

source /opt/asdf/asdf.sh
echo "Installing ${TOOL} version ${VERSION}"

asdf plugin add ${TOOL}
asdf install ${TOOL} ${VERSION}
asdf global ${TOOL} ${VERSION}