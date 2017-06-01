#!/bin/sh

./wait.sh -t 30 -h elk -p 9200 #wait for elasticsearch
./wait.sh -t 15 -h elk -p 5044 # wait for logstash
curl -k \
 --user elastic:changeme \
 -X PUT \
 'https://elk:9200/_template/filebeat?pretty' \
 -d@/etc/filebeat/filebeat.template.json
service filebeat start
mkdir /var/log/filebeat
touch /var/log/filebeat/filebeat.log
#tail -f /var/log/filebeat/filebeat.log
tail -f /var/log/filebeat/filebeat.log & wait