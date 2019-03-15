#!/bin/bash



echo "`date '+%Y-%m-%d %H:%M:%S'` [INFO] STARTING 'start_app_analyzer.sh' script..."

FlagContinue=1
until [ ${FlagContinue} = 1 ]
do
  # never ending loop
  echo "`date '+%Y-%m-%d %H:%M:%S'` [INFO] starting app"
  # run analyzer
  echo "`date '+%Y-%m-%d %H:%M:%S'` [INFO] stopping app"
  # do x times and print result
  sleep 60
done

echo "`date '+%Y-%m-%d %H:%M:%S'` [INFO] STOPPING 'start_app_analyzer.sh' script..."

