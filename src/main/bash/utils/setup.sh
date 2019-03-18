#!/bin/bash

############################################
## script to load parameters
############################################


# alias to print p=label with date
# alias ti="ts '%Y-%m-%d %H-%M-%S [INFO]'"
# alias tw="ts '%Y-%m-%d %H-%M-%S [WARN]'"
# alias te="ts '%Y-%m-%d %H-%M-%S [ERR.]'"

echo "###########################" | ts '%Y-%m-%d %H-%M-%S [INFO]'
echo "main parameters:" | ts '%Y-%m-%d %H-%M-%S [INFO]'
echo "HOST NAME: `hostname`" | ts '%Y-%m-%d %H-%M-%S [INFO]'
echo "HOST IP: `hostname -I`" | ts '%Y-%m-%d %H-%M-%S [INFO]'
echo "USER NAME: `whoami`" | ts '%Y-%m-%d %H-%M-%S [INFO]'
echo "###########################" | ts '%Y-%m-%d %H-%M-%S [INFO]'
echo "loading parameters..." | ts '%Y-%m-%d %H-%M-%S [INFO]'
sleep 1


# check if variavbles SPARK_HOME and SPARK_APP are declared

if [ -z ${SPARK_HOME} ]; then
	echo variable SPARK_HOME not found. Please update the .bashrc file & exit 1;
fi

if [ -z ${SPARK_APP} ]; then
	echo variable SPARK_APP not found. Please update the .bashrc file & exit 1;
fi



echo "SPAKR_HOME: $SPARK_HOME" | ts '%Y-%m-%d %H-%M-%S [INFO]'
echo "SPARK_APP: $SPARK_APP" | ts '%Y-%m-%d %H-%M-%S [INFO]'
sleep 1


# get directories

DIR_CONF=$SPARK_APP/conf
DIR_DATA=$SPARK_APP/data
DIR_TARG=$SPARK_APP/target

echo "DIR_CONF: $DIR_CONF" | ts '%Y-%m-%d %H-%M-%S [INFO]'
echo "DIR_DATA: $DIR_DATA" | ts '%Y-%m-%d %H-%M-%S [INFO]'
echo "DIR_TARG: $DIR_TARG" | ts '%Y-%m-%d %H-%M-%S [INFO]'
sleep 1


# load app configuration from conf.file
source $DIR_CONF/conf.txt
export $(cut -d= -f1 $DIR_CONF/conf.txt)
echo $(cut -d= -f1 $DIR_CONF/conf.txt)
sleep 1
