#!/bin/bash

if [ -z "$CLUSTER_NAME" ]; then
    echo "Cluster name not specified"
    exit 2
fi

if [ "`ls -A $NAMENODE_DIR`" == "" ]; then
    echo "Formatting namenode directory: $NAMENODE_DIR"
    $HADOOP_HOME/bin/hdfs --config $HADOOP_CONF_DIR namenode -format $CLUSTER_NAME
fi

# Start namenode
$HADOOP_HOME/bin/hdfs --config $HADOOP_CONF_DIR namenode
