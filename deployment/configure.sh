#!/bin/bash

#Add role that is configured for logstash indexer named logstash_writer
curl -k \
   --user elastic:changeme \
   -X POST \
   -H "Content-Type: application/json"\
   -d "{ \"cluster\": [\"manage_index_templates\", \"monitor\"], \"indices\": [{ \"names\": [\"logstash-*\", \"linuxbeat-*\", \"firebeat-*\", \"appbeat-*\", \"apachebeat-*\",\"winlogbeat-*\"], \"privileges\": [\"write\", \"delete\", \"create_index\"]}]}" \
   https://localhost:9200/_xpack/security/role/logstash_writer

# Add user with role logstash writer
curl -k \
   --user elastic:changeme \
   -X POST \
   -H "Content-Type: application/json"\
   -d "{ \"password\" : \"changeme\",\"roles\" : [ \"logstash_writer\"],\"full_name\" : \"Internal Logstash User\"}"\
   https://localhost:9200/_xpack/security/user/logstash_internal

curl -k \
 --user elastic:changeme \
 -X PUT \
 'https://localhost:9200/_template/filebeat?pretty' \
 -d@/etc/filebeat/filebeat.template.json


./../scripts/import_dashboards.exe \
 -es https://localhost:9200 \
 -cacert ./filebeat/cryptography/certs/ca/ca.crt \
 -insecure \
 -user elastic \
 -pass changeme \
 -file ./../resources/beats-dashboards-5.4.1.zip

