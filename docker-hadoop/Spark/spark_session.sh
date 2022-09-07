#!/bin/bash

if [[ -z $SPARK_MAIN ]]; then
    start-worker.sh &
    wait
else
    start-master.sh &
    sleep 5
    pyspark
    wait
fi
