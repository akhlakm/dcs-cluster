#!/bin/bash

function addProperty() {
    local path=$1
    local name=$2
    local value=$3

    echo "SET $name=$value in $path"

    local entry="<property><name>$name</name><value>${value}</value></property>"
    local escapedEntry=$(echo $entry | sed 's/\//\\\//g')
    sed -i "/<\/configuration>/ s/.*/${escapedEntry}\n&/" $path
}

if [ -z "$CLUSTER_NAME" ]; then
    echo "Cluster name not specified"
    exit 2
fi

addProperty /etc/hadoop/hdfs-site.xml dfs.namenode.name.dir $NAMENODE_DIR

if [ "`ls -A $NAMENODE_DIR`" == "" ]; then
    echo "Formatting namenode directory: $NAMENODE_DIR"
    $HADOOP_HOME/bin/hdfs --config $HADOOP_CONF_DIR namenode -format $CLUSTER_NAME
fi

# Start namenode
$HADOOP_HOME/bin/hdfs --config $HADOOP_CONF_DIR namenode
