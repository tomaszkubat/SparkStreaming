#!/bin/bash

# remove spaces and special characters before
# easy script - move to documentation if one line
awk -F, '{print>$1}' data.csv
