#!/bin/bash
###################################################################
# Script for automatically generating certificates for system
# Author: Stefan Bratic <cobrijani@gmail.com>
# Version: 1.0.0
###################################################################

KEY_LENGTH=4096
KEYSTORE_DIR=jks
DEFAULT_PASSPHRASE=changeit
###################################################################
#
#                           Root CA
#
###################################################################

CA_DIR=certs/ca
CA_KEY=${CA_DIR}/ca.key
CA_CRT=${CA_DIR}/ca.pem

## generate root CA key
openssl genrsa -out ${CA_KEY} -passout pass:${DEFAULT_PASSPHRASE} ${KEY_LENGTH}

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
ES_PKCS12_KEYSTORE=${KEYSTORE_DIR}/elasticsearch-keystore.p12
ES_JKS_KEYSTORE=${KEYSTORE_DIR}/elasticsearch-keystore.jks
ES_JKS_TRUSTSTORE=${KEYSTORE_DIR}/elasticsearch-truststore.jks

## generate elasticsearch cluster key
openssl genrsa -out ${ES_KEY} -passout pass:${DEFAULT_PASSPHRASE} ${KEY_LENGTH}

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


echo "Creating elasticsearch keystore"
echo "On password prompts write 'changeit'!"
### create elasticsearch keystore pkcs12 format
openssl pkcs12 \
  -export \
  -in ${ES_CRT} \
  -inkey ${ES_KEY} \
  -out ${ES_PKCS12_KEYSTORE} \
  -name "elasticsearch certificate [elusive-1]" \
  -passin pass:${DEFAULT_PASSPHRASE}

### convert pkcs12 keystore to java keystore
keytool \
  -importkeystore \
  -destkeystore ${ES_JKS_KEYSTORE} \
  -deststorepass ${DEFAULT_PASSPHRASE} \
  -srckeystore ${ES_PKCS12_KEYSTORE} \
  -srcstoretype PKCS12 \
  -srcstorepass ${DEFAULT_PASSPHRASE}

echo "On password prompt write 'changeit'"
### create truststore
keytool \
  -import \
  -file ${CA_CRT} \
  -keystore ${ES_JKS_TRUSTSTORE} \
  -storepass ${DEFAULT_PASSPHRASE} \
  -alias "ca"

echo "Creating keystores and truststores for elasticsearch complete"



###################################################################
#
#                           Logstash
#
###################################################################

LOGSTASH_DIR=certs/logstash
LOGSTASH_KEY=${LOGSTASH_DIR}/logstash.key
LOGSTASH_CSR=${LOGSTASH_DIR}/logstash.csr
LOGSTASH_CRT=${LOGSTASH_DIR}/logstash.pem
LOGSTASH_PKCS12_KEYSTORE=${KEYSTORE_DIR}/logstash-keystore.p12
LOGSTASH_JKS_KEYSTORE=${KEYSTORE_DIR}/logstash-keystore.jks
LOGSTASH_JKS_TRUSTSTORE=${KEYSTORE_DIR}/logstash-truststore.jks

### generate logstash private key
openssl genrsa -out ${LOGSTASH_KEY} -passout pass:${DEFAULT_PASSPHRASE} ${KEY_LENGTH}

### change key to be PKC8 compliant
openssl pkcs8 -in ${LOGSTASH_KEY} -topk8 -nocrypt -out ${LOGSTASH_DIR}/logstash.pkcs8

### generate logstash signing request
openssl req \
  -new \
  -key ${LOGSTASH_KEY} \
  -out ${LOGSTASH_CSR} \
  -subj "/CN=logstash_internal"

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

echo "Creating logstash keystore"
echo "On password prompts write 'changeit'!"
### create elasticsearch keystore pkcs12 format
openssl pkcs12 \
  -export \
  -in ${LOGSTASH_CRT} \
  -inkey ${LOGSTASH_KEY} \
  -out ${LOGSTASH_PKCS12_KEYSTORE} \
  -name "logstash certificate [logstash_writer]"\
  -passin pass:${DEFAULT_PASSPHRASE}

### convert pkcs12 keystore to java keystore
keytool \
  -importkeystore \
  -destkeystore ${LOGSTASH_JKS_KEYSTORE} \
  -deststorepass changeit \
  -srckeystore ${LOGSTASH_PKCS12_KEYSTORE} \
  -srcstoretype PKCS12 \
  -srcstorepass ${DEFAULT_PASSPHRASE}

echo "On password prompt write 'changeit'"
### create truststore
keytool \
  -import \
  -file ${CA_CRT} \
  -keystore ${LOGSTASH_JKS_TRUSTSTORE}\
  -storepass ${DEFAULT_PASSPHRASE} \
  -alias "ca"

echo "Creating keystores and truststores for logstash complete"



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
