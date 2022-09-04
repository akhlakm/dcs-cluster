FROM akhlakm/hadoop-base

# create namenode directory
RUN mkdir -p /hadoop/dfs/data

HEALTHCHECK CMD curl -f http://localhost:8188/ || exit 1
EXPOSE 8188

ADD history_manager.sh /history_manager.sh 
RUN chmod a+x /history_manager.sh

CMD ["/history_manager.sh"]
