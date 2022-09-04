FROM akhlakm/hadoop-base

# make sure port is not being used
HEALTHCHECK CMD curl -f http://localhost:9000/ || exit 1

# create namenode directory
RUN mkdir -p /hadoop/dfs/name

# Two ports: one for HDFS at 9000, another for the webserver at 9870
EXPOSE 9870
EXPOSE 9000

# copy the service entry
ADD namenode.sh /namenode.sh 
RUN chmod a+x /namenode.sh 

CMD ["/namenode.sh"]
