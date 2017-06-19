#!/bin/sh
ES_USER=elastic
ES_PASS=changeme
ES_URL=es
ES_PORT=9200
LOGSTASH_URL=logstash
LOGSTASH_PORT=5044

./wait.sh -t 300 -h ${ES_URL} -p ${ES_PORT} #wait for elasticsearch
./wait.sh -t 15 -h ${LOGSTASH_URL} -p ${LOGSTASH_PORT} # wait for logstash


curl -k \
 --user ${ES_USER}:${ES_PASS} \
 -X PUT \
 "https://es:9200/_template/${INDEX_NAME}?pretty" \
 -d@/usr/share/filebeat/filebeat.template.json

# ./usr/share/filebeat/scripts/import_dashboards \
#   -es https://${ES_URL}:${ES_PORT} \
#   -cacert /etc/pki/tls/certs/ca.pem \
#   -insecure \
#   -user ${ES_USER} \
#   -pass ${ES_PASS} \
#   -i ${INDEX_NAME}

/etc/init.d/filebeat start -e

mkdir -p /var/log/filebeat
touch /var/log/filebeat/filebeat.log
tail -f /var/log/filebeat/filebeat.log & wait
