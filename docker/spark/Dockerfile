FROM akhlakm/hadoop-base

ENV SPARK_URL=https://dlcdn.apache.org/spark/spark-3.3.0/spark-3.3.0-bin-without-hadoop.tgz

RUN curl -O https://downloads.apache.org/spark/KEYS
RUN gpg --import KEYS

# download, check integrity, extract
RUN set -x \
    && curl -fSL "$SPARK_URL" -o /tmp/spark.tar.gz \
    && curl -fSL "$SPARK_URL.asc" -o /tmp/spark.tar.gz.asc \
    && gpg --verify /tmp/spark.tar.gz.asc \
    && tar -xvf /tmp/spark.tar.gz -C /opt/ \
    && rm /tmp/spark.tar.gz*
RUN mv /opt/spark* /opt/spark

RUN apt-get install -y pip
RUN pip install jupyterlab pandas matplotlib scikit-learn sqlalchemy

ENV SPARK_HOME=/opt/spark
ENV PATH=$SPARK_HOME/sbin:$SPARK_HOME/bin:$PATH
ENV SPARK_DIST_CLASSPATH=/etc/hadoop:/opt/hadoop-3.3.4/share/hadoop/common/lib/*:/opt/hadoop-3.3.4/share/hadoop/common/*:/opt/hadoop-3.3.4/share/hadoop/hdfs:/opt/hadoop-3.3.4/share/hadoop/hdfs/lib/*:/opt/hadoop-3.3.4/share/hadoop/hdfs/*:/opt/hadoop-3.3.4/share/hadoop/mapreduce/*:/opt/hadoop-3.3.4/share/hadoop/yarn:/opt/hadoop-3.3.4/share/hadoop/yarn/lib/*:/opt/hadoop-3.3.4/share/hadoop/yarn/*
ENV PYTHONPATH=${SPARK_HOME}/python:$PYTHONPATH 
ENV PYTHONPATH=${SPARK_HOME}/python/lib/pyspark.zip:$PYTHONPATH
ENV PYTHONPATH=${SPARK_HOME}/python/lib/py4j-0.10.9.5-src.zip:$PYTHONPATH

COPY spark-defaults.conf /opt/spark/conf/spark-defaults.conf
COPY spark-env.sh /opt/spark/conf/spark-env.sh
COPY log4j.properties /opt/spark/conf/log4j.properties

EXPOSE 7077
EXPOSE 9888
EXPOSE 8080

HEALTHCHECK CMD curl -f http://localhost:9888/ || exit 1

ADD spark_session.sh /spark_session.sh 
RUN chmod a+x /spark_session.sh

CMD ["/spark_session.sh"]
