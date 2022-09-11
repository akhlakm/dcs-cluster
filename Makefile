data = ~/data
port.pg = 5432
port.pgad = 5433
port.spark = 7077
port.sparkUI = 7080
port.sparkMain = 7078
port.sparkPy = 7088
port.sparkHist = 7099
port.hdfs = 9000
port.namenode = 9001
port.yarn = 9002

hadoop:
	docker build -t akhlakm/hadoop-base docker-hadoop/HadoopBase
	docker stop namenode || true
	docker rm namenode || true

	docker build -t akhlakm/hadoop-namenode docker-hadoop/NameNode
	docker run -td \
		-p $(port.hdfs):9000 \
		-p $(port.namenode):9870 \
		-v $(data)/hdfs:/hadoop/dfs \
		--restart=unless-stopped \
		--network=docker \
		--hostname=namenode \
		--name=namenode \
		akhlakm/hadoop-namenode

	docker stop datanode || true
	docker rm datanode || true
	docker build -t akhlakm/hadoop-datanode docker-hadoop/DataNode
	docker run -td \
		-v $(data)/hdfs:/hadoop/dfs \
		--restart=unless-stopped \
		--network=docker \
		--hostname=datanode \
		--name=datanode \
		akhlakm/hadoop-datanode

	docker stop yarn || true
	docker rm yarn || true
	docker build -t akhlakm/hadoop-yarn docker-hadoop/Yarn
	docker run -td \
		-p $(port.yarn):8088 \
		--restart=unless-stopped \
		--network=docker \
		--hostname=yarn \
		--name=yarn \
		akhlakm/hadoop-yarn

spark:
	docker stop spark || true
	docker stop spark-wn || true

	docker rm spark || true
	docker build -t akhlakm/spark ./docker-spark
	docker run -td \
		-p $(port.spark):7077 \
		-p $(port.sparkMain):8080 \
		-p $(port.sparkUI):4040 \
		-p $(port.sparkPy):9888 \
		-p $(port.sparkHist):18080 \
		-v $(data)/spark:/data \
		-e SPARK_MAIN=1 \
		-e MASTER=spark://spark:7077 \
		--restart=unless-stopped \
		--network=docker \
		--hostname spark \
		--name=spark \
		akhlakm/spark

	docker rm spark-wn || true
	docker run -td \
		-e MASTER=spark://spark:7077 \
		--network=docker \
		--hostname spark-wn \
		--name=spark-wn \
		akhlakm/spark

postgres:
	docker stop postgres || true
	docker rm postgres || true
	docker run -td \
		-p $(pgport):5432 \
		-v $(data)/postgres:/data \
		--env-file=.env \
		--restart=unless-stopped \
		--network=docker \
		--hostname=postgres \
		--name=postgres \
		postgres

	docker volume create pgadmin
	docker stop pgadmin || true
	docker rm pgadmin || true
	docker run -td \
		-p $(port.pgad):80 \
		-v pgadmin:/var/lib/pgadmin \
		--env-file=.env \
		--restart=unless-stopped \
		--network=docker \
		--hostname=pgadmin \
		--name=pgadmin \
		dpage/pgadmin4

nginx:
	docker build -t akhlakm/nginx ./docker-nginx
	docker run -td \
		-p 80:80 \
		--env-file=.env \
		--restart=unless-stopped \
		--network=docker \
		akhlakm/nginx

stop:
	docker stop spark
	docker stop spark-wn
	docker stop namenode
	docker stop datanode
	docker stop yarn

fs:
	# Mount the host home directory to /home
	# Then files can be transfered to HDFS using `hadoop fs -fs http://localhost:9000/`
	# You may set an alias to it.
	docker run -it --network=host -v ~/:/home akhlakm/hadoop-base bash

