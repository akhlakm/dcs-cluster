#!/bin/bash

mkdir -p /tmp/spark-events

if [[ -z $SPARK_MAIN ]]; then
    start-worker.sh $MASTER
    cat
else
    start-master.sh &
    sleep 5
    start-history-server.sh &

    # jupyter lab
    export PYSPARK_DRIVER_PYTHON='jupyter-lab'
    export PYSPARK_DRIVER_PYTHON_OPTS='--allow-root --NotebookApp.token='' --NotebookApp.password='' --no-browser --ip 0.0.0.0 --port=9888'
    pyspark
fi
