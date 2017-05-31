#!/bin/sh

./wait.sh elk:9200 #wait for elasticsearch
./wait.sh elk:5044 # wait for logstash
curl -k --user elastic:changeme -XPUT 'https://elk:9200/_template/filebeat?pretty' -d@/etc/filebeat/filebeat.template.json
#/etc/init.d/filebeat start
service filebeat start
mkdir /var/log/filebeat
touch /var/log/filebeat/filebeat.log
#tail -f /var/log/filebeat/filebeat.log
tail -f /var/log/filebeat/filebeat.log & wait