#!/bin/bash

############################################
## move csv files
## from output to input directory
## (reset)
############################################



source env.sh   # load variables

# move all sensors csv files from OU to IN directory
mv $DIR_OU*_sensors.csv $DIR_IN