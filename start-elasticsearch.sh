#!/bin/bash
chown -R elasticsearch:elasticsearch /usr/share/elasticsearch/data
chown -R elasticsearch:elasticsearch /etc/elasticsearch
chown -R elasticsearch:elasticsearch /var/log/elasticsearch

sysctl -w vm.max_map_count=262144
exec /sbin/setuser elasticsearch elasticsearch -Epath.conf=/etc/elasticsearch 

