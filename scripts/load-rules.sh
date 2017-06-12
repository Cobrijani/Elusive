#!/bin/bash
###############################################################################
# Script for automatically loading Elasticsearch with rules defined in 'documents' folder
# Author: Stefan Bratic
# Version: 1.0
#
###############################################################################

ES_USER=elastic
ES_PASS=changeme
ES_URL=localhost
ES_PORT=9200

for filename in ./../documents/*/*.json; do
  [ -e "$filename" ] || continue

  base=${filename##*/}
  echo curl${base%.json}

  curl -k \
  --user ${ES_USER}:${ES_PASS} \
  -X PUT \
  https://${ES_URL}:${ES_PORT}/_xpack/watcher/watch/${base%.json} \
  -d@${filename}

done
