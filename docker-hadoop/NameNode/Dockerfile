FROM akhlakm/hadoop-base

ENV CLUSTER_NAME Shindook

# make sure port is not being used
HEALTHCHECK CMD curl -f http://localhost:9870/ || exit 1

# create namenode directory
RUN mkdir -p /hadoop/dfs/name

# HDFS at 9000, webserver at 9870
EXPOSE 9000
EXPOSE 9870

# NFS
EXPOSE 2049
EXPOSE 4242

# copy the service entry
ADD namenode.sh /namenode.sh 
RUN chmod a+x /namenode.sh 

CMD ["/namenode.sh"]
