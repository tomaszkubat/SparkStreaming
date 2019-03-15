#!/bin/bash

############################################
## move csv files
## from input to output directory
## (simulate data streaming)
############################################


source env.sh   # load variables

# move files from IN to OU directory
for i in $(ls $DIR_IN | sort -n); do
    mv "${DIR_IN}$i" "${DIR_OU}"   # move one file
    echo "${DIR_IN}$i   (added `date`)"
    sleep 30   # wait some time...
done


echo "#######################################"
echo "add_new_file.sh finished"
echo "#######################################"

exit 0 # Success
