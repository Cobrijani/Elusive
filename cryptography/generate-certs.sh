#!/bin/bash
###################################################################
# Script for automatically generating certificates for system
# Author: Stefan Bratic <cobrijani@gmail.com>
# Version: 1.0.0
###################################################################

KEY_LENGTH=4096

###################################################################
#
#                           Root CA
#
###################################################################

CA_DIR=certs/ca
CA_KEY=${CA_DIR}/ca.key
CA_CRT=${CA_DIR}/ca.pem

## generate root CA key
openssl genrsa -out ${CA_KEY} ${KEY_LENGTH}

## generate root Ca certificate
openssl req -x509 \
  -new \
  -nodes \
  -key ${CA_KEY} \
  -days 3650 \
  -out ${CA_CRT} \
  -subj "/CN=Elusive Root CA"

###################################################################
#
#                           Elasticsearch
#
###################################################################

ES_DIR=certs/elusive-1
ES_KEY=${ES_DIR}/elusive-1.key
ES_CSR=${ES_DIR}/elusive-1.csr
ES_CRT=${ES_DIR}/elusive-1.pem

## generate elasticsearch cluster key
openssl genrsa -out ${ES_KEY} ${KEY_LENGTH}

## generate elasticsearch cluster signing request
openssl req \
 -new \
 -key ${ES_KEY} \
 -out ${ES_CSR} \
 -subj "/CN=elusive-1"

### generate elastic search certificate signed by root ca
openssl x509 -req \
 -extensions elasticsearch \
 -extfile ext.conf \
 -in ${ES_CSR} \
 -CA ${CA_CRT} -CAkey ${CA_KEY} \
 -CAcreateserial \
 -out ${ES_CRT} \
 -days 3650


###################################################################
#
#                           Logstash
#
###################################################################

LOGSTASH_DIR=certs/logstash
LOGSTASH_KEY=${LOGSTASH_DIR}/logstash.key
LOGSTASH_CSR=${LOGSTASH_DIR}/logstash.csr
LOGSTASH_CRT=${LOGSTASH_DIR}/logstash.pem

### generate logstash private key
openssl genrsa -out ${LOGSTASH_KEY} ${KEY_LENGTH}

### change key to be PKC8 compliant
openssl pkcs8 -in ${LOGSTASH_KEY} -topk8 -nocrypt -out ${LOGSTASH_DIR}/logstash.pkcs8

### generate logstash signing request
openssl req \
  -new \
  -key ${LOGSTASH_KEY} \
  -out ${LOGSTASH_CSR} \
  -subj "/CN=logstash"

### generate logstash certificate signed by root ca
openssl x509 -req \
  -extensions logstash \
  -extfile ext.conf \
  -in ${LOGSTASH_CSR} \
  -CA ${CA_CRT} \
  -CAkey ${CA_KEY} \
  -CAcreateserial \
  -out ${LOGSTASH_CRT} \
  -days 3650

###################################################################
#
#                           Kibana
#
###################################################################

KIBANA_DIR=certs/kibana
KIBANA_KEY=${KIBANA_DIR}/kibana.key
KIBANA_CSR=${KIBANA_DIR}/kibana.csr
KIBANA_CRT=${KIBANA_DIR}/kibana.pem

### generate Kibana private key
openssl genrsa -out ${KIBANA_KEY} ${KEY_LENGTH}

### generate Kibana signing request
openssl req \
  -new \
  -key ${KIBANA_KEY} \
  -out ${KIBANA_CSR} \
  -subj "/CN=kibana"

### generate Kibana certificate signed by root ca
openssl x509 -req \
  -extensions kibana \
  -extfile ext.conf \
  -in ${KIBANA_CSR} \
  -CA ${CA_CRT} \
  -CAkey ${CA_KEY} \
  -CAcreateserial \
  -out ${KIBANA_CRT} \
  -days 3650


###################################################################
#
#                           Beats
#
###################################################################

BEATS_DIR=certs/beats
BEATS_KEY=${BEATS_DIR}/beats.key
BEATS_CSR=${BEATS_DIR}/beats.csr
BEATS_CRT=${BEATS_DIR}/beats.pem

### generate Beats private key
openssl genrsa -out ${BEATS_KEY} ${KEY_LENGTH}

### generate Beats signing request
openssl req -new \
  -key ${BEATS_KEY} \
  -out ${BEATS_CSR} \
  -subj "/CN=beats"

### generate Beats certificate signed by root ca
openssl x509 -req \
  -extensions beats \
  -extfile ext.conf \
  -in ${BEATS_CSR} \
  -CA ${CA_CRT} \
  -CAkey ${CA_KEY} \
  -CAcreateserial \
  -out ${BEATS_CRT} \
  -days 3650
