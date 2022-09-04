FROM ubuntu

RUN apt update && apt upgrade -y

RUN apt install -y openjdk-8-jdk \
	net-tools \
	curl \
	netcat \
	gnupg \
	ssh \
	pdsh

ENV JAVA_HOME=/usr/lib/java/openjdk-8-jdk/

RUN curl -O https://dlcdn.apache.org/hadoop/common/KEYS

RUN gpg --import KEYS

ENV HADOOP_VERSION 3.3.4

ENV HADOOP_URL https://dlcdn.apache.org/hadoop/common/stable/hadoop-${HADOOP_VERSION}.tar.gz


RUN set -x \
    && curl -fSL "$HADOOP_URL" -o /tmp/hadoop.tar.gz \
    && curl -fSL "$HADOOP_URL.asc" -o /tmp/hadoop.tar.gz.asc \
    && gpg --verify /tmp/hadoop.tar.gz.asc \
    && tar -xvf /tmp/hadoop.tar.gz -C /opt/ \
    && rm /tmp/hadoop.tar.gz*

RUN ln -s /opt/hadoop-$HADOOP_VERSION/etc/hadoop /etc/hadoop

ENV HADOOP_HOME=/opt/hadoop-$HADOOP_VERSION

ENV PATH $HADOOP_HOME/bin/:$PATH

ENV HADOOP_CONF_DIR=/etc/hadoop

RUN mkdir /opt/hadoop-$HADOOP_VERSION/logs

RUN mkdir /hadoop-data

ENV USER=root

