FROM akhlakm/hadoop-base

ENV CLUSTER_NAME Shindook

# make sure port is not being used
HEALTHCHECK CMD curl -f http://localhost:9870/ || exit 1

# create namenode directory
RUN mkdir -p /hadoop/dfs/name
RUN mkdir -p /run/sendsigs.omit.d

RUN echo "#!/bin/sh\nexit 0"

RUN apt-get install -y rpcbind jsvc
ENV HDFS_NFS3_SECURE_USER root
ENV JSVC_HOME /usr/bin/

# copy the service entry
ADD namenode.sh /namenode.sh 
RUN chmod a+x /namenode.sh 

CMD ["/namenode.sh"]
