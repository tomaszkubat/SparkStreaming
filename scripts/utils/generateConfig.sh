#!/bin/bash



# fhis is a subscript for running each a[pplication

############################################
## load static paramethers from config.txt
############################################
source config.txt
export $(cut -d= -f1 config.txt)


# CONFIG_DIR="$(dirname "$(readlink -f "$0")")"
# echo $CONFIG_DIR

############################################
## export to a file
############################################
#DIR="../data/"
#DIR_IN="${DIR}test/"
#DIR_OU="${DIR}input/"
