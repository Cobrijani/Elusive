#!/bin/sh
ES_USER=elastic
ES_PASS=changeme
ES_URL=es
ES_PORT=9200
LOGSTASH_URL=logstash
LOGSTASH_PORT=5044

./wait.sh -t 300 -h ${ES_URL} -p ${ES_PORT} #wait for elasticsearch
./wait.sh -t 15 -h ${LOGSTASH_URL} -p ${LOGSTASH_PORT} # wait for logstashŁ

./usr/share/packetbeat/scripts/import_dashboards \
  -es https://${ES_URL}:${ES_PORT} \
  -cacert /etc/pki/tls/certs/ca.pem \
  -insecure \
  -user ${ES_USER} \
  -pass ${ES_PASS} \
  -i ${INDEX_NAME}

/etc/init.d/packetbeat start -e

mkdir -p /var/log/packetbeat
touch /var/log/packetbeat/packetbeat.log
tail -f /var/log/packetbeat/packetbeat.log & wait
