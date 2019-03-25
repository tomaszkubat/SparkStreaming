#!/bin/bash
# --------------------------------------------------
# split data by timestamp
# --------------------------------------------------

# add loop - do for each file in location
awk -F, '{print > "data/sensors_"substr($1,0,11)".csv"}' data.csv
