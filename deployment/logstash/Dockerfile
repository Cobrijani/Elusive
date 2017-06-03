FROM docker.elastic.co/logstash/logstash:5.4.1

LABEL maintainer "Stefan Bratic <cobrijani@gmail.com>"

ENV LOGSTASH_HOME /usr/share/logstash


RUN .${LOGSTASH_HOME}/bin/logstash-plugin install logstash-filter-grok \
 && .${LOGSTASH_HOME}/bin/logstash-plugin install logstash-filter-date


ADD ./cryptography/certs/ca/ca.crt /etc/pki/tls/certs/ca.crt
ADD ./cryptography/certs/elusive-1/elusive-1.crt /etc/pki/tls/certs/elusive-1.crt
ADD ./cryptography/certs/logstash-beats/logstash-beats.crt /etc/pki/tls/certs/logstash-beats.crt
ADD ./cryptography/certs/logstash-beats/logstash-beats.key /etc/pki/tls/private/logstash-beats.key

