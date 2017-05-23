#!/bin/sh

./wait.sh elk:9200
curl -XPUT 'http://elk:9200/_template/filebeat?pretty' -d@/etc/filebeat/filebeat.template.json
#/etc/init.d/filebeat start
service filebeat start
mkdir /var/log/filebeat
touch /var/log/filebeat/filebeat.log
#tail -f /var/log/filebeat/filebeat.log
tail -f /var/log/filebeat/filebeat.log & wait