#!/bin/bash

# Start Node Manager
$HADOOP_HOME/bin/yarn --config $HADOOP_CONF_DIR nodemanager &

# Start datanode
$HADOOP_HOME/bin/hdfs --config $HADOOP_CONF_DIR datanode
