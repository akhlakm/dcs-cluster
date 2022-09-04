#!/bin/bash

if [ -z "$CLUSTER_NAME" ]; then
    echo "Cluster name not specified"
    exit 2
fi

if [ "`ls -A /hadoop/dfs/name`" == "" ]; then
    echo "Formatting namenode directory: /hadoop/dfs/name"
    $HADOOP_HOME/bin/hdfs --config $HADOOP_CONF_DIR namenode -format $CLUSTER_NAME
fi

# Start namenode
$HADOOP_HOME/bin/hdfs --config $HADOOP_CONF_DIR namenode
