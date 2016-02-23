#!/bin/sh

# Infection Model batch starter
# Authors:
# Anastasia Anagnostou
# Adedeji Fabiyi
# Mario Torrisi

echo "[simulation.sh] - Creating batch parameters file...."

cat <<EOF >batch_params.xml
<?xml version="1.0"?>
<sweep runs="1">
        <parameter name="end_time" type="constant" constant_type="int" value="20"/>
        <parameter name="healthy_count" type="constant" constant_type="int" value="0"/>
        <parameter name="infected_count" type="constant" constant_type="int" value="20"/>
        <parameter name="susceptible_count" type="constant" constant_type="int" value="1500"/>
</sweep>
EOF

echo "[simulation.sh] - batch_params.xml created"

# ***********************
# Model directories
# ***********************

MODEL_NAME=InfectionModel
MODEL_FOLDER=${WORKSPACE}/$MODEL_NAME

# ***********************
# Add InfectionModel to classpath
# ***********************

CP=$REPAST_CLASSPATH:$MODEL_FOLDER/bin

if [ ! -d "${WORKSPACE}/output" ]; then
  mkdir -p ${WORKSPACE}/output
fi

# ***********************
# Run
# ***********************
echo "[simulation.sh] Simulation started at: '" $(date) "'"

java -cp $CP repast.simphony.runtime.RepastBatchMain -params "batch_params.xml" "$MODEL_FOLDER/$MODEL_NAME.rs" > ${WORKSPACE}/stdout 2> ${WORKSPACE}/stderr

echo "[simulation.sh] Simulation finished at: '" $(date) "'"

echo "[simulation.sh] Simulation output"
echo "###################[ OUTPUTS ]#########################"
echo
echo "${WORKSPACE}/output/output.txt"
cat ${WORKSPACE}/output/output.txt
echo
echo "${WORKSPACE}/stderr"
cat ${WORKSPACE}/stderr
echo
echo "######################################################"

#
# ***********************
# END
# ***********************
