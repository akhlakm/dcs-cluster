#!/bin/bash

# Set some sensible defaults
export DEFAULT_FS=${DEFAULT_FS:-hdfs://`hostname -f`:9000}

function addProperty() {
    local path=$1
    local name=$2
    local value=$3

    echo "SET $name=$value in $path"

    local entry="<property><name>$name</name><value>${value}</value></property>"
    local escapedEntry=$(echo $entry | sed 's/\//\\\//g')
    sed -i "/<\/configuration>/ s/.*/${escapedEntry}\n&/" $path
}

# HADOOP
addProperty /etc/hadoop/core-site.xml fs.defaultFS ${DEFAULT_FS}
addProperty /etc/hadoop/core-site.xml hadoop.http.staticuser.user root
addProperty /etc/hadoop/core-site.xml hadoop.proxyuser.hue.hosts *
addProperty /etc/hadoop/core-site.xml hadoop.proxyuser.hue.groups *
addProperty /etc/hadoop/core-site.xml io.compression.codecs org.apache.hadoop.io.compress.SnappyCodec

# HDFS
addProperty /etc/hadoop/hdfs-site.xml dfs.namenode.rpc-bind-host 0.0.0.0
addProperty /etc/hadoop/hdfs-site.xml dfs.namenode.servicerpc-bind-host 0.0.0.0
addProperty /etc/hadoop/hdfs-site.xml dfs.namenode.http-bind-host 0.0.0.0
addProperty /etc/hadoop/hdfs-site.xml dfs.namenode.https-bind-host 0.0.0.0
addProperty /etc/hadoop/hdfs-site.xml dfs.client.use.datanode.hostname true
addProperty /etc/hadoop/hdfs-site.xml dfs.datanode.use.datanode.hostname true
addProperty /etc/hadoop/hdfs-site.xml dfs.webhdfs.enabled true
addProperty /etc/hadoop/hdfs-site.xml dfs.permissions.enabled false
addProperty /etc/hadoop/hdfs-site.xml dfs.namenode.datanode.registration.ip-hostname-check false

# YARN
addProperty /etc/hadoop/yarn-site.xml yarn.resourcemanager.bind-host 0.0.0.0
addProperty /etc/hadoop/yarn-site.xml yarn.nodemanager.bind-host 0.0.0.0
addProperty /etc/hadoop/yarn-site.xml yarn.timeline-service.bind-host 0.0.0.0
addProperty /etc/hadoop/yarn-site.xml yarn.log-aggregation-enable true
addProperty /etc/hadoop/yarn-site.xml yarn.log.server.url http://historyserver:8188/applicationhistory/logs/
addProperty /etc/hadoop/yarn-site.xml yarn.resourcemanager.recovery.enabled true
addProperty /etc/hadoop/yarn-site.xml yarn.resourcemanager.store.class org.apache.hadoop.yarn.server.resourcemanager.recovery.FileSystemRMStateStore
addProperty /etc/hadoop/yarn-site.xml yarn.resourcemanager.scheduler.class org.apache.hadoop.yarn.server.resourcemanager.scheduler.capacity.CapacityScheduler
addProperty /etc/hadoop/yarn-site.xml yarn.scheduler.capacity.root.default.maximum-allocation-mb 8192
addProperty /etc/hadoop/yarn-site.xml yarn.scheduler.capacity.root.default.maximum-allocation-vcores 4
addProperty /etc/hadoop/yarn-site.xml yarn.resourcemanager.fs.state-store.uri /rmstate
addProperty /etc/hadoop/yarn-site.xml yarn.resourcemanager.system-metrics-publisher.enabled true
addProperty /etc/hadoop/yarn-site.xml yarn.resourcemanager.hostname resourcemanager
addProperty /etc/hadoop/yarn-site.xml yarn.resourcemanager.address resourcemanager:8032
addProperty /etc/hadoop/yarn-site.xml yarn.resourcemanager.scheduler.address resourcemanager:8030
addProperty /etc/hadoop/yarn-site.xml yarn.resourcemanager.resource-tracker.address resourcemanager:8031
addProperty /etc/hadoop/yarn-site.xml yarn.timeline-service.enabled true
addProperty /etc/hadoop/yarn-site.xml yarn.timeline-service.generic-application-history.enabled true
addProperty /etc/hadoop/yarn-site.xml yarn.timeline-service.hostname historyserver
addProperty /etc/hadoop/yarn-site.xml mapreduce.map.output.compress true
addProperty /etc/hadoop/yarn-site.xml mapred.map.output.compress.codec org.apache.hadoop.io.compress.SnappyCodec
addProperty /etc/hadoop/yarn-site.xml yarn.nodemanager.resource.memory-mb 16384
addProperty /etc/hadoop/yarn-site.xml yarn.nodemanager.resource.cpu-vcores 8
addProperty /etc/hadoop/yarn-site.xml yarn.nodemanager.disk-health-checker.max-disk-utilization-per-disk-percentage 98.5
addProperty /etc/hadoop/yarn-site.xml yarn.nodemanager.remote-app-log-dir /app-logs
addProperty /etc/hadoop/yarn-site.xml yarn.nodemanager.aux-services mapreduce.shuffle

# MAPRED
addProperty /etc/hadoop/mapred-site.xml yarn.nodemanager.bind-host 0.0.0.0
addProperty /etc/hadoop/mapred-site.xml mapreduce.framework.name yarn
addProperty /etc/hadoop/mapred-site.xml mapred.child.java.opts -Xmx4096m
addProperty /etc/hadoop/mapred-site.xml mapreduce.map.memory.mb 4096
addProperty /etc/hadoop/mapred-site.xml mapreduce.reduce.memory.mb 8192
addProperty /etc/hadoop/mapred-site.xml mapreduce.map.java.opts -Xmx3072m
addProperty /etc/hadoop/mapred-site.xml mapreduce.reduce.java.opts -Xmx6144m
addProperty /etc/hadoop/mapred-site.xml yarn.app.mapreduce.am.env HADOOP.MAPRED.HOME=/opt/hadoop-3.3.4/
addProperty /etc/hadoop/mapred-site.xml mapreduce.map.env HADOOP.MAPRED.HOME=/opt/hadoop-3.3.4/
addProperty /etc/hadoop/mapred-site.xml mapreduce.reduce.env HADOOP.MAPRED.HOME=/opt/hadoop-3.3.4/