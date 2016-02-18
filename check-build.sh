#!/bin/bash -e
. /etc/profile.d/modules.sh
module load ci
module add jdk/${JAVA_VERSION}
cd ${NAME}-${VERSION}

#TODO -Execute test

#TOD - Create module
echo "making module"
mkdir -p modules
(
cat <<MODULE_FILE
#%Module1.0
## $NAME modulefile
##
proc ModulesHelp { } {
puts stderr " This module does nothing but alert the user"
puts stderr " that the [module-info name] module is not available"
}
module-whatis "$NAME $VERSION."
setenv JAVA_VERSION $VERSION
setenv JAVA_DIR                 /apprepo/$::env(SITE)/$::env(OS)/$::env(ARCH)/$NAME/$VERSION
setenv JAVA_HOME                /apprepo/$::env(SITE)/$::env(OS)/$::env(ARCH)/$NAME/$VERSION
prepend-path LD_LIBRARY_PATH    $::env(JAVA_DIR)/lib
prepend-path PATH               $::env(JAVA_DIR)/bin
MODULE_FILE
) > modules/${VERSION}
mkdir -p ${LIBRARIES_MODULES}/${NAME}
cp modules/${VERSION} ${LIBRARIES_MODULES}/${NAME}

echo "Checking java module"
module add $NAME/$VERSION
# TODO - Check if the module provide REPAST
# 
