#!/bin/bash

if [ -z "$CLUSTER_NAME" ]; then
    echo "CLUSTER_NAME not specified"
    exit 2
fi

if [ "`ls -A /hadoop/dfs/name`" == "" ]; then
    echo "Formatting namenode directory: /hadoop/dfs/name"
    $HADOOP_HOME/bin/hdfs --config $HADOOP_CONF_DIR namenode -format $CLUSTER_NAME
fi

$HADOOP_HOME/bin/hdfs --config $HADOOP_CONF_DIR --daemon start portmap

$HADOOP_HOME/bin/hdfs --config $HADOOP_CONF_DIR namenode &

sleep 5
$HADOOP_HOME/bin/hdfs --config $HADOOP_CONF_DIR nfs3 

wait
