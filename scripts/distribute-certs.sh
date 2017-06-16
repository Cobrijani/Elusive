#!/bin/bash
###################################################################
# Helper script for copying certificates in each folder for each docker image
# Author: Stefan Bratic <cobrijani@gmail.com>
# Version: 1.0.1
# Changelog:
# - added copying of keystores
#######################1############################################
cert_dir=./../cryptography/certs/
deploy_dir=./../deployment
jks_dir=./../cryptography/jks

rm -rf ${deploy_dir}/elasticsearch/cryptography/certs
rm -rf ${deploy_dir}/kibana/cryptography/certs
rm -rf ${deploy_dir}/logstash/cryptography/certs
rm -rf ${deploy_dir}/filebeat/cryptography/certs

mkdir ${deploy_dir}/elasticsearch/cryptography/
mkdir ${deploy_dir}/kibana/cryptography/
mkdir ${deploy_dir}/logstash/cryptography/
mkdir ${deploy_dir}/filebeat/cryptography/

cp -r ${cert_dir} ${deploy_dir}/elasticsearch/cryptography/certs/
cp -r ${cert_dir} ${deploy_dir}/kibana/cryptography/certs/
cp -r ${cert_dir} ${deploy_dir}/logstash/cryptography/certs/
cp -r ${cert_dir} ${deploy_dir}/filebeat/cryptography/certs/

mkdir ${deploy_dir}/elasticsearch/cryptography/jks
mkdir ${deploy_dir}/logstash/cryptography/jks

cp ${jks_dir}/logstash-keystore.jks ${deploy_dir}/logstash/cryptography/jks/logstash-keystore.jks
cp ${jks_dir}/logstash-truststore.jks ${deploy_dir}/logstash/cryptography/jks/logstash-truststore.jks
cp ${jks_dir}/elasticsearch-keystore.jks ${deploy_dir}/elasticsearch/cryptography/jks/elasticsearch-keystore.jks
cp ${jks_dir}/elasticsearch-truststore.jks ${deploy_dir}/elasticsearch/cryptography/jks/elasticsearch-truststore.jks


