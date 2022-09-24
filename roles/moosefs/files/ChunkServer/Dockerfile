FROM debian

RUN apt-get update && apt-get install -y \
	curl \
	gnupg2

RUN curl https://ppa.moosefs.com/moosefs.key | apt-key add -
RUN echo "deb [arch=amd64] http://ppa.moosefs.com/moosefs-3/apt/debian/bullseye bullseye main" > /etc/apt/sources.list.d/moosefs.list

RUN apt-get update && apt-get install -y \
	moosefs-chunkserver

COPY mfschunk.cfg /etc/mfs/mfschunkserver.cfg
COPY mfshdd.cfg /etc/mfs/mfshdd.cfg
COPY etc_hosts /etc_hosts

COPY runserver.sh /runserver.sh
RUN chmod +x /runserver.sh

CMD ["/runserver.sh"]

