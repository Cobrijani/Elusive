#!/bin/bash


ES_USER=elastic
ES_PASS=changeme
ES_URL=localhost
ES_PORT=9200

_term() {
  echo "Terminating ELK"
  service elasticsearch stop
  exit 0
}

trap _term SIGTERM

rm -f /var/run/elasticsearch/elasticsearch.pid

OUTPUT_LOGFILES=""

## override default time zone (Etc/UTC) if TZ variable is set
if [ ! -z "$TZ" ]; then
  ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone
fi
## start services as needed

cp -r /opt/elasticsearch/config/ingest-geoip/. /etc/elasticsearch/ingest-geoip
#rm -rf /opt/elasticsearch/config/ingest-geoip

### crond

service cron start

### Elasticsearch

if [ -z "$ELASTICSEARCH_START" ]; then
  ELASTICSEARCH_START=1
fi
if [ "$ELASTICSEARCH_START" -ne "1" ]; then
  echo "ELASTICSEARCH_START is set to something different from 1, not starting..."
else
  # override ES_HEAP_SIZE variable if set
  if [ ! -z "$ES_HEAP_SIZE" ]; then
    awk -v LINE="-Xmx$ES_HEAP_SIZE" '{ sub(/^.Xmx.*/, LINE); print; }' /opt/elasticsearch/config/jvm.options \
        > /opt/elasticsearch/config/jvm.options.new && mv /opt/elasticsearch/config/jvm.options.new /opt/elasticsearch/config/jvm.options
    awk -v LINE="-Xms$ES_HEAP_SIZE" '{ sub(/^.Xms.*/, LINE); print; }' /opt/elasticsearch/config/jvm.options \
        > /opt/elasticsearch/config/jvm.options.new && mv /opt/elasticsearch/config/jvm.options.new /opt/elasticsearch/config/jvm.options
  fi

  # override ES_JAVA_OPTS variable if set
  if [ ! -z "$ES_JAVA_OPTS" ]; then
    awk -v LINE="ES_JAVA_OPTS=\"$ES_JAVA_OPTS\"" '{ sub(/^#?ES_JAVA_OPTS=.*/, LINE); print; }' /etc/default/elasticsearch \
        > /etc/default/elasticsearch.new && mv /etc/default/elasticsearch.new /etc/default/elasticsearch
  fi

  # override MAX_OPEN_FILES variable if set
  if [ ! -z "$MAX_OPEN_FILES" ]; then
    awk -v LINE="MAX_OPEN_FILES=$MAX_OPEN_FILES" '{ sub(/^#?MAX_OPEN_FILES=.*/, LINE); print; }' /etc/init.d/elasticsearch \
        > /etc/init.d/elasticsearch.new && mv /etc/init.d/elasticsearch.new /etc/init.d/elasticsearch \
        && chmod +x /etc/init.d/elasticsearch
  fi

  # override MAX_MAP_COUNT variable if set
  if [ ! -z "$MAX_MAP_COUNT" ]; then
    awk -v LINE="MAX_MAP_COUNT=$MAX_MAP_COUNT" '{ sub(/^#?MAX_MAP_COUNT=.*/, LINE); print; }' /etc/init.d/elasticsearch \
        > /etc/init.d/elasticsearch.new && mv /etc/init.d/elasticsearch.new /etc/init.d/elasticsearch \
        && chmod +x /etc/init.d/elasticsearch
  fi

  service elasticsearch start

  # wait for Elasticsearch to start up before either starting Kibana (if enabled)
  # or attempting to stream its log file
  # - https://github.com/elasticsearch/kibana/issues/3077

  # set number of retries (default: 30, override using ES_CONNECT_RETRY env var)
  re_is_numeric='^[0-9]+$'
  if ! [[ $ES_CONNECT_RETRY =~ $re_is_numeric ]] ; then
     ES_CONNECT_RETRY=30
  fi

  counter=0
  while [ ! "$(curl -k --user elastic:changeme https://localhost:9200 2> /dev/null)" -a $counter -lt $ES_CONNECT_RETRY  ]; do
    sleep 1
    ((counter++))
    echo "waiting for Elasticsearch to be up ($counter/$ES_CONNECT_RETRY)"
  done
  if [ ! "$(curl -k --user elastic:changeme https://localhost:9200 2> /dev/null)" ]; then
    echo "Couln't start Elasticsearch. Exiting."
    echo "Elasticsearch log follows below."
    cat /var/log/elasticsearch/elusive-cluster.log
    cat /var/log/elasticsearch/elasticsearch.log
    exit 1
  fi

  # wait for cluster to respond before getting its name
  counter=0
  while [ -z "$CLUSTER_NAME" -a $counter -lt 30 ]; do
    sleep 1
    ((counter++))
    CLUSTER_NAME=$(curl -k --user elastic:changeme https://localhost:9200/_cat/health?h=cluster 2> /dev/null | tr -d '[:space:]')
    echo "Waiting for Elasticsearch cluster to respond ($counter/30)"
  done
  if [ -z "$CLUSTER_NAME" ]; then
    echo "Couln't get name of cluster. Exiting."
    echo "Elasticsearch log follows below."
    cat /var/log/elasticsearch/elusive-cluster.log
    cat /var/log/elasticsearch/elasticsearch.log
    exit 1
  fi
  OUTPUT_LOGFILES+="/var/log/elasticsearch/${CLUSTER_NAME}.log "
fi


OUTPUT_LOGFILES+="/var/log/elasticsearch/elusive-cluster.log"
# Exit if nothing has been started
if [ "$ELASTICSEARCH_START" -ne "1" ]; then
  >&2 echo "No services started. Exiting."
  exit 1
fi

#Add role that is configured for logstash indexer named logstash_writer
curl -k \
   --user ${ES_USER}:${ES_PASS} \
   -X POST \
   -H "Content-Type: application/json"\
   -d "{ \"cluster\": [\"manage_index_templates\", \"monitor\"], \"indices\": [{ \"names\": [\"logstash-*\", \"linuxbeat-*\", \"firebeat-*\", \"appbeat-*\", \"apachebeat-*\",\"winlogbeat-*\", \"atmbeat-*\", \"apachemainbeat-*\"], \"privileges\": [\"write\", \"delete\", \"create_index\"]}]}" \
   https://${ES_URL}:${ES_PORT}/_xpack/security/role/logstash_writer

# Add user with role logstash writer
curl -k \
   --user ${ES_USER}:${ES_PASS} \
   -X POST \
   -H "Content-Type: application/json"\
   -d "{ \"password\" : \"changeme\",\"roles\" : [ \"logstash_writer\"],\"full_name\" : \"Internal Logstash User\"}"\
   https://${ES_URL}:${ES_PORT}/_xpack/security/user/logstash_internal



touch $OUTPUT_LOGFILES
tail -f $OUTPUT_LOGFILES &
wait
