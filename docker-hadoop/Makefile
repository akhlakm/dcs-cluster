build:
	docker build -t akhlakm/hadoop-base ./HadoopBase
	docker build -t akhlakm/hadoop-namenode ./NameNode
	docker build -t akhlakm/hadoop-datanode ./DataNode
	docker build -t akhlakm/hadoop-histmgr ./HistoryManager
	docker build -t akhlakm/hadoop-nodemgr ./NodeManager
	docker build -t akhlakm/hadoop-yarn ./Yarn

run:
	docker compose up -d 

stop:
	docker compose down
