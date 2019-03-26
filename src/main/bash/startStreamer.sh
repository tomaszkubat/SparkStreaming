#!/bin/bash
###############################################################################
# run Streamer app
###############################################################################


DIR="$(dirname "$(readlink -f "$0")")" # get file directory
source $DIR/utils/setup.sh # run setup (load parameters)



echo -e "***\n`date +%Y-%m-%d_%H:%M:%S` INFO  Connecting Streamer to cluster ${MASTER}"
sleep 1

${SPARK_HOME}/bin/spark-submit \
    --class tk.stream.Streamer \
    --master ${MASTER} \
    --deploy-mode cluster \
    --driver-memory 512M \
    --conf spark.executor.memory=4g \
    --conf spark.cores.max=3 \
    $DIR_TARG/scala-2.11/sparkapps_2.11-0.1.jar ${MASTER} ${STREAMER_REFRESH_INTERVAL} ${DIR_DATA}

echo "`date +%Y-%m-%d_%H:%M:%S` INFO  Streamer was being run"


exit 0 # success