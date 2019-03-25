#!/bin/bash

# --------------------------------------------------
# split data by first column
# c - number of column used to split data (DEFAULT: 1)
# d - directory with files fo split (default: current directory)
# --------------------------------------------------


# get parameters (flags method)
while getopts c:d: option
do
    case "${option}" in
        c) COL=${OPTARG};; # COL - number of column used to split data
        d) DIR=${OPTARG};; # DIR - files location
    esac
done


# set default values for undeclared variables
if [ -z ${DIR+x} ]; then DIR=`pwd`; fi
if [ -z ${COL+x} ]; then COL=1; fi


# check if temporary directory exists
# if [ ! -d ${DIR}/tmp ]; then
#   mkdir ${DIR}/tmp # create subfolder if doesn't know exist
# fi


echo "`date +%Y-%m-%d_%H:%M:%S` INFO starting script..."
sleep 1
echo "***"


# split each file in directory by given column
for file in $(ls ${DIR} | grep csv | sort -n); do

    awk -F, -v col=${COL} 'FNR > 1 {print > "sensors_"substr($col,7,4)substr($col,4,2)substr($col,1,2)".csv"}' ${DIR}/${file} # split data
    # '-F,' - use comma separator
    # '-v col=${COL}' - use COL variable in awk command
    # 'FNR > 1' - remove first line (header)

    echo "`date +%Y-%m-%d_%H:%M:%S` INFO file ${file} splited"  # print info

done


echo -e "***\n`date +%Y-%m-%d_%H:%M:%S` INFO splitTestData.sh finished, have a nice day" # final info

exit 0 # Success