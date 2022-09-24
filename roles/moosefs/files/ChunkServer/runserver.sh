#!/bin/bash

echo "HOSTNAME: $HOSTNAME"
echo "IPs: $(hostname -I)"

cat /etc_hosts >> /etc/hosts
cat /etc/hosts

sleep 1
mfschunkserver -f start

echo "Exiting ..!"

