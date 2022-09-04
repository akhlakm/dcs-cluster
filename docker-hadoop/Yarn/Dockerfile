FROM akhlakm/hadoop-base

# create namenode directory
RUN mkdir -p /hadoop/dfs/data

HEALTHCHECK CMD curl -f http://localhost:8088/ || exit 1
EXPOSE 8088

ADD resource_manager.sh /resource_manager.sh 
RUN chmod a+x /resource_manager.sh

CMD ["/resource_manager.sh"]
