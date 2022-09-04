FROM debian

# do not install UI packages
ENV DEBIAN_FRONTEND noninteractive

# debian removed jdk-8 support, so use the older 'stretch' repo
RUN apt-get update && apt-get install -y software-properties-common
RUN apt-add-repository 'deb http://security.debian.org/debian-security stretch/updates main'
RUN apt-get update

RUN apt-get install -y openjdk-8-jdk \
	net-tools \
	curl \
	netcat \
	gnupg \
	ssh \
	pdsh

ENV JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64
ENV PATH $JAVA_HOME/bin:$PATH

# hadoop package integrity keys
RUN curl -O https://dlcdn.apache.org/hadoop/common/KEYS
RUN gpg --import KEYS

ENV HADOOP_VERSION 3.3.4
ENV HADOOP_URL https://dlcdn.apache.org/hadoop/common/stable/hadoop-${HADOOP_VERSION}.tar.gz

# download, check integrity, extract
RUN set -x \
    && curl -fSL "$HADOOP_URL" -o /tmp/hadoop.tar.gz \
    && curl -fSL "$HADOOP_URL.asc" -o /tmp/hadoop.tar.gz.asc \
    && gpg --verify /tmp/hadoop.tar.gz.asc \
    && tar -xvf /tmp/hadoop.tar.gz -C /opt/ \
    && rm /tmp/hadoop.tar.gz*

# symlink config directory
RUN ln -s /opt/hadoop-$HADOOP_VERSION/etc/hadoop /etc/hadoop

ENV HADOOP_HOME=/opt/hadoop-$HADOOP_VERSION

ENV PATH $HADOOP_HOME/bin/:$PATH

ENV HADOOP_CONF_DIR=/etc/hadoop

RUN mkdir /opt/hadoop-$HADOOP_VERSION/logs

RUN mkdir /hadoop-data

ENV USER=root

# Setup configurations
ADD setup.sh /setup.sh
RUN chmod a+x /setup.sh
# RUN bash /setup.sh

# Use entrypoint, so the current image is an executable, not a service
ENTRYPOINT [ "/setup.sh" ]
