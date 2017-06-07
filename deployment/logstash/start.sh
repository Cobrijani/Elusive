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

### Logstash
./usr/local/bin/wait.sh -t 300 -h es -p 9200 # wait for elasticsearch

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
