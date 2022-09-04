FROM akhlakm/hadoop-base

# create namenode directory
RUN mkdir -p /hadoop/dfs/data

HEALTHCHECK CMD curl -f http://localhost:9864/ || exit 1
EXPOSE 9864

ADD datanode.sh /datanode.sh 
RUN chmod a+x /datanode.sh

CMD ["/datanode.sh"]
