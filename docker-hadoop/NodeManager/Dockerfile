FROM akhlakm/hadoop-base

# create namenode directory
RUN mkdir -p /hadoop/dfs/data

HEALTHCHECK CMD curl -f http://localhost:8042/ || exit 1
EXPOSE 8042

ADD node_manager.sh /node_manager.sh 
RUN chmod a+x /node_manager.sh

CMD ["/node_manager.sh"]
