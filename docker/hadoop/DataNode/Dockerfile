FROM akhlakm/hadoop-base

# create datanode directory
RUN mkdir -p /hadoop/dfs/data

HEALTHCHECK CMD curl -f http://localhost:9864/ || exit 1


# Data node
EXPOSE 9864

# Node manager
EXPOSE 8042

ADD datanode.sh /datanode.sh 
RUN chmod a+x /datanode.sh

CMD ["/datanode.sh"]
