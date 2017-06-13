FROM docker.elastic.co/elasticsearch/elasticsearch:5.4.1

LABEL maintainer "Stefan Bratic <cobrijani@gmail.com>"


ENV ES_CONFIG=/usr/share/elasticsearch/config
ENV X_PACK_ES=${ES_CONFIG}/x-pack


ADD ./cryptography/certs/ca/ca.pem ${X_PACK_ES}/ca.pem
ADD ./cryptography/certs/ca/ca.key ${X_PACK_ES}/ca.key
ADD ./cryptography/certs/elusive-1/elusive-1.pem ${X_PACK_ES}/elusive-1.pem
ADD ./cryptography/certs/elusive-1/elusive-1.key ${X_PACK_ES}/elusive-1.key
