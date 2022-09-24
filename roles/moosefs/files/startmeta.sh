#!/usr/bin/env bash

HOST=$1 # current host name
[[ -n $HOST ]]      || exit 1

MDIR=/root/mfsMeta
mkdir -p $MDIR

docker stop mfsMeta 	|| true
docker rm mfsMeta 		|| true

docker build -t akhlakm/mfsmeta MetaLogger
docker run -td -v ${MDIR}:/var/lib/mfs --hostname="${HOST}" --name=mfsMeta akhlakm/mfsmeta

exit $?
