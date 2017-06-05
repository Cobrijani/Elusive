FROM phusion/baseimage
MAINTAINER Stefan Bratic
ENV REFRESHED_AT 2017-06-01


###############################################################################
#                                INSTALLATION
###############################################################################

ENV FILEBEAT_VERSION 5.4.0

RUN apt-get update -qq \
 && apt-get install -qqy curl \
 && apt-get clean

RUN curl -L -O https://artifacts.elastic.co/downloads/beats/filebeat/filebeat-${FILEBEAT_VERSION}-amd64.deb \
 && dpkg -i filebeat-${FILEBEAT_VERSION}-amd64.deb \
 && rm filebeat-${FILEBEAT_VERSION}-amd64.deb \
 && mkdir /var/log/firewall \
 && chmod go+x /var/log/firewall

###############################################################################
#                                CONFIGURATION
###############################################################################


# config file
ADD filebeat.yml /etc/filebeat/filebeat.yml
RUN chmod 644 /etc/filebeat/filebeat.yml

# CA cert
RUN mkdir -p /etc/pki/tls/certs
ADD logstash-beats.crt /etc/pki/tls/certs/logstash-beats.crt

###############################################################################
#                                    START
###############################################################################

ADD wait.sh /wait.sh
RUN chmod +x /wait.sh


ADD start.sh /usr/local/bin/start.sh
RUN chmod +x /usr/local/bin/start.sh


VOLUME /var/log/firewall

CMD [ "/usr/local/bin/start.sh" ]