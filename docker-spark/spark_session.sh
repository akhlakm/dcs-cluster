#!/bin/bash

mkdir -p /tmp/spark-events

if [[ -z $SPARK_MAIN ]]; then
    start-worker.sh $MASTER
    cat
else
    start-master.sh &
    sleep 5
    start-history-server.sh &
    pyspark
fi
