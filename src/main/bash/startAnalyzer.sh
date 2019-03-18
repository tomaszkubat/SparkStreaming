#!/bin/bash
###############################################################################
# run Analyzer app
###############################################################################

echo "STARTING ANALYZER SCRIPT" | ts '%Y-%m-%d %H-%M-%S [INFO]'
sleep 2

DIR="$(dirname "$(readlink -f "$0")")" # get file directory
source $DIR/utils/setup.sh # run setup (load parameters)




# run Analyzer app
${SPARK_HOME}/bin/spark-submit \
    --class tk.analysis.Analyzer \
    --master $MASTER \
    --deploy-mode cluster \
    $DIR_TARG/scala-2.11/sparkapps_2.11-0.1.jar


echo "STOPPING ANALYZER SCRIPT" | ts '%Y-%m-%d %H-%M-%S [INFO]'

exit 0 # success

# never ending loop
# FLAGCONTINUE=0
# until [ ${FLAGCONTINUE} < 1 ]; do
#	echo aaa
#  	sleep 1
# done

