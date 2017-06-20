#!/bin/bash
_term() {
  echo "Terminating Logstash"
  service logstash stop
  exit 0
}

trap _term SIGTERM

## initialise list of log files to stream in console (initially empty)
OUTPUT_LOGFILES=""


## override default time zone (Etc/UTC) if TZ variable is set
if [ ! -z "$TZ" ]; then
  ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone
fi


## start services as needed

### crond

service cron start

# set number of retries (default: 30, override using ES_CONNECT_RETRY env var)
  re_is_numeric='^[0-9]+$'
  if ! [[ $ES_CONNECT_RETRY =~ $re_is_numeric ]] ; then
     ES_CONNECT_RETRY=300
  fi

  counter=0
  while [ ! "$(curl -k --user elastic:changeme https://es:9200 2> /dev/null)" -a $counter -lt $ES_CONNECT_RETRY  ]; do
    sleep 1
    ((counter++))
    echo "Logstash waiting for Elasticsearch to be up ($counter/$ES_CONNECT_RETRY)"
  done
  if [ ! "$(curl -k --user elastic:changeme https://es:9200 2> /dev/null)" ]; then
    echo "Couln't start Elasticsearch. Exiting."
    exit 1
  fi

  # wait for cluster to respond before getting its name
  counter=0
  while [ -z "$CLUSTER_NAME" -a $counter -lt 30 ]; do
    sleep 1
    ((counter++))
    CLUSTER_NAME=$(curl -k --user elastic:changeme https://es:9200/_cat/health?h=cluster 2> /dev/null | tr -d '[:space:]')
    echo "Logstash waiting for Elasticsearch cluster to respond ($counter/30)"
  done
  if [ -z "$CLUSTER_NAME" ]; then
    echo "Couln't get name of cluster. Exiting."
    exit 1
  fi

### Logstash
#./usr/local/bin/wait.sh -t 300 -h es -p 9200 # wait for elasticsearch

if [ -z "$LOGSTASH_START" ]; then
  LOGSTASH_START=1
fi
if [ "$LOGSTASH_START" -ne "1" ]; then
  echo "LOGSTASH_START is set to something different from 1, not starting..."
else
  # override LS_HEAP_SIZE variable if set
  if [ ! -z "$LS_HEAP_SIZE" ]; then
    awk -v LINE="-Xmx$LS_HEAP_SIZE" '{ sub(/^.Xmx.*/, LINE); print; }' /opt/logstash/config/jvm.options \
        > /opt/logstash/config/jvm.options.new && mv /opt/logstash/config/jvm.options.new /opt/logstash/config/jvm.options
    awk -v LINE="-Xms$LS_HEAP_SIZE" '{ sub(/^.Xms.*/, LINE); print; }' /opt/logstash/config/jvm.options \
        > /opt/logstash/config/jvm.options.new && mv /opt/logstash/config/jvm.options.new /opt/logstash/config/jvm.options
  fi

  # override LS_OPTS variable if set
  if [ ! -z "$LS_OPTS" ]; then
    awk -v LINE="LS_OPTS=\"$LS_OPTS\"" '{ sub(/^LS_OPTS=.*/, LINE); print; }' /etc/init.d/logstash \
        > /etc/init.d/logstash.new && mv /etc/init.d/logstash.new /etc/init.d/logstash && chmod +x /etc/init.d/logstash
  fi

  service logstash start
  OUTPUT_LOGFILES+="/var/log/logstash/logstash-plain.log "
fi

touch $OUTPUT_LOGFILES
tail -f $OUTPUT_LOGFILES & wait
