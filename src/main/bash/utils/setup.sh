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

# global directories
DIR_DATA=${SPARK_APP}/data
DIR_TARG=${SPARK_APP}/target

# streaming directories
DIR_S_TST=$DIR_DATA/stream/testData
DIR_S_INP=$DIR_DATA/stream/input
DIR_S_OUT=$DIR_DATA/stream/output

# applications paramethers
STREAMER_REFRESH_INTERVAL=30 # Streamer refresh interval; in seconds
ANALYZER_REFRESH_INTERVAL=1800 # Analyzer refresh interval; in seconds
ANALYZER_MIN_EFFICIENCY=0.9 # Analyzer min efficiency to assume sensor as working


############################################
## PRINT RESULTS
############################################


echo "`date +%Y-%m-%d_%H:%M:%S` INFO starting script..."
sleep 1
echo -e "***\n`date +%Y-%m-%d_%H:%M:%S` INFO loading setup..."
echo -e "`date +%Y-%m-%d_%H:%M:%S` INFO operating as: `whoami`@${MASTER_IP}\n***"
sleep 1
echo -e "***\n`date +%Y-%m-%d_%H:%M:%S` INFO setup.sh finished, have a nice day" # final info
sleep 1