#!/bin/bash

# generate welcome screen

echo "###############################################################################"
echo "#"
echo "# WELCOME IN SPARK APPLICAION!"
echo "#"
echo "# host: `hostname`"
echo "# ip:   `hostname -I`"
echo "# user: `whoami`"
echo "#"
echo "###############################################################################"

# wait a moment to anable reading the baner by user
wait 5

exit 0 # success