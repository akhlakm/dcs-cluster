#!/bin/bash

# Start datanode
$HADOOP_HOME/bin/hdfs --config $HADOOP_CONF_DIR --daemon start datanode

# Start Node Manager
$HADOOP_HOME/bin/yarn --config $HADOOP_CONF_DIR --daemon start nodemanager

