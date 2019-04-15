# About this project
This document is a short brochure about my postgraduate project with Apache Spark Structured Streaming in action. Full documentation can be found here ![documentation](https://github.com/tomaszkubat/SparkStreaming/tree/master/doc/documentation.pdf)

**Project contains**:
- two small Scala applications (**Streamer, Analyzer**),
- map visualization in R (**VisualizeR**),
- a few **additional bash scripts** to ensure handy operating with applications.

Whole solution is rather an example (small Spark in-action demo) than a production-ready solution. In the documentation are enclosed some annotations about possibloe prodctions upgrades. E.g. it would be great to use Apache Kafka Streams as a data broker to provide fully data integration and streaming solution, which i didn't use, because it was out of scope.


# Purpose&solution
My goal was to analyze air pollution data from Lombardia (Italy), publicized by ARPA Agency Regional Agency for Environmental Protection). Data and more details about it can be found here: ![datasets](https://dati.lombardia.it/stories/s/auv9-c2sj). We face a few issues, because data:  
- are generated hourly by ~950 sensors simultaneously (**frequency**),
- concern various (17) sensor type (**diversity**),
- have broad history (data bask to 1968) and to prepare reasonable presentation it's required to load a data from a few years (**amount**).

To achieve our goal we have to operate on set of different technologies - Spark, Spark Structured Streanming, R, bash. Suggested architecture is presented below: ![architecture](https://github.com/tomaszkubat/SparkStreaming/tree/master/doc/img/fin/cluster.png).
Thre main applications are used: **Streamer**, **Analyzer**, **VisualizeR**. To perform streaming/analyzing operations we use the Spark mini-cluster, which contains two, phisicaly separated, machines:
![Spark cluster](https://github.com/tomaszkubat/SparkStreaming/tree/master/doc/img/fin/architecture.png).


# Configuration
Befor running an applications some configuration steps are required. Configuration process was described in the documentations 'Configuration' section: ![documentation](https://github.com/tomaszkubat/SparkStreaming/tree/master/doc/documentation.pdf)


# Runing applications
### Runing Spark cluster in standalone mode
1) Ensure, that machines you are supposed to use are running.
2) Log to the master node as 'usr_spark' user
3) **Run Spark cluster**:
```bash
# navigate to Spark Home
$ cd $SPARK_HOME
# use predefined script to run cluster
$ ./sbin/start-all.sh
# wait a while
```
4a) Check if cluster is running:
* terminal:
```bash
$ jps
# worker and master processes should be visible
```
* webui - open web brbowser and type 'localhost:8080'. Webpages with master and workers details should be availible.


### Prepare broder data (option)
To test the applications **you can use a small example dataset it is absolutely fine. If you would like to see aplication handling with broader historical data, it's necesary to make some pre-steps**:
1) muanualy download the data from ![ARPA page](https://dati.lombardia.it/stories/s/auv9-c2sj)
2) use provided script to split the data:
```bash
# navigate to directory with downloaded files
$ cd /home/usr_spark/Downloads
# use script to split data
$ .$SPARK_APP/src/maiin/bash/utils/splitTestData.sh
# copy files to 'testData' directory
$ cp * $SPARK_APP/data/stream/testData
```
