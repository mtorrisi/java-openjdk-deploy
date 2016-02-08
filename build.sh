#!/bin/bash -e
# build script for java
# Java has some really messed up dependencies like cpus - wtf, seriously ? - so, we are going against the grain
# of CODE-RADE here by deploying pre-packaged binary files.

# Build only downloads and unpacks the code to the install dir.
. /etc/profile.d/modules.sh
SOURCE_FILE=${NAME}-${VERSION}.tar.gz
module load ci
mkdir -p ${SRC_DIR}
echo "getting the file from gnu.org mirror"

if [ ! -e ${SRC_DIR}/${SOURCE_FILE}.lock ] && [ ! -s ${SRC_DIR}/${SOURCE_FILE} ] ; then
# claim the download
  touch  ${SRC_DIR}/${SOURCE_FILE}.lock
#TODO @mtorrisi   wget -O ${SRC_DIR}/${SOURCE_FILE}
  echo "releasing lock"
  rm -v ${SRC_DIR}/${SOURCE_FILE}.lock
elif [ -e ${SRC_DIR}/${SOURCE_FILE}.lock ] ; then
  # Someone else has the file, wait till it's released
  while [ -e ${SRC_DIR}/${SOURCE_FILE}.lock ] ; do
    echo " There seems to be a download currently under way, will check again in 5 sec"
    sleep 5
  done
fi

tar xfz ${SRC_DIR}/${SOURCE_FILE} -C ${WORKSPACE} --skip-old-files
cd ${WORKSPACE}/${NAME}-${VERSION}

# TODO - see if Java works.
