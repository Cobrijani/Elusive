#!/bin/bash
#Add role that is configured for logstash indexer named logstash_writer
curl -k \
   --user elastic:changeme \
   -X POST \
   -H "Content-Type: application/json"\
   -d "{ \"cluster\": [\"manage_index_templates\", \"monitor\"], \"indices\": [{ \"names\": [\"logstash-*\", \"filebeat-*\", \"winlogbeat-*\"], \"privileges\": [\"write\", \"delete\", \"create_index\"]}]}" \
   https://localhost:9200/_xpack/security/role/logstash_writer

# Add user with role logstash writer
curl -k \
   --user elastic:changeme \
   -X POST \
   -H "Content-Type: application/json"\
   -d "{ \"password\" : \"changeme\",\"roles\" : [ \"logstash_writer\"],\"full_name\" : \"Internal Logstash User\"}"\
   https://localhost:9200/_xpack/security/user/logstash_internal