#!/bin/bash
###############################################################################
# run Analyzer app
###############################################################################


DIR="$(dirname "$(readlink -f "$0")")" # get file directory
source $DIR/utils/setup.sh # run setup (load parameters)



# Run Analyzer in never ending loop :)
while true
do

    echo -e "***\n`date +%Y-%m-%d_%H:%M:%S` INFO  Connecting Analyzer to cluster ${MASTER}"
    sleep 1

	${SPARK_HOME}/bin/spark-submit \
        --class tk.analysis.Analyzer \
        --master ${MASTER} \
        --deploy-mode cluster \
        --driver-memory 512M \
	--conf spark.cores.max=2 \
        --conf spark.executor.memory=5g \
        $DIR_TARG/scala-2.11/sparkapps_2.11-0.1.jar ${MASTER} ${ANALYZER_MIN_EFFICIENCY} ${DIR_DATA}

    echo "`date +%Y-%m-%d_%H:%M:%S` INFO  Analyzer was being run"
    echo -e "***\nNext run starts in ${ANALYZER_REFRESH_INTERVAL} seconds.\nDon't kill this process."
  	sleep ${ANALYZER_REFRESH_INTERVAL}

done


exit 0 # success
