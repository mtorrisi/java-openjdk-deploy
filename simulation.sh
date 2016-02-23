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
MODEL_FOLDER=./$MODEL_NAME

# ***********************
# Add InfectionModel to classpath
# ***********************

CP=$REPAST_CLASSPATH:$MODEL_FOLDER/bin

# ***********************
# Run
# ***********************
echo "[simulation.sh] Simulation started at: '" $(date) "'"

java -cp $CP repast.simphony.runtime.RepastBatchMain -params "batch_params.xml" "$MODEL_FOLDER/$MODEL_NAME.rs"

echo "[simulation.sh] Simulation finished at: '" $(date) "'"

#
# ***********************
# END
# ***********************
