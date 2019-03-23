#!/bin/bash

#################################################
## simulate data stream -
## move csv files from test directory
## to input directory
#################################################

DIR="$(dirname "$(readlink -f "$0")")" # get file directory
source ${DIR}/setup.sh   # run setup (load parameters)


echo "`date +%Y-%m-%d_%H:%M:%S` INFO move data from: '${DIR_S_TST}'"
echo "`date +%Y-%m-%d_%H:%M:%S` INFO move data to: '${DIR_S_INP}'"


# move test data to input directory
for i in $(ls ${DIR_S_TST} | sort -n); do

    scp "${DIR_S_TST}/$i" usr_spark@slave01:"${DIR_S_INP}" # copy one file to the slave01
    mv "${DIR_S_TST}/$i" "${DIR_S_INP}"   # move one file on master

    echo "`date +%Y-%m-%d_%H:%M:%S` INFO $i copied to slave01" # print status
    echo "`date +%Y-%m-%d_%H:%M:%S` INFO $i moved to `hostname`" # print status
    echo "`date +%Y-%m-%d_%H:%M:%S` INFO waiting ${STREAMER_REFRESH_INTERVAL} seconds..."

    sleep ${STREAMER_REFRESH_INTERVAL}   # wait some time...

done


echo "***\n`date +%Y-%m-%d_%H:%M:%S` INFO simulateDataStream.sh finished" # final info

exit 0 # Success