build:
	docker build -t akhlakm/hadoop-base ./HadoopBase
	docker build -t akhlakm/hadoop-namenode ./NameNode
	docker build -t akhlakm/hadoop-datanode ./DataNode
	docker build -t akhlakm/hadoop-yarn ./Yarn

run:
	docker compose up -d --remove-orphans

stop:
	docker compose down

fs:
	# Mount the host home directory to /home
	# Then files can be transfered to HDFS using `hadoop fs -fs http://localhost:9000/`
	# You may set an alias to it.
	docker run -it --network=host -v ~/:/home akhlakm/hadoop-base bash

