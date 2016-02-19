#!/bin/bash -e
# Build script for REPAST Symphony
# The Recursive Porous Agent Simulation Toolkit (Repast) is a widely used free and open-source,
# cross-platform, agent-based modeling and simulation toolkit.

# Build only downloads and unpacks the code to the install dir.
. /etc/profile.d/modules.sh
SOURCE_FILE=${NAME}_${VERSION}_linux-x64.tar.gz

module add deploy

echo "[deploy.sh] - Now deploying to ${SOFT_DIR}"
cd ${WORKSPACE}/${NAME}-${VERSION}
echo "[deploy.sh] -  REPAST $VERSION will now go into ${SOFT_DIR}/"
mkdir -p ${SOFT_DIR}
unzip ${SRC_DIR}/${SOURCE_FILE} -d ${WORKSPACE}/${NAME}-${VERSION}

# REPAST specific costants
PREFIX=repast.simphony
PLUGINS=./plugins

# ***********************
# Add plugins to classpath
# ***********************

export CLASSPATH=.:$PLUGINS/libs.bsf_$VERSION/lib/*:\
$PLUGINS/libs.ext_$VERSION/lib/*:\
$PLUGINS/$PREFIX.batch_$VERSION/lib/*:\
$PLUGINS/$PREFIX.batch_$VERSION/bin:\
$PLUGINS/$PREFIX.distributed.batch_$VERSION/lib/*:\
$PLUGINS/$PREFIX.distributed.batch_$VERSION/bin:\
$PLUGINS/$PREFIX.core_$VERSION/lib/*:\
$PLUGINS/$PREFIX.core_$VERSION/bin:\
$PLUGINS/$PREFIX.runtime_$VERSION/lib/*:\
$PLUGINS/$PREFIX.runtime_$VERSION/bin:\
$PLUGINS/$PREFIX.data_$VERSION/bin:\
$PLUGINS/$PREFIX.dataLoader_$VERSION/bin:\
$PLUGINS/$PREFIX.scenario_$VERSION/bin:\
$PLUGINS/$PREFIX.essentials_$VERSION/bin:\
$PLUGINS/$PREFIX.groovy_$VERSION/bin:\
$PLUGINS/$PREFIX.intergation_$VERSION/lib/*:\
$PLUGINS/$PREFIX.intergation_$VERSION/bin:\
$PLUGINS/saf.core.ui_$VERSION/saf.core.v3d.jar:\
$PLUGINS/saf.core.ui_$VERSION/lib/*:\

# Execute test
echo "[deploy.sh] - Executing test..."
java -cp $CLASSPATH repast.simphony.runtime.RepastBatchMain -help

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
setenv REPAST_VERSION $VERSION
setenv REPAST_DIR                 $::env(CVMFS_DIR)/$::env(SITE)/$::env(OS)/$::env(ARCH)/$NAME/$VERSION
setenv REPAST_HOME                $::env(CVMFS_DIR)/$::env(SITE)/$::env(OS)/$::env(ARCH)/$NAME/$VERSION
prepend-path LD_LIBRARY_PATH    $::env(CLASSPATH)
MODULE_FILE
) > modules/${VERSION}
mkdir -p ${LIBRARIES_MODULES}/${NAME}/${VERSION}
cp modules/${VERSION} ${LIBRARIES_MODULES}/${NAME}/${VERSION}

echo "[deploy.sh] - Checking java module"
module add $NAME/$VERSION
module list
echo "[deploy.sh] - which java are we using ? "
java -cp $CLASSPATH repast.simphony.runtime.RepastBatchMain -help
