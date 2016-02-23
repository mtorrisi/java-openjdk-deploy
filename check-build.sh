#!/bin/bash -e
. /etc/profile.d/modules.sh
module load ci
module add jdk/${JAVA_VERSION}
cd ${NAME}-${VERSION}

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
echo "[check-build.sh] - Executing test..."
java -cp $CLASSPATH repast.simphony.runtime.RepastBatchMain -help

# clean out previous module
rm -rf modules ${LIBRARIES_MODULES}/${NAME}

# Create module
echo "[check-build.sh] - Making module"
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
setenv REPAST_CLASSPATH $CLASSPATH
setenv REPAST_VERSION $VERSION
setenv REPAST_DIR                 /apprepo/$::env(SITE)/$::env(OS)/$::env(ARCH)/$NAME/$VERSION
setenv REPAST_HOME                /apprepo/$::env(SITE)/$::env(OS)/$::env(ARCH)/$NAME/$VERSION
prepend-path LD_LIBRARY_PATH      $::env(REPAST_CLASSPATH)
MODULE_FILE
) > modules/${VERSION}
mkdir -p ${LIBRARIES_MODULES}/${NAME}

cp modules/${VERSION} ${LIBRARIES_MODULES}/${NAME}

echo "[check-build.sh] - Checking REPAST module"
module add $NAME/$VERSION

# Check if the module provide REPAST
java -cp $CLASSPATH repast.simphony.runtime.RepastBatchMain -help
