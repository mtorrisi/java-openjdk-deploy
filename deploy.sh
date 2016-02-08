#!/bin/bash -e
# deploy script for java openjdk

# Build only downloads and unpacks the code to the install dir.
. /etc/profile.d/modules.sh

module add deploy

echo "now deploying to ${SOFT_DIR}"
cd ${WORKSPACE}/${NAME}-${VERSION}

mkdir -p ${SOFT_DIR}

# TODO - see if Java works.
