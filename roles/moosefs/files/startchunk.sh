#!/usr/bin/env bash

HOST=$1 # current host name
PORT=$2 # port for the chunkserver
CDIR=$3 # directory to store chunks

[[ -n $HOST ]]      || exit 1
[[ -n $PORT ]]      || exit 2
[[ -n $CDIR ]]      || exit 3

IP=`grep $HOST /etc/hosts | awk '{print $1}'`

if [[ -z $IP ]]
then
    echo "Can't determine IP for $HOST"
    exit 10
fi

CONTAINER="mfsChunk$PORT"

docker stop $CONTAINER 	    || true
docker rm $CONTAINER 		|| true

docker build -t akhlakm/mfschunk ChunkServer
docker run -td -p $PORT:$PORT -v ${CDIR}:/data --hostname="${IP}-$PORT" --name=$CONTAINER akhlakm/mfschunk

exit $?
