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
        <parameter name="end_time" type="constant" constant_type="int" value="$1"/>
        <parameter name="healthy_count" type="constant" constant_type="int" value="$2"/>
        <parameter name="infected_count" type="constant" constant_type="int" value="$3"/>
        <parameter name="susceptible_count" type="constant" constant_type="int" value="$4"/>
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

if [ ! -d output ]; then
  mkdir -p output
fi

# ***********************
# Run
# ***********************
echo "[simulation.sh] - Simulation started at: '" $(date) "'"
echo "java -cp $CP repast.simphony.runtime.RepastBatchMain -params batch_params.xml $MODEL_FOLDER/$MODEL_NAME.rs > output/stdout 2> output/stderr"
java -cp $CP repast.simphony.runtime.RepastBatchMain -params "batch_params.xml" "$MODEL_FOLDER/$MODEL_NAME.rs" > "output/stdout" 2> "output/stderr"

echo "[simulation.sh] - Simulation finished at: '" $(date) "'"

echo "[simulation.sh] Simulation output"
echo "###################[ OUTPUTS ]#########################"
echo
echo "output/output.txt"
cat output/output.txt
echo
echo "stderr"
cat output/stderr
echo
echo "######################################################"

#
# ***********************
# END
# ***********************
