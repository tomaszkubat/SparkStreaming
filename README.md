# About this project
This document is a short brochure about my postgraduate project with Apache Spark Structured Streaming in action. Full documentation can be found here ![documentation](https://github.com/tomaszkubat/SparkStreaming/tree/master/doc/documentation.pdf)

**Project contains**:
- two small Scala applications (**Streamer, Analyzer**),
- map visualization in R (**VisualizeR**),
- a few additional bash scripts to ensure handy operating with applications.

Whole solution is rather an example (small Spark in-action demo) than a production-ready solution. In the documentation are enclosed some annotations about possibloe prodctions upgrades. E.g. it would be great to use Apache Kafka Streams as a data broker to provide fully data integration and streaming solution, which i didn't use, because it was out of scope.


# Purpose
My goal was to analyze air pollution data from Lombardia (Italy), publicized by ARPA Agency Regional Agency for Environmental Protection). We faced a few issues, because data:  
- are generated hourly by ~950 sensors simultaneously (**frequency**),
- concern various (17) sensor type (**diversity**),
- have broad history (data bask to 1968) and to prepare reasonable presentation it's required to load a data from a few years (**amount**).

Data and more details about datasets can be found here: ![datasets](https://dati.lombardia.it/stories/s/auv9-c2sj)


# Solution



![architecture](https://github.com/tomaszkubat/SparkStreaming/tree/master/doc/img/fin/cluster.png)

![architecture](https://github.com/tomaszkubat/SparkStreaming/tree/master/doc/img/fin/architecture.png)



# Configuration
Befor running an applications some configuration steps are required. Configuration process was described in the documentations 'Configuration' section: ![documentation](https://github.com/tomaszkubat/SparkStreaming/tree/master/doc/documentation.pdf)


# Runing applications
