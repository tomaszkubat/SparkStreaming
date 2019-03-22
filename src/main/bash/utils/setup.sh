#!/bin/bash
# setup variables before application run

#################################################
## CHECK VARIABLES DECLARATION IN ~/.bashrc
##
## SPARK_HOME
## SPARK_APP
## MASTER_IP # ip address is being set dynamically
#################################################


if [ -z ${SPARK_HOME} ]; then
	echo variable SPARK_HOME not found: update ~/.bashrc & exit 1;
fi

if [ -z ${SPARK_APP} ]; then
	echo variable SPARK_APP not found: update ~/.bashrc & exit 1;
fi

if [ -z ${MASTER_IP} ]; then
	echo variable MASTER_IP not found: update ~/.bashrc & exit 1;
fi


#################################################
## SET PARAMETERS
#################################################


# master
MASTER='spark://'${MASTER_IP}':7077' # use default port

# directories
DIR_DATA=${SPARK_APP}/data
DIR_TARG=${SPARK_APP}/target

# applications paramethers
STREAMER_REFRESH_INTERVAL=30 # Streamer refresh interval; in seconds
ANALYZER_REFRESH_INTERVAL=1800 # Analyzer refresh interval; in seconds
ANALYZER_MIN_EFFICIENCY=0.9 # Analyzer min efficiency to assume sensor as working


############################################
## PRINT RESULTS
############################################

red='e[0;31m'
nocolor='\e[0m'

echo "starting script..."
sleep 1
echo -e "***\nloading setup..."
echo "operating as: ${red}`whoami`@${MASTER_IP}${nocolor}"
sleep 1
