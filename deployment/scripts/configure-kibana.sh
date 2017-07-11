#!/bin/bash

# Wait for Kibana to start up before doing anything.
until curl -s https://kibana:5601/login -o /dev/null; do
    echo Waiting for Kibana...
    sleep 1
done

curl -s -XPUT -k https://elastic:changeme@es:9200/.kibana/index-pattern/logstash-* \
     -d '{"title" : "logstash-*",  "timeFieldName": "@timestamp"}'


# Set the default index pattern.
curl -s -XPUT -k https://elastic:changeme@es:9200/.kibana/config/5.4.1 \
     -d '{"defaultIndex" : "logstash-*"}'
