#!/bin/bash

#################################################
## clean input directory -
## remove files from the slaves
## move files on the master
#################################################

DIR="$(dirname "$(readlink -f "$0")")" # get file directory
source ${DIR}/setup.sh   # run setup (load parameters)


ssh slave01 rm ${DIR_S_INP}/*_sensors.csv # [slave01] remove all sencors.csv files from INP directory
mv ${DIR_S_INP}/*_sensors.csv ${DIR_S_TST} # [master] move all sensors csv files from OU to IN directory


echo "`date +%Y-%m-%d_%H:%M:%S` INFO slave01: files deleted"
echo "`date +%Y-%m-%d_%H:%M:%S` INFO master: files moved from: '${DIR_S_INP}' to '${DIR_S_TST}'"
echo -e "***\n`date +%Y-%m-%d_%H:%M:%S` INFO cleanDataStreamDir.sh finished" # final info

exit 0 # Success