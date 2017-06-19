#!/bin/bash
#
# /usr/local/bin/start.sh


_term() {
  echo "Terminating Kibana"
  service kibana stop
  exit 0
}

trap _term SIGTERM


## remove pidfiles in case previous graceful termination failed

rm -f /var/run/kibana5.pid

## initialise list of log files to stream in console (initially empty)
OUTPUT_LOGFILES=""


## override default time zone (Etc/UTC) if TZ variable is set
if [ ! -z "$TZ" ]; then
  ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone
fi


#./usr/local/bin/wait.sh -t 300 -h es -p 9200 # wait for elasticsearch
#./usr/local/bin/wait.sh -t 300 -h logstash -p 5044 # wait for logstash

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
    echo "Kibana waiting for Elasticsearch to be up ($counter/$ES_CONNECT_RETRY)"
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
    echo "Kibana waiting for Elasticsearch cluster to respond ($counter/30)"
  done
  if [ -z "$CLUSTER_NAME" ]; then
    echo "Couln't get name of cluster. Exiting."
    exit 1
  fi


### Kibana

if [ -z "$KIBANA_START" ]; then
  KIBANA_START=1
fi
if [ "$KIBANA_START" -ne "1" ]; then
  echo "KIBANA_START is set to something different from 1, not starting..."
else
  # override NODE_OPTIONS variable if set
  if [ ! -z "$NODE_OPTIONS" ]; then
    awk -v LINE="NODE_OPTIONS=\"$NODE_OPTIONS\"" '{ sub(/^NODE_OPTIONS=.*/, LINE); print; }' /etc/init.d/kibana \
        > /etc/init.d/kibana.new && mv /etc/init.d/kibana.new /etc/init.d/kibana && chmod +x /etc/init.d/kibana
  fi

  service kibana start
  OUTPUT_LOGFILES+="/var/log/kibana/kibana5.log "
fi

touch $OUTPUT_LOGFILES
tail -f $OUTPUT_LOGFILES & wait
