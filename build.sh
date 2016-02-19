#!/bin/bash -e
# build script for java
# Java has some really messed up dependencies like cpus - wtf, seriously ? - so, we are going against the grain
# of CODE-RADE here by deploying pre-packaged binary files.

# Build only downloads and unpacks the code to the install dir.
#. /etc/profile.d/modules.sh

echo "build number is ${BUILD_NUMBER}"
SOURCE_FILE=${NAME}_${VERSION}_linux-x64.zip
#module load ci
#module add jdk/${JAVA_VERSION}
mkdir -p ${SRC_DIR}
echo "Getting REPAST Libraries from http://grid.ct.infn.it/csgf/binaries/repast/${VERSION}"

if [ ! -e ${SRC_DIR}/${SOURCE_FILE}.lock ] && [ ! -s ${SRC_DIR}/${SOURCE_FILE} ] ; then
# claim the download
  touch  ${SRC_DIR}/${SOURCE_FILE}.lock
  wget "http://grid.ct.infn.it/csgf/binaries/repast/${VERSION}/${SOURCE_FILE}" -O ${SRC_DIR}/${SOURCE_FILE}
  echo "releasing lock"
  rm -v ${SRC_DIR}/${SOURCE_FILE}.lock
elif [ -e ${SRC_DIR}/${SOURCE_FILE}.lock ] ; then
  # Someone else has the file, wait till it's released
  while [ -e ${SRC_DIR}/${SOURCE_FILE}.lock ] ; do
    echo " There seems to be a download currently under way, will check again in 5 sec"
    sleep 5
  done
fi

mkdir -p ${WORKSPACE}/${NAME}-${VERSION}
# the name of the tar upack dir is some wierd combination of underscores and numbers, so we'll just redefined where
# the code gets unpacked
unzip ${SRC_DIR}/${SOURCE_FILE} -d ${WORKSPACE}/${NAME}-${VERSION}
cd ${WORKSPACE}/${NAME}-${VERSION}
ls -al
# TODO - see if REPAST builds.
