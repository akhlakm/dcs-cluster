#!/bin/bash

# Address of the NameNode.
# DataNodes will connect to this address.
export DEFAULT_FS=hdfs://namenode:9000

function addProperty() {
    local path=/etc/hadoop/$1
    local name=$2
    local value=$3

    # echo "SET $name=$value to $1"

    local entry="<property><name>$name</name><value>${value}</value></property>"
    local escapedEntry=$(echo $entry | sed 's/\//\\\//g')
    sed -i "/<\/configuration>/ s/.*/${escapedEntry}\n&/" $path
}

# HADOOP
addProperty core-site.xml fs.defaultFS ${DEFAULT_FS}
addProperty core-site.xml hadoop.http.staticuser.user root
addProperty core-site.xml hadoop.proxyuser.hue.hosts *
addProperty core-site.xml hadoop.proxyuser.hue.groups *
addProperty core-site.xml io.compression.codecs org.apache.hadoop.io.compress.SnappyCodec

# HDFS
addProperty hdfs-site.xml dfs.namenode.name.dir /hadoop/dfs/name
addProperty hdfs-site.xml dfs.datanode.data.dir /hadoop/dfs/data
addProperty hdfs-site.xml dfs.namenode.rpc-bind-host 0.0.0.0
addProperty hdfs-site.xml dfs.namenode.servicerpc-bind-host 0.0.0.0
addProperty hdfs-site.xml dfs.namenode.http-bind-host 0.0.0.0
addProperty hdfs-site.xml dfs.namenode.https-bind-host 0.0.0.0
addProperty hdfs-site.xml dfs.client.use.datanode.hostname true
addProperty hdfs-site.xml dfs.datanode.use.datanode.hostname true
addProperty hdfs-site.xml dfs.webhdfs.enabled true
addProperty hdfs-site.xml dfs.permissions.enabled false
addProperty hdfs-site.xml dfs.namenode.datanode.registration.ip-hostname-check false

# YARN
addProperty yarn-site.xml yarn.resourcemanager.bind-host 0.0.0.0
addProperty yarn-site.xml yarn.nodemanager.bind-host 0.0.0.0
addProperty yarn-site.xml yarn.timeline-service.bind-host 0.0.0.0
addProperty yarn-site.xml yarn.log-aggregation-enable true
addProperty yarn-site.xml yarn.log.server.url http://historyserver:8188/applicationhistory/logs/
addProperty yarn-site.xml yarn.resourcemanager.recovery.enabled true
addProperty yarn-site.xml yarn.resourcemanager.store.class org.apache.hadoop.yarn.server.resourcemanager.recovery.FileSystemRMStateStore
addProperty yarn-site.xml yarn.resourcemanager.scheduler.class org.apache.hadoop.yarn.server.resourcemanager.scheduler.capacity.CapacityScheduler
addProperty yarn-site.xml yarn.scheduler.capacity.root.default.maximum-allocation-mb 8192
addProperty yarn-site.xml yarn.scheduler.capacity.root.default.maximum-allocation-vcores 4
addProperty yarn-site.xml yarn.resourcemanager.fs.state-store.uri /rmstate
addProperty yarn-site.xml yarn.resourcemanager.system-metrics-publisher.enabled true
addProperty yarn-site.xml yarn.resourcemanager.hostname resourcemanager
addProperty yarn-site.xml yarn.resourcemanager.address resourcemanager:8032
addProperty yarn-site.xml yarn.resourcemanager.scheduler.address resourcemanager:8030
addProperty yarn-site.xml yarn.resourcemanager.resource-tracker.address resourcemanager:8031
addProperty yarn-site.xml yarn.timeline-service.enabled true
addProperty yarn-site.xml yarn.timeline-service.generic-application-history.enabled true
addProperty yarn-site.xml yarn.timeline-service.hostname historyserver
addProperty yarn-site.xml mapreduce.map.output.compress true
addProperty yarn-site.xml mapred.map.output.compress.codec org.apache.hadoop.io.compress.SnappyCodec
addProperty yarn-site.xml yarn.nodemanager.resource.memory-mb 16384
addProperty yarn-site.xml yarn.nodemanager.resource.cpu-vcores 8
addProperty yarn-site.xml yarn.nodemanager.disk-health-checker.max-disk-utilization-per-disk-percentage 98.5
addProperty yarn-site.xml yarn.nodemanager.remote-app-log-dir /app-logs
addProperty yarn-site.xml yarn.nodemanager.aux-services mapreduce.shuffle

# MAPRED
addProperty mapred-site.xml yarn.nodemanager.bind-host 0.0.0.0
addProperty mapred-site.xml mapreduce.framework.name yarn
addProperty mapred-site.xml mapred.child.java.opts -Xmx4096m
addProperty mapred-site.xml mapreduce.map.memory.mb 4096
addProperty mapred-site.xml mapreduce.reduce.memory.mb 8192
addProperty mapred-site.xml mapreduce.map.java.opts -Xmx3072m
addProperty mapred-site.xml mapreduce.reduce.java.opts -Xmx6144m
addProperty mapred-site.xml yarn.app.mapreduce.am.env HADOOP.MAPRED.HOME=/opt/hadoop-3.3.4/
addProperty mapred-site.xml mapreduce.map.env HADOOP.MAPRED.HOME=/opt/hadoop-3.3.4/
addProperty mapred-site.xml mapreduce.reduce.env HADOOP.MAPRED.HOME=/opt/hadoop-3.3.4/

exec $@