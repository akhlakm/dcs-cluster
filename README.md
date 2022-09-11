# home-cluster
These scripts will setup a virtual cluster of the latest version of Apache Hadoop and Spark using Docker containers. 

Install `make` and `docker-ce` first.

Usage:

```bash
make build
make hadoop
make spark
```

Optionally a PostgreSql along with PGAdmin containers can be run.

```bash
make postgres
```

## HDFS and Spark
- HDFS server is hosted at `hdfs://<ip_address>:9000` and Spark master is hosted at `spark://spark:7077`.

## Web UI
- The NameNode of HDFS can be accessed via at `http://<ip_address>:9001`.
- The Yarn ResourceManager at `http://<ip_address>:9002`.
- A jupyter lab instance serving PySpark `http://<ip_address>:7088`.
- Spark History manager at `http://<ip_address>:7099`.

