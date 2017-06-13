#!/bin/bash
###################################################################
# Helper script for copying certificates in each folder for each docker image
# Author: Stefan Bratic <cobrijani@gmail.com>
# Version: 1.0.0
###################################################################
cert_dir=./../cryptography/certs/
deploy_dir=./../deployment

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
